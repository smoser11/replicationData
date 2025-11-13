******************************************************************************************
********************** SWB and Voting in Europe, 1973-2014 *******************************
******************************************************************************************



set more off

use "$clean/clean_macro.dta", clear

* Control vars to be used in main  regressions 
global controls 		parties_ingov seatshare_cabinet cab_ideol_sd ENEP_tmin1 

lab var vote_share_cab 	"Cabient Vote Share"
lab var vote_share_pm 	"PM Party Vote Share"
lab var z_satislfe_survey_mean "National Happiness"
lab var z_gdppc_growth_rate "GDP Growth Rate"
lab var z_unemployment_rate "Unemployment Rate"
lab var z_inflation_rate "Inflation Rate"
lab var parties_ingov   "Number of Parties in Government"
lab var ENEP_tmin1      "Effective Number of Parties"
lab var seatshare_cabinet "Cabinet Seat Share"
lab var cab_ideol_sd "Cabinet Ideological Disparity"

reg vote_share_cab  z_satislfe_survey_mean  $controls  i.co  i.year   , cluster(co)  
keep if e(sample)

** Table 1 
eststo clear
eststo: xi: reg vote_share_cab  z_satislfe_survey_mean  $controls  i.co  i.year   , cluster(co)  
eststo: xi: reg vote_share_cab   z_gdppc_growth_rate $controls  i.co  i.year    , cluster(co)  
eststo: xi: reg vote_share_cab   z_unemployment_rate  $controls  i.co  i.year    , cluster(co)  
eststo: xi: reg vote_share_cab   z_inflation_rate $controls  i.co  i.year    , cluster(co)  
eststo: xi: reg vote_share_cab   z_gdppc_growth_rate z_unemployment_rate z_inflation_rate $controls  i.co  i.year    , cluster(co)  
eststo: xi: reg vote_share_cab  z_satislfe_survey_mean z_gdppc_growth_rate z_unemployment_rate z_inflation_rate $controls  i.co  i.year    , cluster(co)  

eststo: xi: reg parlgov_turnout  z_satislfe_survey_mean  $controls  i.co  i.year    , cluster(co)  
eststo: xi: reg parlgov_turnout  z_satislfe_survey_mean z_gdppc_growth_rate z_unemployment_rate z_inflation_rate $controls  i.co  i.year    , cluster(co)  

**  Figure 1
eststo clear 
eststo:  xtreg vote_share_cab satislfe_survey_mean,  fe
gen r2 = e(r2_w) if _n==1
gen model = 1 if _n==1
eststo:  xtreg vote_share_cab gdppc_growth_rate ,  fe
replace r2 = e(r2_w) if _n==2
replace model = 2 if _n==2
eststo:  xtreg vote_share_cab unemployment_rate,  fe
replace r2 = e(r2_w) if _n==3
replace model = 3 if _n==3
eststo:  xtreg vote_share_cab inflation_rate,  fe
replace r2 = e(r2_w) if _n==4
replace model = 4 if _n==4


label def model 1 "National Happiness" 2 "GDP Growth Rate" 3 "Unemployment Rate" 4 "Inflation Rate"
label val model model
lab var r2 "R-squared"

graph hbar r2, over(model) blabel(total, format(%9.2g))   ylab(, nogrid) graphregion(fcolor(white)) ytitle("Within-Country R{sup:2}") ///
bar(1, color(ebblue))  intensity(30)


*** SUPPLEMENTARY ***


**** Appendix Section S3 ****

* Table S5
eststo clear

gen sat = z_satis_resid_nocontrols
eststo: xi:  reg vote_share_cab  sat z_gdppc_growth_rate $controls  i.year i.co     , cluster(co)  
estadd local dem "No"
estadd local fix  "Yes"
estadd local pol "No"
drop sat

gen sat = z_satis_resid_dem
eststo: xi:  reg vote_share_cab  sat z_gdppc_growth_rate $controls  i.year i.co     , cluster(co)  
estadd local dem "Yes"
estadd local fix  "Yes"
estadd local pol "No"
drop sat

gen sat = z_satis_resid_dempluspol
eststo: xi:  reg vote_share_cab  sat z_gdppc_growth_rate $controls  i.year i.co     , cluster(co)  
estadd local dem "Yes"
estadd local fix  "Yes"
estadd local pol "Yes"

lab var sat "National Happiness"
drop sat


* Table S6
eststo clear
eststo:  reg vote_share_pm   z_satislfe_survey_mean $controls  i.year i.co   , cluster(co)  
eststo:  reg vote_share_pm  z_gdppc_growth_rate  $controls  i.year i.co   , cluster(co)  
eststo:  reg vote_share_pm   z_unemployment_rate  $controls  i.year i.co   , cluster(co)  
eststo:  reg vote_share_pm   z_inflation_rate $controls   i.year i.co   , cluster(co)  
eststo:  reg vote_share_pm  z_satislfe_survey_mean z_gdppc_growth_rate z_unemployment_rate z_inflation_rate    $controls  i.year i.co   , cluster(co)  


* Table S8
eststo clear
eststo: xi: reg vote_share_cab  z_satislfe_survey_mean z_gdppc_growth_rate  i.co   ,   cluster(co)
eststo: xi: reg vote_share_cab  z_satislfe_survey_mean z_gdppc_growth_rate  i.co i.year  ,   cluster(co)
eststo: xi: reg vote_share_cab  z_satislfe_survey_mean z_gdppc_growth_rate  $controls  i.co i.year  , cluster(co)  
eststo: xi: reg vote_share_cab  z_satislfe_survey_mean z_gdppc_growth_rate  $controls  i.co trend*  ,  cluster(co)
eststo: xi: reg vote_share_cab  z_satislfe_survey_mean z_gdppc_growth_rate  $controls  i.co quad_tr* trend*  ,  cluster(co)
eststo: xi: reg vote_share_cab  z_satislfe_survey_mean z_gdppc_growth_rate  $controls  i.co i.year trend*  ,  cluster(co)
eststo: xi: reg vote_share_cab  z_satislfe_survey_mean z_gdppc_growth_rate  $controls  i.co i.year quad_tr* trend*  ,  cluster(co)


* Table S9 
eststo clear
eststo: xi: reg parlgov_turnout  z_satislfe_survey_mean  $controls  i.co  i.year  if vote_share_cab!=. , cluster(co)  
eststo: xi: reg parlgov_turnout  z_satislfe_survey_mean z_gdppc_growth_rate z_unemployment_rate z_inflation_rate $controls  i.co  i.year  if vote_share_cab!=.  , cluster(co)  
eststo: xi: sem (parlgov_turnout <- z_satislfe_survey_mean  $controls  i.co  i.year) (vote_share_cab <- parlgov_turnout z_satislfe_survey_mean  $controls  i.co  i.year) , nocapslatent vce(cluster co)
eststo: xi: sem (parlgov_turnout <- z_satislfe_survey_mean z_gdppc_growth_rate z_unemployment_rate z_inflation_rate $controls  i.co  i.year) (vote_share_cab <- parlgov_turnout z_satislfe_survey_mean z_gdppc_growth_rate z_unemployment_rate z_inflation_rate $controls  i.co  i.year) , nocapslatent vce(cluster co)




* Table S10
foreach var of varlist satislfe_electionyear_mean  satislfe_sd* satislfe_growthrate  {
egen z_`var' = std(`var')
}

gen gr_neg = z_satislfe_growthrate if satislfe_growthrate<=0
replace gr_neg = abs(gr_neg)
gen gr_pos = z_satislfe_growthrate if satislfe_growthrate>0
replace gr_neg = 0 if satislfe_growthrate>0 
replace gr_pos = 0 if satislfe_growthrate<=0



lab var z_satislfe_electionyear_mean "National Happiness (election year mean)"
lab var z_satislfe_sd "National Happiness (Std Dev)"
lab var z_satislfe_sd_overmean "National Happiness (Std Dev/Mean)"
lab var gr_neg "Spline: Growth Rate Negative"
lab var z_satislfe_growthrate "Spline: Growth Rate Positive"


eststo clear
eststo: xi: reg vote_share_cab   z_satislfe_survey_mean $controls  i.co  i.year    , cluster(co)  
eststo: xi: reg vote_share_cab   z_satislfe_electionyear_mean $controls  i.co  i.year    , cluster(co)  
eststo: xi: reg vote_share_cab   z_satislfe_sd  $controls  i.co  i.year    , cluster(co)  
eststo: xi: reg vote_share_cab   z_satislfe_sd_overmean $controls  i.co  i.year    , cluster(co)  
eststo: xi: reg vote_share_cab   z_satislfe_growthrate $controls  i.co  i.year    , cluster(co)  
eststo: xi: reg vote_share_cab   gr_neg gr_pos $controls  i.co  i.year    , cluster(co)  
eststo: xi: reg vote_share_cab   z_satislfe_survey_mean z_satislfe_sd $controls  i.co  i.year    , cluster(co)  
eststo: xi: reg vote_share_cab   z_satislfe_survey_mean z_satislfe_sd_overmean $controls  i.co  i.year    , cluster(co)  
eststo: xi: reg vote_share_cab   z_satislfe_survey_mean z_satislfe_growthrate $controls  i.co  i.year    , cluster(co)  
eststo: xi: reg vote_share_cab   z_satislfe_survey_mean gr_neg gr_pos $controls  i.co  i.year    , cluster(co)  



 
 * Table S11
eststo clear
eststo: xi: reg vote_share_cab   z_loggdp $controls  i.co  i.year    , cluster(co)  
eststo: xi: reg vote_share_cab   z_loggdp z_gdppc_growth_rate z_unemployment_rate z_inflation_rate $controls  i.co  i.year    , cluster(co)  
eststo: xi: reg vote_share_cab   z_satislfe_survey_mean z_loggdp $controls  i.co  i.year    , cluster(co)  
eststo: xi: reg vote_share_cab   z_satislfe_survey_mean z_loggdp z_gdppc_growth_rate z_unemployment_rate z_inflation_rate $controls  i.co  i.year    , cluster(co)  




* Table S12
foreach var of varlist sat1_pc sat2_pc sat3_pc sat4_pc {
replace `var' = `var'*100
}

lab var sat1_pc "\% Not at all satisfied"
lab var sat2_pc "\% Not very satisfied"
lab var sat3_pc "\% Fairly satisfied"
lab var sat4_pc "\% Very satisfied"

eststo clear
eststo:  reg vote_share_cab  sat1_pc     $controls   i.year i.co   , cluster(co)  
eststo:  reg vote_share_cab   sat2_pc     $controls   i.year i.co   , cluster(co)  
eststo:  reg vote_share_cab   sat3_pc     $controls   i.year i.co   , cluster(co)  
eststo:  reg vote_share_cab   sat4_pc    $controls   i.year i.co   , cluster(co)  







**** Appendix Section S6 ****

use "$clean/clean_macro.dta", clear

* Table S21
foreach var of varlist parties_ingov seatshare_cabinet cab_ideol_sd ENEP_tmin1 {
egen z_`var' = std(`var')
gen sat_x_`var' = z_satislfe_survey_mean *  z_`var'
}


foreach var of varlist z_parties_ingov z_cab_ideol_sd z_ENEP {
omscore `var' 
}
egen clarity = rowmean(rr_z_parties_ingov z_seatshare_cabinet rr_z_cab_ideol_sd rr_z_ENEP)
egen z_clarity = std(clarity)
gen sat_x_clarity = z_clarity*z_satislfe_survey_mean

lab var z_clarity "Clarity of Responsibility (Index)"
lab var sat_x_clarity "SWB * CoR"
lab var z_parties_ingov "Parties in Government"
lab var z_seatshare_cabinet "Government Seat Share"
lab var z_cab_ideol_sd "Government Ideological Discordance"
lab var z_ENEP_tmin1 "Party Fractionalisation"
lab var sat_x_parties_ingov		"SWB * Parties in Gov."
lab var sat_x_seatshare_cabinet		"SWB * Gov. Seat Share"
lab var sat_x_cab_ideol_sd	"SWB * Ideological Discordance"
lab var sat_x_ENEP_tmin1 "SWB * Party Fractionalisation"

eststo clear
eststo:  reg vote_share_cab  z_satislfe_survey_mean z_parties_ingov z_seatshare_cabinet z_cab_ideol_sd z_ENEP_tmin1							  i.year i.co   , cluster(co)  
eststo:  reg vote_share_cab  z_satislfe_survey_mean z_parties_ingov z_seatshare_cabinet z_cab_ideol_sd z_ENEP_tmin1	sat_x_parties_ingov						  i.year i.co   , cluster(co)  
eststo:  reg vote_share_cab  z_satislfe_survey_mean z_parties_ingov z_seatshare_cabinet z_cab_ideol_sd z_ENEP_tmin1	sat_x_seatshare_cabinet						  i.year i.co   , cluster(co)  
eststo:  reg vote_share_cab  z_satislfe_survey_mean z_parties_ingov z_seatshare_cabinet z_cab_ideol_sd z_ENEP_tmin1	sat_x_cab_ideol_sd						  i.year i.co   , cluster(co)  
eststo:  reg vote_share_cab  z_satislfe_survey_mean z_parties_ingov z_seatshare_cabinet z_cab_ideol_sd z_ENEP_tmin1	sat_x_ENEP_tmin1						  i.year i.co   , cluster(co)  
eststo:  reg vote_share_cab  z_satislfe_survey_mean z_parties_ingov z_seatshare_cabinet z_cab_ideol_sd z_ENEP_tmin1	sat_x_parties_ingov		sat_x_seatshare_cabinet		sat_x_cab_ideol_sd	sat_x_ENEP_tmin1	  i.year i.co   , cluster(co)  


