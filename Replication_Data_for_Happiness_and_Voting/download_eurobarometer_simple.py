#!/usr/bin/env python3
"""
Simple Eurobarometer downloader - no login required
"""

import os
import time
from selenium import webdriver
from selenium.webdriver.common.by import By
from selenium.webdriver.support.ui import WebDriverWait
from selenium.webdriver.support import expected_conditions as EC
from selenium.webdriver.chrome.service import Service
from selenium.webdriver.chrome.options import Options
from webdriver_manager.chrome import ChromeDriverManager

# Configuration
DOWNLOAD_DIR = os.path.join(os.getcwd(), "Raw Data", "EB")
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
    """Set up Chrome driver with download preferences"""
    chrome_options = Options()

    # Set download directory
    prefs = {
        "download.default_directory": DOWNLOAD_DIR,
        "download.prompt_for_download": False,
        "download.directory_upgrade": True,
        "safebrowsing.enabled": True
    }
    chrome_options.add_experimental_option("prefs", prefs)

    # Use ChromeDriverManager to automatically download correct version
    service = Service(ChromeDriverManager().install())
    driver = webdriver.Chrome(service=service, options=chrome_options)
    return driver

def download_study(driver, study_id):
    """Download a single study"""
    try:
        # Navigate to study page
        url = f"https://search.gesis.org/research_data/ZA{study_id}"
        print(f"  Navigating to {url}...")
        driver.get(url)

        wait = WebDriverWait(driver, 15)

        # Wait for page to load
        time.sleep(3)

        # Try to find the "Datasets" link in the Downloads section
        try:
            datasets_link = wait.until(
                EC.element_to_be_clickable((By.PARTIAL_LINK_TEXT, "Datasets"))
            )
            print(f"  Found 'Datasets' link, clicking...")
            datasets_link.click()
            time.sleep(2)
        except:
            print(f"  'Datasets' link not found, trying alternative method...")

        # Find all radio buttons for data purpose
        purpose_radios = driver.find_elements(By.NAME, "purpose")

        if purpose_radios:
            print(f"  Found {len(purpose_radios)} purpose options")
            if len(purpose_radios) >= 5:
                # Scroll to element and click option 5 (scientific research)
                driver.execute_script("arguments[0].scrollIntoView(true);", purpose_radios[4])
                time.sleep(0.5)
                purpose_radios[4].click()
                print(f"  Selected purpose: scientific research")
                time.sleep(1)
            else:
                # Just click the first one if less than 5 options
                purpose_radios[0].click()
                time.sleep(1)

        # Find and click Stata (.dta) download link
        try:
            dta_links = driver.find_elements(By.PARTIAL_LINK_TEXT, ".dta")
            if dta_links:
                print(f"  Found {len(dta_links)} .dta link(s)")
                driver.execute_script("arguments[0].scrollIntoView(true);", dta_links[0])
                time.sleep(0.5)
                dta_links[0].click()
                time.sleep(4)
                print(f"  ✓ Download initiated for ZA{study_id}")
                return True
            else:
                print(f"  ✗ No .dta link found for ZA{study_id}")
                # Save screenshot for debugging
                screenshot_path = os.path.join(DOWNLOAD_DIR, f"error_ZA{study_id}.png")
                driver.save_screenshot(screenshot_path)
                print(f"  Screenshot saved to: {screenshot_path}")
                return False
        except Exception as e:
            print(f"  ✗ Error finding .dta link: {str(e)}")
            screenshot_path = os.path.join(DOWNLOAD_DIR, f"error_ZA{study_id}.png")
            driver.save_screenshot(screenshot_path)
            print(f"  Screenshot saved to: {screenshot_path}")
            return False

    except Exception as e:
        print(f"  ✗ Failed to download ZA{study_id}: {str(e)}")
        screenshot_path = os.path.join(DOWNLOAD_DIR, f"error_ZA{study_id}.png")
        driver.save_screenshot(screenshot_path)
        print(f"  Screenshot saved to: {screenshot_path}")
        return False

def main():
    print("=" * 60)
    print("Eurobarometer Download Script (Simple Version)")
    print("=" * 60)
    print()
    print(f"Download directory: {DOWNLOAD_DIR}")
    print(f"Number of surveys to download: {len(STUDY_IDS)}")
    print()

    try:
        print("Starting Chrome browser...")
        driver = setup_driver()
        print("✓ Chrome browser started\n")

        # Download all studies
        successful = 0
        failed = []

        for i, study_id in enumerate(STUDY_IDS, 1):
            print(f"\n[{i}/{len(STUDY_IDS)}] Downloading ZA{study_id}...")

            if download_study(driver, study_id):
                successful += 1
            else:
                failed.append(study_id)

            # Delay between downloads
            time.sleep(2)

        # Summary
        print("\n" + "=" * 60)
        print(f"Summary: {successful} successful, {len(failed)} failed")
        if failed:
            print(f"Failed studies: {', '.join(['ZA' + s for s in failed])}")
        print(f"Download directory: {DOWNLOAD_DIR}")
        print("=" * 60)

    except Exception as e:
        print(f"\n✗ Error: {str(e)}")

    finally:
        # Close browser
        try:
            print("\nClosing browser...")
            driver.quit()
            print("✓ Browser closed")
        except:
            pass

if __name__ == "__main__":
    main()
