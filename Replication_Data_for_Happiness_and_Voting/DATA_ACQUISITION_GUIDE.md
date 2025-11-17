# Data Acquisition Guide for "Happiness and Voting" Replication

## Current Status

### ✓ Data Already Available
Located in: `Replication_Data_for_Happiness_and_Voting/`
- `economic_data.dta` - World Bank and OECD economic data
- `gallagher_data.xlsx` - Party fractionalization data
- `parlgov_stable.xlsx` - Electoral data from ParlGov
- `party_xwalk.xlsx` - Eurobarometer to ParlGov party ID crosswalk

### ✗ Data That Must Be Obtained

#### 1. Eurobarometer Surveys (34 surveys from GESIS)
**Access**: Free for academic researchers after registration at https://search.gesis.org/

**IMPORTANT**: The URLs in the original README.pdf are outdated. New URL format:
`https://search.gesis.org/research_data/ZA####`

**Updated URLs for Required Surveys:**

| EB # | Data File | Updated URL |
|------|-----------|-------------|
| Trend | ZA3521_v2-0-1.dta | https://search.gesis.org/research_data/ZA3521 |
| 44.2 | ZA2828_v1-0-1.dta | https://search.gesis.org/research_data/ZA2828 |
| 58.1 | ZA3693_v1-0-1.dta | https://search.gesis.org/research_data/ZA3693 |
| 60.1 | ZA3938_v1-0-1.dta | https://search.gesis.org/research_data/ZA3938 |
| 62.0 | ZA4229_v1-1-0.dta | https://search.gesis.org/research_data/ZA4229 |
| 62.2 | ZA4231_v1-1-0.dta | https://search.gesis.org/research_data/ZA4231 |
| 63.4 | ZA4411_v1-1-0.dta | https://search.gesis.org/research_data/ZA4411 |
| 64.2 | ZA4414_v1-1-0.dta | https://search.gesis.org/research_data/ZA4414 |
| 65.2 | ZA4506_v1-0-1.dta | https://search.gesis.org/research_data/ZA4506 |
| 66.1 | ZA4526_v1-0-1.dta | https://search.gesis.org/research_data/ZA4526 |
| 67.2 | ZA4530_v2-1-0.dta | https://search.gesis.org/research_data/ZA4530 |
| 68.1 | ZA4565_v4-0-1.dta | https://search.gesis.org/research_data/ZA4565 |
| 69.2 | ZA4744_v5-0-0.dta | https://search.gesis.org/research_data/ZA4744 |
| 70.1 | ZA4819_v3-0-2.dta | https://search.gesis.org/research_data/ZA4819 |
| 71.1 | ZA4971_v4-0-0.dta | https://search.gesis.org/research_data/ZA4971 |
| 71.2 | ZA4972_v3-0-2.dta | https://search.gesis.org/research_data/ZA4972 |
| 71.3 | ZA4973_v3-0-0.dta | https://search.gesis.org/research_data/ZA4973 |
| 72.4 | ZA4994_v3-0-0.dta | https://search.gesis.org/research_data/ZA4994 |
| 73.4 | ZA5234_v2-0-1.dta | https://search.gesis.org/research_data/ZA5234 |
| 73.5 | ZA5235_v4-0-0.dta | https://search.gesis.org/research_data/ZA5235 |
| 74.2 | ZA5449_v2-2-0.dta | https://search.gesis.org/research_data/ZA5449 |
| 75.3 | ZA5481_v2-0-1.dta | https://search.gesis.org/research_data/ZA5481 |
| 75.4 | ZA5564_v3-0-1.dta | https://search.gesis.org/research_data/ZA5564 |
| 76.3 | ZA5567_v2-0-1.dta | https://search.gesis.org/research_data/ZA5567 |
| 77.3 | ZA5612_v2-0-0.dta | https://search.gesis.org/research_data/ZA5612 |
| 77.4 | ZA5613_v3-0-0.dta | https://search.gesis.org/research_data/ZA5613 |
| 78.1 | ZA5685_v2-0-0.dta | https://search.gesis.org/research_data/ZA5685 |
| 79.3 | ZA5689_v2-0-0.dta | https://search.gesis.org/research_data/ZA5689 |
| 80.1 | ZA5876_v2-0-0.dta | https://search.gesis.org/research_data/ZA5876 |
| 80.2 | ZA5877_v2-0-0.dta | https://search.gesis.org/research_data/ZA5877 |
| 81.2 | ZA5913_v2-0-0.dta | https://search.gesis.org/research_data/ZA5913 |
| 81.4 | ZA5928_v3-0-0.dta | https://search.gesis.org/research_data/ZA5928 |
| 81.5 | ZA5929_v3-0-0.dta | https://search.gesis.org/research_data/ZA5929 |
| 82.3 | ZA5932_v3-0-0.dta | https://search.gesis.org/research_data/ZA5932 |

**Registration Process:**
1. Go to https://search.gesis.org/
2. Create account (free for academic users)
3. Agree to terms and conditions
4. Search for each ZA study number
5. Download Stata (.dta) format files

**Alternative: R Package Method**
```r
# Install package
install.packages("gesisdata")

# Download all surveys at once
library(gesisdata)
za_numbers <- c("ZA3521", "ZA2828", "ZA3693", "ZA3938", "ZA4229", "ZA4231",
                "ZA4411", "ZA4414", "ZA4506", "ZA4526", "ZA4530", "ZA4565",
                "ZA4744", "ZA4819", "ZA4971", "ZA4972", "ZA4973", "ZA4994",
                "ZA5234", "ZA5235", "ZA5449", "ZA5481", "ZA5564", "ZA5567",
                "ZA5612", "ZA5613", "ZA5685", "ZA5689", "ZA5876", "ZA5877",
                "ZA5913", "ZA5928", "ZA5929", "ZA5932")
gesis_download(file_id = za_numbers, download_dir = "./Raw Data/EB")
```

#### 2. BHPS (British Household Panel Survey)
**Access**: Free for academic researchers after registration

**Source**: UK Data Service
**URL**: https://beta.ukdataservice.ac.uk/datacatalogue/studies/study?id=6614
**Dataset**: Study #6614 - "Understanding Society: Waves 1-8, 2009-2017 and Harmonised BHPS: Waves 1-18, 1991-2009"

**Registration Process:**
1. Create UK Data Service account
2. Request access to Study #6614
3. Agree to terms of use
4. Download the dataset (will receive folder "UKDA-6614-stata")

**Files Needed After Extraction:**
- Folders: BHPS_w1 through BHPS_w18
- Folders: ukhls_w1 through ukhls_w8

#### 3. SOEP (German Socio-Economic Panel)
**Access**: Free for academic researchers after registration

**Source**: DIW Berlin
**URL**: https://www.diw.de/en/soep
**Version Required**: SOEP-LONG v31 (bilingual version 31, Stata format, German+English)

**Important Notes:**
- Must request LONG format version (not the standard format)
- Specific file needed: `SOEP-LONG_v31_stata_de+en`
- The normal request form doesn't allow selecting previous versions
- After submitting signed data use agreement, email SOEP directly to request this specific version

**Files Needed After Extraction:**
From the `SOEP-LONG_v31_stata_de+en` folder, extract these 5 files:
- pequiv.dta
- pgen.dta
- pl.dta
- pl2.dta
- hl.dta

**Registration Process:**
1. Go to https://www.diw.de/en/soep
2. Register and complete data use agreement
3. Email SOEP directly requesting: "SOEP-LONG_v31_stata_de+en"
4. Wait for approval and download link

---

## Folder Structure Setup

Per README Section III, create this structure:

```
Your_Working_Directory/
├── Raw Data/
│   ├── Voting/          # Place the 4 existing .xlsx/.dta files here
│   ├── EB/              # Place 34 Eurobarometer .dta files here
│   ├── BHPS/            # Place BHPS_w1-w18 and ukhls_w1-w8 folders here
│   └── SOEP/            # Place 5 SOEP .dta files here
├── Clean Data/          # Generated by scripts
├── Do Files/            # Place all .do files and .ado file here
└── Results/             # Analysis output will go here
```

---

## Next Steps After Data Acquisition

1. **Set up folder structure** (see above)
2. **Update Master.do** - Change line 3 to your working directory path
3. **Run Master.do** in Stata 14+ to:
   - Install required Stata packages (carryforward, tsspell, dm7, estout, cibar)
   - Clean all raw data
   - Generate `clean_macro.dta` and other clean datasets
   - Run all analyses

---

## Targeting Only clean_macro.dta

If you only need `clean_macro.dta` (national-level analysis), you can skip BHPS and SOEP.

**Required for clean_macro.dta only:**
1. Eurobarometer surveys (all 34)
2. The 4 existing data files (already have)

**You can skip:**
- BHPS data (only needed for individual panel analysis)
- SOEP data (only needed for individual panel analysis)

**Relevant scripts for clean_macro.dta:**
```stata
do Cleaner_votingdata.do
do Cleaner_swb.do
do DatasetBuilder_EB_Macro.do
```

This will create: `Clean Data/clean_macro.dta`
