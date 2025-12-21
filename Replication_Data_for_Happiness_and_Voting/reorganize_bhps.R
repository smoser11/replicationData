#!/usr/bin/env Rscript
# Reorganize BHPS and UKHLS files into wave-specific folders
# R translation of reorganize_bhps.sh

# Set the base directory (update if your extraction path is different)
BASE_DIR <- path.expand("~/Downloads/UKDA-6614-stata/stata/stata13_se")
DEST_DIR <- "/Users/sm38679/Documents/GitHub/replicationData/Replication_Data_for_Happiness_and_Voting/Raw Data/bhps"

# Create destination directory
if (!dir.exists(DEST_DIR)) {
  dir.create(DEST_DIR, recursive = TRUE)
}

cat("=========================================\n")
cat("Reorganizing BHPS files into wave folders\n")
cat("=========================================\n")

# BHPS waves: a through r (18 waves)
waves <- letters[1:18]  # a through r

for (i in seq_along(waves)) {
  wave_num <- i
  wave_letter <- waves[i]

  cat(sprintf("Processing BHPS Wave %d (letter: %s)...\n", wave_num, wave_letter))

  # Create wave folder
  wave_dir <- file.path(DEST_DIR, sprintf("bhps_w%d", wave_num))
  if (!dir.exists(wave_dir)) {
    dir.create(wave_dir, recursive = TRUE)
  }

  # Copy all files starting with b{wave_letter}_ to the wave folder
  bhps_source <- file.path(BASE_DIR, "bhps")
  if (dir.exists(bhps_source)) {
    pattern <- sprintf("^b%s_.*\\.dta$", wave_letter)
    files_to_copy <- list.files(bhps_source, pattern = pattern, full.names = TRUE)

    if (length(files_to_copy) > 0) {
      file.copy(files_to_copy, wave_dir, overwrite = TRUE)
      cat(sprintf("  → Copied %d files to bhps_w%d/\n", length(files_to_copy), wave_num))
    } else {
      cat(sprintf("  → No files found for bhps_w%d/\n", wave_num))
    }
  }
}

cat("\n")
cat("=========================================\n")
cat("Reorganizing UKHLS files into wave folders\n")
cat("=========================================\n")

# UKHLS waves: a through n (14 waves)
ukhls_waves <- letters[1:14]  # a through n

for (i in seq_along(ukhls_waves)) {
  wave_num <- i
  wave_letter <- ukhls_waves[i]

  cat(sprintf("Processing UKHLS Wave %d (letter: %s)...\n", wave_num, wave_letter))

  # Create wave folder
  wave_dir <- file.path(DEST_DIR, sprintf("ukhls_w%d", wave_num))
  if (!dir.exists(wave_dir)) {
    dir.create(wave_dir, recursive = TRUE)
  }

  # Copy all files starting with {wave_letter}_ to the wave folder
  ukhls_source <- file.path(BASE_DIR, "ukhls")
  if (dir.exists(ukhls_source)) {
    pattern <- sprintf("^%s_.*\\.dta$", wave_letter)
    files_to_copy <- list.files(ukhls_source, pattern = pattern, full.names = TRUE)

    if (length(files_to_copy) > 0) {
      file.copy(files_to_copy, wave_dir, overwrite = TRUE)
      cat(sprintf("  → Copied %d files to ukhls_w%d/\n", length(files_to_copy), wave_num))
    } else {
      cat(sprintf("  → No files found for ukhls_w%d/\n", wave_num))
    }
  }
}

cat("\n")
cat("=========================================\n")
cat("Reorganization Complete!\n")
cat("=========================================\n")
cat(sprintf("Files are now organized in: %s\n", DEST_DIR))
cat("\n")
cat("Verifying structure:\n")

bhps_dirs <- list.dirs(DEST_DIR, full.names = TRUE, recursive = FALSE)
bhps_dirs <- bhps_dirs[grepl("bhps_w|ukhls_w", basename(bhps_dirs))]
cat(paste(head(bhps_dirs, 10), collapse = "\n"))
cat("\n...\n\n")

bhps_count <- length(list.dirs(DEST_DIR, full.names = FALSE, recursive = FALSE)[grepl("^bhps_w", list.dirs(DEST_DIR, full.names = FALSE, recursive = FALSE))])
ukhls_count <- length(list.dirs(DEST_DIR, full.names = FALSE, recursive = FALSE)[grepl("^ukhls_w", list.dirs(DEST_DIR, full.names = FALSE, recursive = FALSE))])

cat(sprintf("Total BHPS wave folders: %d\n", bhps_count))
cat(sprintf("Total UKHLS wave folders: %d\n", ukhls_count))
