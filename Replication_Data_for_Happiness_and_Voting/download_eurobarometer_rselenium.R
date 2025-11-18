#!/usr/bin/env Rscript
# Download Eurobarometer surveys using RSelenium with Chrome
# Based on gesisdata package but using Chrome instead of broken PhantomJS

cat("=======================================================\n")
cat("Eurobarometer Download Script (RSelenium + Chrome)\n")
cat("=======================================================\n\n")

# Install required packages
cat("Step 1: Installing required packages...\n")
packages <- c("RSelenium", "netstat", "stringr")
for (pkg in packages) {
  if (!require(pkg, character.only = TRUE, quietly = TRUE)) {
    install.packages(pkg)
    library(pkg, character.only = TRUE)
  }
}
cat("✓ Packages loaded\n\n")

# Set download directory
download_dir <- file.path(getwd(), "Raw Data", "EB")
dir.create(download_dir, recursive = TRUE, showWarnings = FALSE)

# List of all 34 ZA study numbers
study_ids <- c(
  "3521", "2828", "3693", "3938", "4229", "4231", "4411", "4414",
  "4506", "4526", "4530", "4565", "4744", "4819", "4971", "4972",
  "4973", "4994", "5234", "5235", "5449", "5481", "5564", "5567",
  "5612", "5613", "5685", "5689", "5876", "5877", "5913", "5928",
  "5929", "5932"
)

# Get credentials
cat("Step 2: Enter your GESIS credentials:\n")
gesis_email <- readline(prompt = "Email: ")
gesis_password <- readline(prompt = "Password: ")
cat("\n")

# Start Selenium server
cat("Step 3: Starting Chrome browser (this may take a moment)...\n")
cat("NOTE: Chrome will open automatically. Do not close it!\n\n")

tryCatch({
  # Start RSelenium with Chrome
  # First, try to find an available port
  port <- netstat::free_port(random = TRUE)

  # Start Selenium server with Chrome
  rD <- rsDriver(
    browser = "chrome",
    port = port,
    chromever = "latest",
    check = TRUE,
    verbose = FALSE,
    extraCapabilities = list(
      chromeOptions = list(
        prefs = list(
          "download.default_directory" = download_dir,
          "download.prompt_for_download" = FALSE,
          "download.directory_upgrade" = TRUE,
          "safebrowsing.enabled" = TRUE
        )
      )
    )
  )

  remDr <- rD[["client"]]
  cat("✓ Chrome browser started\n\n")

  # Login to GESIS
  cat("Step 4: Logging into GESIS...\n")
  remDr$navigate("https://login.gesis.org/realms/gesis/protocol/openid-connect/auth?client_id=js-login&redirect_uri=https%3A%2F%2Fsearch.gesis.org%2F&response_mode=fragment&response_type=code&scope=openid")
  Sys.sleep(3)

  # Find and fill login form
  username_field <- remDr$findElement(using = "id", value = "username")
  username_field$sendKeysToElement(list(gesis_email))

  password_field <- remDr$findElement(using = "id", value = "password")
  password_field$sendKeysToElement(list(gesis_password))

  login_button <- remDr$findElement(using = "id", value = "kc-login")
  login_button$clickElement()
  Sys.sleep(3)

  cat("✓ Logged in successfully\n\n")

  # Download each survey
  cat("Step 5: Downloading", length(study_ids), "surveys...\n\n")
  successful <- 0
  failed_studies <- c()

  for (i in seq_along(study_ids)) {
    study_id <- study_ids[i]
    cat(sprintf("[%d/%d] Downloading ZA%s...\n", i, length(study_ids), study_id))

    tryCatch({
      # Navigate to study page
      url <- sprintf("https://search.gesis.org/research_data/ZA%s", study_id)
      remDr$navigate(url)
      Sys.sleep(2)

      # Try to switch to English (optional, may fail)
      tryCatch({
        english_link <- remDr$findElement(using = "partial link text", value = "Englis")
        english_link$clickElement()
        Sys.sleep(1)
      }, error = function(e) {})

      # Find and click download button for Stata file
      # Look for elements with class "data_purpose" and select purpose 5
      download_buttons <- remDr$findElements(using = "class name", value = "data_purpose")

      if (length(download_buttons) >= 5) {
        # Click the 5th option (scientific research)
        download_buttons[[5]]$clickElement()
        Sys.sleep(1)

        # Find and click .dta download link
        dta_link <- remDr$findElement(using = "partial link text", value = ".dta")
        dta_link$clickElement()

        # Wait for download to start and complete
        Sys.sleep(5)

        successful <- successful + 1
        cat(sprintf("✓ Downloaded ZA%s\n\n", study_id))
      } else {
        failed_studies <- c(failed_studies, study_id)
        cat(sprintf("✗ Could not find download button for ZA%s\n\n", study_id))
      }

    }, error = function(e) {
      failed_studies <- c(failed_studies, study_id)
      cat(sprintf("✗ Failed: %s\n\n", e$message))
    })

    # Small delay between downloads
    Sys.sleep(2)
  }

  # Close browser and stop server
  cat("\nStep 6: Cleaning up...\n")
  remDr$close()
  rD$server$stop()
  cat("✓ Browser closed\n\n")

  # Summary
  cat("=======================================================\n")
  cat(sprintf("Summary: %d successful, %d failed\n", successful, length(failed_studies)))
  if (length(failed_studies) > 0) {
    cat("Failed studies:", paste0("ZA", failed_studies, collapse = ", "), "\n")
  }
  cat("Download directory:", download_dir, "\n")
  cat("=======================================================\n")

}, error = function(e) {
  cat("\n✗ Error starting Selenium:\n")
  cat(e$message, "\n\n")
  cat("TROUBLESHOOTING:\n")
  cat("1. Make sure Chrome is installed on your system\n")
  cat("2. Run: install.packages('wdman')\n")
  cat("3. If Chrome version issues, try: binman::list_versions('chromedriver')\n")
  cat("\nAlternatively, use manual download: MANUAL_DOWNLOAD_CHECKLIST.md\n")
})
