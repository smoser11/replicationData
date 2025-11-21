#!/usr/bin/env python3
"""
Eurobarometer downloader - Following exact manual workflow
Based on step-by-step demonstration
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

    service = Service(ChromeDriverManager().install())
    driver = webdriver.Chrome(service=service, options=chrome_options)
    driver.set_window_size(1400, 1000)
    return driver

def login_to_gesis(driver, email, password):
    """Step 1: Login to GESIS"""
    print("\n[Step 1] Logging into GESIS...")

    driver.get("https://login.gesis.org/")
    wait = WebDriverWait(driver, 15)

    try:
        # Wait for login form
        time.sleep(2)

        # Enter email
        username_field = wait.until(
            EC.presence_of_element_located((By.ID, "username"))
        )
        username_field.clear()
        username_field.send_keys(email)

        # Enter password
        password_field = driver.find_element(By.ID, "password")
        password_field.clear()
        password_field.send_keys(password)

        # Click login button
        login_button = driver.find_element(By.ID, "kc-login")
        login_button.click()

        time.sleep(5)
        print("✓ Logged in successfully")
        return True

    except Exception as e:
        print(f"✗ Login failed: {str(e)}")
        return False

def download_dataset(driver, study_id, is_first=False):
    """Download a single dataset following the demonstrated workflow"""

    print(f"\n{'='*70}")
    print(f"Processing ZA{study_id}")
    print('='*70)

    wait = WebDriverWait(driver, 20)

    try:
        # Step 2: Open new tab (except for first dataset)
        if not is_first:
            print("  → Opening new tab...")
            driver.execute_script("window.open('');")
            driver.switch_to.window(driver.window_handles[-1])
            time.sleep(1)

        # Step 3: Navigate to dataset page
        url = f"https://search.gesis.org/research_data/ZA{study_id}"
        print(f"  → Navigating to {url}")
        driver.get(url)
        time.sleep(3)

        # Step 4: Click "Datasets" link
        print("  → Clicking 'Datasets' link...")
        datasets_link = wait.until(
            EC.element_to_be_clickable((By.PARTIAL_LINK_TEXT, "Datasets"))
        )
        datasets_link.click()
        time.sleep(3)  # Wait for popup to open

        # Step 5: Select "lecturer" from data_purpose dropdown
        print("  → Selecting 'lecturer' from purpose dropdown...")

        # Find the dropdown
        purpose_dropdown = wait.until(
            EC.presence_of_element_located((By.CSS_SELECTOR, "select.data_purpose"))
        )

        # Select using JavaScript (most reliable)
        driver.execute_script("""
            var select = arguments[0];
            select.value = 'lecturer';

            // Trigger the onchange event
            var event = new Event('change', { bubbles: true });
            select.dispatchEvent(event);

            // Call the onchange function directly
            if (select.onchange) {
                select.onchange.call(select);
            }
        """, purpose_dropdown)

        time.sleep(2)
        print("  ✓ Purpose selected")

        # Step 6: Click the .dta.zip file link
        print("  → Looking for .dta.zip file...")

        # Find link containing ".dta" (should be the .dta.zip file)
        dta_links = driver.find_elements(By.PARTIAL_LINK_TEXT, ".dta")

        if not dta_links:
            raise Exception("No .dta file found")

        # Get the first .dta link (should be the .dta.zip Stata file)
        dta_link = dta_links[0]
        filename = dta_link.text.strip()
        print(f"  → Found: {filename}")

        print("  → Clicking to download...")
        dta_link.click()
        time.sleep(2)

        print(f"  ✓ Download started for ZA{study_id}")
        return True

    except Exception as e:
        print(f"  ✗ Error: {str(e)}")

        # Save screenshot
        screenshot_path = os.path.join(DOWNLOAD_DIR, f"error_ZA{study_id}_working.png")
        try:
            driver.save_screenshot(screenshot_path)
            print(f"  → Screenshot saved: {screenshot_path}")
        except:
            pass

        return False

def main():
    if len(sys.argv) < 3:
        print("Usage: python3 download_eurobarometer_working.py email password")
        sys.exit(1)

    email = sys.argv[1]
    password = sys.argv[2]

    print("="*70)
    print("Eurobarometer Downloader - Following Demonstrated Workflow")
    print("="*70)
    print(f"\nDownload directory: {DOWNLOAD_DIR}")
    print(f"Total datasets: {len(STUDY_IDS)}\n")

    driver = None

    try:
        # Setup
        print("Starting Chrome browser...")
        driver = setup_driver()
        print("✓ Chrome started\n")

        # Login
        if not login_to_gesis(driver, email, password):
            print("\n✗ Login failed. Exiting.")
            return

        # Download all datasets
        successful = 0
        failed = []

        for i, study_id in enumerate(STUDY_IDS, 1):
            is_first = (i == 1)

            if download_dataset(driver, study_id, is_first=is_first):
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
            print(f"\nFailed: {', '.join(['ZA' + s for s in failed])}")

        # Count downloaded files
        try:
            zip_files = [f for f in os.listdir(DOWNLOAD_DIR) if f.endswith('.zip')]
            print(f"\n.zip files in directory: {len(zip_files)}")
        except:
            pass

        print("="*70)

    except KeyboardInterrupt:
        print("\n\nInterrupted by user")
    except Exception as e:
        print(f"\n✗ Fatal error: {str(e)}")
        import traceback
        traceback.print_exc()
    finally:
        if driver:
            input("\nPress Enter to close browser...")
            try:
                driver.quit()
                print("✓ Browser closed")
            except:
                pass

if __name__ == "__main__":
    main()
