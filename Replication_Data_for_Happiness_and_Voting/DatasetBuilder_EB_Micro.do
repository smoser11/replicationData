clear*
set more off

use "$eb/ZA3521_v2-0-1.dta", clear /* 	Mannheim Eurobarometer Trend File 	*/


* Time 
gen month = .
replace month =	9	if eb ==	3
replace month =	5	if eb ==	30
replace month =	10	if eb ==	40
replace month =	6	if eb ==	50
replace month =	11	if eb ==	60
replace month =	5	if eb ==	70
replace month =	11	if eb ==	80
replace month =	6	if eb ==	90
replace month =	11	if eb ==	100
replace month =	4	if eb ==	110
replace month =	4	if eb ==	130
replace month =	4	if eb ==	150
replace month =	4	if eb ==	170
replace month =	10	if eb ==	180
replace month =	4	if eb ==	190
replace month =	10	if eb ==	200
replace month =	4	if eb ==	210
replace month =	11	if eb ==	220
replace month =	4	if eb ==	230
replace month =	11	if eb ==	240
replace month =	4	if eb ==	250
replace month =	11	if eb ==	260
replace month =	4	if eb ==	270
replace month =	11	if eb ==	280
replace month =	4	if eb ==	290
replace month =	4	if eb ==	310
replace month =	7	if eb ==	311
replace month =	11	if eb ==	320
replace month =	12	if eb ==	321
replace month =	3	if eb ==	330
replace month =	10	if eb ==	340
replace month =	11	if eb ==	341
replace month =	3	if eb ==	350
replace month =	11	if eb ==	360
replace month =	4	if eb ==	370
replace month =	5	if eb ==	371
replace month =	10	if eb ==	380
replace month =	11	if eb ==	381
replace month =	4	if eb ==	390
replace month =	10	if eb ==	400
replace month =	4	if eb ==	410
replace month =	12	if eb ==	420
replace month =	4	if eb ==	431
replace month =	4	if eb ==	471
replace month =	4	if eb ==	490
replace month =	11	if eb ==	520
replace month =	11	if eb ==	521
replace month =	4	if eb ==	530
replace month =	12	if eb ==	541
replace month =	5	if eb ==	551
replace month =	10	if eb ==	561
replace month =	11	if eb ==	562
replace month =	4	if eb ==	571
replace eb = 520 if eb==521


gen day = 1 
gen survey_date = mdy(month, day, year) 
drop month day
gen month = mofd(survey_date)


* Life Satisfaction 
recode satislfe (4=1) (3=2) (2=3) (1=4) (5/10=.)
label define Satisfaction 1 "Not at all satisfied" 2 "Not very satisfied " 3 "Fairly satisfied" 4 "Very satisfied"
label values satislfe Satisfaction
drop if missing(satislfe)

* Country 
label define nation1 1 "FRA" 2 "BEL" 3 "NLD" 4 "DEU-W" 5 "ITA" 6 "LUX" 7 ///
"DNK"8 "IRL" 9 "GBR" 10 "NI" 11 "GRC" 12 "ESP" 13 "PRT" 14 "DEU-E" ///
16 "FIN" 17 "SWE" 18 "AUT", replace
label values nation1 nation1
decode nation1, gen(country)
drop if country=="NI" | country=="DEU-E"
replace country = "DEU" if country=="DEU-W"
drop if country==""
egen country_eb = group(country eb)
encode country, gen(co)

* Age and Sex
gen age_sq = age^2
gen male = (sex==1) 
gen female = (sex==2) 

recode age (0=.)
keep if age>=18


* Education
gen educ_0to15 = (educ==1 | educ==2 | educrec==1) 
gen educ_16to19 = (educ==3 | educ==4 | educ==5 | educ==6  | educrec==2) 
gen educ_20plus = (educ==7 | educ==8 | educ==9 | educrec==3)
gen educ_stillstudying = (educ==10 | educrec==4) 
gen educ_missing = (educ==.)


* Marital Status 
recode married (9/10=.)
gen mar4_single = (married==1) 
gen mar4_married = (married==2 | married==3) 
gen mar4_divsep = (married==4 | married==5) 
gen mar4_widowed = (married==6) 
gen mar4_missing = (married==.) 


* Political Leanings 
format month %tm
merge m:1 country month using "$vote/cabinet_composition_eurobarometerID.dta"
drop _merge

merge m:1 country month using "$vote/enep_bymonth.dta"
drop if _merge==1
drop _merge


recode lrs (11/100=.)
replace lrs = . if lrs==.a
replace lrs = . if lrs==.b
gen l = 0 if lrs!=.
replace l = 1 if lrs==1 | lrs==2 | lrs==3
gen r = 0 if lrs!=.
replace r = 1 if lrs==8 | lrs==9 | lrs==10
lab var left_right_cabinet "Right-wingness of Government (0-10 scale)"
gen l_x_leftrightcab = l*left_right_cabinet
gen r_x_leftrightcab = r*left_right_cabinet
lab var l_x_leftrightcab "Left-Wing Indiv' * Right-Wingness of Gov'"
lab var r_x_leftrightcab "Right-Wing Indiv' * Right-Wingness of Gov'"
lab var l "Left-winger (vs. centrist)"
lab var r "Right-winger (vs. centrist)"


local new = _N + 1
set obs `new'
replace left_right_cabinet = 0 in `new'

local new = _N + 1
        set obs `new'
replace left_right_cabinet = 10 in `new'
		
su left_right_cabinet, meanonly 
gen left_right_cabinet_01 = (left_right_cabinet - r(min)) / (r(max) - r(min)) 
*drop if left_right_cabinet==0 
*drop if left_right_cabinet==10 

su lrs, meanonly 
gen lrs_01 = (lrs - r(min)) / (r(max) - r(min)) 

gen ideol_proximity = lrs_01 - left_right_cabinet_01
replace  ideol_proximity = abs(ideol_proximity)
lab var lrs "Left-Right Placement (1-10)"
lab var ideol_proximity	"Ideological Distance from Gov'"

* Electoral Behaviour

su voteint

recode voteint (0=998)
bysort co eb: egen count = count(voteint)
replace voteint = . if count==1
drop count 


recode voteint (505=500) if co==7
recode voteint (999=.) 

replace voteint = inclvote if inclvote<901 & inclvote>0 & voteint==.

*For a few rounds, the actual voteint question is a "feel closer to a party" kind of question
replace voteint = .  if country=="ITA" & eb<=190
replace voteint = .  if country=="LUX" & eb<=80
replace voteint = .  if country=="IRL" & eb<=160
replace voteint = .  if country=="IRL" & eb==180 | eb==190 
su voteint


gen vote_wouldntvote = (voteint>=995 & voteint<=998) if voteint!=.

gen vote_pm = (voteint==pm) if voteint!=.
gen vote_cab = (voteint==cab1 | voteint==cab2 | voteint==cab3 | voteint==cab4 | voteint==cab5 | ///
				voteint==cab6 | voteint==cab7 | voteint==cab8 | voteint==cab9) if voteint!=.

gen lastvote_pm = (lastvote==pm) if lastvote!=.
gen lastvote_cab = (lastvote==cab1 | lastvote==cab2 | lastvote==cab3 | lastvote==cab4 | lastvote==cab5 | ///
				lastvote==cab6 | lastvote==cab7 | lastvote==cab8 | lastvote==cab9) if lastvote!=.
su voteint

				
bysort co eb: egen meanvotecab = mean(vote_cab)
bysort co eb: egen meanvotepm = mean(vote_pm)
replace vote_cab = . if 	meanvotecab==0			
replace vote_pm = . if 		meanvotepm==0			
su voteint
								
* Life Satisfaction
tab satislfe, gen(satis)
lab var satis1 "Life: Not at all satisfied" 
lab var satis2 "Not very satisfied" 
lab var satis3 "Fairly satisfied" 
lab var satis4 "Very satisfied"
global satlife satis1 satis2 satis3 satis4

egen z_satislfe = std(satislfe)

recode better (5/10=.)

* Household Finances
recode finapast (6/10=.)
tab finapast, gen(egotrop_econ)
lab var egotrop_econ1 "Financial Situation: A lot better" 
lab var egotrop_econ2 "A little better" 
lab var egotrop_econ3 "Stayed the same" 
lab var egotrop_econ4 "A little worse"
lab var egotrop_econ5 "A lot worse"


				
* Labels
lab var female "Female"
lab var satislfe "Life Satisfaction"
lab var vote_cab "Vote Intention: Governing party"
lab var age "Age"
lab var age_sq "Age$^2$"
lab var mar4_single "Single"
lab var mar4_married "Married/Live as Married"
lab var mar4_divsep "Divorced/Separated"
lab var mar4_widowed "Widow/Widower"
lab var educ_0to15 "Education: until 0-15 years old"
lab var educ_16to19 "Education: until 16-19 years old"
lab var educ_20plus "Education: until 20+ years old"
lab var educ_stillstudying  "Education: still studying"

lab var ideol_proximity "Ideological Distance from Gov."
lab var lastvote_cab   "Last vote was for governing party"
lab var lrs   "Left-Right Placement "

lab var parties_ingov   	"Num. of Government Parties"
lab var ENEP      			"Effective Number of Parties"
lab var seatshare_cabinet 	"Government Seat Share"
lab var cab_ideol_sd 		"Gov. Ideological Disparity"

lab var vote_wouldntvote "Vote Int: Blank/Wouldnt/Refused/DK"
lab var vote_pm "Vote Intention: PM party"
lab var lastvote_pm "Last vote was for PM party"
lab var co "Country code"
lab var country_eb "Country*Survey"
lab var country "Country"
lab var month "Survey Month"
lab var left_right_pm "Right-wingness of PM Party"
lab var parliament_id "Parlgov Parliament ID"
lab var cabinet_id "Parlgov Cabinet ID"
lab var eb "Eurobometer #"
lab var voteint "Voting Intention"
lab var id "Eurobometer unique ID"
lab var year "Eurobometer year"

keep study_id version id year eb satislfe satis1 satis2 satis3 satis4 egotrop_econ1 egotrop_econ2 egotrop_econ3 egotrop_econ4 egotrop_econ5 finapast ///
vote_cab vote_pm  month country country_eb co age age_sq female educ_0to15 educ_16to19 educ_20plus educ_stillstudying ///
educ_missing mar4_single mar4_married mar4_divsep mar4_widowed mar4_missing cabinet_id parliament_id seatshare_cabinet left_right_cabinet voteint ///
left_right_pm cab_ideol_sd parties_ingov  ENEP ideol_proximity vote_wouldntvote vote_pm vote_cab lastvote_pm lastvote_cab better z_satislfe

order country co year month eb satislfe vote* lastvote* satis1 satis2 satis3 satis4 z_satislfe better finapast egotrop*  
reg vote_cab satislfe 
keep if e(sample)


save "$clean/clean_micro.dta", replace

erase "$vote/enep_bymonth.dta"
erase "$vote/cabinet_composition_eurobarometerID.dta"
