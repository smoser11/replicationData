#!/usr/bin/env Rscript
# DatasetBuilder_BHPS.R
# R translation of DatasetBuilder_BHPS.do
# Creates clean_bhps.dta from BHPS and UKHLS data

# Load required libraries
library(haven)
library(dplyr)
library(tidyr)

# Set paths (update these to match your setup)
# BHPS_PATH <- "/Users/sm38679/Documents/GitHub/replicationData/Replication_Data_for_Happiness_and_Voting/Raw Data/bhps"
# CLEAN_PATH <- "/Users/sm38679/Documents/GitHub/replicationData/Replication_Data_for_Happiness_and_Voting/Clean Data"
BHPS_PATH <- "/home/smoser/Documents/GitHub/replicationData/Replication_Data_for_Happiness_and_Voting/Raw Data/bhps"
CLEAN_PATH <- "/home/smoser/Documents/GitHub/replicationData/Replication_Data_for_Happiness_and_Voting/Clean Data"

cat("=========================================\n")
cat("Building BHPS Dataset\n")
cat("=========================================\n\n")

# ============================================================================
# PART 1: Load and combine BHPS household data (waves a-r, 18 waves)
# ============================================================================
cat("Loading BHPS household data...\n")

bhps_hh_list <- list()
waves <- letters[1:18]  # a through r

for (i in seq_along(waves)) {
  wave_letter <- waves[i]
  wave_num <- i

  file_path <- file.path(BHPS_PATH, sprintf("bhps_w%d", wave_num),
                          sprintf("b%s_hhresp.dta", wave_letter))

  if (file.exists(file_path)) {
    cat(sprintf("  Loading BHPS wave %d (%s)...\n", wave_num, wave_letter))
    df <- read_dta(file_path)

    # Remove wave prefix from column names (e.g., "ba_" becomes "")
    names(df) <- sub(sprintf("^b%s_", wave_letter), "", names(df))

    # Add wave number
    df$wave <- wave_num

    bhps_hh_list[[i]] <- df
  } else {
    cat(sprintf("  WARNING: File not found for BHPS wave %d: %s\n", wave_num, file_path))
  }
}

# Combine all BHPS household data
bhps_hh <- bind_rows(bhps_hh_list)
bhps_hh <- bhps_hh %>% arrange(hid, wave)
cat(sprintf("  → Combined BHPS household data: %d observations\n\n", nrow(bhps_hh)))

# ============================================================================
# PART 2: Load and combine BHPS individual data (waves a-r, 18 waves)
# ============================================================================
cat("Loading BHPS individual data...\n")

bhps_ind_list <- list()

for (i in seq_along(waves)) {
  wave_letter <- waves[i]
  wave_num <- i

  file_path <- file.path(BHPS_PATH, sprintf("bhps_w%d", wave_num),
                          sprintf("b%s_indresp.dta", wave_letter))

  if (file.exists(file_path)) {
    cat(sprintf("  Loading BHPS wave %d (%s)...\n", wave_num, wave_letter))
    df <- read_dta(file_path)

    # Remove wave prefix from column names
    names(df) <- sub(sprintf("^b%s_", wave_letter), "", names(df))

    # Add wave number
    df$wave <- wave_num

    bhps_ind_list[[i]] <- df
  } else {
    cat(sprintf("  WARNING: File not found for BHPS wave %d: %s\n", wave_num, file_path))
  }
}

# Combine all BHPS individual data
bhps_ind <- bind_rows(bhps_ind_list)
bhps_ind <- bhps_ind %>% arrange(pid, wave)
cat(sprintf("  → Combined BHPS individual data: %d observations\n\n", nrow(bhps_ind)))

# Merge BHPS household and individual data
cat("Merging BHPS household and individual data...\n")
bhps_long <- bhps_ind %>%
  inner_join(bhps_hh, by = c("hid", "wave"))
cat(sprintf("  → BHPS merged data: %d observations\n\n", nrow(bhps_long)))

# Clean up
rm(bhps_hh_list, bhps_ind_list, bhps_hh, bhps_ind)
gc()

# ============================================================================
# PART 3: Load and combine UKHLS household data (waves a-f, 6 waves)
# ============================================================================
cat("Loading UKHLS household data...\n")

ukhls_hh_list <- list()
ukhls_waves <- letters[1:6]  # a through f

for (j in seq_along(ukhls_waves)) {
  wave_letter <- ukhls_waves[j]
  wave_num <- 18 + j  # UKHLS starts at wave 19

  file_path <- file.path(BHPS_PATH, sprintf("ukhls_w%d", j),
                          sprintf("%s_hhresp.dta", wave_letter))

  if (file.exists(file_path)) {
    cat(sprintf("  Loading UKHLS wave %d (%s)...\n", j, wave_letter))
    df <- read_dta(file_path)

    # Remove wave prefix from column names
    names(df) <- sub(sprintf("^%s_", wave_letter), "", names(df))

    # Add wave number
    df$wave <- wave_num

    ukhls_hh_list[[j]] <- df
  } else {
    cat(sprintf("  WARNING: File not found for UKHLS wave %d: %s\n", j, file_path))
  }
}

# Combine all UKHLS household data
ukhls_hh <- bind_rows(ukhls_hh_list)
ukhls_hh <- ukhls_hh %>% arrange(hidp, wave)
cat(sprintf("  → Combined UKHLS household data: %d observations\n\n", nrow(ukhls_hh)))

# ============================================================================
# PART 4: Load and combine UKHLS individual data (waves a-f, 6 waves)
# ============================================================================
cat("Loading UKHLS individual data...\n")

ukhls_ind_list <- list()

for (j in seq_along(ukhls_waves)) {
  wave_letter <- ukhls_waves[j]
  wave_num <- 18 + j

  file_path <- file.path(BHPS_PATH, sprintf("ukhls_w%d", j),
                          sprintf("%s_indresp.dta", wave_letter))

  if (file.exists(file_path)) {
    cat(sprintf("  Loading UKHLS wave %d (%s)...\n", j, wave_letter))
    df <- read_dta(file_path)

    # Remove wave prefix from column names
    names(df) <- sub(sprintf("^%s_", wave_letter), "", names(df))

    # Add wave number
    df$wave <- wave_num

    ukhls_ind_list[[j]] <- df
  } else {
    cat(sprintf("  WARNING: File not found for UKHLS wave %d: %s\n", j, file_path))
  }
}

# Combine all UKHLS individual data
ukhls_ind <- bind_rows(ukhls_ind_list)
ukhls_ind <- ukhls_ind %>% arrange(pidp, wave)
cat(sprintf("  → Combined UKHLS individual data: %d observations\n\n", nrow(ukhls_ind)))

# Merge UKHLS household and individual data
cat("Merging UKHLS household and individual data...\n")
ukhls_long <- ukhls_ind %>%
  inner_join(ukhls_hh, by = c("hidp", "wave"))
cat(sprintf("  → UKHLS merged data: %d observations\n\n", nrow(ukhls_long)))

# Clean up
rm(ukhls_hh_list, ukhls_ind_list, ukhls_hh, ukhls_ind)
gc()

# ============================================================================
# PART 5: Combine BHPS and UKHLS
# ============================================================================
cat("Combining BHPS and UKHLS datasets...\n")

# Append BHPS to UKHLS
combined <- bind_rows(ukhls_long, bhps_long)

# Create unified ID variable
combined <- combined %>%
  mutate(
    pid = ifelse(pid < 1 | is.na(pid), NA_real_, pid),
    id = ifelse(!is.na(pid), pid, -pidp),
    upid = as.numeric(factor(id))
  )

cat(sprintf("  → Combined dataset: %d observations\n\n", nrow(combined)))

# Clean up
rm(bhps_long, ukhls_long)
gc()

# ============================================================================
# PART 6: Create derived variables
# ============================================================================
cat("Creating derived variables...\n")

# Dates
combined <- combined %>%
  mutate(
    year = ifelse(istrtdaty > 0, istrtdaty, NA_real_),
    month = ifelse(istrtdatm > 0, istrtdatm, NA_real_)
  )

# Region
# gor_dv exists in UKHLS, but not in early BHPS waves
# Need to handle both gor_dv (UKHLS) and region (BHPS)
# First, create gor_dv and region if they don't exist
if (!"gor_dv" %in% names(combined)) {
  combined$gor_dv <- NA_real_
}
if (!"region" %in% names(combined)) {
  combined$region <- NA_real_
}

combined <- combined %>%
  mutate(
    reg = case_when(
      !is.na(gor_dv) & gor_dv > 0 ~ gor_dv,
      !is.na(region) & region > 0 ~ region,
      TRUE ~ NA_real_
    ),
    reg = ifelse(reg %in% c(-10:-1), 99, reg),
    reg = ifelse(reg == 13, 99, reg)
  ) %>%
  filter(is.na(reg) | reg != 12)  # Drop Northern Ireland

# Life satisfaction
combined <- combined %>%
  mutate(
    lifesatisfaction = ifelse(lfsato > 0, lfsato, NA_real_),
    lifesatisfaction = ifelse(sclfsato > 0 & is.na(lifesatisfaction), sclfsato, lifesatisfaction)
  )

# Finances
combined <- combined %>%
  mutate(
    # Financial situation today (reversed from 5-point to make higher = better)
    finansit_today = case_when(
      finnow == 5 ~ 1,
      finnow == 4 ~ 2,
      finnow == 3 ~ 3,
      finnow == 2 ~ 4,
      finnow == 1 ~ 5,
      TRUE ~ NA_real_
    ),
    # Financial situation change (1 year)
    finansit_1ychange = case_when(
      fisitc == 1 ~ 3,  # Better
      fisitc == 2 ~ 1,  # Worse
      fisitc == 3 ~ 2,  # Same
      TRUE ~ NA_real_
    ),
    # Financial situation future
    finansit_future = case_when(
      fisitx == 1 ~ 3,  # Better
      fisitx == 2 ~ 1,  # Worse
      fisitx == 3 ~ 2,  # Same
      finfut == 1 ~ 3,
      finfut == 2 ~ 1,
      finfut == 3 ~ 2,
      TRUE ~ NA_real_
    )
  )

# Create dummy variables for financial situation
for (i in 1:5) {
  combined[[paste0("fin_today", i)]] <- as.numeric(combined$finansit_today == i)
}

for (i in 1:3) {
  combined[[paste0("fin_1ych", i)]] <- as.numeric(combined$finansit_1ychange == i)
  combined[[paste0("fin_fut", i)]] <- as.numeric(combined$finansit_future == i)
}

# Helper function for mode (define before use)
modal_value <- function(x) {
  ux <- unique(x[!is.na(x)])
  if (length(ux) == 0) return(NA)
  ux[which.max(tabulate(match(x, ux)))]
}

# Gender
# More memory-efficient approach: create women first, then handle modal values separately
cat("  → Processing gender variable...\n")
combined <- combined %>%
  mutate(women = ifelse(sex == 2, 1, ifelse(sex > 0, 0, NA_real_)))

# Fill missing women values with modal value per person (using data.table for efficiency)
library(data.table)
dt <- as.data.table(combined)
dt[, women_mode := {
  w <- women[!is.na(women)]
  if (length(w) > 0) modal_value(w) else NA_real_
}, by = id]
dt[is.na(women), women := women_mode]
dt[, women_mode := NULL]

# Filter out individuals with inconsistent gender coding
dt[, women_sd := sd(women, na.rm = TRUE), by = id]
dt <- dt[women_sd == 0 | is.na(women_sd)]
dt[, women_sd := NULL]

combined <- as_tibble(dt)
rm(dt)
gc()

# *** CRITICAL FIX: Age variable ***
# The original Stata code dropped age and only used age_dv, which doesn't exist in early BHPS waves
# Fix: Use age_dv when available (UKHLS), fall back to age (BHPS)
cat("  → Creating age variable (FIXED to handle missing age_dv)...\n")

combined <- combined %>%
  mutate(
    # Use age_dv if it exists and is positive, otherwise use age
    age_final = case_when(
      !is.na(age_dv) & age_dv > 0 ~ age_dv,
      !is.na(age) & age > 0 ~ age,
      TRUE ~ NA_real_
    )
  ) %>%
  # Remove the old age column and rename
  select(-matches("^age$")) %>%
  rename(age = age_final) %>%
  mutate(agesq = (age * age) / 1000) %>%
  filter(age >= 18 | is.na(age))

# Number of children
combined <- combined %>%
  mutate(
    num_children = ifelse(nkids_dv >= 0, nkids_dv, 0)
  )

# Adults in household
# Create hhtype and hhtype_dv if they don't exist
if (!"hhtype" %in% names(combined)) {
  combined$hhtype <- NA_real_
}
if (!"hhtype_dv" %in% names(combined)) {
  combined$hhtype_dv <- NA_real_
}

combined <- combined %>%
  mutate(
    adults = case_when(
      hhtype %in% c(3, 4, 5) ~ 2,
      hhtype == 8 ~ 3,
      hhtype_dv > 5 & hhtype_dv < 19 ~ 2,
      hhtype_dv > 18 ~ 3,
      TRUE ~ 1
    )
  )

# Equivalence scale for income
combined <- combined %>%
  mutate(
    equivscale = case_when(
      hhtype %in% c(1, 2, 7) | hhtype_dv %in% c(1, 2, 3) ~ 1,
      hhtype %in% c(3, 5) | hhtype_dv %in% c(6, 8, 16, 17) ~ 1.7,
      hhtype_dv %in% c(10, 11, 12, 18) | hhtype == 4 ~ 1.7 + 0.5 * num_children,
      hhtype == 6 | hhtype_dv %in% c(4, 5) ~ 1 + 0.5 * num_children,
      hhtype %in% c(8, 9) | hhtype_dv %in% c(19, 20, 21, 22, 23) ~ 2,
      TRUE ~ 1
    )
  )

# Income
combined <- combined %>%
  mutate(
    income_gross_nominal = ifelse(fihhmngrs_dv != -9, fihhmngrs_dv, NA_real_),
    income_gross_nominal_equiv = income_gross_nominal / equivscale,
    logincome = log(income_gross_nominal_equiv)
  )

# Marital status
combined <- combined %>%
  mutate(
    mastat = ifelse(mastat <= 0, NA_real_, mastat),
    mastat_dv = ifelse(mastat_dv <= 0, NA_real_, mastat_dv),
    mar_single = as.numeric(mastat == 6 | mastat_dv == 1),
    mar_married = as.numeric(mastat_dv %in% c(2, 3, 10) | mastat %in% c(1, 2, 7)),
    mar_divsep = as.numeric(mastat_dv %in% c(4, 5, 7, 8) | mastat %in% c(4, 5, 8, 9)),
    mar_widowed = as.numeric(mastat_dv %in% c(6, 9) | mastat %in% c(3, 10)),
    mar_single = ifelse(is.na(mastat) & is.na(mastat_dv), NA_real_, mar_single),
    mar_married = ifelse(is.na(mastat) & is.na(mastat_dv), NA_real_, mar_married),
    mar_divsep = ifelse(is.na(mastat) & is.na(mastat_dv), NA_real_, mar_divsep),
    mar_widowed = ifelse(is.na(mastat) & is.na(mastat_dv), NA_real_, mar_widowed)
  )

# Politics
combined <- combined %>%
  mutate(
    pol_supports_lab = ifelse(vote4 == 2 & vote4 > 0, 1,
                             ifelse(vote4 > 0, 0,
                                   ifelse(vote3 == 2 & vote3 > -2, 1,
                                         ifelse(vote3 > -2, 0, NA_real_)))),
    pol_supports_con = ifelse(vote4 == 1 & vote4 > 0, 1,
                             ifelse(vote4 > 0, 0,
                                   ifelse(vote3 == 1 & vote3 > -2, 1,
                                         ifelse(vote3 > -2, 0, NA_real_)))),
    pol_supports_lib = ifelse(vote4 == 3 & vote4 > 0, 1,
                             ifelse(vote4 > 0, 0,
                                   ifelse(vote3 == 3 & vote3 > -2, 1,
                                         ifelse(vote3 > -2, 0, NA_real_))))
  )

# Government party support (based on year and coalition status)
combined <- combined %>%
  mutate(
    pol_supports_govparty = case_when(
      year < 1997 & !is.na(pol_supports_lab) ~ as.numeric(pol_supports_con == 1),
      year == 1997 & month <= 4 & !is.na(pol_supports_lab) ~ as.numeric(pol_supports_con == 1),
      year == 1997 & month >= 5 & !is.na(pol_supports_lab) ~ as.numeric(pol_supports_lab == 1),
      year > 1997 & year < 2010 & !is.na(pol_supports_lab) ~ as.numeric(pol_supports_lab == 1),
      year == 2010 & month <= 4 & !is.na(pol_supports_lab) ~ as.numeric(pol_supports_lab == 1),
      year > 2010 & year < 2015 & !is.na(pol_supports_lab) ~ as.numeric(pol_supports_con == 1 | pol_supports_lib == 1),
      year == 2015 & month <= 4 & !is.na(pol_supports_lab) ~ as.numeric(pol_supports_con == 1 | pol_supports_lib == 1),
      year == 2015 & month >= 5 & !is.na(pol_supports_lab) ~ as.numeric(pol_supports_con == 1),
      year > 2015 & !is.na(pol_supports_lab) ~ as.numeric(pol_supports_con == 1),
      TRUE ~ NA_real_
    )
  )

# Keep only relevant variables
keep_vars <- c("pid", "id", "wave", "age", "year", "month", "reg", "lifesatisfaction",
               "finansit_today", "finansit_1ychange", "finansit_future",
               paste0("fin_today", 1:5), paste0("fin_1ych", 1:3), paste0("fin_fut", 1:3),
               "women", "agesq", "income_gross_nominal_equiv", "logincome",
               "mar_single", "mar_married", "mar_divsep", "mar_widowed",
               "pol_supports_lab", "pol_supports_con", "pol_supports_lib", "pol_supports_govparty")

combined <- combined %>% select(all_of(keep_vars[keep_vars %in% names(combined)]))

# Standardized life satisfaction
combined <- combined %>%
  mutate(z_lifesatisfaction = (lifesatisfaction - mean(lifesatisfaction, na.rm = TRUE)) /
           sd(lifesatisfaction, na.rm = TRUE))

# Drop missing PIDs
combined <- combined %>% filter(!is.na(pid))

# Drop waves where life satisfaction not asked
combined <- combined %>%
  filter(wave >= 6, wave != 11)

# Count observations per person
combined <- combined %>%
  group_by(pid) %>%
  mutate(count_pid = n()) %>%
  ungroup()

cat(sprintf("  → Final dataset: %d observations\n", nrow(combined)))
cat(sprintf("  → Age variable non-missing: %d (%.1f%%)\n",
            sum(!is.na(combined$age)),
            100 * sum(!is.na(combined$age)) / nrow(combined)))

# ============================================================================
# PART 7: Save output
# ============================================================================
cat("\nSaving clean_bhps.dta...\n")

output_file <- file.path(CLEAN_PATH, "clean_bhps.dta")
write_dta(combined, output_file)

cat(sprintf("  → Saved: %s\n", output_file))
cat(sprintf("  → File size: %.1f MB\n", file.size(output_file) / 1024^2))

cat("\n=========================================\n")
cat("Dataset building complete!\n")
cat("=========================================\n")
