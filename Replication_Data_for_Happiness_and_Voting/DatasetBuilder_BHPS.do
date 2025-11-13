			
clear*
set memory 1g
set maxvar 30000
set more off 

*** BHPS ***	


	
local i = 0
foreach w in a b c d e f g h i j k l m n o p q r {
local i = `i'+1
use "$bhps/bhps_w`i'/b`w'_hhresp.dta"
renpfix b`w'_
gen wave = `i'
tempfile tempdata_`w'
save "`tempdata_`w''"
}
		
					
clear
foreach w in a b c d e f g h i j k l m n o p q r {
	append using "`tempdata_`w''"
	}
	
order hid wave
sort  hid wave

save "bhps_hh.dta", replace

				
local i = 0
foreach w in a b c d e f g h i j k l m n o p q r {
local i = `i'+1
use "$bhps/bhps_w`i'/b`w'_indresp.dta"
renpfix b`w'_
gen wave = `i'
tempfile tempdata_`w'
save "`tempdata_`w''"
}
		
					
clear
foreach w in a b c d e f g h i j k l m n o p q r {
	append using "`tempdata_`w''"
	}
	
order pid wave
sort  pid wave


merge m:1 hid wave using "bhps_hh.dta"
keep if _merge==3
drop _merge

save "bhps_long.dta", replace
erase "bhps_hh.dta"









		

*** UKHLS ***
	

local i = 18
local j = 0
foreach w in a b c d e f {
	local j = `j'+1  
use "$bhps/ukhls_w`j'/`w'_hhresp.dta"
	renpfix `w'_      
	local i = `i'+1  
 	gen wave = `i'   
	tempfile tempdata_`w'
	save "`tempdata_`w''"
}
		
					
clear
foreach w in a b c d e f {
	append using "`tempdata_`w''"
	}
	
order hid wave
sort  hid wave

save "ukhls_hh.dta", replace

	
	
local i = 18
local j = 0
foreach w in a b c d e f {
	local j = `j'+1  
use "$bhps/ukhls_w`j'/`w'_indresp.dta"
	renpfix `w'_      
	local i = `i'+1  
 	gen wave = `i'   
	tempfile tempdata_`w'
	save "`tempdata_`w''"
}
		
					
clear
foreach w in a b c d e f {
	append using "`tempdata_`w''"
	}
	
order pidp wave
sort  pidp wave


merge m:1 hidp wave using "ukhls_hh.dta"
keep if _merge==3
drop _merge

save "ukhls_long.dta", replace
erase "ukhls_hh.dta"



*** COMBINE
append using "bhps_long.dta"


replace pid=. if pid<1
 gen double id=pid if pid<.
 replace id=-pidp if pid>=.
 egen double upid=group(id)
 isid upid wave
xtset id wave
			
			
save "bhps_ukhls_long.dta"			, replace
			
			
			
			
			
					*---------------------------------------*
	
** Dates
cap drop month
gen year = istrtdaty if istrtdaty>0
gen month = istrtdatm if istrtdatm>0 


clonevar reg = gor_dv 
recode reg (-10/-1=99) (13=99)
drop if reg==12 /* drop NI */

** Life satisfaction
 gen lifesatisfaction = lfsato if lfsato>0
 replace lifesatisfaction = sclfsato if sclfsato>0 & lifesatisfaction==.
 
** Finances

recode finnow (-10/0=.) (5=1) (4=2) (3=3) (2=4) (1=5), gen(finansit_today)
recode fisitc (-10/0=.) (1=3) (2=1) (3=2) , gen(finansit_1ychange)

recode fisitx (-10/0=.) (1=3) (2=1) (3=2) , gen(finansit_future)
recode finfut (-10/0=.) (1=3) (2=1) (3=2), gen(temp)
replace finansit_future = temp if finansit_future==.
drop temp


ta finansit_today, gen(fin_today) 
lab var fin_today5 "Living Comfortably"
lab var fin_today4 "Doing Alright"
lab var fin_today3 "Just About Getting By"
lab var fin_today2 "Finding it Quite Difficult"
lab var fin_today1 "Finding it Very Difficult"

ta finansit_1ychange, gen(fin_1ych)
lab var fin_1ych1 "Worse Off" 
lab var fin_1ych2 "About Same" 
lab var fin_1ych3 "Better Off" 

ta finansit_future, gen(fin_fut)
lab var fin_fut1 "Worse Off" 
lab var fin_fut2 "About Same" 
lab var fin_fut3 "Better Off" 



 ** Gender
gen women= (sex==2) if sex>0
bysort id: egen temp = mode(women)
replace women = temp if women==.
drop temp
bysort id: egen var = sd(women)
drop if var>0
drop var


 ** Age
gen age = age_dv if age_dv>0 
gen agesq=(age*age)/1000 
drop if age<18


 ** nb of children

gen num_children = nkids_dv
replace num_children=0 if num_children<0

gen adults= 1 
replace adults=2 if hhtype==3 | hhtype==4 | hhtype==5 
replace adults=3 if hhtype==8
replace adults=2 if hhtype_dv>5 & hhtype_dv<19 & hhtype_dv!=.
replace adults=3 if hhtype_dv>18 & hhtype_dv!=. 
 

 * Income 

gen equivscale=1
replace equivscale=1 if hhtype==1 | hhtype==2 | hhtype==7 | hhtype_dv==1 | hhtype_dv==2 | hhtype_dv==3  
replace equivscale=1.7 if hhtype==3 | hhtype==5 | hhtype_dv==6 | hhtype_dv==8 | hhtype_dv==16 | hhtype_dv==17
replace equivscale=1.7+0.5*num_children if hhtype_dv==10 | hhtype_dv==11 | hhtype_dv==12 | hhtype_dv==18 | hhtype==4 
replace equivscale=1+0.5*num_children if hhtype==6  | hhtype_dv==4 | hhtype_dv==5
replace equivscale=2 if hhtype==8 | hhtype==9 | hhtype_dv==19  | hhtype_dv==20  | hhtype_dv==21  | hhtype_dv==22  | hhtype_dv==23

gen income_gross_nominal =  fihhmngrs_dv if  fihhmngrs_dv!=-9
gen income_gross_nominal_equiv = income_gross_nominal/equivscale

gen logincome = ln(income_gross_nominal_equiv)
drop num_children adults equivscale

* Marital Status
recode mastat (-100/0=.)
recode mastat_dv (-100/0=.)

 gen mar_single = ( mastat==6 | mastat_dv==1) 
 gen mar_married = (mastat_dv==2 | mastat_dv==3 | mastat_dv==10 | mastat==1 | mastat==2 | mastat==7)
 gen mar_divsep = (mastat_dv==5 | mastat_dv==8 | mastat==4 | mastat==8 | mastat_dv==4 | mastat_dv==7 | mastat==5  | mastat==9)
 gen mar_widowed = (mastat_dv==6 | mastat_dv==9 | mastat==3 | mastat==10)
 foreach var of varlist mar_* {
replace `var' = . if mastat==. & mastat_dv==.
 }
 


*********  Politics 

* First, ask whether support a party or are close to a party [vote1 & vote2].  If yes to either, answer vote4...
gen pol_supports_lab = (vote4==2 )  if  vote4>0
gen pol_supports_con = (vote4==1 )  if  vote4>0
gen pol_supports_lib = (vote4==3 )  if  vote4>0
* If no to both, ask whether whom they'd vote for if there were an election tomorrow [vote3]... (some still don't know [-1], so they go to zero)
replace pol_supports_lab = (vote3==2 )  if   vote3>-2 & pol_supports_lab==.
replace pol_supports_con = (vote3==1 )  if   vote3>-2 & pol_supports_con==.
replace pol_supports_lib = (vote3==3 )  if   vote3>-2 & pol_supports_lib==.

gen pol_supports_govparty = (pol_supports_con==1) if year<1997 & pol_supports_lab!=.
replace pol_supports_govparty = (pol_supports_con==1) if year==1997 & month<=4 & pol_supports_lab!=.
replace pol_supports_govparty = (pol_supports_lab==1) if year==1997 & month>=5 & pol_supports_lab!=.
replace pol_supports_govparty = (pol_supports_lab==1) if year>1997 & year<2010 & pol_supports_lab!=.
replace pol_supports_govparty = (pol_supports_lab==1) if year==2010 & month<=4 & pol_supports_lab!=.
replace pol_supports_govparty = (pol_supports_con==1 | pol_supports_lib) if year>2010 & year<2015 & pol_supports_lab!=.
replace pol_supports_govparty = (pol_supports_con==1 | pol_supports_lib) if year==2015 & month<=4 & pol_supports_lab!=.
replace pol_supports_govparty = (pol_supports_con==1) if year==2015 & month>=5 & pol_supports_lab!=.
replace pol_supports_govparty = (pol_supports_con==1) if year>2015  & pol_supports_lab!=.	


keep pid id wave age year-pol_supports_govparty 
drop income_gross_nominal


egen z_lifesatisfaction = std(lifesatisfaction)


lab var fin_today1 "HH Finances: Finding it Very Difficult"
lab var fin_today2 "Financial Sit: Finding it quite diff"
lab var fin_today3 "Financial Sit: Just abt getting by"
lab var fin_today4 "Financial Sit: Doing alright"
lab var fin_today5 "Financial Sit: Living comfortably"

lab var fin_fut1 "Fin Sit Next Yr: Worse"
lab var fin_fut2 "Fin Sit Next Yr: Same"
lab var fin_fut3 "Fin Sit Next Yr: Better"

lab var fin_1ych1 "Fin Sit Change: Worse"
lab var fin_1ych2 "Fin Sit Change Yr: Same"
lab var fin_1ych3 "Fin Sit Change Yr: Better"
 
lab var mar_married "Married"
lab var mar_divsep "Divorced/Separated"
lab var mar_widowed "Widowed"
lab var pol_supports_govparty "Supports Government Party"
lab var women "Female"
lab var age   "Age"
lab var logincome "Log Income"
lab var finansit_today "Financial Situation: Today"
lab var finansit_1ychange "Financial Situation: Since Past Year"
lab var finansit_future "Financial Situation: Future"
lab var logincome "Household Income (ln)"

lab var agesq "Age-squared"
lab var mar_single "Marital: Single"
lab var wave "Survey Wave"
lab var year  "Survey Year"
lab var month "Survey Month"

lab var lifesatisfaction "Life Satisfaction"
lab var income_gross_nominal "HH Income"
lab var income_gross_nominal_equiv "HH Income (equivalized)"


drop if pid==.
xtset pid wave

* drop waves in which life sat not asked
drop if wave<6  
drop if wave==11

bysort pid: egen count_pid = count(pid)
lab var count_pid "# Waves Observed in BHPS"

save "$clean/clean_bhps.dta", replace

erase "ukhls_long.dta"
erase "bhps_long.dta"
erase "bhps_ukhls_long.dta"	
			
