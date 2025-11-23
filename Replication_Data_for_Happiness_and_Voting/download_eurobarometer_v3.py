#!/usr/bin/env python3
"""
Eurobarometer downloader - Version 3 with improved reliability

Usage:
  python3 download_eurobarometer_v3.py email password
"""

import os
import sys
import time
from selenium import webdriver
from selenium.webdriver.common.by import By
from selenium.webdriver.support.ui import WebDriverWait
from selenium.webdriver.support import expected_conditions as EC
from selenium.webdriver.chrome.service import Service
from selenium.webdriver.chrome.options import Options
from selenium.webdriver.support.select import Select
from webdriver_manager.chrome import ChromeDriverManager

# Configuration
DOWNLOAD_DIR = os.path.abspath(os.path.join(os.getcwd(), "Raw Data", "EB"))
os.makedirs(DOWNLOAD_DIR, exist_ok=True)

# All 34 ZA study numbers
STUDY_IDS = [
    "3521", "2828", "3693", "3938", "4229", "4231", "4411", "4414",
    "4506", "4526", "4530", "4565", "4744", "4819", "4971", "4972",
    "4973", "4994", "5234", "5235", "5449", "5481", "5564", "5567",
    "5612", "5613", "5685", "5689", "5876", "5877", "5913", "5928",
    "5929", "5932"
]

def setup_driver():
    """Set up Chrome driver"""
    chrome_options = Options()
    prefs = {
        "download.default_directory": DOWNLOAD_DIR,
        "download.prompt_for_download": False,
        "download.directory_upgrade": True,
        "safebrowsing.enabled": True,
        "plugins.always_open_pdf_externally": True
    }
    chrome_options.add_experimental_option("prefs", prefs)

    # Don't run headless - we want to see the browser
    service = Service(ChromeDriverManager().install())
    driver = webdriver.Chrome(service=service, options=chrome_options)
    driver.set_window_size(1400, 1000)
    return driver

def login_gesis_manual(driver):
    """Manual login - most reliable"""
    print("\n" + "="*70)
    print("MANUAL LOGIN REQUIRED")
    print("="*70)
    print("\nThe browser will open GESIS. Please:")
    print("1. Click the 'Login' button in the top right")
    print("2. Enter your credentials and log in")
    print("3. Wait for the page to load")
    print("4. Come back here and press Enter\n")

    driver.get("https://search.gesis.org")
    time.sleep(2)

    input("Press Enter after you have logged in to GESIS...")
    print("✓ Login complete\n")

def download_study(driver, study_id, is_first=False):
    """Download a single study with improved error handling"""
    print(f"\n[Processing ZA{study_id}]")

    try:
        wait = WebDriverWait(driver, 20)

        # Open new tab for subsequent downloads
        if not is_first:
            driver.execute_script("window.open('');")
            driver.switch_to.window(driver.window_handles[-1])
            time.sleep(1)

        # Navigate to study page
        url = f"https://search.gesis.org/research_data/ZA{study_id}"
        print(f"  → {url}")
        driver.get(url)
        time.sleep(3)

        # Step 1: Click "Datasets" link
        print(f"  → Clicking 'Datasets' link...")
        datasets_link = wait.until(
            EC.element_to_be_clickable((By.PARTIAL_LINK_TEXT, "Datasets"))
        )
        datasets_link.click()
        time.sleep(4)  # Wait for popup to fully load

        # Step 2: Find and select purpose dropdown
        print(f"  → Looking for purpose dropdown...")

        # Find the dropdown (try multiple methods)
        purpose_dropdown = None
        try:
            purpose_dropdown = driver.find_element(By.CSS_SELECTOR, "select.data_purpose")
        except:
            try:
                # Find any visible select element
                selects = driver.find_elements(By.TAG_NAME, "select")
                for sel in selects:
                    if sel.is_displayed():
                        purpose_dropdown = sel
                        break
            except:
                pass

        if not purpose_dropdown:
            raise Exception("Could not find purpose dropdown")

        print(f"  → Found purpose dropdown")

        # Select "lecturer" option using PURE JAVASCRIPT (bypasses Selenium interaction issues)
        print(f"  → Selecting 'in a course as lecturer' (using JavaScript)...")
        driver.execute_script("""
            var dropdown = arguments[0];

            // Set the value directly
            dropdown.value = 'lecturer';

            // Trigger change event
            var changeEvent = new Event('change', { bubbles: true });
            dropdown.dispatchEvent(changeEvent);

            // Call the onchange handler function if it exists
            if (typeof DataDownloadPurpose === 'function') {
                DataDownloadPurpose(dropdown);
            }

            // Also try triggering via the onchange attribute
            if (dropdown.onchange) {
                dropdown.onchange();
            }
        """, purpose_dropdown)

        time.sleep(2)

        # Verify selection
        selected = driver.execute_script("return arguments[0].value;", purpose_dropdown)
        print(f"  → Dropdown value is now: {selected}")

        if selected != "lecturer":
            print(f"  ⚠️  Warning: Dropdown still shows '{selected}' instead of 'lecturer'")

        # Step 3: Click .dta file to download
        print(f"  → Looking for .dta file...")
        dta_link = wait.until(
            EC.element_to_be_clickable((By.PARTIAL_LINK_TEXT, ".dta"))
        )
        filename = dta_link.text
        print(f"  → Found: {filename}")
        print(f"  → Clicking to download...")

        dta_link.click()
        time.sleep(3)

        # Step 4: Close popup (try multiple methods)
        print(f"  → Closing popup...")
        try:
            # Try to find close button
            close_btn = driver.find_element(By.CSS_SELECTOR, ".close, button.close, [aria-label='Close']")
            close_btn.click()
        except:
            try:
                # Try pressing Escape
                from selenium.webdriver.common.keys import Keys
                driver.find_element(By.TAG_NAME, "body").send_keys(Keys.ESCAPE)
            except:
                print(f"  → Could not close popup (may have closed automatically)")

        time.sleep(1)

        print(f"  ✓ Download completed for ZA{study_id}")
        return True

    except Exception as e:
        print(f"  ✗ Error: {str(e)}")
        screenshot_path = os.path.join(DOWNLOAD_DIR, f"error_ZA{study_id}_v3.png")
        try:
            driver.save_screenshot(screenshot_path)
            print(f"  → Screenshot: {screenshot_path}")
        except:
            pass
        return False

def main():
    if len(sys.argv) < 3:
        print("Usage: python3 download_eurobarometer_v3.py email password")
        print("Note: This version uses MANUAL login for reliability")
        sys.exit(1)

    email = sys.argv[1]
    password = sys.argv[2]

    print("="*70)
    print("Eurobarometer Download Script - Version 3")
    print("="*70)
    print(f"\nDownload directory: {DOWNLOAD_DIR}")
    print(f"Number of surveys: {len(STUDY_IDS)}\n")

    driver = None
    try:
        print("Starting Chrome browser...")
        driver = setup_driver()
        print("✓ Chrome started")

        # Manual login (most reliable)
        login_gesis_manual(driver)

        # Download all studies
        successful = 0
        failed = []

        for i, study_id in enumerate(STUDY_IDS, 1):
            print(f"\n{'='*70}")
            print(f"[{i}/{len(STUDY_IDS)}] Downloading ZA{study_id}")
            print('='*70)

            is_first = (i == 1)
            if download_study(driver, study_id, is_first=is_first):
                successful += 1
            else:
                failed.append(study_id)

            # Brief pause between downloads
            time.sleep(2)

        # Summary
        print("\n" + "="*70)
        print("DOWNLOAD SUMMARY")
        print("="*70)
        print(f"Successful: {successful}/{len(STUDY_IDS)}")
        print(f"Failed: {len(failed)}/{len(STUDY_IDS)}")

        if failed:
            print(f"\nFailed studies: {', '.join(['ZA' + s for s in failed])}")

        # Count actual .dta files
        try:
            dta_files = [f for f in os.listdir(DOWNLOAD_DIR) if f.endswith('.dta')]
            print(f"\n.dta files in directory: {len(dta_files)}")
        except:
            pass

        print("="*70)

    except KeyboardInterrupt:
        print("\n\nDownload interrupted by user")
    except Exception as e:
        print(f"\n✗ Fatal error: {str(e)}")
        import traceback
        traceback.print_exc()
    finally:
        if driver:
            input("\nPress Enter to close browser and exit...")
            try:
                driver.quit()
                print("✓ Browser closed")
            except:
                pass

if __name__ == "__main__":
    main()
