
clear*
set memory 1g
set maxvar 30000
set more off 



use "$soep/pequiv.dta", clear
merge 1:1   pid syear using "$soep/pgen.dta"
drop _merge
merge m:1 cid hid syear using "$soep/hl.dta"
drop _merge
merge m:1 pid hid syear using "$soep/pl.dta"
drop _merge
merge m:1 pid hid syear using "$soep/pl2.dta"
drop _merge

lab lang EN


duplicates report pid syear
duplicates drop pid syear, force
clonevar wave = welle
clonevar id = pid
gen month = pgmonth if pgmonth>0
rename syear year
xtset id year

clonevar reg = l11101 
recode reg (-1=.)


gen lifesatisfaction=p11101 if p11101>=0
gen sat_lifein5y = plh0183 if plh0183>=0

clonevar finances_worried = plh0033 if plh0033>=0 
 
ta  finances_worried, gen(fin_worr)
lab var fin_worr1 "HH Finances: Very Concerned"
lab var fin_worr2 "Somewhat Concerned"
lab var fin_worr3 "Not Concerned At All	"


gen women= (d11102==2) if d11102>0

gen age=d11101 if d11101>=0
gen agesq=(age*age)/1000 if age>0
drop if age<18

gen income_gross_nominal = i11101 if i11101>=0
gen logincome = ln(income_gross_nominal)

 gen mar_married = (d11104==1) if d11104>=0
 gen mar_single = (d11104==2) if d11104>=0
 gen mar_divsep = (d11104==4 | d11104==5) if d11104>=0
 gen mar_widowed = (d11104==3) if d11104>=0
 

recode plh0008 (-10/-1=.), gen(polsup1)
recode plh0011 (-10/-1=.), gen(polsup2)
gen pol_supports_aparty = (polsup1==1) if polsup1!=.
replace pol_supports_aparty = (polsup2==1) if polsup2!=. & pol_supports_aparty==.

gen pol1 = plh0012 if pol_supports_aparty!=. 
gen pol_supports_cdu = (pol1==2 | pol1==3 | pol1==10 | pol1==13 | pol1==14  | pol1==15) if pol1!=.
gen pol_supports_spd = (pol1==1 | pol1==9 | pol1==10 | pol1==11 | pol1==12 | pol1==17) if pol1!=.
gen pol_supports_fdp = (pol1==4 | pol1==11 | pol1==14 | pol1==22) if pol1!=.
gen pol_supports_green = (pol1==5 | pol1==9 | pol1==15 | pol1==16  | pol1==18  | pol1==23 ) if pol1!=.

gen pol_supports_govparty = (pol_supports_cdu==1 | pol_supports_fdp==1) if year<1998  & pol_supports_cdu!=.
replace pol_supports_govparty = (pol_supports_cdu==1 | pol_supports_fdp==1) if year==1998 & month<=9  & pol_supports_cdu!=.
replace pol_supports_govparty = (pol_supports_spd==1 | pol_supports_green==1) if year==1998 & month>=10  & pol_supports_cdu!=.
replace pol_supports_govparty = (pol_supports_spd==1 | pol_supports_green==1) if year>1998 & year<2005  & pol_supports_cdu!=.
replace pol_supports_govparty = (pol_supports_spd==1 | pol_supports_green==1) if year==2005  & month<=9  & pol_supports_cdu!=.
replace pol_supports_govparty = (pol_supports_cdu==1 | pol_supports_spd==1) if year==2005  & month>=10  & pol_supports_cdu!=.
replace pol_supports_govparty = (pol_supports_cdu==1 | pol_supports_spd==1) if year>2005 & year<2009  & pol_supports_cdu!=.
replace pol_supports_govparty = (pol_supports_cdu==1 | pol_supports_spd==1) if year==2009 & month<=9  & pol_supports_cdu!=.
replace pol_supports_govparty = (pol_supports_cdu==1 | pol_supports_fdp==1) if year==2009 & month>=10  & pol_supports_cdu!=.
replace pol_supports_govparty = (pol_supports_cdu==1 | pol_supports_fdp==1) if year>2009 & year<2013  & pol_supports_cdu!=.
replace pol_supports_govparty = (pol_supports_cdu==1 | pol_supports_fdp==1) if year==2013  & month<=9  & pol_supports_cdu!=.
replace pol_supports_govparty = (pol_supports_cdu==1 | pol_supports_spd==1) if year==2013  & month>=10  & pol_supports_cdu!=.
replace pol_supports_govparty = (pol_supports_cdu==1 | pol_supports_spd==1) if year>2013 & year<2016  & pol_supports_cdu!=.


keep wave id month year reg lifesatisfaction-pol_supports_govparty


egen z_lifesatisfaction = std(lifesatisfaction)

lab var mar_married "Married"
lab var mar_divsep "Divorced/Separated"
lab var mar_widowed "Widowed"
lab var lifesatisfaction "Life Satisfaction"
lab var sat_lifein5y "Life in 5Y"
lab var logincome "Household Income (ln)"
lab var pol_supports_govparty "Supports Government Party"
lab var women "Female"
lab var age   "Age"
lab var logincome "Log Income"
lab var month "Survey Month"
lab var wave "Survey Wave"
lab var agesq "Age-squared"
lab var income_gross_nominal "Gross Nominal HH Income"
lab var logincome "Log Income"
lab var mar_single "Marital: Single"

drop polsup1 polsup2 pol_supports_aparty pol1

bysort id: egen count_id = count(id)
lab var count_id "# Waves Observed in SOEP"

save "$clean/clean_soep.dta", replace


