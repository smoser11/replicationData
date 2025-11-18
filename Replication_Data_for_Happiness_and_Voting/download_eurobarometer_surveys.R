#!/usr/bin/env Rscript
# Script to download all 34 Eurobarometer surveys required for Ward (2020) replication
# Requires GESIS registration and gesisdata package

# Install gesisdata package if needed
if (!require("gesisdata")) {
  install.packages("gesisdata")
}

library(gesisdata)

# Set download directory to Raw Data/EB folder
download_dir <- file.path(getwd(), "Raw Data", "EB")
dir.create(download_dir, recursive = TRUE, showWarnings = FALSE)

# List of all 34 ZA study numbers from the README
za_numbers <- c(
  "ZA3521",  # Trend
  "ZA2828",  # 44.2
  "ZA3693",  # 58.1
  "ZA3938",  # 60.1
  "ZA4229",  # 62.0
  "ZA4231",  # 62.2
  "ZA4411",  # 63.4
  "ZA4414",  # 64.2
  "ZA4506",  # 65.2
  "ZA4526",  # 66.1
  "ZA4530",  # 67.2
  "ZA4565",  # 68.1
  "ZA4744",  # 69.2
  "ZA4819",  # 70.1
  "ZA4971",  # 71.1
  "ZA4972",  # 71.2
  "ZA4973",  # 71.3
  "ZA4994",  # 72.4
  "ZA5234",  # 73.4
  "ZA5235",  # 73.5
  "ZA5449",  # 74.2
  "ZA5481",  # 75.3
  "ZA5564",  # 75.4
  "ZA5567",  # 76.3
  "ZA5612",  # 77.3
  "ZA5613",  # 77.4
  "ZA5685",  # 78.1
  "ZA5689",  # 79.3
  "ZA5876",  # 80.1
  "ZA5877",  # 80.2
  "ZA5913",  # 81.2
  "ZA5928",  # 81.4
  "ZA5929",  # 81.5
  "ZA5932"   # 82.3
)

cat("=======================================================\n")
cat("Eurobarometer Survey Download Script\n")
cat("=======================================================\n\n")
cat("This script will download", length(za_numbers), "Eurobarometer surveys\n")
cat("Download directory:", download_dir, "\n\n")

cat("IMPORTANT: You will be prompted for your GESIS credentials on first download\n")
cat("Email: Your GESIS registration email\n")
cat("Password: Your GESIS password\n\n")

# Attempt to download all surveys
successful_downloads <- c()
failed_downloads <- c()

for (i in seq_along(za_numbers)) {
  za_num <- za_numbers[i]
  cat(sprintf("\n[%d/%d] Downloading %s...\n", i, length(za_numbers), za_num))

  tryCatch({
    # Download the study (file_id without "ZA" prefix)
    study_id <- gsub("ZA", "", za_num)
    gesis_download(
      file_id = study_id,
      download_dir = download_dir,
      use = 5,  # 5 = for scientific research (incl. doctorate)
      convert = FALSE,  # Keep original .dta format instead of converting to .RData
      reset = (i == 1)  # Prompt for credentials on first download only
    )
    successful_downloads <- c(successful_downloads, za_num)
    cat(sprintf("✓ Successfully downloaded %s\n", za_num))

  }, error = function(e) {
    failed_downloads <- c(failed_downloads, za_num)
    cat(sprintf("✗ Failed to download %s: %s\n", za_num, e$message))
  })

  # Small delay to avoid overwhelming the server
  Sys.sleep(2)
}

# Summary
cat("\n=======================================================\n")
cat("Download Summary\n")
cat("=======================================================\n")
cat(sprintf("Successful: %d/%d\n", length(successful_downloads), length(za_numbers)))
cat(sprintf("Failed: %d/%d\n", length(failed_downloads), length(za_numbers)))

if (length(failed_downloads) > 0) {
  cat("\nFailed downloads:\n")
  cat(paste(failed_downloads, collapse = ", "), "\n")
  cat("\nYou can retry these manually at:\n")
  for (za in failed_downloads) {
    study_id <- gsub("ZA", "", za)
    cat(sprintf("  https://search.gesis.org/research_data/%s\n", za))
  }
}

cat("\nDownload directory:", download_dir, "\n")
cat("\nNext step: Check that all .dta files are present in Raw Data/EB/\n")
