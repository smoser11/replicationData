#!/usr/bin/env python3
"""
Eurobarometer downloader - handles GESIS download workflow correctly
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
    """Set up Chrome driver with download preferences"""
    chrome_options = Options()

    # Set download directory
    prefs = {
        "download.default_directory": DOWNLOAD_DIR,
        "download.prompt_for_download": False,
        "download.directory_upgrade": True,
        "safebrowsing.enabled": True,
        "plugins.always_open_pdf_externally": True  # Don't open PDFs in browser
    }
    chrome_options.add_experimental_option("prefs", prefs)

    # Use ChromeDriverManager
    service = Service(ChromeDriverManager().install())
    driver = webdriver.Chrome(service=service, options=chrome_options)
    driver.set_window_size(1400, 1000)  # Larger window for better element visibility
    return driver

def download_study(driver, study_id):
    """Download a single study"""
    print(f"  Navigating to ZA{study_id}...")

    try:
        # Navigate to study page
        url = f"https://search.gesis.org/research_data/ZA{study_id}"
        driver.get(url)

        wait = WebDriverWait(driver, 15)

        # Wait for page to load
        time.sleep(3)

        # Step 1: Find and click the "Datasets" link in the Downloads section
        print(f"  Looking for 'Datasets' link...")
        try:
            # Try multiple strategies to find the Datasets link
            datasets_link = None

            # Strategy 1: Look for link with exact text
            try:
                datasets_link = driver.find_element(By.LINK_TEXT, "Datasets")
            except:
                pass

            # Strategy 2: Look for partial text
            if not datasets_link:
                try:
                    datasets_link = driver.find_element(By.PARTIAL_LINK_TEXT, "Dataset")
                except:
                    pass

            # Strategy 3: Look in the Downloads section
            if not datasets_link:
                try:
                    downloads_section = driver.find_element(By.XPATH, "//h3[contains(text(), 'Downloads')]/..")
                    datasets_link = downloads_section.find_element(By.PARTIAL_LINK_TEXT, "Dataset")
                except:
                    pass

            if datasets_link:
                print(f"  Found 'Datasets' link, clicking...")
                driver.execute_script("arguments[0].scrollIntoView(true);", datasets_link)
                time.sleep(0.5)
                datasets_link.click()
                print(f"  Waiting for purpose dropdown to appear...")
                time.sleep(3)  # Wait longer for the dropdown to load
            else:
                print(f"  'Datasets' link not found, page might already show download options")

        except Exception as e:
            print(f"  Note: Could not click Datasets link ({str(e)}), continuing...")

        # Step 2: Look for purpose dropdown (should appear after clicking Datasets)
        print(f"  Looking for purpose dropdown...")

     # Find all radio buttons for data purpose
        purpose_radios = driver.find_elements(By.NAME, "purpose")

        if purpose_radios:
            print(f"  Found {len(purpose_radios)} purpose options")
            if len(purpose_radios) >= 5:
                # Scroll to element and click option 5 (scientific research)
                driver.execute_script("arguments[0].scrollIntoView(true);", purpose_radios[4])
                time.sleep(0.5)
                purpose_radios[7].click()
                print(f"  Selected purpose: scientific research")
                time.sleep(1)
            else:
                # Just click the first one if less than 5 options
                purpose_radios[0].click()
                time.sleep(1)


                print(f"  Found purpose dropdown with {len(select.options)} options")


        # Step 3: Find and click .dta download link
        print(f"  Looking for .dta download link...")

        # Wait a bit for links to appear after selecting purpose
        time.sleep(1)

        # Find all links containing .dta
        dta_links = driver.find_elements(By.PARTIAL_LINK_TEXT, ".dta")

        # Filter for actual data files (not metadata or codebooks)
        data_links = []
        for link in dta_links:
            href = link.get_attribute("href") or ""
            text = link.text or ""
            # Look for actual data file, not codebook or questionnaire
            if ".dta" in text.lower() and "codebook" not in text.lower() and "questionnaire" not in text.lower():
                data_links.append(link)

        if data_links:
            print(f"  Found {len(data_links)} .dta data file link(s)")
            # Click the first data file
            driver.execute_script("arguments[0].scrollIntoView(true);", data_links[0])
            time.sleep(0.5)

            # Get the filename from the link text or href
            filename = data_links[0].text
            print(f"  Clicking to download: {filename}")

            data_links[0].click()
            time.sleep(5)  # Wait for download to start

            print(f"  ✓ Download initiated for ZA{study_id}")
            return True
        else:
            print(f"  ✗ No .dta data file link found")
            # Save screenshot for debugging
            screenshot_path = os.path.join(DOWNLOAD_DIR, f"error_ZA{study_id}.png")
            driver.save_screenshot(screenshot_path)
            print(f"  Screenshot saved: {screenshot_path}")

            # Also print what links were found
            all_links = driver.find_elements(By.TAG_NAME, "a")
            print(f"  Debug: Found {len(dta_links)} links containing '.dta':")
            for link in dta_links[:5]:  # Show first 5
                print(f"    - {link.text}")

            return False

    except Exception as e:
        print(f"  ✗ Error: {str(e)}")
        screenshot_path = os.path.join(DOWNLOAD_DIR, f"error_ZA{study_id}.png")
        try:
            driver.save_screenshot(screenshot_path)
            print(f"  Screenshot saved: {screenshot_path}")
        except:
            pass
        return False

def login_gesis(driver):
    """Log in to GESIS at the start"""
    print("\nLogging into GESIS...")
    print("You will need to log in manually in the browser window that opens.")
    print("After logging in, press Enter here to continue...\n")

    # Navigate to GESIS search (will redirect to login if needed)
    driver.get("https://search.gesis.org/research_data/ZA3521")

    # Wait for user to log in manually
    input("Press Enter after you have logged in to GESIS in the browser window...")

    print("✓ Login complete, proceeding with downloads\n")

def main():
    print("=" * 65)
    print("Eurobarometer Download Script (Version 2)")
    print("=" * 65)
    print()
    print(f"Download directory: {DOWNLOAD_DIR}")
    print(f"Number of surveys: {len(STUDY_IDS)}")
    print()

    try:
        print("Starting Chrome browser...")
        driver = setup_driver()
        print("✓ Chrome started\n")

        # Log in first
        login_gesis(driver)

        # Download all studies
        successful = 0
        failed = []

        for i, study_id in enumerate(STUDY_IDS, 1):
            print(f"\n[{i}/{len(STUDY_IDS)}] Downloading ZA{study_id}")
            print("-" * 50)

            if download_study(driver, study_id):
                successful += 1
            else:
                failed.append(study_id)

            # Delay between downloads
            time.sleep(3)

        # Summary
        print("\n" + "=" * 65)
        print(f"SUMMARY: {successful} successful, {len(failed)} failed")
        if failed:
            print(f"\nFailed studies: {', '.join(['ZA' + s for s in failed])}")
            print("\nCheck screenshots in Raw Data/EB/ for debugging")
        print(f"\nDownload directory: {DOWNLOAD_DIR}")
        print("=" * 65)

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
