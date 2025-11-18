#!/usr/bin/env Rscript
# Fixed script to download Eurobarometer surveys
# Installs PhantomJS from GitHub (not broken Bitbucket)

cat("=======================================================\n")
cat("Eurobarometer Survey Download Script (Fixed Version)\n")
cat("=======================================================\n\n")

# Step 1: Install PhantomJS from working source
cat("Step 1: Installing PhantomJS dependency...\n")
if (!require("webshot")) {
  install.packages("webshot")
}
library(webshot)

if (!is_phantomjs_installed()) {
  cat("Installing PhantomJS from GitHub...\n")
  install_phantomjs()
  cat("✓ PhantomJS installed successfully\n\n")
} else {
  cat("✓ PhantomJS already installed\n\n")
}

# Step 2: Install gesisdata package
cat("Step 2: Installing gesisdata package...\n")
if (!require("gesisdata")) {
  install.packages("gesisdata")
}
library(gesisdata)
cat("✓ gesisdata package loaded\n\n")

# Set download directory
download_dir <- file.path(getwd(), "Raw Data", "EB")
dir.create(download_dir, recursive = TRUE, showWarnings = FALSE)

# List of all 34 ZA study numbers
study_ids <- c(
  "3521",  # Trend
  "2828",  # 44.2
  "3693",  # 58.1
  "3938",  # 60.1
  "4229",  # 62.0
  "4231",  # 62.2
  "4411",  # 63.4
  "4414",  # 64.2
  "4506",  # 65.2
  "4526",  # 66.1
  "4530",  # 67.2
  "4565",  # 68.1
  "4744",  # 69.2
  "4819",  # 70.1
  "4971",  # 71.1
  "4972",  # 71.2
  "4973",  # 71.3
  "4994",  # 72.4
  "5234",  # 73.4
  "5235",  # 73.5
  "5449",  # 74.2
  "5481",  # 75.3
  "5564",  # 75.4
  "5567",  # 76.3
  "5612",  # 77.3
  "5613",  # 77.4
  "5685",  # 78.1
  "5689",  # 79.3
  "5876",  # 80.1
  "5877",  # 80.2
  "5913",  # 81.2
  "5928",  # 81.4
  "5929",  # 81.5
  "5932"   # 82.3
)

cat("Step 3: Downloading", length(study_ids), "Eurobarometer surveys\n")
cat("Download directory:", download_dir, "\n\n")

# Prompt for credentials once
cat("Enter your GESIS credentials:\n")
gesis_email <- readline(prompt = "Email: ")
gesis_password <- readline(prompt = "Password: ")

cat("\nStarting downloads...\n\n")

# Download all surveys
successful <- 0
failed_studies <- c()

for (i in seq_along(study_ids)) {
  study_id <- study_ids[i]
  cat(sprintf("[%d/%d] Downloading ZA%s...\n", i, length(study_ids), study_id))

  tryCatch({
    gesis_download(
      file_id = study_id,
      download_dir = download_dir,
      email = gesis_email,
      password = gesis_password,
      use = 5,  # Scientific research (incl. doctorate)
      convert = FALSE,  # Keep original .dta format
      msg = FALSE
    )
    successful <- successful + 1
    cat(sprintf("✓ Successfully downloaded ZA%s\n\n", study_id))

  }, error = function(e) {
    failed_studies <- c(failed_studies, study_id)
    cat(sprintf("✗ Failed: %s\n\n", e$message))
  })

  # Delay to avoid overwhelming the server
  Sys.sleep(2)
}

# Summary
cat("=======================================================\n")
cat(sprintf("Summary: %d successful, %d failed\n", successful, length(failed_studies)))
if (length(failed_studies) > 0) {
  cat("Failed studies:", paste0("ZA", failed_studies, collapse = ", "), "\n")
  cat("\nYou can download these manually from:\n")
  for (study in failed_studies) {
    cat(sprintf("  https://search.gesis.org/research_data/ZA%s\n", study))
  }
}
cat("=======================================================\n")
