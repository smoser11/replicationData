
clear
set more off


*__________________ Effective number of parties __________________*

* Effective number of parties from Gallagher --- https://www.tcd.ie/Political_Science/staff/michael_gallagher/ElSystems/Docts/ElectionIndices.pdf 
import excel "$vote/gallagher_data.xlsx",  firstrow clear
destring EffNv, gen(ENEP)
keep year country ENEP  election_number
encode country, gen(nat_code)
xtset nat_code election_number
gen ENEP_tmin1 = L.ENEP
drop nat_code ENEP
saveold "$vote/gallagher_data.dta", replace



*__________________ EUROBAROMETER PARTY ID LINKAGE __________________*


**************** LINKFILE
import excel "$vote/party_xwalk.xlsx",  firstrow clear

saveold "$vote/partyid_link.dta", replace

**************** PARLGOV
import excel "$vote/parlgov_stable.xlsx", sheet("party") firstrow clear

keep if country_name_short=="AUT" | country_name_short=="BEL" | country_name_short=="DNK" |  country_name_short=="FIN" | country_name_short=="FRA" |  country_name_short=="DEU" | ///
 country_name_short=="GBR" |  country_name_short=="GRC" | country_name_short=="IRL" |  country_name_short=="ITA" | country_name_short=="LUX" |  country_name_short=="NLD" | ///
 country_name_short=="PRT" |  country_name_short=="SWE" | country_name_short=="ESP" 

gen partyid_parlgov = party_id

merge m:1 partyid_parlgov using "$vote/partyid_link.dta"
keep if _merge==3
drop _merge

keep countryname  party_name_short partyid_parlgov partyid_eb  party_name
order countryname country party_name_short partyid_parlgov partyid_eb party_name
sort countryname

saveold "$vote/partyid_link.dta", replace 


*__________________ CABINET COMPOSITION __________________*

import excel "$vote/parlgov_stable.xlsx", sheet("cabinet") firstrow clear
keep if country_name_short=="AUT" | country_name_short=="BEL" | country_name_short=="DNK" |  country_name_short=="FIN" | country_name_short=="FRA" |  country_name_short=="DEU" | ///
 country_name_short=="GBR" |  country_name_short=="GRC" | country_name_short=="IRL" |  country_name_short=="ITA" | country_name_short=="LUX" |  country_name_short=="NLD" | ///
 country_name_short=="PRT" |  country_name_short=="SWE" | country_name_short=="ESP" 

 
gen date_cabstart = date(start_date, "YMD")
gen year_cabstart = 	yofd(date_cabstart)
gen month_cabstart = mofd(date_cabstart)
format date_cabstart %td
format month_cabstart %tm
gen partyid_parlgov = party_id


merge m:1 partyid_parlgov using "$vote/partyid_link.dta"
keep if _merge==3
drop _merge

keep if prime_minister==1 | cabinet_party==1 
drop if country_name_short == "AUT" & year < 1951
drop if country_name_short == "BEL" & year < 1951
drop if country_name_short == "DNK" & year < 1951
drop if country_name_short == "FIN" & year < 1951
drop if country_name_short == "FRA" & year < 1951
drop if country_name_short == "DEU" & year < 1951
drop if country_name_short == "GRC" & year < 1951
drop if country_name_short == "GBR" & year < 1951
drop if country_name_short == "IRL" & year < 1951
drop if country_name_short == "ITA" & year < 1951
drop if country_name_short == "LUX" & year < 1951
drop if country_name_short == "NLD" & year < 1951
drop if country_name_short == "PRT" & year < 1951
drop if country_name_short == "SWE" & year < 1951
drop if country_name_short == "ESP" & year < 1951
rename countryname country

gen seat_share = seats / election_seats_total
sort  cabinet_id
by cabinet_id: egen seats_cabinet_total = total(seat_share) if cabinet_party==1

gen left_right_cab = left_right*seat_share if cabinet_party==1
sort  cabinet_id
by cabinet_id: egen left_right_cabinet = total(left_right_cab)
replace left_right_cabinet = left_right_cabinet/seats_cabinet_total
drop left_right_cab

gen left_right_pm = left_right if prime_minister==1

bysort cabinet_id: egen cab_ideol_sd = sd(left_right)
replace cab_ideol_sd = 0 if cab_ideol_sd==.

sort country_name_short  start_date
 
bysort cabinet_id: gen cabpartynum = _n
bysort cabinet_id: gen pm = partyid_eb if prime_minister==1
forvalues x= 1/9 {
bysort cabinet_id: gen cab`x' = partyid_eb if cabpartynum==`x'
}

egen parliament_id = group(country_name_short  election_date)
gen date_election = date(election_date, "YMD")
gen month_election = mofd(date_election)
format date_election %td
format month_election %tm

collapse  previous_cabinet_id left_right_cabinet left_right_pm cab_ideol_sd year_cabstart month_cabstart month_election parliament_id pm cab1 cab2 cab3 cab4 cab5 cab6 cab7 cab8 cab9 seats_cabinet_total, by(cabinet_id country)
sort country month_cabstart
encode country, gen(co)

egen parties_ingov = rownonmiss(cab1-cab9)

foreach var of varlist pm cab1-cab9 {
replace `var' = 0 if `var'==.
}


sort co month_cabstart 
bysort co : gen n = _n
xtset co  
gen month = month_cabstart
format month %tm
 sort co  month
xtset co month
tsfill, full
by co (month): carryforward cabinet_id country previous_cabinet_id month_cabstart left_right_cabinet left_right_pm cab_ideol_sd month_election  parliament_id cab1 cab2 cab3 cab4 cab5 cab6 cab7 cab8 cab9 pm co n seats_cabinet_total parties_ingov, replace
drop if cabinet_id==.

order country month month_cabstart pm cab1 cab2 cab3 cab4 cab5 cab6 cab7 cab8 cab9  cabinet_id parliament_id month_election   seats_cabinet_total

rename seats_cabinet_total seatshare_cabinet
gen minoritygov = (seatshare_cabinet<0.5) if seatshare_cabinet!=.
gen coalition_gov = (parties_ingov>1) if parties_ingov!=.


tsspell pm
gen pm_monthsinpower = _seq
drop _spell _seq _end


drop if country == "AUT" & year < 1985
drop if country == "BEL" & year < 1965
drop if country == "DNK" & year < 1965
drop if country == "FIN" & year < 1985
drop if country == "FRA" & year < 1965
drop if country == "DEU" & year < 1965
drop if country == "GRC" & year < 1975
drop if country == "GBR" & year < 1965
drop if country == "IRL" & year < 1965
drop if country == "ITA" & year < 1965
drop if country == "LUX" & year < 1965
drop if country == "NLD" & year < 1965
drop if country == "PRT" & year < 1980
drop if country == "SWE" & year < 1990
drop if country == "ESP" & year < 1980

saveold "$vote/cabinet_composition_eurobarometerID.dta", replace 


keep country month pm_monthsinpower seatshare_cabinet
saveold "$vote/pm_monthsinpower.dta", replace





*__________________ PARLGOV ELECTION RESULTS __________________*
import excel "$vote/parlgov_stable.xlsx", sheet("viewcalc_election_parameter") firstrow clear

foreach var of varlist turnout  disproportionality advantage_ratio polarization_vote polarization_seats {
rename `var' parlgov_`var'
}
keep parlgov_* election_id

saveold "$vote/elec_cal.dta", replace


* Import the election data into stata, and prepare it for merging.  
import excel "$vote/parlgov_stable.xlsx", sheet("election") firstrow clear
keep if election_type=="parliament"
drop election_type 

merge m:1 election_id using "$vote/elec_cal.dta"
keep if _merge==3
drop _merge

gen date = date(election_date, "YMD")
format date %td
gen year = yofd(date)
drop if year<1960 
drop date year

saveold "$vote/election_t.dta", replace

* Previus election data, and prepare it for merging.  
import excel "$vote/parlgov_stable.xlsx", sheet("election") firstrow clear
keep if election_type=="parliament"

merge m:1 election_id using "$vote/elec_cal.dta"
keep if _merge==3
drop _merge

foreach var of varlist parlgov_* {
rename `var' prev_`var'
}

gen date = date(election_date, "YMD")
format date %td
gen year = yofd(date)
drop if year<1960 
drop date year

drop previous_parliament_election_id
rename election_id previous_parliament_election_id
rename election_date election_date_previous
rename vote_share vote_share_previous_elec
keep country_name_short election_date_previous vote_share_previous_elec party_name_short ///
party_name_english country_id previous_parliament_election_id party_id prev_* ///

saveold "$vote/election_tmin1.dta", replace

* Import the cabinet data into stata, and prepare it for merging with election data
import excel "$vote/parlgov_stable.xlsx", sheet("cabinet") firstrow clear
keep country_id party_id cabinet_id party_name_short party_name_english prime_minister cabinet_party  left_right
rename cabinet_id previous_cabinet_id

drop if party_id==947


saveold "$vote/cabinet.dta", replace 

* Merge and organise

use "$vote/election_t.dta", clear
merge 1:1 country_id party_id previous_cabinet_id party_name_short party_name_english using "$vote/cabinet.dta"
drop if _merge==2
drop _merge
replace prime_minister = 0 if prime_minister==.
replace cabinet_party = 0 if cabinet_party==.

merge 1:1 country_name_short party_name_short party_name_english country_id previous_parliament_election_id ///
party_id using "$vote/election_tmin1.dta"
drop if _merge==2

sort country_name_short election_date
order country_name_short country_id election_id country_name election_date party_name_short ///
prime_minister cabinet_party vote_share vote_share_previous_elec party_name_english


* Tidy up 

*** ITALY ***
* 2001: the left goes forward as the Olive Tree
replace prime_minister = 1 if election_id==498 & party_id==1048
replace cabinet_party = 1 if election_id==498 & party_id==1048
* 2008: Democratic Party is new, but is an amalgam of previous cabinet parties
replace cabinet_party = 1 if election_id==111 & party_id==382 
* The rainbow list is also an amalgam of previous cabinet parties
replace cabinet_party = 1 if election_id==111 & party_id==1437
* In 1994 there is no incumbent, as Ciampi is an independent PM.  Of the five parties in Ciampi's caretaker gov (DC נPSI נPLI נPSDI נPC), only the PSI still exists into the election.  As a result, the election is dropped. 
replace cabinet_party = 0 if election_id==146


*** GERMANY ***
* CDU and CSU appear separately in the election results, but are already together in the cabinet file
replace prime_minister = 1 if election_id==484 & party_id==808
replace prime_minister = 1 if election_id==484 & party_id==1180
replace prime_minister = 1 if election_id==588 & party_id==808
replace prime_minister = 1 if election_id==588 & party_id==1180
replace prime_minister = 1 if election_id==445 & party_id==808
replace prime_minister = 1 if election_id==445 & party_id==1180
replace prime_minister = 1 if election_id==595 & party_id==808
replace prime_minister = 1 if election_id==595 & party_id==1180
replace prime_minister = 1 if election_id==679 & party_id==808
replace prime_minister = 1 if election_id==679 & party_id==1180
replace prime_minister = 1 if election_id==93 & party_id==808
replace prime_minister = 1 if election_id==93 & party_id==1180
replace prime_minister = 1 if election_id==800 & party_id==808
replace prime_minister = 1 if election_id==800 & party_id==1180

replace cabinet_party = 1 if election_id==484 & party_id==808
replace cabinet_party = 1 if election_id==484 & party_id==1180
replace cabinet_party = 1 if election_id==588 & party_id==808
replace cabinet_party = 1 if election_id==588 & party_id==1180
replace cabinet_party = 1 if election_id==445 & party_id==808
replace cabinet_party = 1 if election_id==445 & party_id==1180
replace cabinet_party = 1 if election_id==595 & party_id==808
replace cabinet_party = 1 if election_id==595 & party_id==1180
replace cabinet_party = 1 if election_id==679 & party_id==808
replace cabinet_party = 1 if election_id==679 & party_id==1180
replace cabinet_party = 1 if election_id==93 & party_id==808
replace cabinet_party = 1 if election_id==93 & party_id==1180
replace cabinet_party = 1 if election_id==800 & party_id==808
replace cabinet_party = 1 if election_id==800 & party_id==1180

* FRANCE
*In 2002 the UMP is formed as a merger of the RPR and UDF
replace cabinet_party = 1 if election_id==403 & party_id==658
replace prime_minister = 1 if election_id==403 & party_id==658
* In 1978, the two coalition parties going into the election were the UDF and RPR (under an "independent" Barre government)
replace cabinet_party = 1 if election_id==496 & party_id==138
replace cabinet_party = 1 if election_id==496 & party_id==509
* The RPR was in 1978 UDR, coded in parlgov simply as a catch-all G (Gaullist) 
replace vote_share_previous_elec = 26 if election_id==496 & party_id==138


* Generate vote and seat share variables for both cabinets as a whole and lead parties
sort  country_name_short election_date
by country_name_short election_date: egen vote_share_pm = total(vote_share) if prime_minister==1
by country_name_short election_date: egen vote_share_cab = total(vote_share) if cabinet_party==1
by country_name_short election_date: egen vote_share_pm_tmin1 = total(vote_share_previous_elec) if prime_minister==1
by country_name_short election_date: egen vote_share_cab_tmin1 = total(vote_share_previous_elec) if cabinet_party==1

* The 2001 ITA results are included in parlgov as aggregate alliance vote shares, but the disaggregated vote shares are included in 2006.  Here I simply sum the vote shares of the individual elements of the electoral lists/alliances.
replace vote_share_pm_tmin1 = 29.2 if election_id==107 & party_id==596
replace vote_share_cab_tmin1 = 45.57 if election_id==107
replace vote_share_cab_tmin1 = 47.7 if election_id==111
*  The Belgian 2010 lagged vote share needs amending since it appears as missing, as the christian democrats changed their name to CD&V
replace vote_share_pm_tmin1 = 18.5 if election_id==486

* Generate a number of cabinet parties variable 
by country_name_short election_date : egen parties_ingov = total(cabinet_party)

* Generate an ideological position of government variables (mean left-right 0-10 scale for all cabinet parites, weighted by their respective vote shares)
gen left_right_cab = left_right*vote_share if cabinet_party==1
sort election_id
by election_id: egen left_right_cabinet = total(left_right_cab)
replace left_right_cabinet = left_right_cabinet/vote_share_cab

gen left_right_pm = left_right if prime_minister==1

bysort election_id: egen cab_ideol_sd = sd(left_right) if cabinet_party==1
replace cab_ideol_sd = 0 if cab_ideol_sd==. & prime_minister==1

* Greece 1990
replace vote_share_pm_tmin1 = . if vote_share_pm_tmin1==0
replace vote_share_cab_tmin1 = . if vote_share_cab_tmin1==0
replace vote_share_pm = . if vote_share_pm==0
replace vote_share_cab = . if vote_share_cab==0

*******
* Now, collapse these data into country-election observations
collapse  vote_share_pm vote_share_cab vote_share_cab_tmin1 vote_share_pm_tmin1 parties_ingov ///
 left_right_cabinet left_right_pm cab_ideol_sd parlgov_* prev_parlgov_*, by(country_name_short election_date)

* useful time variables
gen elec_date = date(election_date, "YMD")
format elec_date %td
drop election_date
gen year = yofd(elec_date)
gen election_month = mofd(elec_date)
gen election_quarter = qofd(elec_date)

* We are only interested in the elections for which we have Eurobarometer SWB data available.

keep if country_name_short=="AUT" | country_name_short=="BEL" | country_name_short=="DNK" |  country_name_short=="FIN" | country_name_short=="FRA" |  country_name_short=="DEU" | ///
 country_name_short=="GBR" |  country_name_short=="GRC" | country_name_short=="IRL" |  country_name_short=="ITA" | country_name_short=="LUX" |  country_name_short=="NLD" | ///
 country_name_short=="PRT" |  country_name_short=="SWE" | country_name_short=="ESP" 

drop if country_name_short == "AUT" & year < 1994
drop if country_name_short == "BEL" & year < 1971
drop if country_name_short == "DNK" & year < 1971
drop if country_name_short == "FIN" & year < 1991
drop if country_name_short == "FRA" & year < 1968
drop if country_name_short == "DEU" & year < 1972
drop if country_name_short == "GRC" & year < 1977
drop if country_name_short == "GBR" & year < 1970
drop if country_name_short == "IRL" & year < 1969
drop if country_name_short == "ITA" & year < 1972
drop if country_name_short == "LUX" & year < 1968
drop if country_name_short == "NLD" & year < 1972
drop if country_name_short == "PRT" & year < 1983
drop if country_name_short == "SWE" & year < 1994
drop if country_name_short == "ESP" & year < 1982


* Sort/Tidy
sort country_name_short elec_date
rename country_name_short country
bysort country: gen election_number = _n

saveold "$vote/parlgov.dta", replace 


use "$vote/parlgov.dta", clear 
encode country, gen(co)
xtset co election_number


merge m:1 country election_number using "$vote/gallagher_data.dta"  
drop if _merge==2
drop _merge
sort co election_number
replace ENEP_tmin1 = L.ENEP if ENEP_tmin1==.

gen month = election_month-1
format month %tm
merge 1:1 country month using "$vote/pm_monthsinpower.dta"  
drop if _merge==2
drop _merge month

order country year elec_date election_number vote_share_cab vote_share_cab_tmin1 vote_share_pm vote_share_pm_tmin1 ///
  ENEP_tmin1   parties_ingov  

  
  
  
lab var country "Country Name"
lab var year "Election Year"
lab var elec_date "Election Date"
lab var election_number "Election Number in Sample"
lab var vote_share_cab "Gov Vote Share"
lab var vote_share_cab_tmin1 "Gov Vote Share - Last Election"
lab var vote_share_pm "PM Party Vote Share"
lab var vote_share_pm_tmin1 "PM Party Vote Share - Last Election"
lab var ENEP_tmin1 "Party Fractionalisation - Last Election"
lab var parties_ingov "Parties in Government"
lab var left_right_cabinet "Ideology of Government"
lab var left_right_pm  "Ideology of PM Party"
lab var cab_ideol_sd "Gov Ideologial Disparity"
lab var election_month "Election Month"
lab var election_quarter "Election Quarter"
lab var co "Country Code"
lab var ENEP "Fractionalisation"
lab var seatshare_cabinet "Prior Government Seat Share" 
lab var parlgov_turnout "Turnout"
drop pm_months parlgov_disproportionality-prev_parlgov_polarization_seats
  
  
  
  
  
  
saveold "$vote/election_data.dta", replace 

erase "$vote/gallagher_data.dta"  
erase "$vote/election_t.dta"
erase "$vote/election_tmin1.dta"  
erase "$vote/cabinet.dta"  
erase "$vote/parlgov.dta"  
erase "$vote/partyid_link.dta"
erase "$vote/pm_monthsinpower.dta"
erase "$vote/elec_cal.dta"

keep country elec_date ENEP 
encode country, gen(co)
gen month = mofd(elec_date)
format month %tm

sort co  month
xtset co month
tsfill, full
by co (month):  carryforward country elec_date ENEP, replace
drop if elec_date==.

keep country month elec_date ENEP

saveold "$vote/enep_bymonth.dta", replace




