# GESIS Eurobarometer Data Acquisition and Processing

This document provides complete, reproducible instructions for acquiring and processing the 34 Eurobarometer surveys needed for the Ward (2020) "Happiness and Voting" replication.

## Table of Contents
- [Overview](#overview)
- [Prerequisites](#prerequisites)
- [Data Required](#data-required)
- [Method 1: Automated Download (Recommended)](#method-1-automated-download-recommended)
- [Method 2: Manual Download](#method-2-manual-download)
- [Data Processing](#data-processing)
- [Verification](#verification)
- [Troubleshooting](#troubleshooting)

---

## Overview

**What we're acquiring**: 34 Eurobarometer survey datasets from GESIS (Leibniz Institute for the Social Sciences)

**Final output**: `Clean Data/clean_macro.dta` - National-level macro panel dataset

**Time required**:
- Registration: 10-15 minutes
- Automated download: 30-60 minutes (depends on internet speed)
- Data processing: 10-15 minutes

---

## Prerequisites

### Software Requirements
- **Python 3.7+** with the following packages:
  - `selenium`
  - `webdriver-manager`

  Install with:
  ```bash
  pip3 install selenium webdriver-manager
  ```

- **Chrome browser** (required for Selenium automation)

- **Stata 14+** (for data processing)

### GESIS Account
You need a free GESIS account with academic access:

1. Go to https://login.gesis.org/realms/gesis/login-actions/registration
2. Complete registration with your academic email
3. Verify your email address
4. Log in at https://login.gesis.org/

**Important**: Keep your login credentials handy - you'll need them for the automated download.

---

## Data Required

The replication requires **34 Eurobarometer datasets** in Stata (.dta) format:

| EB # | ZA Study | Data File | Years Covered |
|------|----------|-----------|---------------|
| Trend | ZA3521 | ZA3521_v2-0-1.dta | 1970-2002 |
| 44.2 | ZA2828 | ZA2828_v1-0-1.dta | 1995-1996 |
| 58.1 | ZA3693 | ZA3693_v1-0-1.dta | 2002 |
| 60.1 | ZA3938 | ZA3938_v1-0-1.dta | 2003 |
| 62.0 | ZA4229 | ZA4229_v1-1-0.dta | 2004 |
| 62.2 | ZA4231 | ZA4231_v1-1-0.dta | 2004 |
| 63.4 | ZA4411 | ZA4411_v1-1-0.dta | 2005 |
| 64.2 | ZA4414 | ZA4414_v1-1-0.dta | 2005 |
| 65.2 | ZA4506 | ZA4506_v1-0-1.dta | 2006 |
| 66.1 | ZA4526 | ZA4526_v1-0-1.dta | 2006 |
| 67.2 | ZA4530 | ZA4530_v2-1-0.dta | 2007 |
| 68.1 | ZA4565 | ZA4565_v4-0-1.dta | 2007 |
| 69.2 | ZA4744 | ZA4744_v5-0-0.dta | 2008 |
| 70.1 | ZA4819 | ZA4819_v3-0-2.dta | 2008 |
| 71.1 | ZA4971 | ZA4971_v4-0-0.dta | 2009 |
| 71.2 | ZA4972 | ZA4972_v3-0-2.dta | 2009 |
| 71.3 | ZA4973 | ZA4973_v3-0-0.dta | 2009 |
| 72.4 | ZA4994 | ZA4994_v3-0-0.dta | 2009 |
| 73.4 | ZA5234 | ZA5234_v2-0-1.dta | 2010 |
| 73.5 | ZA5235 | ZA5235_v4-0-0.dta | 2010 |
| 74.2 | ZA5449 | ZA5449_v2-2-0.dta | 2010 |
| 75.3 | ZA5481 | ZA5481_v2-0-1.dta | 2011 |
| 75.4 | ZA5564 | ZA5564_v3-0-1.dta | 2011 |
| 76.3 | ZA5567 | ZA5567_v2-0-1.dta | 2011 |
| 77.3 | ZA5612 | ZA5612_v2-0-0.dta | 2012 |
| 77.4 | ZA5613 | ZA5613_v3-0-0.dta | 2012 |
| 78.1 | ZA5685 | ZA5685_v2-0-0.dta | 2012 |
| 79.3 | ZA5689 | ZA5689_v2-0-0.dta | 2013 |
| 80.1 | ZA5876 | ZA5876_v2-0-0.dta | 2013 |
| 80.2 | ZA5877 | ZA5877_v2-0-0.dta | 2013 |
| 81.2 | ZA5913 | ZA5913_v2-0-0.dta | 2014 |
| 81.4 | ZA5928 | ZA5928_v3-0-0.dta | 2014 |
| 81.5 | ZA5929 | ZA5929_v3-0-0.dta | 2014 |
| 82.3 | ZA5932 | ZA5932_v3-0-0.dta | 2014 |

**Total data size**: Approximately 2-3 GB

---

## Method 1: Automated Download (Recommended)

### Overview
We've created a Python script that automates the entire download process using Selenium WebDriver.

### Step 1: Verify the Download Script

The script `download_eurobarometer_working.py` should be in your replication folder. Verify it exists:

```bash
ls -la download_eurobarometer_working.py
```

If it doesn't exist, the script is included in this repository.

### Step 2: Run the Automated Download

```bash
cd /path/to/Replication_Data_for_Happiness_and_Voting
python3 download_eurobarometer_working.py YOUR_EMAIL@example.com YOUR_PASSWORD
```

**Replace**:
- `YOUR_EMAIL@example.com` with your GESIS login email
- `YOUR_PASSWORD` with your GESIS password

### Step 3: Monitor Progress

The script will:
1. Log into GESIS automatically
2. Navigate to each dataset page
3. Click "Datasets" link
4. Select "lecturer" from purpose dropdown
5. Download the .dta.zip file
6. Continue to the next dataset

**Expected output**:
```
======================================================================
Eurobarometer Downloader - Following Demonstrated Workflow
======================================================================

Download directory: /path/to/Raw Data/EB
Total datasets: 34

Starting Chrome browser...
✓ Chrome started

[Step 1] Logging into GESIS...
✓ Logged in successfully

======================================================================
Processing ZA3521
======================================================================
  → Opening new tab...
  → Navigating to https://search.gesis.org/research_data/ZA3521
  → Clicking 'Datasets' link...
  → Selecting 'lecturer' from purpose dropdown...
  ✓ Purpose selected
  → Looking for .dta.zip file...
  → Found: ZA3521_v2-0-1.dta.zip
  → Clicking to download...
  ✓ Download started for ZA3521

[... continues for all 34 datasets ...]
```

### Step 4: Wait for Completion

**Total time**: 30-60 minutes depending on:
- Internet speed
- GESIS server load
- Browser performance

**Do not close the browser window** until the script completes.

When finished, you'll see:
```
======================================================================
DOWNLOAD SUMMARY
======================================================================
Successful: 34/34
Failed: 0/34

.zip files in directory: 34
======================================================================

Press Enter to close browser...
```

### Step 5: Extract Downloaded Files

Many files will be downloaded as `.dta.zip` files. Extract them:

```bash
cd "Raw Data/EB"

# Extract all .zip files
for file in *.zip; do
    unzip -o "$file"
    echo "Extracted: $file"
done
```

### Step 6: Verify All Files Present

Run this verification script:

```bash
cd "Raw Data/EB"

# Count .dta files
dta_count=$(ls -1 *.dta 2>/dev/null | wc -l)
echo "Total .dta files: $dta_count"

# Should show 34
if [ "$dta_count" -eq 34 ]; then
    echo "✓ All 34 Eurobarometer datasets present!"
else
    echo "✗ Missing datasets. Expected 34, found $dta_count"
fi
```

---

## Method 2: Manual Download

If the automated script doesn't work, you can download manually:

### For Each Dataset:

1. Go to: `https://search.gesis.org/research_data/ZA####` (replace #### with study number)
2. Click the **"Datasets"** link
3. In the popup, select **"lecturer"** from the "Purpose of Data Use" dropdown
4. Click the **Stata (.dta.zip)** file link to download
5. Save to `Raw Data/EB/`
6. Repeat for all 34 datasets

**Study numbers to download**:
```
3521, 2828, 3693, 3938, 4229, 4231, 4411, 4414,
4506, 4526, 4530, 4565, 4744, 4819, 4971, 4972,
4973, 4994, 5234, 5235, 5449, 5481, 5564, 5567,
5612, 5613, 5685, 5689, 5876, 5877, 5913, 5928,
5929, 5932
```

---

## Data Processing

Once all 34 datasets are downloaded and extracted:

### Step 1: Verify Folder Structure

```
Replication_Data_for_Happiness_and_Voting/
├── Raw Data/
│   ├── EB/              # 34 .dta files here
│   └── Voting/          # existing files (economic_data.dta, etc.)
├── Clean Data/          # will contain output
├── Master.do
├── Cleaner_votingdata.do
├── Cleaner_swb.do
├── DatasetBuilder_EB_Macro.do
└── [other .do files]
```

### Step 2: Update Master.do Path

Edit `Master.do` line 3 with your working directory:

```stata
global path = "/Users/YOUR_USERNAME/path/to/Replication_Data_for_Happiness_and_Voting"
```

### Step 3: Run Data Cleaning Scripts

Open Stata and run:

```stata
* Set working directory
cd "/Users/YOUR_USERNAME/path/to/Replication_Data_for_Happiness_and_Voting"

* Set global paths
global path = "/Users/YOUR_USERNAME/path/to/Replication_Data_for_Happiness_and_Voting"
global raw = "$path/Raw Data"
global do = "$path"
global clean = "$path/Clean Data"
global eb = "$raw/EB"
global vote = "$raw/Voting"

* Step 1: Clean voting data
do Cleaner_votingdata.do

* Step 2: Clean Eurobarometer subjective well-being data (THIS TAKES 10-15 MINUTES)
do Cleaner_swb.do

* Step 3: Build macro dataset
do DatasetBuilder_EB_Macro.do
```

### Step 4: Verify Output

After successful completion, you should have:

**File created**: `Clean Data/clean_macro.dta`

**File size**: ~94 KB

**What it contains**:
- Country-election level observations
- Aggregated life satisfaction measures
- Electoral outcomes (vote shares, cabinet changes)
- Economic indicators (unemployment, inflation, GDP growth)
- Time trends and standardized variables

Verify in Stata:
```stata
use "Clean Data/clean_macro.dta", clear
describe
summarize
```

---

## Verification

### Check Dataset Completeness

In Stata:
```stata
use "Clean Data/clean_macro.dta", clear

* Check number of observations
count
* Should show 394 observations (country-election combinations)

* Check key variables exist
describe satislfe_survey_mean vote_share_cab z_unemp z_infl

* Check country coverage (should be 15 countries)
tab cntry

* Check time coverage
summarize year
* Should show range from ~1973 to 2014
```

### Expected Variable List

Key variables in `clean_macro.dta`:
- `satislfe_survey_mean` - Average life satisfaction in pre-election survey
- `satislfe_year_mean` - Average life satisfaction in election year
- `vote_share_cab` - Vote share of cabinet parties
- `vote_share_pm` - Vote share of PM's party
- `vote_share_cab_lag` - Previous election vote share
- `z_unemp`, `z_infl`, `z_gdpgr` - Standardized economic indicators
- `satis_resid_*` - Residualized happiness measures
- `country_trend`, `country_trend_sq` - Country-specific time trends

---

## Troubleshooting

### Issue: Download script fails to login

**Solution**:
- Verify your GESIS credentials are correct
- Check that your account is activated (check email for verification link)
- Try logging in manually at https://login.gesis.org/ first

### Issue: Download script can't find .dta file

**Symptoms**: Error message "No .dta file found"

**Solution**:
- The dataset might only be available in other formats
- Download manually from the GESIS website
- Check if you selected "lecturer" purpose (required to see download links)

### Issue: Some .dta files are still .zip

**Solution**:
```bash
cd "Raw Data/EB"
unzip -o "*.zip"
```

### Issue: Cleaner_swb.do fails with "file not found"

**Solution**:
- Check all 34 .dta files are in `Raw Data/EB/`
- Verify file names match exactly (case-sensitive)
- Ensure `global eb = "$raw/EB"` is set correctly

### Issue: Processing takes very long

**Expected behavior**:
- `Cleaner_swb.do` processes 34 surveys individually - takes 10-15 minutes
- Each survey shows progress messages
- This is normal - be patient!

### Issue: Missing observations in clean_macro.dta

**Check**:
1. All 34 Eurobarometer datasets downloaded?
2. Voting data files present in `Raw Data/Voting/`?
   - `economic_data.dta`
   - `gallagher_data.xlsx`
   - `parlgov_stable.xlsx`
   - `party_xwalk.xlsx`

---

## Files Created During Processing

**Temporary files** (automatically deleted):
- `Clean Data/clean_election.dta`
- `Clean Data/clean_econ.dta`
- Various temporary survey files

**Final output**:
- `Clean Data/clean_macro.dta` - **THIS IS THE PRIMARY OUTPUT**

---

## Citation

If you use this data, please cite:

Ward, George. 2020. "Happiness and Voting: Evidence from Four Decades of Elections in Europe." *American Journal of Political Science* 64(4): 504-518.

GESIS datasets should be cited individually. See: https://www.gesis.org/en/services/finding-and-accessing-data/citing-data

---

## Notes

- **Data access**: GESIS data is free for academic use but requires registration
- **Terms of use**: You agreed to GESIS terms during download - data is for research only
- **Redistribution**: Do NOT redistribute raw GESIS data files - others must download from GESIS themselves
- **Updates**: These instructions are based on GESIS website structure as of November 2024

---

## Support

For issues with:
- **GESIS data access**: Contact GESIS support at https://www.gesis.org/en/help
- **This replication**: See main repository README or open an issue

---

**Last updated**: November 2024
**Tested with**: Stata 14, Python 3.9, macOS Sonoma 14.6
