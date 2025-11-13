clear
set more off


use "$clean/clean_micro.dta", clear


**** Figure 2
cibar vote_cab if vote_w==0, over1(satislfe) ///
graphopts(ylabel(65(5)75, nogrid) graphregion(color(white)) ytitle("Proportion of Voters Intending to Vote for Government", size(small)) ///
yscale(range(.25(.05).5)) ylab(.25(.05).5, nogrid) legend(size(small) region(col(white)) col(4)  symxsize(3) colgap(2) span)) ///
barcol(forest_green*.25 forest_green*.5 forest_green*.75 forest_green*1 )




**** Table 2

global dem 		female age age_sq educ_16to19 educ_20plus educ_stillstudying educ_missing mar4_married mar4_divsep mar4_widowed mar4_missing  
global gov 		parties_ingov seatshare_cabinet ENEP cab_ideol_sd
global income 	inc2 inc3 inc4 inc5
global egotrop 	egotrop_econ5 egotrop_econ4  egotrop_econ2 egotrop_econ1
global lifesat  satis2 satis3 satis4

gen likelyvote = (vote_wouldnt==0) if vote_wouldnt!=.
lab var likelyvote "1 if Likely to Vote "
lab var vote_cab "1 if Intention to Vote for Governing Party"

eststo clear
reg likelyvote  $lifesat $dem $gov i.eb i.co ,    cluster(co)  
eststo: xi: reg likelyvote  $lifesat  if e(sample)==1,    cluster(co)  
eststo: xi: reg likelyvote  $lifesat $dem $gov i.eb i.co if e(sample)==1,    cluster(co)  

reg vote_cab  $lifesat $dem $gov i.eb i.co if vote_wouldntvote==0,    cluster(co)  
eststo: xi: reg vote_cab  $lifesat if e(sample)==1,    cluster(co)  
eststo: xi: reg vote_cab  $lifesat i.eb i.co $dem $gov if e(sample)==1,    cluster(co)  

 reg vote_cab  $lifesat lastvote_cab  i.eb i.co $dem $gov if e(sample)==1,    cluster(co)  
eststo: xi: reg vote_cab  $lifesat  i.eb i.co $dem $gov if e(sample)==1,    cluster(co)  
eststo: xi: reg vote_cab  $lifesat lastvote_cab i.eb i.co $dem $gov if e(sample)==1,    cluster(co)  

 reg vote_cab  $lifesat lastvote_cab  $egotrop i.eb i.co $dem $gov if e(sample)==1,    cluster(co)  
eststo: xi: reg vote_cab  $egotrop lastvote_cab  i.eb i.co $dem $gov if e(sample)==1,    cluster(co)  
eststo: xi: reg vote_cab  $lifesat lastvote_cab  $egotrop i.eb i.co $dem $gov if e(sample)==1,    cluster(co)  






**** SUPPLEMENTARY TABLES ***


* Table S13
eststo clear 
eststo: xi: probit likelyvote 			$lifesat $gov $dem i.eb i.co ,   cluster(co) 
eststo: xi: probit vote_cab 			$lifesat $gov $dem i.eb i.co ,   cluster(co) 
eststo: xi: biprobit likelyvote vote_cab 			$lifesat $gov $dem i.eb i.co ,   cluster(co) 
eststo: xi: biprobit likelyvote vote_cab 	lastvote_cab		$lifesat $gov $dem i.eb i.co ,   cluster(co) 


* Table S14
eststo clear
reg vote_cab  $lifesat $dem $gov i.eb i.co ,    cluster(co)  
eststo: xi: reg vote_cab  $lifesat if e(sample)==1,    cluster(co)  
eststo: xi: reg vote_cab  $lifesat i.eb i.co if e(sample)==1,    cluster(co)  
eststo: xi: reg vote_cab  $lifesat i.eb i.co $dem $gov if e(sample)==1,    cluster(co)  
 reg vote_cab  $lifesat lastvote_cab  i.eb i.co $dem $gov if e(sample)==1,    cluster(co)  
eststo: xi: reg vote_cab  $lifesat  i.eb i.co $dem $gov if e(sample)==1,    cluster(co)  
eststo: xi: reg vote_cab  $lifesat lastvote_cab i.eb i.co $dem $gov if e(sample)==1,    cluster(co)  

 reg vote_cab  $lifesat lastvote_cab  $egotrop i.eb i.co $dem $gov if e(sample)==1,    cluster(co)  
eststo: xi: reg vote_cab  $egotrop lastvote_cab  i.eb i.co $dem $gov if e(sample)==1,    cluster(co)  
eststo: xi: reg vote_cab  $lifesat lastvote_cab  $egotrop i.eb i.co $dem $gov if e(sample)==1,    cluster(co)  







* Table S15
eststo clear
reg vote_cab  $lifesat $dem $gov lastvote_cab ideol_proximity i.eb i.co if vote_w==0,    cluster(co)  
eststo: xi: reg vote_cab  $lifesat $gov $dem i.eb i.co if e(sample)==1,    cluster(co)  
eststo: xi: reg vote_cab  $lifesat ideol_proximity $gov $dem i.eb i.co if e(sample)==1,    cluster(co)  
eststo: xi: reg vote_cab  $lifesat ideol_proximity lastvote_cab $gov $dem i.eb i.co if e(sample)==1,    cluster(co)  
eststo: xi: reg vote_cab   ideol_proximity lastvote_cab $gov $dem $egotrop i.eb i.co if e(sample)==1,    cluster(co)  
eststo: xi: reg vote_cab  $lifesat ideol_proximity lastvote_cab $gov $dem $egotrop i.eb i.co if e(sample)==1,    cluster(co)  




* Table S16
tab better, gen(ls_future)
global fut  ls_future3 ls_future1
lab var ls_future3 "Worse"
lab var ls_future1 "Better"

eststo clear 
eststo: xi: reg vote_cab  $fut i.eb i.co $dem $gov if vote_w==0,    cluster(co)  
eststo: xi: reg vote_cab  $fut lastvote_cab i.eb i.co $dem $gov if e(sample)==1,    cluster(co)  
eststo: xi: reg vote_cab  $fut $lifesat lastvote_cab i.eb i.co $dem $gov if e(sample)==1,    cluster(co)  
eststo: xi: reg vote_cab  $fut $egotrop lastvote_cab i.eb i.co $dem $gov if e(sample)==1,    cluster(co)  
eststo: xi: reg vote_cab  $fut $lifesat $egotrop lastvote_cab i.eb i.co $dem $gov if e(sample)==1,    cluster(co)  



* Table S17

reg vote_cab  $lifesat $gov $dem i.eb i.co if vote_wouldntvote==0
eststo clear
eststo: xi: logit vote_cab  $lifesat  if e(sample)==1,   cluster(co) 
eststo: mfx, var($lifesat)
eststo: xi: logit vote_cab  $lifesat $gov $dem i.eb i.co if e(sample)==1,   cluster(co) 
eststo: mfx, var($lifesat)
eststo: xi: logit vote_cab  $lifesat lastvote_cab $gov $dem i.eb i.co if e(sample)==1,   cluster(co) 
eststo: mfx, var($lifesat lastvote_cab)
eststo: xi: logit vote_cab  $lifesat lastvote_cab $egotrop $gov $dem i.eb i.co if e(sample)==1,   cluster(co) 
eststo: mfx, var($lifesat lastvote_cab $egotrop)




* Table S18 
lab var lastvote_pm "Last vote was for PM party"

eststo clear
reg vote_pm  $lifesat $dem $gov i.eb i.co if vote_wouldntvote==0,    cluster(co)  
eststo: xi: reg vote_pm  $lifesat if e(sample)==1,    cluster(co)  
eststo: xi: reg vote_pm  $lifesat i.eb i.co if e(sample)==1,    cluster(co)  
eststo: xi: reg vote_pm  $lifesat i.eb i.co $dem $gov if e(sample)==1,    cluster(co)  
 reg vote_pm  $lifesat lastvote_cab  i.eb i.co $dem $gov if e(sample)==1,    cluster(co)  
eststo: xi: reg vote_pm  $lifesat  i.eb i.co $dem $gov if e(sample)==1,    cluster(co)  
eststo: xi: reg vote_pm  $lifesat lastvote_cab i.eb i.co $dem $gov if e(sample)==1,    cluster(co)  

 reg vote_cab  $lifesat lastvote_cab  $egotrop i.eb i.co $dem $gov if e(sample)==1,    cluster(co)  
eststo: xi: reg vote_pm  $egotrop lastvote_cab  i.eb i.co $dem $gov if e(sample)==1,    cluster(co)  
eststo: xi: reg vote_pm  $lifesat lastvote_cab  $egotrop i.eb i.co $dem $gov if e(sample)==1,    cluster(co)  





* Table S22
foreach var of varlist parties_ingov seatshare_cabinet cab_ideol_sd ENEP {
egen z_`var' = std(`var')
gen sat_x_`var' = z_`var' *  z_satislfe
}
lab var sat_x_parties_ingov		"SWB * Parties in Gov."
lab var sat_x_seatshare_cabinet		"SWB * Gov. Seat Share"
lab var sat_x_cab_ideol_sd	"SWB * Ideological Discordance"
lab var sat_x_ENEP "SWB * Party Fractionalisation"


foreach var of varlist z_parties_ingov z_cab_ideol_sd z_ENEP {
omscore `var' 
}

egen clarity = rowmean(rr_z_parties_ingov z_seatshare_cabinet rr_z_cab_ideol_sd rr_z_ENEP)
egen z_clarity = std(clarity)
gen sat_x_clarity = z_clarity*z_satislfe
lab var z_clarity "Clarity of Responsibility (Index)"
lab var sat_x_clarity "SWB * CoR"

 
 eststo clear
eststo: xi: reg vote_cab  z_satislfe $dem z_parties_ingov z_seatshare_cabinet z_cab_ideol_sd z_ENEP  i.eb i.co if vote_wouldntvote==0,    cluster(co)  
eststo: xi: reg vote_cab  z_satislfe $dem z_parties_ingov z_seatshare_cabinet z_cab_ideol_sd z_ENEP sat_x_parties_ingov  i.eb  i.co  if vote_wouldntvote==0,    cluster(co)  
eststo: xi: reg vote_cab  z_satislfe $dem z_parties_ingov z_seatshare_cabinet z_cab_ideol_sd z_ENEP sat_x_seatshare_cabinet  i.eb  i.co  if vote_wouldntvote==0,    cluster(co)  
eststo: xi: reg vote_cab  z_satislfe $dem z_parties_ingov z_seatshare_cabinet z_cab_ideol_sd z_ENEP sat_x_cab_ideol_sd  i.eb i.co   if vote_wouldntvote==0,    cluster(co)  
eststo: xi: reg vote_cab  z_satislfe $dem z_parties_ingov z_seatshare_cabinet z_cab_ideol_sd z_ENEP sat_x_ENEP  i.eb  i.co  if vote_wouldntvote==0,    cluster(co)  
eststo: xi: reg vote_cab  z_satislfe $dem z_parties_ingov z_seatshare_cabinet z_cab_ideol_sd z_ENEP sat_x_parties_ingov sat_x_seatshare_cabinet sat_x_cab_ideol_sd  sat_x_ENEP i.eb  i.co  if vote_wouldntvote==0,    cluster(co)  

 
 
 


