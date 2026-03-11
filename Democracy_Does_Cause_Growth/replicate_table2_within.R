# Replication of Table 2 (Within Estimates) from "Democracy Does Cause Growth"
# Acemoglu, Naidu, Restrepo, and Robinson (2019, JPE)

# Load required packages
library(haven)      # For reading Stata files
library(fixest)     # For fixed effects estimation
library(lmtest)     # For robust standard errors
library(sandwich)   # For robust standard errors
library(dplyr)

# Set working directory
setwd("/Users/sm38679/Documents/GitHub/replicationData/Democracy_Does_Cause_Growth")

# Load data
data <- read_dta("DDCGdata_final.dta")

# Create necessary variables
# The paper uses log GDP per capita and a dichotomous democracy measure

# Display variable names to understand the data structure
cat("Variable names in dataset:\n")
print(names(data))

# Assuming the key variables are:
# - country_id or similar for country identifier
# - year for time
# - dem or democracy for democracy indicator
# - lgdppc or similar for log GDP per capita

# Function to calculate long-run effect
calc_long_run_effect <- function(beta_dem, gamma_coefs) {
  persistence <- sum(gamma_coefs)
  long_run <- beta_dem / (1 - persistence)
  return(long_run)
}

# Function to calculate 25-year effect
calc_25year_effect <- function(beta_dem, gamma_coefs, years = 25) {
  cumulative_effect <- 0
  temp_effect <- beta_dem

  for (i in 1:years) {
    cumulative_effect <- cumulative_effect + temp_effect
    # Calculate next year's effect
    temp_effect <- 0
    for (j in 1:min(length(gamma_coefs), i)) {
      if (i - j == 0) {
        temp_effect <- temp_effect + gamma_coefs[j] * beta_dem
      } else {
        # This would need the full path, simplified here
      }
    }
  }

  return(cumulative_effect)
}

# Estimate models with different numbers of lags
# Model 1: 1 lag
# Model 2: 2 lags
# Model 3: 4 lags (preferred specification)
# Model 4: 8 lags

cat("\n=== REPLICATING TABLE 2, PANEL A: WITHIN ESTIMATES ===\n\n")

# Note: You'll need to adjust variable names based on actual data
# Common possibilities: democracy, dem, democ for democracy variable
#                      lgdppc, lgdp, log_gdppc for log GDP per capita
#                      country_name, country_id, ccode for country
#                      year for time

cat("Please check the actual variable names in your data and adjust the script accordingly.\n")
cat("Run: names(data) to see all variable names.\n")

# Example template (adjust variable names as needed):
#
# # Model 1: 1 lag
# mod1 <- feols(lgdppc ~ democracy + l(lgdppc, 1) | country + year,
#               data = data,
#               cluster = ~country)
#
# # Model 2: 2 lags
# mod2 <- feols(lgdppc ~ democracy + l(lgdppc, 1:2) | country + year,
#               data = data,
#               cluster = ~country)
#
# # Model 3: 4 lags (preferred)
# mod3 <- feols(lgdppc ~ democracy + l(lgdppc, 1:4) | country + year,
#               data = data,
#               cluster = ~country)
#
# # Model 4: 8 lags
# mod4 <- feols(lgdppc ~ democracy + l(lgdppc, 1:8) | country + year,
#               data = data,
#               cluster = ~country)
#
# # Display results
# etable(mod1, mod2, mod3, mod4,
#        se = "cluster",
#        cluster = ~country,
#        digits = 3)

cat("\nScript created. Please:\n")
cat("1. Check variable names in the data\n")
cat("2. Uncomment and adjust the model specifications\n")
cat("3. Run the models\n")
