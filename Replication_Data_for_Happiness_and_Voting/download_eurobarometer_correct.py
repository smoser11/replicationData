#!/usr/bin/env python3
"""
Eurobarometer downloader - Correct workflow based on actual GESIS interface
"""

import os
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

def login_gesis(driver):
    """Manual login at start"""
    print("\nLogging into GESIS...")
    print("Please log in manually using the Login button in the browser.")
    print("After logging in, press Enter here to continue...\n")
    driver.get("https://search.gesis.org")
    input("Press Enter after you have logged in to GESIS...")
    print("✓ Login complete\n")

def download_study(driver, study_id, is_first=False):
    """Download a single study"""
    print(f"  Processing ZA{study_id}...")

    try:
        wait = WebDriverWait(driver, 15)

        # Step 1: Navigate to study page (in new tab if not first)
        if not is_first:
            # Open new tab
            driver.execute_script("window.open('');")
            driver.switch_to.window(driver.window_handles[-1])
            print(f"  Opened new tab")

        url = f"https://search.gesis.org/research_data/ZA{study_id}"
        print(f"  Navigating to {url}")
        driver.get(url)
        time.sleep(2)

        # Step 2: Click "Datasets" link (opens popup)
        print(f"  Looking for 'Datasets' link...")
        datasets_link = wait.until(
            EC.element_to_be_clickable((By.PARTIAL_LINK_TEXT, "Datasets"))
        )
        print(f"  Clicking 'Datasets' to open popup...")
        datasets_link.click()
        time.sleep(2)

        # Step 3: Find .dta file link in popup
        print(f"  Looking for .dta file link...")
        dta_link = wait.until(
            EC.element_to_be_clickable((By.PARTIAL_LINK_TEXT, ".dta"))
        )
        filename = dta_link.text
        print(f"  Found: {filename}")

        # Step 4: Click .dta link FIRST TIME (makes dropdown appear)
        print(f"  Clicking .dta link (first time - to show dropdown)...")
        dta_link.click()
        time.sleep(2)

        # Step 5: Select purpose from dropdown
        print(f"  Looking for purpose dropdown...")
        purpose_dropdown = wait.until(
            EC.presence_of_element_located((By.CSS_SELECTOR, "select.data_purpose"))
        )
        select = Select(purpose_dropdown)
        print(f"  Found dropdown with {len(select.options)} options")

        # Select "in a course as lecturer" (value="lecturer", last option)
        print(f"  Selecting 'in a course as lecturer'...")
        select.select_by_value("lecturer")
        time.sleep(1)

        # Step 6: Click .dta link SECOND TIME (actually downloads)
        print(f"  Clicking .dta link (second time - to download)...")
        # Need to find the link again as DOM may have changed
        dta_link = driver.find_element(By.PARTIAL_LINK_TEXT, ".dta")
        dta_link.click()
        time.sleep(2)

        # Step 7: Close the popup
        print(f"  Closing popup...")
        # Try multiple ways to close the popup
        try:
            # Look for close button (X)
            close_button = driver.find_element(By.CSS_SELECTOR, "button.close, a.close, .modal-close")
            close_button.click()
        except:
            try:
                # Try pressing Escape key
                from selenium.webdriver.common.keys import Keys
                driver.find_element(By.TAG_NAME, "body").send_keys(Keys.ESCAPE)
            except:
                print(f"  Could not close popup automatically, continuing...")

        time.sleep(1)

        print(f"  ✓ Download initiated for ZA{study_id}")
        return True

    except Exception as e:
        print(f"  ✗ Error: {str(e)}")
        screenshot_path = os.path.join(DOWNLOAD_DIR, f"error_ZA{study_id}.png")
        try:
            driver.save_screenshot(screenshot_path)
            print(f"  Screenshot saved: {screenshot_path}")
        except:
            pass
        return False

def main():
    print("=" * 70)
    print("Eurobarometer Download Script - Correct Workflow")
    print("=" * 70)
    print()
    print(f"Download directory: {DOWNLOAD_DIR}")
    print(f"Number of surveys: {len(STUDY_IDS)}")
    print()

    try:
        print("Starting Chrome browser...")
        driver = setup_driver()
        print("✓ Chrome started\n")

        # Login first
        login_gesis(driver)

        # Download all studies
        successful = 0
        failed = []

        for i, study_id in enumerate(STUDY_IDS, 1):
            print(f"\n[{i}/{len(STUDY_IDS)}] Downloading ZA{study_id}")
            print("-" * 60)

            is_first = (i == 1)
            if download_study(driver, study_id, is_first=is_first):
                successful += 1
            else:
                failed.append(study_id)

            # Brief pause between downloads
            time.sleep(2)

        # Summary
        print("\n" + "=" * 70)
        print(f"SUMMARY: {successful} successful, {len(failed)} failed")
        if failed:
            print(f"\nFailed: {', '.join(['ZA' + s for s in failed])}")
        print(f"\nDownload directory: {DOWNLOAD_DIR}")

        # Count downloaded files
        try:
            dta_files = [f for f in os.listdir(DOWNLOAD_DIR) if f.endswith('.dta')]
            print(f"Total .dta files in directory: {len(dta_files)}")
        except:
            pass

        print("=" * 70)

    except Exception as e:
        print(f"\n✗ Fatal error: {str(e)}")
        import traceback
        traceback.print_exc()

    finally:
        try:
            input("\nPress Enter to close browser and exit...")
            driver.quit()
            print("✓ Browser closed")
        except:
            pass

if __name__ == "__main__":
    main()
