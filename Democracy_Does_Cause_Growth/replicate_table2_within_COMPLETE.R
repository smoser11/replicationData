# =============================================================================
# Replication of Table 2 (Panel A: Within Estimates)
# "Democracy Does Cause Growth" - Acemoglu, Naidu, Restrepo, and Robinson (2019)
# =============================================================================

# Load required packages
if (!require("haven")) install.packages("haven")
if (!require("fixest")) install.packages("fixest")
if (!require("dplyr")) install.packages("dplyr")
if (!require("lmtest")) install.packages("lmtest")
if (!require("sandwich")) install.packages("sandwich")

library(haven)
library(fixest)
library(dplyr)
library(lmtest)
library(sandwich)

# Set working directory
setwd("/Users/sm38679/Documents/GitHub/replicationData/Democracy_Does_Cause_Growth")

# Load data
cat("Loading data...\n")
data <- read_dta("DDCGdata_final.dta")

cat("Data dimensions:", dim(data)[1], "observations,", dim(data)[2], "variables\n\n")

# Set up panel structure (country and year)
cat("Setting up panel structure...\n")
data <- panel(data, panel.id = ~wbcode2 + year)
cat("Panel structure set.\n\n")

# =============================================================================
# Helper functions
# =============================================================================

# Calculate long-run effect: beta / (1 - sum of gamma coefficients)
calc_long_run <- function(beta_dem, gamma_coefs) {
  persistence <- sum(gamma_coefs, na.rm = TRUE)
  long_run <- beta_dem / (1 - persistence)
  return(long_run)
}

# Calculate standard error for long-run effect using delta method
calc_long_run_se <- function(beta_dem, se_dem, gamma_coefs, vcov_matrix, coef_names) {
  persistence <- sum(gamma_coefs, na.rm = TRUE)

  # Extract relevant part of variance-covariance matrix
  # For delta method: Var(f(theta)) = grad' * V * grad

  # This is a simplified calculation - for exact replication
  # you would want to use the full delta method via msm::deltamethod()

  # Simple approximation:
  denominator <- (1 - persistence)
  se_approx <- abs(beta_dem / denominator^2) * sqrt(sum(diag(vcov_matrix)[grep("lag", names(coef(vcov_matrix)))]))

  return(se_approx)
}

# Calculate 25-year cumulative effect
calc_25year_effect <- function(beta_dem, gamma_coefs, years = 25) {
  # This recursively calculates the cumulative effect over 25 years
  # effect_t = beta + gamma_1 * effect_(t-1) + gamma_2 * effect_(t-2) + ...

  n_lags <- length(gamma_coefs)
  effects <- numeric(years + n_lags)

  # Initialize: effect in year 0 is just beta
  for (i in 1:n_lags) {
    effects[i] <- 0
  }

  for (t in 1:years) {
    effects[n_lags + t] <- beta_dem
    for (j in 1:n_lags) {
      if (n_lags + t - j > 0) {
        effects[n_lags + t] <- effects[n_lags + t] + gamma_coefs[j] * effects[n_lags + t - j]
      }
    }
  }

  # Return cumulative sum up to 25 years
  cumulative <- sum(effects[(n_lags + 1):(n_lags + years)])
  return(cumulative)
}

# =============================================================================
# Estimate Models
# =============================================================================

cat("=================================================================\n")
cat("REPLICATING TABLE 2, PANEL A: WITHIN ESTIMATES\n")
cat("=================================================================\n\n")

# Model 1: 1 lag of GDP
cat("Model 1: 1 lag of log GDP\n")
cat("-----------------------------------------------------------------\n")

mod1 <- feols(y ~ dem + l(y, 1) | wbcode2 + year,
              data = data,
              cluster = ~wbcode2)

# Extract coefficients
beta_dem_1 <- coef(mod1)["dem"]
gamma_1 <- coef(mod1)["l(y, 1)"]

# Standard errors
se_dem_1 <- se(mod1)["dem"]

# Calculate derived statistics
persistence_1 <- gamma_1
long_run_1 <- calc_long_run(beta_dem_1, gamma_1)
effect_25_1 <- calc_25year_effect(beta_dem_1, gamma_1, 25)

cat("Democracy coefficient:", sprintf("%.3f", beta_dem_1), "\n")
cat("                   SE:", sprintf("(%.3f)", se_dem_1), "\n")
cat("Long-run effect:      ", sprintf("%.3f", long_run_1), "\n")
cat("Effect after 25 years:", sprintf("%.3f", effect_25_1), "\n")
cat("Persistence:          ", sprintf("%.3f", persistence_1), "\n")
cat("Observations:         ", mod1$nobs, "\n")
cat("Countries:            ", length(unique(data$wbcode2[!is.na(data$y) & !is.na(lag(data$y))])), "\n\n")


# Model 2: 2 lags of GDP
cat("Model 2: 2 lags of log GDP\n")
cat("-----------------------------------------------------------------\n")

mod2 <- feols(y ~ dem + l(y, 1:2) | wbcode2 + year,
              data = data,
              cluster = ~wbcode2)

beta_dem_2 <- coef(mod2)["dem"]
gamma_2 <- coef(mod2)[c("l(y, 1)", "l(y, 2)")]
se_dem_2 <- se(mod2)["dem"]

persistence_2 <- sum(gamma_2)
long_run_2 <- calc_long_run(beta_dem_2, gamma_2)
effect_25_2 <- calc_25year_effect(beta_dem_2, gamma_2, 25)

cat("Democracy coefficient:", sprintf("%.3f", beta_dem_2), "\n")
cat("                   SE:", sprintf("(%.3f)", se_dem_2), "\n")
cat("Long-run effect:      ", sprintf("%.3f", long_run_2), "\n")
cat("Effect after 25 years:", sprintf("%.3f", effect_25_2), "\n")
cat("Persistence:          ", sprintf("%.3f", persistence_2), "\n")
cat("Observations:         ", mod2$nobs, "\n")
cat("Countries:            ", mod2$nobs_origin["wbcode2"], "\n\n")


# Model 3: 4 lags of GDP (PREFERRED SPECIFICATION)
cat("Model 3: 4 lags of log GDP (PREFERRED)\n")
cat("-----------------------------------------------------------------\n")

mod3 <- feols(y ~ dem + l(y, 1:4) | wbcode2 + year,
              data = data,
              cluster = ~wbcode2)

beta_dem_3 <- coef(mod3)["dem"]
gamma_3 <- coef(mod3)[c("l(y, 1)", "l(y, 2)", "l(y, 3)", "l(y, 4)")]
se_dem_3 <- se(mod3)["dem"]

persistence_3 <- sum(gamma_3)
long_run_3 <- calc_long_run(beta_dem_3, gamma_3)
effect_25_3 <- calc_25year_effect(beta_dem_3, gamma_3, 25)

cat("Democracy coefficient:", sprintf("%.3f", beta_dem_3), "\n")
cat("                   SE:", sprintf("(%.3f)", se_dem_3), "\n")
cat("Long-run effect:      ", sprintf("%.3f", long_run_3), "\n")
cat("Effect after 25 years:", sprintf("%.3f", effect_25_3), "\n")
cat("Persistence:          ", sprintf("%.3f", persistence_3), "\n")
cat("Observations:         ", mod3$nobs, "\n")
cat("Countries:            ", mod3$nobs_origin["wbcode2"], "\n\n")


# Model 4: 8 lags of GDP
cat("Model 4: 8 lags of log GDP\n")
cat("-----------------------------------------------------------------\n")

mod4 <- feols(y ~ dem + l(y, 1:8) | wbcode2 + year,
              data = data,
              cluster = ~wbcode2)

beta_dem_4 <- coef(mod4)["dem"]
gamma_4 <- coef(mod4)[paste0("l(y, ", 1:8, ")")]
se_dem_4 <- se(mod4)["dem"]

persistence_4 <- sum(gamma_4)
long_run_4 <- calc_long_run(beta_dem_4, gamma_4)
effect_25_4 <- calc_25year_effect(beta_dem_4, gamma_4, 25)

# Test for joint significance of lags 5-8
cat("Testing joint significance of lags 5-8...\n")
test_lags <- wald(mod4, c("l(y, 5)", "l(y, 6)", "l(y, 7)", "l(y, 8)"))
# Extract p-value (wald returns the p-value directly in fixest)
p_val <- if(is.list(test_lags)) test_lags$p else test_lags[4]
cat("F-test p-value:", sprintf("%.3f", p_val), "\n\n")

cat("Democracy coefficient:", sprintf("%.3f", beta_dem_4), "\n")
cat("                   SE:", sprintf("(%.3f)", se_dem_4), "\n")
cat("Long-run effect:      ", sprintf("%.3f", long_run_4), "\n")
cat("Effect after 25 years:", sprintf("%.3f", effect_25_4), "\n")
cat("Persistence:          ", sprintf("%.3f", persistence_4), "\n")
cat("Observations:         ", mod4$nobs, "\n")
cat("Countries:            ", mod4$nobs_origin["wbcode2"], "\n\n")


# =============================================================================
# Create comparison table
# =============================================================================

cat("\n=================================================================\n")
cat("SUMMARY TABLE (Compare with Table 2, Panel A)\n")
cat("=================================================================\n\n")

# Note: The paper multiplies democracy coefficient by 100 to report in percentage points
results_table <- data.frame(
  Specification = c("1 lag", "2 lags", "4 lags (preferred)", "8 lags"),
  Democracy_Coef = c(beta_dem_1, beta_dem_2, beta_dem_3, beta_dem_4),
  SE = c(se_dem_1, se_dem_2, se_dem_3, se_dem_4),
  Long_Run = c(long_run_1, long_run_2, long_run_3, long_run_4),
  Effect_25yr = c(effect_25_1, effect_25_2, effect_25_3, effect_25_4),
  Persistence = c(persistence_1, persistence_2, persistence_3, persistence_4),
  N_obs = c(mod1$nobs, mod2$nobs, mod3$nobs, mod4$nobs)
)

print(results_table, digits = 3, row.names = FALSE)

cat("\nNOTE: Democracy coefficients are in log points.\n")
cat("      Paper reports these multiplied by 100.\n")
cat("      Long-run effects are percentage increases in GDP.\n\n")

cat("Expected values from Table 2 (Column 3, 4 lags):\n")
cat("  Democracy coef: 0.787 (SE: 0.226)\n")
cat("  Long-run effect: 21.24%\n")
cat("  Effect after 25 years: 16.90%\n")
cat("  Persistence: 0.963\n")
cat("  Observations: 6,336\n")
cat("  Countries: 175\n\n")

# Display full regression table with etable
cat("=================================================================\n")
cat("DETAILED REGRESSION OUTPUT\n")
cat("=================================================================\n\n")

etable(mod1, mod2, mod3, mod4,
       headers = c("1 lag", "2 lags", "4 lags", "8 lags"),
       digits = 3,
       digits.stats = 1)

cat("\n=================================================================\n")
cat("Replication complete!\n")
cat("=================================================================\n")
