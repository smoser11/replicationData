# BHPS/Understanding Society Data Acquisition and Processing

This document provides complete, reproducible instructions for acquiring and processing the British Household Panel Survey (BHPS) and Understanding Society data needed for the Ward (2020) "Happiness and Voting" replication.

## Table of Contents
- [Overview](#overview)
- [Prerequisites](#prerequisites)
- [Data Required](#data-required)
- [Step 1: Register with UK Data Service](#step-1-register-with-uk-data-service)
- [Step 2: Request Access to Study #6614](#step-2-request-access-to-study-6614)
- [Step 3: Download the Data](#step-3-download-the-data)
- [Step 4: Extract and Organize Files](#step-4-extract-and-organize-files)
- [Step 5: Process the Data](#step-5-process-the-data)
- [Verification](#verification)
- [Troubleshooting](#troubleshooting)

---

## Overview

**What we're acquiring**:
- BHPS (British Household Panel Survey): Waves 1-18 (1991-2009)
- Understanding Society: Waves 1-14+ (2009-present)

**Source**: UK Data Service Study #6614

**Final output**: `Clean Data/clean_bhps.dta` - British longitudinal household panel dataset

**Time required**:
- Registration and access request: 15-30 minutes
- Approval wait time: Usually instant for UK academics, can take 1-2 business days for others
- Download: 30-60 minutes (5+ GB)
- Data processing: 10-15 minutes

---

## Prerequisites

### Software Requirements
- **Bash/Terminal** (macOS/Linux) or equivalent
- **Stata 14+** (for data processing)
- **Unzip utility** (standard on macOS/Linux)

### UK Data Service Account
You need a UK Data Service account with appropriate access rights:

**Eligibility**:
- UK-based researchers (academic or commercial)
- Non-UK researchers (limited access, approval required)
- Students under supervision

**Registration**: https://ukdataservice.ac.uk/help/registration/

---

## Data Required

### Study Information

**Study Number**: 6614

**Full Title**: "Understanding Society: Waves 1-14, 2009-2023 and Harmonised BHPS: Waves 1-18, 1991-2009"

**DOI**: 10.5255/UKDA-SN-6614-18

**Principal Investigators**: University of Essex, Institute for Social and Economic Research

**Data Collection**: 1991-2023 (ongoing)

### What's Included

This study combines two major UK longitudinal surveys:

1. **BHPS (British Household Panel Survey)**
   - 18 waves: 1991-2009
   - ~10,000 households
   - Annual interviews
   - Covers: demographics, employment, health, life satisfaction

2. **Understanding Society (UKHLS)**
   - 14+ waves: 2009-2023
   - ~40,000 households
   - Annual interviews
   - Continuation and expansion of BHPS

**For this replication, we need**:
- BHPS waves 1-18 (folders: `bhps_w1` through `bhps_w18`)
- UKHLS waves 1-6 (folders: `ukhls_w1` through `ukhls_w6`)

---

## Step 1: Register with UK Data Service

### 1.1 Create Account

1. Go to: https://beta.ukdataservice.ac.uk/
2. Click **"Register"** (top right)
3. Complete the registration form:
   - Use your **institutional email** (university/research organization)
   - Select appropriate user category (Student/Researcher/Other)
   - Provide institutional affiliation
4. Verify email address
5. Complete profile information

### 1.2 Verify Access Level

Log in and check your access level:
- **Academic users**: Should have access to most datasets
- **Students**: May need supervisor information
- **Non-UK users**: May need to justify access

---

## Step 2: Request Access to Study #6614

### 2.1 Navigate to Study Page

**Direct URL**: https://beta.ukdataservice.ac.uk/datacatalogue/studies/study?id=6614

Or search:
1. Go to https://beta.ukdataservice.ac.uk/
2. Search for: `6614` or `Understanding Society`
3. Click on Study #6614

### 2.2 Request Access

1. On the study page, click **"Add to account"** button (purple button in sidebar)
2. Go to your account/basket (top right - click your username)
3. Review the study in your basket
4. Click **"Request access"** or **"Download"**

### 2.3 Agree to End User Licence

You'll need to:
1. Read the End User Licence (EUL)
2. Check boxes agreeing to:
   - Use data for research/education only
   - Not redistribute data files
   - Cite the data properly
   - Follow data security protocols
3. Submit your agreement

### 2.4 Wait for Approval

- **UK academics**: Usually **instant** approval
- **Students**: May need supervisor approval
- **Non-UK researchers**: 1-2 business days
- **Commercial users**: May need additional justification

You'll receive an email when access is granted.

---

## Step 3: Download the Data

### 3.1 Select Download Format

**CRITICAL**: You must download the **Stata format**, not Tab-delimited!

1. After approval, go to your account/downloads
2. Find Study #6614
3. **Select format**: Choose **"Stata"** from the dropdown
   - ❌ NOT "Tab-delimited"
   - ❌ NOT "SPSS"
   - ✅ YES "Stata"

### 3.2 Download the Package

1. Click **"Download"**
2. Save file: `UKDA-6614-stata.zip`
3. **File size**: Approximately 4-5 GB
4. **Download time**: 30-60 minutes (depending on connection)

**Note**: The download is a single .zip file containing all waves and formats.

### 3.3 Verify Download

```bash
cd ~/Downloads

# Check file exists and size
ls -lh UKDA-6614-stata.zip

# Should show approximately 4-5 GB
```

---

## Step 4: Extract and Organize Files

### 4.1 Extract the Main Archive

```bash
cd ~/Downloads

# Extract the main zip file
unzip UKDA-6614-stata.zip

# This creates folder: UKDA-6614-stata
```

**Note**: Extraction may take 5-10 minutes due to large file size.

### 4.2 Verify Directory Structure

The extracted folder structure should be:
```
UKDA-6614-stata/
├── stata/
│   └── stata13_se/
│       ├── bhps/           # All BHPS .dta files (flat directory)
│       ├── ukhls/          # All UKHLS .dta files (flat directory)
│       ├── xwavedat.dta
│       └── [other files]
├── mrdoc/                  # Documentation
├── pdf/                    # Questionnaires
└── [other folders]
```

**Important**: The .dta files are in **flat directories** (all files in `bhps/` and `ukhls/`), but we need them organized into **wave-specific folders** for processing.

### 4.3 Run Reorganization Script

We need to reorganize files from flat structure to wave-specific folders.

**The script `reorganize_bhps.sh` is provided in the repository.**

Verify and run:

```bash
# Navigate to replication directory
cd /path/to/Replication_Data_for_Happiness_and_Voting

# Verify reorganization script exists
ls -la reorganize_bhps.sh

# Make it executable (if needed)
chmod +x reorganize_bhps.sh

# Run the reorganization
bash reorganize_bhps.sh
```

### 4.4 What the Reorganization Script Does

The script:
1. Creates folders `bhps_w1` through `bhps_w18`
2. Creates folders `ukhls_w1` through `ukhls_w14`
3. Moves files into wave-specific folders based on naming convention:
   - `ba_*.dta` → `bhps_w1/` (wave 1, letter a)
   - `bb_*.dta` → `bhps_w2/` (wave 2, letter b)
   - `a_*.dta` → `ukhls_w1/` (UKHLS wave 1)
   - etc.

Expected output:
```
=========================================
Reorganizing BHPS files into wave folders
=========================================
Processing BHPS Wave 1 (letter: a)...
  → Copied        7 files to bhps_w1/
Processing BHPS Wave 2 (letter: b)...
  → Copied       13 files to bhps_w2/
[... continues for all 18 waves ...]

=========================================
Reorganizing UKHLS files into wave folders
=========================================
Processing UKHLS Wave 1 (letter: a)...
  → Copied       15 files to ukhls_w1/
[... continues for all 14 waves ...]

Total BHPS wave folders:       18
Total UKHLS wave folders:       14
```

### 4.5 Verify Reorganization

```bash
cd "Raw Data/BHPS"

# Count folders
ls -d bhps_w* | wc -l
# Should show: 18

ls -d ukhls_w* | wc -l
# Should show: 14

# Check contents of first wave
ls "bhps_w1/"
# Should show files like: ba_hhresp.dta, ba_indresp.dta, etc.
```

### 4.6 Final Directory Structure

After reorganization, your folder should look like:
```
Replication_Data_for_Happiness_and_Voting/
├── Raw Data/
│   └── BHPS/
│       ├── bhps_w1/
│       │   ├── ba_hhresp.dta
│       │   ├── ba_indresp.dta
│       │   └── [other ba_*.dta files]
│       ├── bhps_w2/
│       │   ├── bb_hhresp.dta
│       │   └── [other bb_*.dta files]
│       ├── ... [bhps_w3 through bhps_w18]
│       ├── ukhls_w1/
│       │   ├── a_hhresp.dta
│       │   ├── a_indresp.dta
│       │   └── [other a_*.dta files]
│       ├── ukhls_w2/
│       │   └── [b_*.dta files]
│       └── ... [ukhls_w3 through ukhls_w14]
```

---

## Step 5: Process the Data

### 5.1 Verify Master.do Paths

Ensure `Master.do` has correct paths (should be set from GESIS processing):

```stata
global path = "/path/to/Replication_Data_for_Happiness_and_Voting"
global raw = "$path/Raw Data"
global clean = "$path/Clean Data"
global bhps = "$raw/BHPS"
```

### 5.2 Run DatasetBuilder_BHPS.do

Open Stata and run:

```stata
* Set working directory
cd "/path/to/Replication_Data_for_Happiness_and_Voting"

* Set global paths
global path = "/path/to/Replication_Data_for_Happiness_and_Voting"
global raw = "$path/Raw Data"
global clean = "$path/Clean Data"
global bhps = "$raw/BHPS"

* Run BHPS dataset builder
do DatasetBuilder_BHPS.do
```

### 5.3 What the Script Does

**Processing Steps**:

1. **Load BHPS household files** (waves 1-18)
   - Files: `ba_hhresp.dta` through `br_hhresp.dta`
   - Standardizes variable names across waves
   - Creates temporary combined file

2. **Load BHPS individual files** (waves 1-18)
   - Files: `ba_indresp.dta` through `br_indresp.dta`
   - Merges with household data
   - Creates `bhps_long.dta`

3. **Load UKHLS household files** (waves 1-6)
   - Files: `a_hhresp.dta` through `f_hhresp.dta`
   - Standardizes to match BHPS structure

4. **Load UKHLS individual files** (waves 1-6)
   - Files: `a_indresp.dta` through `f_indresp.dta`
   - Merges with UKHLS household data
   - Creates `ukhls_long.dta`

5. **Combine BHPS + UKHLS**
   - Appends datasets
   - Harmonizes person IDs
   - Creates panel structure

6. **Create Analysis Variables**:
   - **Life satisfaction**: `lifesatisfaction` (harmonized across surveys)
   - **Financial situation**: Current, past year change, future expectations
   - **Demographics**: Age, gender, marital status, household income
   - **Political variables**: Party support, government party indicator
   - **Geographic**: Region codes (drops Northern Ireland)

7. **Apply Restrictions**:
   - Drop Northern Ireland (different political system)
   - Restrict to ages 18+
   - Drop waves where life satisfaction not asked (waves <6, wave 11)
   - Remove inconsistent gender coding across waves

8. **Create Final Dataset**: `Clean Data/clean_bhps.dta`

**Processing time**: 10-15 minutes

Expected output messages will show:
- File loads for each wave
- Variable harmonization warnings (normal)
- Merge statistics
- Sample restrictions
- Final save confirmation

### 5.4 Note on Script Bug Fix

**Important**: The original `DatasetBuilder_BHPS.do` had a bug that prevented completion. We fixed it by adding these lines before creating the age variable:

```stata
** Age
drop age              # Added: drop existing age variable
cap drop agesq        # Added: safely drop agesq if exists
gen age = age_dv if age_dv>0
gen agesq=(age*age)/1000
```

This fix is **already included** in the repository version.

---

## Verification

### 6.1 Check File Created

```bash
ls -lh "Clean Data/clean_bhps.dta"

# Should show file size approximately 100-150 MB
```

### 6.2 Verify in Stata

```stata
use "Clean Data/clean_bhps.dta", clear

* Check observations
count
* Should show approximately 400,000-450,000 observations

* Check panel structure
describe pid wave
xtdes

* Check time coverage
tab wave
* Should show waves 6-18, 19-24 (excluding wave 11)

* Check key variables exist
describe lifesatisfaction finansit_today pol_supports_govparty women age logincome

* Summarize life satisfaction
summarize lifesatisfaction
* Mean should be around 5.0-5.5 (on 1-7 scale)

* Check country coverage (UK only)
tab reg
* Should show 11 UK regions (Northern Ireland excluded)

* Check political party variables
tab pol_supports_govparty
* Should show distribution of government party support
```

### 6.3 Expected Dataset Structure

**Panel dimensions**:
- **N (individuals)**: ~60,000-70,000 unique persons
- **T (waves)**: 6-24 (excluding waves <6 and wave 11)
- **Total observations**: ~400,000-450,000 person-wave observations

**Key Variables**:
- `pid` - Person ID (BHPS)
- `pidp` - Person ID (UKHLS)
- `upid` - Unified person ID
- `wave` - Survey wave (1-24)
- `year` - Survey year (1996-2015)
- `lifesatisfaction` - Life satisfaction (1-7 scale)
- `finansit_today` - Current financial situation (1-5)
- `finansit_1ychange` - Financial change past year (1-3)
- `finansit_future` - Expected financial situation (1-3)
- `pol_supports_govparty` - Dummy: supports government party
- `women` - Female dummy
- `age`, `agesq` - Age, age-squared
- `logincome` - Log household income (equivalized)
- `mar_*` - Marital status dummies

---

## Troubleshooting

### Issue: "file not found" when running reorganization script

**Check**:
1. Verify extraction path is correct in `reorganize_bhps.sh`:
   ```bash
   BASE_DIR="$HOME/Downloads/UKDA-6614-stata/stata/stata13_se"
   ```
2. Find actual path:
   ```bash
   find ~/Downloads -name "stata13_se" -type d 2>/dev/null
   ```
3. Update `BASE_DIR` in script if different

### Issue: Download is Tab-delimited format, not Stata

**Symptoms**: Files have `.tab` extension instead of `.dta`

**Solution**:
- You downloaded the wrong format
- Go back to UK Data Service
- Select **Stata format** from dropdown
- Download again (should be `UKDA-6614-stata.zip`)

### Issue: Reorganization script shows "0 files copied"

**Check**:
1. Verify you're in correct directory:
   ```bash
   ls ~/Downloads/UKDA-6614-stata/stata/stata13_se/bhps/ba_*.dta
   ```
2. If files exist but script fails, check file permissions:
   ```bash
   chmod -R 755 ~/Downloads/UKDA-6614-stata/
   ```

### Issue: DatasetBuilder_BHPS.do fails with "variable age already defined"

**Solution**:
- The repository version has this bug fixed
- If using an old version, manually add before line 204:
  ```stata
  drop age
  cap drop agesq
  ```

### Issue: Merge issues or missing observations

**Common causes**:
1. Missing wave folders - verify all 18 BHPS and 6+ UKHLS folders present
2. Files not in correct folders - check wave naming (ba_ = wave 1, bb_ = wave 2, etc.)
3. Corrupted downloads - re-download if file sizes seem wrong

### Issue: Processing takes very long or hangs

**Expected behavior**:
- Processing 18 BHPS + 6 UKHLS waves takes 10-15 minutes
- Each wave shows progress messages
- Merges show statistics
- This is normal - be patient!

**If truly hung** (>30 minutes):
- Check Stata memory: `set memory 1g` (should be set in script)
- Close other programs
- Try running on machine with more RAM

---

## Data Documentation

### Official Documentation

The `mrdoc/` folder in your download contains:
- **Questionnaires**: Survey questions for each wave
- **User guides**: How to use the data
- **Variable search**: Searchable variable lists
- **Technical reports**: Sampling, weights, response rates

**Online documentation**: https://www.understandingsociety.ac.uk/documentation/

### Variable Naming Convention

**BHPS waves** (prefix b + wave letter):
- Wave 1: `ba_*` (1991)
- Wave 2: `bb_*` (1992)
- ...
- Wave 18: `br_*` (2009)

**UKHLS waves** (wave letter only):
- Wave 1: `a_*` (2009-2010)
- Wave 2: `b_*` (2010-2011)
- ...

**File types**:
- `*_indresp.dta` - Individual response file
- `*_hhresp.dta` - Household response file
- `*_hhsamp.dta` - Household sample info
- `*_child.dta` - Child data
- etc.

---

## Citation

When using this data, cite:

**Full citation**:
```
University of Essex, Institute for Social and Economic Research. (2023).
Understanding Society: Waves 1-14, 2009-2023 and Harmonised BHPS: Waves 1-18, 1991-2009.
[data collection]. 18th Edition. UK Data Service. SN: 6614,
DOI: 10.5255/UKDA-SN-6614-18
```

**Also cite the Ward paper**:
```
Ward, George. 2020. "Happiness and Voting: Evidence from Four Decades of Elections in Europe."
American Journal of Political Science 64(4): 504-518.
```

---

## Terms of Use

By downloading this data, you agreed to:

1. **Use for research/education only** - Not for commercial purposes
2. **No redistribution** - Others must download from UK Data Service themselves
3. **Cite properly** - Use official citation format
4. **Data security** - Keep files secure, don't share login credentials
5. **Report findings** - Inform UK Data Service of publications using the data

**Full terms**: https://ukdataservice.ac.uk/help/registration/

---

## Files Created During Processing

**Temporary files** (automatically deleted by script):
- `bhps_hh.dta` - BHPS household temporary file
- `bhps_long.dta` - BHPS longitudinal file
- `ukhls_hh.dta` - UKHLS household temporary file
- `ukhls_long.dta` - UKHLS longitudinal file
- `bhps_ukhls_long.dta` - Combined file before cleaning

**Final output**:
- `Clean Data/clean_bhps.dta` - **THIS IS THE PRIMARY OUTPUT**

---

## Additional Resources

### Understanding Society Website
- **Main page**: https://www.understandingsociety.ac.uk/
- **Documentation**: https://www.understandingsociety.ac.uk/documentation/
- **Data dictionary**: https://www.understandingsociety.ac.uk/documentation/mainstage/dataset-documentation
- **User forum**: https://www.understandingsociety.ac.uk/about/user-support

### UK Data Service
- **Main page**: https://ukdataservice.ac.uk/
- **Study #6614 page**: https://beta.ukdataservice.ac.uk/datacatalogue/studies/study?id=6614
- **Help & support**: https://ukdataservice.ac.uk/help/

### Training Materials
- **Understanding Society webinars**: https://www.understandingsociety.ac.uk/about/training-and-events
- **UK Data Service training**: https://ukdataservice.ac.uk/learning-hub/

---

## Support

For issues with:
- **Data access/download**: Contact UK Data Service at https://ukdataservice.ac.uk/help/get-in-touch/
- **Understanding Society technical questions**: Contact Understanding Society user support
- **This replication**: See main repository README or open an issue

---

## Notes

- **Data updates**: Understanding Society releases new waves annually (usually October)
- **Version used**: This replication uses Study #6614, Edition 18
- **BHPS only needed**: The script uses BHPS waves 6-18 and UKHLS waves 1-6 (wave letters a-f)
- **Life satisfaction**: Asked starting BHPS wave 6 (1996), not asked in BHPS wave 11

---

**Last updated**: November 2024
**Tested with**: Stata 14, macOS Sonoma 14.6
**Data version**: UKDA-6614-18 (18th Edition)
