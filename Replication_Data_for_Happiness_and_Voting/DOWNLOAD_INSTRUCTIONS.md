# Instructions for Downloading Eurobarometer Surveys

## Overview
You need to download 34 Eurobarometer surveys from GESIS. I've created two R scripts to automate this process.

## Prerequisites
✓ GESIS account registered (you've completed this!)
✓ R installed on your machine
✓ Folder structure set up (already done)

## Current Folder Structure
```
Replication_Data_for_Happiness_and_Voting/
├── Raw Data/
│   ├── EB/           # Eurobarometer surveys will go here (empty now)
│   ├── Voting/       # Existing data files (already populated)
│   ├── BHPS/         # For BHPS data (skip for now)
│   └── SOEP/         # For SOEP data (skip for now)
├── Clean Data/       # Output datasets will go here
├── Do Files/         # For .do files
└── Results/          # For analysis output
```

## Method 1: Automated Download (Recommended)

### Step 1: Navigate to the folder
```bash
cd Replication_Data_for_Happiness_and_Voting
```

### Step 2: Run the download script
```bash
Rscript download_eurobarometer_surveys_manual.R
```

### Step 3: Enter credentials when prompted
- **Email**: Your GESIS registration email
- **Password**: Your GESIS password

The script will:
- Download all 34 surveys automatically
- Show progress for each download
- Create a summary report
- Save all .dta files to `Raw Data/EB/`

**Expected time**: ~10-20 minutes (depending on connection speed and GESIS server)

## Method 2: Manual Download via Web Interface

If the R script fails, you can download manually:

1. Go to https://search.gesis.org/
2. Sign in with your credentials
3. For each ZA number in the list below, visit the URL and click "Download"
4. Select Stata (.dta) format
5. Save to `Raw Data/EB/`

### Required Surveys:
| ZA Number | URL |
|-----------|-----|
| ZA3521 | https://search.gesis.org/research_data/ZA3521 |
| ZA2828 | https://search.gesis.org/research_data/ZA2828 |
| ZA3693 | https://search.gesis.org/research_data/ZA3693 |
| ZA3938 | https://search.gesis.org/research_data/ZA3938 |
| ZA4229 | https://search.gesis.org/research_data/ZA4229 |
| ZA4231 | https://search.gesis.org/research_data/ZA4231 |
| ZA4411 | https://search.gesis.org/research_data/ZA4411 |
| ZA4414 | https://search.gesis.org/research_data/ZA4414 |
| ZA4506 | https://search.gesis.org/research_data/ZA4506 |
| ZA4526 | https://search.gesis.org/research_data/ZA4526 |
| ZA4530 | https://search.gesis.org/research_data/ZA4530 |
| ZA4565 | https://search.gesis.org/research_data/ZA4565 |
| ZA4744 | https://search.gesis.org/research_data/ZA4744 |
| ZA4819 | https://search.gesis.org/research_data/ZA4819 |
| ZA4971 | https://search.gesis.org/research_data/ZA4971 |
| ZA4972 | https://search.gesis.org/research_data/ZA4972 |
| ZA4973 | https://search.gesis.org/research_data/ZA4973 |
| ZA4994 | https://search.gesis.org/research_data/ZA4994 |
| ZA5234 | https://search.gesis.org/research_data/ZA5234 |
| ZA5235 | https://search.gesis.org/research_data/ZA5235 |
| ZA5449 | https://search.gesis.org/research_data/ZA5449 |
| ZA5481 | https://search.gesis.org/research_data/ZA5481 |
| ZA5564 | https://search.gesis.org/research_data/ZA5564 |
| ZA5567 | https://search.gesis.org/research_data/ZA5567 |
| ZA5612 | https://search.gesis.org/research_data/ZA5612 |
| ZA5613 | https://search.gesis.org/research_data/ZA5613 |
| ZA5685 | https://search.gesis.org/research_data/ZA5685 |
| ZA5689 | https://search.gesis.org/research_data/ZA5689 |
| ZA5876 | https://search.gesis.org/research_data/ZA5876 |
| ZA5877 | https://search.gesis.org/research_data/ZA5877 |
| ZA5913 | https://search.gesis.org/research_data/ZA5913 |
| ZA5928 | https://search.gesis.org/research_data/ZA5928 |
| ZA5929 | https://search.gesis.org/research_data/ZA5929 |
| ZA5932 | https://search.gesis.org/research_data/ZA5932 |

## Verifying Downloads

After downloading, verify you have all files:

```bash
cd "Replication_Data_for_Happiness_and_Voting/Raw Data/EB"
ls -1 *.dta | wc -l
```

**Expected output**: 34

You should see files like:
- ZA3521_v2-0-1.dta
- ZA2828_v1-0-1.dta
- ZA3693_v1-0-1.dta
- etc.

## Troubleshooting

**Issue**: R package installation fails
```r
# Try installing from source
install.packages("gesisdata", type = "source")
```

**Issue**: Authentication fails
- Double-check email/password
- Ensure your GESIS account is activated
- Try logging in via web interface first

**Issue**: Some downloads fail
- The script will report which ones failed
- Download those manually via the web interface

**Issue**: Wrong file format downloaded
- Ensure you select ".dta" (Stata) format, not ".sav" (SPSS)

## Next Steps

After downloading all surveys:

1. **Verify** all 34 .dta files are in `Raw Data/EB/`
2. **Move .do files** to `Do Files/` folder
3. **Update** Master.do with your local path
4. **Run** the data cleaning scripts

See `DATA_ACQUISITION_GUIDE.md` for complete workflow.
