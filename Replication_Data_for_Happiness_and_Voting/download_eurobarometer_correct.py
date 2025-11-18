#!/usr/bin/env python3
"""
Eurobarometer downloader - Correct workflow based on actual GESIS interface

Usage:
  python3 download_eurobarometer_correct.py                    # Manual login
  python3 download_eurobarometer_correct.py email password     # Auto login
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

def login_gesis(driver, email=None, password=None):
    """Login to GESIS - manual or automated"""
    print("\nLogging into GESIS...")

    if email and password:
        # Automated login
        print("Using automated login...")

        # Go directly to login page with redirect to search
        login_url = "https://login.gesis.org/realms/gesis/protocol/openid-connect/auth?client_id=js-login&redirect_uri=https%3A%2F%2Fsearch.gesis.org%2F&response_mode=fragment&response_type=code&scope=openid"
        driver.get(login_url)

        wait = WebDriverWait(driver, 15)

        try:
            # Wait for login form to appear
            print("  Waiting for login form...")
            username_field = wait.until(
                EC.visibility_of_element_located((By.ID, "username"))
            )

            print("  Entering credentials...")
            username_field.clear()
            username_field.send_keys(email)

            password_field = wait.until(
                EC.visibility_of_element_located((By.ID, "password"))
            )
            password_field.clear()
            password_field.send_keys(password)

            # Click login submit button
            print("  Submitting login...")
            submit_button = wait.until(
                EC.element_to_be_clickable((By.ID, "kc-login"))
            )
            submit_button.click()

            # Wait for redirect back to GESIS
            print("  Waiting for redirect...")
            time.sleep(6)

            # Verify login by checking URL
            current_url = driver.current_url
            print(f"  Current URL: {current_url[:50]}...")

            if "login.gesis.org" in current_url:
                print("  ⚠️ Still on login page - login may have failed")
                # Try to see if there's an error message
                try:
                    error_msg = driver.find_element(By.CSS_SELECTOR, ".alert-error, .error, #error-message")
                    print(f"  Error message: {error_msg.text}")
                except:
                    pass

            print("✓ Automated login complete\n")

        except Exception as e:
            print(f"✗ Automated login failed: {str(e)}")
            import traceback
            traceback.print_exc()
            print("\nFalling back to manual login...")
            input("Please log in manually and press Enter...")
            print("✓ Manual login complete\n")
    else:
        # Manual login
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

        # Step 2: Click "Datasets" link (opens popup with dropdown)
        print(f"  Looking for 'Datasets' link...")
        datasets_link = wait.until(
            EC.element_to_be_clickable((By.PARTIAL_LINK_TEXT, "Datasets"))
        )
        print(f"  Clicking 'Datasets' to open popup...")
        datasets_link.click()
        time.sleep(3)

        # Step 3: Select purpose from dropdown (appears immediately in popup)
        print(f"  Looking for purpose dropdown...")

        # Wait a bit longer for popup content to fully load
        time.sleep(2)

        # Debug: check what select elements exist
        all_selects = driver.find_elements(By.TAG_NAME, "select")
        print(f"  Debug: Found {len(all_selects)} select elements on page")

        # Try multiple selectors to find the dropdown
        purpose_dropdown = None

        # Strategy 1: Direct class selector with longer wait
        try:
            long_wait = WebDriverWait(driver, 10)
            purpose_dropdown = long_wait.until(
                EC.presence_of_element_located((By.CSS_SELECTOR, "select.data_purpose"))
            )
            print(f"  Found dropdown with class selector")
        except Exception as e:
            print(f"  Class selector failed: {str(e)[:100]}")

        # Strategy 2: Any visible select element
        if not purpose_dropdown:
            try:
                selects = driver.find_elements(By.TAG_NAME, "select")
                for sel in selects:
                    if sel.is_displayed():
                        purpose_dropdown = sel
                        print(f"  Found visible select element")
                        break
            except Exception as e:
                print(f"  Visible select search failed: {str(e)[:100]}")

        if not purpose_dropdown:
            # Save screenshot for debugging
            screenshot_path = os.path.join(DOWNLOAD_DIR, f"error_ZA{study_id}_no_dropdown.png")
            driver.save_screenshot(screenshot_path)
            print(f"  Screenshot saved: {screenshot_path}")
            raise Exception("Could not find purpose dropdown with any selector")

        # Scroll to dropdown to ensure it's visible
        driver.execute_script("arguments[0].scrollIntoView(true);", purpose_dropdown)
        time.sleep(0.5)

        select = Select(purpose_dropdown)
        print(f"  Found dropdown with {len(select.options)} options")

        # List available options for debugging
        for i, option in enumerate(select.options):
            print(f"    Option {i}: {option.get_attribute('value')} - {option.text}")

        # Select "in a course as lecturer" using Selenium Select
        print(f"  Selecting 'in a course as lecturer' (value='lecturer')...")
        try:
            select.select_by_value("lecturer")
            print(f"  ✓ Selected by value")
        except:
            # Fallback: select by index (last option)
            select.select_by_index(7)
            print(f"  ✓ Selected by index 7")

        # IMPORTANT: Trigger the onchange event to call DataDownloadPurpose()
        print(f"  Triggering onChange event...")
        driver.execute_script("""
            var event = new Event('change', { bubbles: true });
            arguments[0].dispatchEvent(event);
            // Also try calling the function directly if it exists
            if (typeof DataDownloadPurpose === 'function') {
                DataDownloadPurpose(arguments[0]);
            }
        """, purpose_dropdown)

        # Wait for selection to register
        time.sleep(2)

        # Verify selection
        selected_value = purpose_dropdown.get_attribute("value")
        print(f"  Dropdown value is now: {selected_value}")

        # Step 4: NOW click .dta file link to download
        print(f"  Looking for .dta file link...")
        dta_link = wait.until(
            EC.element_to_be_clickable((By.PARTIAL_LINK_TEXT, ".dta"))
        )
        filename = dta_link.text
        print(f"  Found: {filename}")
        print(f"  Clicking .dta link to download...")
        dta_link.click()
        time.sleep(3)

        # Step 5: Close the popup
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

    # Check for command-line credentials
    email = sys.argv[1] if len(sys.argv) > 1 else None
    password = sys.argv[2] if len(sys.argv) > 2 else None

    if email and password:
        print("⚠️  WARNING: Using credentials from command line")
        print("    Make sure not to share your terminal history!\n")

    try:
        print("Starting Chrome browser...")
        driver = setup_driver()
        print("✓ Chrome started\n")

        # Login first (automated if credentials provided, otherwise manual)
        login_gesis(driver, email, password)

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
