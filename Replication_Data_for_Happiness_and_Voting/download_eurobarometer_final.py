#!/usr/bin/env python3
"""
Eurobarometer downloader - Final version
Handles both radio buttons AND dropdown for purpose selection
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
    print("Please log in manually in the browser window.")
    print("After logging in, press Enter here to continue...\n")
    driver.get("https://search.gesis.org/research_data/ZA3521")
    input("Press Enter after you have logged in to GESIS...")
    print("✓ Login complete\n")

def download_study(driver, study_id):
    """Download a single study"""
    print(f"  Navigating to ZA{study_id}...")

    try:
        url = f"https://search.gesis.org/research_data/ZA{study_id}"
        driver.get(url)
        wait = WebDriverWait(driver, 15)
        time.sleep(2)

        # Step 1: Click "Datasets" link
        print(f"  Looking for 'Datasets' link...")
        try:
            datasets_link = None
            try:
                datasets_link = driver.find_element(By.LINK_TEXT, "Datasets")
            except:
                try:
                    datasets_link = driver.find_element(By.PARTIAL_LINK_TEXT, "Dataset")
                except:
                    pass

            if datasets_link:
                print(f"  Clicking 'Datasets' link...")
                driver.execute_script("arguments[0].scrollIntoView(true);", datasets_link)
                time.sleep(0.5)
                datasets_link.click()
                time.sleep(3)  # Wait for form to load
            else:
                print(f"  'Datasets' link not found")
        except Exception as e:
            print(f"  Could not click Datasets: {str(e)}")

        # Step 2: Select purpose - TRY BOTH METHODS
        print(f"  Looking for purpose selection...")
        purpose_selected = False

        # Method 1: Try radio buttons first
        try:
            purpose_radios = driver.find_elements(By.NAME, "purpose")
            if purpose_radios and len(purpose_radios) > 0:
                print(f"  Found {len(purpose_radios)} radio button(s)")
                # Select option 7 if available, otherwise option 5, otherwise first
                idx = min(6, len(purpose_radios) - 1)  # Try index 6 (option 7)
                if len(purpose_radios) <= 6:
                    idx = min(4, len(purpose_radios) - 1)  # Fallback to index 4 (option 5)

                driver.execute_script("arguments[0].scrollIntoView(true);", purpose_radios[idx])
                time.sleep(0.5)
                driver.execute_script("arguments[0].click();", purpose_radios[idx])
                print(f"  Selected radio button option {idx + 1}")
                purpose_selected = True
                time.sleep(2)
        except Exception as e:
            print(f"  No radio buttons found: {str(e)}")

        # Method 2: Try dropdown if radio buttons didn't work
        if not purpose_selected:
            try:
                purpose_dropdown = None
                try:
                    purpose_dropdown = driver.find_element(By.NAME, "purpose")
                    if purpose_dropdown.tag_name != "select":
                        purpose_dropdown = None
                except:
                    pass

                if not purpose_dropdown:
                    try:
                        purpose_dropdown = driver.find_element(By.XPATH, "//select[contains(@name, 'purpose') or contains(@id, 'purpose')]")
                    except:
                        pass

                if purpose_dropdown:
                    select = Select(purpose_dropdown)
                    print(f"  Found dropdown with {len(select.options)} options")
                    # Try option 7, fallback to option 5, fallback to last option
                    try:
                        select.select_by_index(6)  # Option 7
                        print(f"  Selected dropdown option 7")
                    except:
                        try:
                            select.select_by_index(4)  # Option 5
                            print(f"  Selected dropdown option 5")
                        except:
                            select.select_by_index(len(select.options) - 1)
                            print(f"  Selected last dropdown option")
                    purpose_selected = True
                    time.sleep(2)
            except Exception as e:
                print(f"  No dropdown found: {str(e)}")

        if not purpose_selected:
            print(f"  ✗ Could not find or select purpose")
            screenshot_path = os.path.join(DOWNLOAD_DIR, f"error_ZA{study_id}_no_purpose.png")
            driver.save_screenshot(screenshot_path)
            return False

        # Step 3: Find and click .dta download link
        print(f"  Looking for .dta link...")
        time.sleep(1)

        try:
            dta_link = wait.until(
                EC.element_to_be_clickable((By.PARTIAL_LINK_TEXT, ".dta"))
            )
            driver.execute_script("arguments[0].scrollIntoView(true);", dta_link)
            time.sleep(0.5)

            filename = dta_link.text
            print(f"  Clicking: {filename}")
            dta_link.click()
            time.sleep(4)

            print(f"  ✓ Download initiated for ZA{study_id}")
            return True

        except Exception as e:
            print(f"  ✗ No .dta link found: {str(e)}")
            screenshot_path = os.path.join(DOWNLOAD_DIR, f"error_ZA{study_id}_no_dta.png")
            driver.save_screenshot(screenshot_path)
            return False

    except Exception as e:
        print(f"  ✗ Error: {str(e)}")
        screenshot_path = os.path.join(DOWNLOAD_DIR, f"error_ZA{study_id}.png")
        try:
            driver.save_screenshot(screenshot_path)
        except:
            pass
        return False

def main():
    print("=" * 70)
    print("Eurobarometer Download Script - Final Version")
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

            if download_study(driver, study_id):
                successful += 1
            else:
                failed.append(study_id)

            time.sleep(3)

        # Summary
        print("\n" + "=" * 70)
        print(f"SUMMARY: {successful} successful, {len(failed)} failed")
        if failed:
            print(f"\nFailed: {', '.join(['ZA' + s for s in failed])}")
        print(f"\nDownload directory: {DOWNLOAD_DIR}")
        print("=" * 70)

    except Exception as e:
        print(f"\n✗ Fatal error: {str(e)}")
        import traceback
        traceback.print_exc()

    finally:
        try:
            print("\nClosing browser...")
            driver.quit()
            print("✓ Browser closed")
        except:
            pass

if __name__ == "__main__":
    main()
