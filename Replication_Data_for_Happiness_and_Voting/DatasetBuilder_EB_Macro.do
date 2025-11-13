clear*
set more off


use "$vote/election_data.dta", clear

gen merge_month = mofd(elec_date) 
replace merge_month = merge_month - 1
nearmrgstable country using "$eb/eb_aggregates_by_survey.dta", lower nearvar(merge_month)
keep if _merge==3
drop _merge

merge m:1 country year using "$eb/eb_aggregates_by_year.dta"
drop if _merge==2
drop _merge

merge m:1 country year using "$vote/economic_data.dta"
keep if _merge==3
drop _merge

* Create Main Macro Indicator Varis
gen unemployment_rate = oecd_unemployment
gen inflation_rate = oecd_cpi_inflation
replace inflation_rate = wb_cpi_inflation if inflation_rate==.
gen gdppc_growth_rate = oecd_gdp_pc_growth
gen loggdp = ln(oecd_gdp_pc_usd2010PPP)




* Standardise main variables for analysis 
foreach var of varlist vote_share_pm vote_share_cab satislfe_survey_mean gdppc_growth_rate unemployment_rate inflation_rate loggdp satis_resid* {
egen z_`var' = std(`var')
}



* Create country-specific time trends  
tab co, gen(trend) 
forvalues x = 1(1)15 {
replace trend`x' = trend`x'*year
gen quad_trend`x' = trend`x'*(year^2)
}


* XTSET 
xtset co election_number 

drop election_number merge_month study_id survey_lag_months_inbetw satislfe_electionyear_mean_L2-satislfe_electionyear_mean_L4  satislfe_electionyear_mean_D*  oecd_* countryname wb_* 

lab var satislfe_survey_mean "Life Satisfaction"
lab var gdppc_growth_rate "Per Capita GDP Growth Rate"
lab var unemployment_rate "Unemployment Rate"
lab var inflation_rate "Inflation Rate"
lab var z_satislfe_survey_mean "Life Satisfaction"
lab var z_gdppc_growth_rate "Per Capita GDP Growth Rate"
lab var z_unemployment_rate "Unemployment Rate"
lab var z_inflation_rate "Inflation Rate"
lab var satis_resid_nocontrols "Residualized SWB (survey FEs)"
lab var satis_resid_dem "Residualized SWB (survey FEs + Dem)"
lab var satis_resid_dempluspol "Residualized SWB (survey FEs + Dem + Pol)"
lab var z_loggdp "GDP per Capita (ln)"

lab var sat1_pc  "% satislfe==1"
lab var sat2_pc  "% satislfe==2"
lab var sat3_pc  "% satislfe==3"
lab var sat4_pc  "% satislfe==4"

lab var satislfe_sd "SD SWB"
lab var survey_date "Survey Date"
lab var eb "Eurobarometer Study #" 



save "$clean/clean_macro.dta", replace 





erase "$eb/eb_aggregates_by_survey.dta"
erase "$eb/eb_aggregates_by_year.dta"
erase "$vote/election_data.dta"




