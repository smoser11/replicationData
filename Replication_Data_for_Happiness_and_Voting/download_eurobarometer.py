#!/usr/bin/env python3
"""
Download Eurobarometer surveys from GESIS using Selenium with Chrome
Requires: pip install selenium webdriver-manager

Usage:
  python3 download_eurobarometer.py                    # Interactive mode
  python3 download_eurobarometer.py email password     # Command-line mode
"""

import os
import sys
import time
import getpass
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

# List of all 34 ZA study numbers
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

    # Optional: run in headless mode (comment out to see browser)
    # chrome_options.add_argument("--headless")

    # Use ChromeDriverManager to automatically download correct version
    service = Service(ChromeDriverManager().install())
    driver = webdriver.Chrome(service=service, options=chrome_options)
    return driver

def login_gesis(driver, email, password):
    """Check if login is required and log in if necessary"""
    print("\nChecking GESIS access...")

    # Navigate to first study page
    driver.get("https://search.gesis.org/research_data/ZA3521")
    time.sleep(3)

    # Check if we're on the study page or redirected to login
    if "login.gesis.org" in driver.current_url:
        print("Login required. Logging in...")
        wait = WebDriverWait(driver, 15)

        try:
            # Wait for username field to appear
            username_field = wait.until(
                EC.presence_of_element_located((By.ID, "username"))
            )
            username_field.send_keys(email)

            # Find password field
            password_field = wait.until(
                EC.presence_of_element_located((By.ID, "password"))
            )
            password_field.send_keys(password)

            # Find and click login button
            login_button = wait.until(
                EC.element_to_be_clickable((By.ID, "kc-login"))
            )
            login_button.click()

            # Wait for redirect after login
            time.sleep(5)
            print("✓ Logged in successfully\n")

        except Exception as e:
            screenshot_path = os.path.join(DOWNLOAD_DIR, "login_error.png")
            driver.save_screenshot(screenshot_path)
            print(f"✗ Login failed. Screenshot saved to: {screenshot_path}")
            raise
    else:
        print("✓ No login required - datasets are publicly accessible\n")

def download_study(driver, study_id):
    """Download a single study"""
    try:
        # Navigate to study page
        url = f"https://search.gesis.org/research_data/ZA{study_id}"
        driver.get(url)

        wait = WebDriverWait(driver, 15)

        # Try to switch to English (optional, may not be needed)
        try:
            english_link = wait.until(
                EC.presence_of_element_located((By.PARTIAL_LINK_TEXT, "Englis"))
            )
            english_link.click()
            time.sleep(1)
        except:
            pass  # English link not found or already in English

        # Wait for page to load completely
        time.sleep(2)

        # Find all radio buttons for data purpose
        purpose_radios = driver.find_elements(By.NAME, "purpose")

        if len(purpose_radios) >= 5:
            # Scroll to element and click option 5 (scientific research)
            driver.execute_script("arguments[0].scrollIntoView(true);", purpose_radios[4])
            time.sleep(0.5)
            purpose_radios[4].click()
            time.sleep(1)

            # Find and click Stata (.dta) download link
            try:
                dta_link = wait.until(
                    EC.element_to_be_clickable((By.PARTIAL_LINK_TEXT, ".dta"))
                )
                driver.execute_script("arguments[0].scrollIntoView(true);", dta_link)
                time.sleep(0.5)
                dta_link.click()
                time.sleep(4)  # Wait for download to start
                print(f"✓ Download initiated for ZA{study_id}")
                return True
            except:
                print(f"✗ No .dta link found for ZA{study_id}")
                return False
        else:
            print(f"✗ Could not find download options for ZA{study_id}")
            return False

    except Exception as e:
        print(f"✗ Failed to download ZA{study_id}: {str(e)}")
        return False

def main():
    print("=" * 55)
    print("Eurobarometer Download Script (Python + Selenium)")
    print("=" * 55)
    print()

    # Get credentials from command line or prompt (may not be needed)
    if len(sys.argv) == 3:
        email = sys.argv[1]
        password = sys.argv[2]
        print("Using credentials from command line arguments")
    else:
        print("Enter your GESIS credentials (press Enter to skip if not required):")
        email = input("Email (or press Enter): ").strip()
        if email:
            password = getpass.getpass("Password: ")
        else:
            email = ""
            password = ""
            print("Skipping credentials - will check if login is required")

    print(f"\nDownload directory: {DOWNLOAD_DIR}")
    print(f"Number of surveys to download: {len(STUDY_IDS)}\n")

    # Set up browser
    print("Starting Chrome browser...")
    print("NOTE: Chrome will open automatically. Do not close it!\n")

    try:
        driver = setup_driver()
        print("✓ Chrome browser started\n")

        # Login
        login_gesis(driver, email, password)

        # Download all studies
        print(f"Downloading {len(STUDY_IDS)} surveys...\n")
        successful = 0
        failed = []

        for i, study_id in enumerate(STUDY_IDS, 1):
            print(f"[{i}/{len(STUDY_IDS)}] Downloading ZA{study_id}...")

            if download_study(driver, study_id):
                successful += 1
            else:
                failed.append(study_id)

            # Delay between downloads
            time.sleep(2)

        # Summary
        print("\n" + "=" * 55)
        print(f"Summary: {successful} successful, {len(failed)} failed")
        if failed:
            print(f"Failed studies: {', '.join(['ZA' + s for s in failed])}")
        print(f"Download directory: {DOWNLOAD_DIR}")
        print("=" * 55)

    except Exception as e:
        print(f"\n✗ Error: {str(e)}")
        print("\nTROUBLESHOOTING:")
        print("1. Make sure Chrome is installed")
        print("2. Install Selenium: pip install selenium")
        print("3. Chrome driver will be installed automatically")
        print("\nAlternatively, use manual download: MANUAL_DOWNLOAD_CHECKLIST.md")

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
