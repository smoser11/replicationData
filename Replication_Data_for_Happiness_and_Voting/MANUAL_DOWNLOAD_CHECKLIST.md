# Manual Download Checklist for Eurobarometer Surveys

**Total surveys needed:** 34

**Download location:** `Raw Data/EB/`

**Instructions:**
1. Click each link below
2. Log in with your GESIS credentials
3. Select "Purpose: for scientific research (incl. doctorate)"
4. Download the **Stata (.dta)** file
5. Save to: `/Users/sm38679/Documents/GitHub/replicationData/Replication_Data_for_Happiness_and_Voting/Raw Data/EB/`
6. Check off the box when complete

---

## Survey List

- [ ] [ZA3521 - Mannheim Eurobarometer Trend File](https://search.gesis.org/research_data/ZA3521)
- [ ] [ZA2828 - Eurobarometer 44.2](https://search.gesis.org/research_data/ZA2828)
- [ ] [ZA3693 - Eurobarometer 58.1](https://search.gesis.org/research_data/ZA3693)
- [ ] [ZA3938 - Eurobarometer 60.1](https://search.gesis.org/research_data/ZA3938)
- [ ] [ZA4229 - Eurobarometer 62.0](https://search.gesis.org/research_data/ZA4229)
- [ ] [ZA4231 - Eurobarometer 62.2](https://search.gesis.org/research_data/ZA4231)
- [ ] [ZA4411 - Eurobarometer 63.4](https://search.gesis.org/research_data/ZA4411)
- [ ] [ZA4414 - Eurobarometer 64.2](https://search.gesis.org/research_data/ZA4414)
- [ ] [ZA4506 - Eurobarometer 65.2](https://search.gesis.org/research_data/ZA4506)
- [ ] [ZA4526 - Eurobarometer 66.1](https://search.gesis.org/research_data/ZA4526)
- [ ] [ZA4530 - Eurobarometer 67.2](https://search.gesis.org/research_data/ZA4530)
- [ ] [ZA4565 - Eurobarometer 68.1](https://search.gesis.org/research_data/ZA4565)
- [ ] [ZA4744 - Eurobarometer 69.2](https://search.gesis.org/research_data/ZA4744)
- [ ] [ZA4819 - Eurobarometer 70.1](https://search.gesis.org/research_data/ZA4819)
- [ ] [ZA4971 - Eurobarometer 71.1](https://search.gesis.org/research_data/ZA4971)
- [ ] [ZA4972 - Eurobarometer 71.2](https://search.gesis.org/research_data/ZA4972)
- [ ] [ZA4973 - Eurobarometer 71.3](https://search.gesis.org/research_data/ZA4973)
- [ ] [ZA4994 - Eurobarometer 72.4](https://search.gesis.org/research_data/ZA4994)
- [ ] [ZA5234 - Eurobarometer 73.4](https://search.gesis.org/research_data/ZA5234)
- [ ] [ZA5235 - Eurobarometer 73.5](https://search.gesis.org/research_data/ZA5235)
- [ ] [ZA5449 - Eurobarometer 74.2](https://search.gesis.org/research_data/ZA5449)
- [ ] [ZA5481 - Eurobarometer 75.3](https://search.gesis.org/research_data/ZA5481)
- [ ] [ZA5564 - Eurobarometer 75.4](https://search.gesis.org/research_data/ZA5564)
- [ ] [ZA5567 - Eurobarometer 76.3](https://search.gesis.org/research_data/ZA5567)
- [ ] [ZA5612 - Eurobarometer 77.3](https://search.gesis.org/research_data/ZA5612)
- [ ] [ZA5613 - Eurobarometer 77.4](https://search.gesis.org/research_data/ZA5613)
- [ ] [ZA5685 - Eurobarometer 78.1](https://search.gesis.org/research_data/ZA5685)
- [ ] [ZA5689 - Eurobarometer 79.3](https://search.gesis.org/research_data/ZA5689)
- [ ] [ZA5876 - Eurobarometer 80.1](https://search.gesis.org/research_data/ZA5876)
- [ ] [ZA5877 - Eurobarometer 80.2](https://search.gesis.org/research_data/ZA5877)
- [ ] [ZA5913 - Eurobarometer 81.2](https://search.gesis.org/research_data/ZA5913)
- [ ] [ZA5928 - Eurobarometer 81.4](https://search.gesis.org/research_data/ZA5928)
- [ ] [ZA5929 - Eurobarometer 81.5](https://search.gesis.org/research_data/ZA5929)
- [ ] [ZA5932 - Eurobarometer 82.3](https://search.gesis.org/research_data/ZA5932)

---

## Tips for Faster Downloads

1. **Keep GESIS logged in** - The session should persist across tabs
2. **Open multiple tabs** - Download several at once (don't overwhelm the server though)
3. **Look for the Stata file** - Usually named like `ZA####_v#-#-#.dta`
4. **Check file sizes** - They range from ~5MB to ~100MB typically

## Verification Command

After downloading, verify you have all 34 files:

```bash
cd "/Users/sm38679/Documents/GitHub/replicationData/Replication_Data_for_Happiness_and_Voting/Raw Data/EB"
ls -1 *.dta | wc -l
```

Should return: `34`

## Alternative: Python with Selenium (if you want automation)

If you prefer automation and have Python installed, I can create a Python script using Selenium with ChromeDriver (more reliable than PhantomJS). Let me know if you'd like this option.
