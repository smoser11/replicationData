clear*
set memory 1g
set maxvar 30000
set more off 
set matsize 11000


* Table 3 
global dem 		 age agesq mar_married mar_divsep mar_widowed i.wave i.reg

use "$clean/clean_soep.dta", clear
tab lifesatisfaction, gen (ls)
xtreg pol_supports_govparty logincome ls2-ls11 fin_worr1 fin_worr3 $dem   , fe cluster(id)
keep if e(sample)
gen sample = e(sample)
bys id: egen count = count(sample==1)
keep if count>1

eststo clear 
eststo : xi: xtreg pol_supports_govparty logincome ls2-ls11  $dem   , fe cluster(id)
eststo : xi: xtreg pol_supports_govparty logincome fin_worr1 fin_worr3 $dem   , fe cluster(id)
eststo : xi: xtreg pol_supports_govparty logincome ls2-ls11 fin_worr1 fin_worr3 $dem   , fe cluster(id)


use "$clean/clean_bhps.dta", clear
tab lifesatisfaction, gen(ls)
global today 	fin_today1 fin_today2 fin_today4 fin_today5
xtreg pol_supports_govparty logincome ls2-ls7 $today $dem   , fe cluster(id)
keep if e(sample)
gen sample = e(sample)
bys id: egen count = count(sample==1)
keep if count>1

eststo clear
eststo : xi: xtreg pol_supports_govparty logincome ls2-ls7  $dem  , fe cluster(id)
eststo : xi: xtreg pol_supports_govparty   logincome $today  $dem , fe cluster(id)
eststo : xi: xtreg pol_supports_govparty  ls2-ls7  logincome $today  $dem , fe cluster(id)




***** Table A1

use "$clean/clean_soep.dta", clear
tab sat_lifein5y, gen(fls)
tab lifesatisfaction, gen(ls)

xtreg pol_supports_govparty logincome ls2-ls11 fls2-fls11 $dem  , fe cluster(id)
keep if e(sample)
gen sample = e(sample)
bys id: egen count = count(sample==1)
keep if count>1

eststo clear 
eststo : xi: xtreg pol_supports_govparty logincome fls2-fls11  $dem   , fe cluster(id)
eststo : xi: xtreg pol_supports_govparty logincome ls2-ls11  $dem   , fe cluster(id)
eststo : xi: xtreg pol_supports_govparty logincome fls2-fls11 ls2-ls11  $dem   , fe cluster(id)



*** Figure S1

use "$clean/clean_soep.dta", clear
cap drop n coef se ci_lo ci_hi
gen n = .
gen coef = .
gen se = . 
local i = 1
eststo clear
forvalues n=2(1)31 {
local i = `i' + 1
eststo: xtreg pol_supports_govparty z_lifesatisfaction logincome    $dem if count >=`n', fe r
replace n = `n' if _n==`i'
replace coef = _b[z_lifesatisfaction] if _n==`i'
replace se = _se[z_lifesatisfaction]  if _n==`i'
}

gen ci_lo = coef - (1.96*se)
gen ci_hi = coef + (1.96*se)
twoway (line coef n ) (line ci_lo n, lstyle(p7 )) (line ci_hi n, lstyle(p7 )), scheme(s1mono) legend(off)  ///
xtitle("", size(large)) ytitle("", size(large)) saving(1.gph, replace) title(Germany) 

use "$clean/clean_bhps.dta", clear
cap drop n coef se ci_lo ci_hi
gen n = .
gen coef = .
gen se = . 
local i = 1
eststo clear
forvalues n=2(1)17 {
local i = `i' + 1
eststo: xtreg pol_supports_govparty z_lifesatisfaction logincome    $dem if count >=`n', fe r
replace n = `n' if _n==`i'
replace coef = _b[z_lifesatisfaction] if _n==`i'
replace se = _se[z_lifesatisfaction]  if _n==`i'
}

gen ci_lo = coef - (1.96*se)
gen ci_hi = coef + (1.96*se)
twoway (line coef n) (line ci_lo n, lstyle(p7 )) (line ci_hi n, lstyle(p7 )), scheme(s1mono) legend(off) ///
xtitle("", size(large)) ytitle("", size(large))  saving(2.gph, replace) title(Great Britain)


graph combine 1.gph 2.gph , ycom scheme(s1mono) l1(Coefficient) b1(Minimum Waves Observed)
erase 1.gph
erase 2.gph




***** Table S20
global today 	fin_today1 fin_today2 fin_today4 fin_today5
global change 	fin_1ych1 fin_1ych3
global future   fin_fut1 fin_fut3
use "$clean/clean_bhps.dta", clear
tab lifesatisfaction, gen(ls)

reg pol_supports_govparty  ls2-ls7  logincome $change $today $future $dem
gen sam = e(sample)
bys pid: egen sam1 = max(sam)
keep if sam1==1


eststo clear 
reg pol_supports_govparty logincome ls2-ls7  $dem  $today $future
gen sample = e(sample)
bys pid: egen count = count(sample==1)
keep if sample==1 & count>1

eststo: xi: xtreg pol_supports_govparty logincome ls2-ls7  $dem  if e(sample)==1, fe cluster(id)

eststo: xi: xtreg pol_supports_govparty  ls2-ls7  logincome $today  $dem if e(sample)==1 , fe cluster(id)

eststo: xi: xtreg pol_supports_govparty  ls2-ls7  logincome $future  $dem   if e(sample)==1, fe cluster(id)

reg pol_supports_govparty  ls2-ls7  logincome $change $today $future $dem
eststo: xi: xtreg pol_supports_govparty  ls2-ls7  logincome   $dem if e(sample)==1 , fe cluster(id)
eststo: xi: xtreg pol_supports_govparty  ls2-ls7  logincome $change  $dem  if e(sample)==1, fe cluster(id)
eststo: xi: xtreg pol_supports_govparty  ls2-ls7  logincome $change $today $future  $dem  if e(sample)==1, fe cluster(id)

 
 
 
*** Table S19
use "$clean/clean_soep.dta", clear
eststo clear

reg pol_supports_govparty z_lifesatisfaction $dem logincome fin_worr1 fin_worr3
keep if e(sample)
gen sample = e(sample)
bys id: egen count = count(sample==1)
keep if count>1

eststo: xi: clogit pol_supports_govparty z_lifesatisfaction $dem logincome , group(id) vce(cluster id)
eststo: xi: xtprobit pol_supports_govparty z_lifesatisfaction $dem logincome  , vce(cluster id)

use "$clean/clean_bhps.dta", clear

reg pol_supports_govparty z_lifesatisfaction $dem logincome $today
keep if e(sample)
gen sample = e(sample)
bys id: egen count = count(sample==1)
keep if count>1

eststo: xi: clogit pol_supports_govparty z_lifesatisfaction logincome  $dem, group(id)  vce(cluster id)
eststo: xi: xtprobit pol_supports_govparty z_lifesatisfaction logincome  $dem , vce(cluster id)





