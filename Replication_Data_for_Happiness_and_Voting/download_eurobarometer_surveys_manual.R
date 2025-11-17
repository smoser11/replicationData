#!/usr/bin/env Rscript
# Alternative script using manual credential input
# More reliable than the automated version

# Install gesisdata package if needed
if (!require("gesisdata")) {
  install.packages("gesisdata")
}

library(gesisdata)

# Set download directory
download_dir <- file.path(getwd(), "Raw Data", "EB")
dir.create(download_dir, recursive = TRUE, showWarnings = FALSE)

# List of all 34 ZA study numbers (without "ZA" prefix for gesisdata)
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

cat("=======================================================\n")
cat("Eurobarometer Survey Download Script (Manual Version)\n")
cat("=======================================================\n\n")
cat("This script will download", length(study_ids), "Eurobarometer surveys\n\n")

# Prompt for credentials once
cat("Enter your GESIS credentials:\n")
gesis_email <- readline(prompt = "Email: ")
gesis_password <- readline(prompt = "Password: ")

# Set environment variables for the session
Sys.setenv(GESIS_USER = gesis_email)
Sys.setenv(GESIS_PASS = gesis_password)

cat("\nStarting downloads...\n")
cat("Download directory:", download_dir, "\n\n")

# Download all surveys
successful <- 0
failed_studies <- c()

for (i in seq_along(study_ids)) {
  study_id <- study_ids[i]
  cat(sprintf("\n[%d/%d] Downloading ZA%s...\n", i, length(study_ids), study_id))

  tryCatch({
    gesis_download(
      file_id = study_id,
      download_dir = download_dir,
      filetype = ".dta",
      purpose = 5  # Scientific research
    )
    successful <- successful + 1
    cat(sprintf("✓ Successfully downloaded ZA%s\n", study_id))

  }, error = function(e) {
    failed_studies <- c(failed_studies, study_id)
    cat(sprintf("✗ Failed: %s\n", e$message))
  })

  Sys.sleep(2)
}

# Summary
cat("\n=======================================================\n")
cat(sprintf("Summary: %d successful, %d failed\n", successful, length(failed_studies)))
if (length(failed_studies) > 0) {
  cat("Failed studies:", paste0("ZA", failed_studies, collapse = ", "), "\n")
}
cat("=======================================================\n")
