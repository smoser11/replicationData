# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Repository Purpose

This repository contains replication materials for the academic paper "Happiness and Voting: Evidence from Four Decades of Elections in Europe" by George Ward (MIT), published in the American Journal of Political Science. The analysis examines the relationship between national happiness (subjective well-being) and electoral outcomes across 15 European countries from 1973-2014.

## Primary Replication Folder

**Focus exclusively on:** `Replication_Data_for_Happiness_and_Voting/`

All replication code, data, and documentation are contained in this folder. Do not work outside this folder unless explicitly instructed.

## Code Structure & Workflow

The replication package follows a **pipeline architecture** orchestrated by `Master.do`:

### 1. Data Cleaning Phase
Scripts that process raw survey and electoral data:
- **`Cleaner_votingdata.do`**: Processes ParlGov electoral data, creates cabinet composition variables, merges party IDs, generates election results dataset
- **`Cleaner_swb.do`**: Processes 34 Eurobarometer surveys individually, standardizes life satisfaction variables, creates harmonized survey dataset spanning 1973-2014

### 2. Dataset Building Phase
Scripts that merge cleaned data to create analysis-ready files:
- **`DatasetBuilder_EB_Macro.do`**: Creates **`clean_macro.dta`** (national-level analysis file) by merging:
  - Aggregated Eurobarometer life satisfaction data (by survey and by year)
  - Election results from `Cleaner_votingdata.do`
  - Economic indicators (OECD/World Bank)
  - Uses custom `nearmrgstable.ado` to match election dates to nearest prior survey

- **`DatasetBuilder_EB_Micro.do`**: Creates `clean_micro.dta` (individual-level cross-sectional analysis)
- **`DatasetBuilder_BHPS.do`**: Creates `clean_bhps.dta` (British panel data)
- **`DatasetBuilder_SOEP.do`**: Creates `clean_soep.dta` (German panel data)

### 3. Analysis Phase
Scripts that generate tables and figures for the paper:
- **`Analysis_EB_Macro.do`**: National-level analysis (Section II) - uses `clean_macro.dta`
- **`Analysis_EB_Micro.do`**: Individual-level analysis (Section III)
- **`Analysis_Panels.do`**: Panel analysis (Section IV)

## Key Technical Details

### Path Configuration
All scripts use **global macros** for paths (defined in Master.do lines 3-14):
```stata
global path = "/Users/wardg/Dropbox (MIT)/..."  // MUST be updated for your machine
global raw = "$path/Raw Data"
global do = "$path/Do Files"
global clean = "$path/Clean Data"
global eb = "$raw/EB"
global soep = "$raw/SOEP"
global bhps = "$raw/BHPS"
global vote = "$raw/Voting"
global res = "$path/Results"
```

### Custom Stata Commands
- **`nearmrgstable.ado`**: Custom merge command that matches election dates to the nearest prior Eurobarometer survey date (critical for macro analysis)
- External packages installed via Master.do: `carryforward`, `tsspell`, `dm7`, `estout`, `cibar`

### Data Processing Patterns

**Cleaner_swb.do structure** (1412 lines):
- Processes each of 34 Eurobarometer surveys individually in sequence
- Each survey block: loads raw .dta → renames variables → recodes life satisfaction scale → saves temporary file
- Variable name mappings change across surveys (e.g., v37 vs v40 for satislfe)
- Standardizes marital status, education, age, sex, political orientation (lrs)
- Combines individual surveys → Mannheim Trend File → final aggregation
- Creates survey-level and year-level aggregates with residualized happiness measures

**Cleaner_votingdata.do structure** (470 lines):
- Builds party fractionalization dataset from Gallagher data
- Processes ParlGov data (parties, elections, cabinets) with extensive manual fixes for country-specific issues
- Key country-specific corrections: Italy 2001/2008, Germany CDU/CSU handling, France UMP merger
- Creates time-series panel of cabinet composition matched to Eurobarometer party IDs
- Generates derived variables: vote shares (current & lagged), ideological positions, coalition indicators

**DatasetBuilder_EB_Macro.do** (creates the primary output `clean_macro.dta`):
- Merges election data with nearest-prior Eurobarometer survey using `nearmrgstable`
- Adds economic indicators (unemployment, inflation, GDP growth)
- Standardizes all variables for regression analysis
- Creates country-specific time trends (linear and quadratic)
- Final dataset structure: country-election observations with matched happiness/economic data

### Missing Data Requirements

**Critical**: The replication requires data not included in this repository:

**For `clean_macro.dta` only** (national-level analysis):
- 34 Eurobarometer surveys (ZA3521, ZA2828, ZA3693, etc.) - from GESIS
- Already have: `economic_data.dta`, `gallagher_data.xlsx`, `parlgov_stable.xlsx`, `party_xwalk.xlsx`

**For panel analyses** (BHPS/SOEP):
- UK Data Service Study #6614 (BHPS + Understanding Society)
- DIW SOEP-LONG v31 bilingual Stata files

See `DATA_ACQUISITION_GUIDE.md` for updated URLs (original README.pdf URLs are broken).

### Running the Replication

**Full replication**:
1. Set up folder structure: `Raw Data/{EB, BHPS, SOEP, Voting}`, `Clean Data/`, `Do Files/`, `Results/`
2. Update Master.do line 3 with your working directory
3. Run `Master.do` in Stata 14+

**To generate only `clean_macro.dta`**:
```stata
// After updating paths in Master.do
do Cleaner_votingdata.do
do Cleaner_swb.do
do DatasetBuilder_EB_Macro.do
```

This creates `Clean Data/clean_macro.dta` without requiring BHPS/SOEP data.

## Output Structure

- **`clean_macro.dta`**: Primary national-level dataset (country-election observations)
  - Key variables: `satislfe_survey_mean`, `vote_share_cab`, `vote_share_pm`, economic indicators
  - Standardized versions prefixed with `z_`
  - Residualized happiness: `satis_resid_nocontrols`, `satis_resid_dem`, `satis_resid_dempluspol`

- **`results.smcl`**: Stata log file with all regression output (included in package)

## Important Notes

- All code is written for **Stata 14 for Mac**
- The analysis covers **15 EU countries**: AUT, BEL, DNK, FIN, FRA, DEU, GBR, GRC, IRL, ITA, LUX, NLD, PRT, SWE, ESP
- Country-level clustering is used throughout for standard errors
- Eurobarometer life satisfaction question: 4-point scale (originally counter-intuitive, recoded: 1=not at all satisfied → 4=very satisfied)
- Time periods vary by country due to data availability (earliest: 1965, latest: 2014)

## When Modifying Code

- Preserve global macro structure for portability
- Maintain country-specific data restrictions (see drop if statements in Cleaner_votingdata.do)
- Be cautious with variable name changes - Eurobarometer variable names are inconsistent across waves
- The `nearmrgstable` merge is critical - it matches elections to the most recent prior survey, not exact dates
- All intermediate .dta files are erased after use to save space (see erase statements at end of cleaners)
