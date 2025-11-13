
clear
set more off

*************
use "$eb/ZA2828_v1-0-1.dta" /* Open Data for Eurobarometer 44.2bis*/

gen eb = 442
gen year = 1996
gen month = 2
rename v604 date_interview 

rename v5 id_original
rename v2 study_id
rename v8 country
rename v9 wnation
rename v7 wuk
rename v37 satislfe
rename v549 voteint_96coding

rename v554 age
rename v550 marital_status
rename v551 education
recode education (0=10) (1/14=1) (15=2) (16=3) (17=4) (18=5) (19=6) (20=7) (21=8) (22/80=9), gen(educ_10cat)
rename v553 sex
rename v543 lrs

/* In this wave Finland, Sweden and Austria are coded differently to elsewhere in the EB */

recode country (15=16) (16=17) (17=18)

keep eb year month date_interview id_original study_id country wnation wuk satislfe age marital_status education educ_10cat ///
sex  lrs   voteint_96coding   



save	"44.2.dta"	, replace		
*************


*************
use "$eb/ZA3693_v1-0-1.dta", clear	/*	Open Data for Eurobarometer 58.1*/

gen eb = 581
gen year = 2002
gen month = 10
rename v448 date_interview 

rename v5 id_original
rename v2 study_id
rename v8 country
rename v9 wnation
rename v7 wuk
rename v40 satislfe

rename v420 age
rename v416 marital_8cat
recode marital_8cat (1/2=2) (3=3) (4/5=1) (6=4) (7=5) (8=6) (9=.), gen(marital_status)
rename v417 education
recode education (98=10) (1/14=1) (15=2) (16=3) (17=4) (18=5) (19=6) (20=7) (21=8) (22/80=9), gen(educ_10cat)
rename v419 sex
rename v413 lrs

keep eb year month date_interview id_original study_id country wnation wuk satislfe   ///
age marital_8cat marital_status education educ_10cat sex  lrs  

save	"58.1.dta"	, replace
*************


*************
use "$eb/ZA3938_v1-0-1.dta", clear	/*	Open Data for Eurobarometer60.1	*/

gen eb = 601
gen year = 2003
gen month = 10
rename v626 date_interview 

rename v5 id_original
rename v2 study_id
rename v8 country
rename v9 wnation
rename v7 wuk
rename v38 satislfe

rename v598 age
rename v594 marital_8cat
recode marital_8cat (1/2=2) (3=3) (4/5=1) (6=4) (7=5) (8=6) (9=.), gen(marital_status)
rename v595 education
recode education (98=10) (1/14=1) (15=2) (16=3) (17=4) (18=5) (19=6) (20=7) (21=8) (22/80=9), gen(educ_10cat)
rename v597 sex
rename v591 lrs
 
keep eb year month date_interview id_original study_id country wnation wuk satislfe   ///
 age marital_8cat marital_status educ_10cat sex  lrs  


save	"60.1.dta"	, replace
*************


*************
use "$eb/ZA4229_v1-1-0.dta", clear /*	Open Data for Eurobarometer62.0	*/

gen eb = 620
gen year = 2004
gen month = 10
rename v445 date_interview 

rename v5 id_original
rename v2 study_id
rename v6 country
rename v8 wnation
rename v10 wuk
rename v69 satislfe

rename v429 age
rename v425 marital_8cat
rename v426 education
rename v428 sex
rename v422 lrs

recode marital_8cat (1/2=2) (3=3) (4/5=1) (6=4) (7=5) (8=6) (9=.), gen(marital_status)
recode education (98=10) (97=1) (1/14=1) (15=2) (16=3) (17=4) (18=5) (19=6) (20=7) (21=8) (22/85=9), gen(educ_10cat)

keep eb year month date_interview id_original study_id country wnation wuk satislfe  ///
 age marital_8cat education sex  lrs marital_status educ_10cat 

save	"62.0.dta"	, replace
*************


*************
use "$eb/ZA4231_v1-1-0.dta", clear	/*	Open Data for Eurobarometer62.2	*/

gen eb = 622
gen year = 2004
gen month = 12
rename v493 date_interview 

rename v5 id_original
rename v2 study_id
rename v6 country
rename v8 wnation
rename v10 wuk
recode v219 (5/6=.)
rename v219 satislfe

rename v471 age
rename v467 marital_8cat
rename v468 education
rename v470 sex
rename v464 lrs

recode marital_8cat (1/2=2) (3=3) (4/5=1) (6=4) (7=5) (8=6) (9=.), gen(marital_status)
recode education (98=10) (97=1) (1/14=1) (15=2) (16=3) (17=4) (18=5) (19=6) (20=7) (21=8) (22/85=9), gen(educ_10cat)

keep eb year month date_interview id_original study_id country wnation wuk satislfe age marital_8cat education sex ///
 lrs marital_status educ_10cat 

save	"62.2.dta"	, replace
*************


*************
use "$eb/ZA4411_v1-1-0.dta"	, clear /*	Open Data for Eurobarometer63.4	*/

gen eb = 634
gen year = 2005
gen month = 6
* Mostly in May, but quite a lot in June too
rename v584 date_interview 

rename v5 id_original
rename v2 study_id
rename v6 country
rename v8 wnation
rename v10 wuk
rename v69 satislfe

rename v411 age
rename v407 marital_8cat
rename v408 education
rename v410 sex
rename v404 lrs

recode marital_8cat (1/2=2) (3=3) (4/5=1) (6=4) (7=5) (8=6) (9=.), gen(marital_status)
recode education (98=10) (1/14=1) (15=2) (16=3) (17=4) (18=5) (19=6) (20=7) (21=8) (22/85=9), gen(educ_10cat)

keep eb year month date_interview id_original study_id country wnation wuk satislfe  ///
 age marital_8cat education sex   lrs marital_status educ_10cat 

save	"63.4.dta"	, replace
*************


*************
use "$eb/ZA4414_v1-1-0.dta", clear	/*	Open Data for Eurobarometer64.2	*/

gen eb = 642
gen year = 2005
gen month = 11
* Mostly in October, but quite a lot in november too
rename v3309 date_interview 

rename v5 id_original
rename v2 study_id
rename v6 country
rename v8 wnation
rename v10 wuk
rename v75 satislfe

rename v440 age
rename v436 marital_8cat
rename v437 education
rename v439 sex
rename v433 lrs

recode marital_8cat (1/2=2) (3=3) (4/5=1) (6=4) (7=5) (8=6) (9=.), gen(marital_status)
recode education (98=10) (97=1) (1/14=1) (15=2) (16=3) (17=4) (18=5) (19=6) (20=7) (21=8) (22/85=9), gen(educ_10cat)

keep eb year month date_interview id_original study_id country wnation wuk satislfe  ///
 age marital_8cat education sex   lrs marital_status educ_10cat 

save	"64.2.dta"	, replace
*************


*************
use "$eb/ZA4506_v1-0-1.dta", clear	/*	Open Data for Eurobarometer65.2	*/

gen eb = 652
gen year = 2006
gen month = 4
rename v3342 date_interview 

rename v5 id_original
rename v2 study_id
rename v6 country
rename v8 wnation
rename v10 wuk
rename v73 satislfe

rename v3311 age
rename v3307 marital_8cat
rename v3308 education
rename v3310 sex
rename v3304 lrs

recode marital_8cat (1/2=2) (3=3) (4/5=1) (6=4) (7=5) (8=6) (9=.), gen(marital_status)
recode education (98=10) (97=1) (1/14=1) (15=2) (16=3) (17=4) (18=5) (19=6) (20=7) (21=8) (22/85=9), gen(educ_10cat)

keep eb year month date_interview id_original study_id country wnation wuk satislfe age marital_8cat education sex  ///
 lrs marital_status educ_10cat 


save	"65.2.dta"	, replace
*************


*************
use "$eb/ZA4526_v1-0-1.dta"	, clear /*	Open Data for Eurobarometer66.1	*/

gen eb = 661
gen year = 2006
gen month = 9
rename v491 date_interview 

rename v5 id_original
rename v2 study_id
rename v6 country
rename v8 wnation
rename v10 wuk
rename v75 satislfe

rename v463 age
rename v459 marital_8cat
rename v460 education
rename v462 sex
rename v456 lrs

recode marital_8cat (1/2=2) (3=3) (4/5=1) (6=4) (7=5) (8=6) (9=.), gen(marital_status)
recode education (98=10) (97=1) (1/14=1) (15=2) (16=3) (17=4) (18=5) (19=6) (20=7) (21=8) (22/85=9), gen(educ_10cat)

keep eb year month date_interview id_original study_id country wnation wuk satislfe  ///
 age marital_8cat education sex   lrs marital_status educ_10cat 


save	"66.1.dta"	, replace
*************


*************
use "$eb/ZA4530_v2-1-0.dta"	, clear /*	Open Data for Eurobarometer67.2	*/

gen eb = 672
gen year = 2007
gen month = 4
rename v579 date_interview 

rename v5 id_original
rename v2 study_id
rename v6 country
rename v8 wnation
rename v10 wuk
rename v83 satislfe

rename v549 age
rename v545 marital_8cat
rename v546 education
rename v548 sex
rename v542 lrs

recode marital_8cat (1/2=2) (3=3) (4/5=1) (6=4) (7=5) (8=6) (9=.), gen(marital_status)
recode education (98=10) (97=1) (1/14=1) (15=2) (16=3) (17=4) (18=5) (19=6) (20=7) (21=8) (22/85=9), gen(educ_10cat)

keep eb year month date_interview id_original study_id country wnation wuk satislfe  age marital_8cat education sex  ///
 lrs marital_status educ_10cat 


save	"67.2.dta"	, replace
*************


*************
use "$eb/ZA4565_v4-0-1.dta", clear	/*	Open Data for Eurobarometer68.1	*/

gen eb = 681
gen year = 2007
gen month = 10
rename v3968 date_interview 

rename v5 id_original
rename v2 study_id
rename v6 country
rename v8 wnation
rename v10 wuk
rename v87 satislfe

rename v421 age
rename v417 marital_8cat
rename v418 education
rename v420 sex
rename v414 lrs

recode marital_8cat (1/2=2) (3=3) (4/5=1) (6=4) (7=5) (8=6) (9=.), gen(marital_status)
recode education (98=10) (97=1) (1/14=1) (15=2) (16=3) (17=4) (18=5) (19=6) (20=7) (21=8) (22/85=9), gen(educ_10cat)

keep eb year month date_interview id_original study_id country wnation wuk satislfe  age marital_8cat education sex  ///
 lrs marital_status educ_10cat 


save	"68.1.dta"	, replace
*************


*************
use "$eb/ZA4744_v5-0-0.dta"	, clear /*	Open Data for Eurobarometer69.2	*/


gen eb = 692
gen year = 2008
gen month = 4
rename v798 date_interview

rename v5 id_original
rename v2 study_id
rename v6 country
rename v8 wnation
rename v10 wuk
rename v88 satislfe

rename v768 age
rename v764 marital_8cat
rename v765 education
rename v767 sex
rename v761 lrs

recode marital_8cat (1/2=2) (3=3) (4/5=1) (6=4) (7=5) (8=6) (9=.), gen(marital_status)
recode education (98=10) (97=1) (1/14=1) (15=2) (16=3) (17=4) (18=5) (19=6) (20=7) (21=8) (22/85=9), gen(educ_10cat)

keep eb year month date_interview id_original study_id country wnation wuk satislfe  age marital_8cat education sex  ///
 lrs marital_status educ_10cat 

save	"69.2.dta"	, replace
*************


*************
use "$eb/ZA4819_v3-0-2.dta"	, clear /*	Open Data for Eurobarometer70.1	*/

gen eb = 701
gen year = 2008
gen month = 10
rename v699 date_interview

rename v5 id_original
rename v2 study_id
rename v6 country
rename v8 wnation
rename v10 wuk
rename v88 satislfe

rename v671 age
rename v667 marital_8cat
rename v668 education
rename v670 sex
rename v664 lrs

recode marital_8cat (1/2=2) (3=3) (4/5=1) (6=4) (7=5) (8=6) (9=.), gen(marital_status)
recode education (98=10) (97=1) (1/14=1) (15=2) (16=3) (17=4) (18=5) (19=6) (20=7) (21=8) (22/85=9), gen(educ_10cat)

keep eb year month date_interview id_original study_id country wnation wuk satislfe   ///
 age marital_8cat education sex   lrs marital_status educ_10cat 

save	"70.1.dta"	, replace
*************


*************
use "$eb/ZA4971_v4-0-0.dta", clear	/*	Open Data for Eurobarometer71.1	*/

gen eb = 711
gen year = 2009
gen month = 2
* Mostly in Jan, but quite a lot in Feb too
rename v675 date_interview

rename v5 id_original
rename v2 study_id
rename v6 country
rename v8 wnation
rename v10 wuk
rename v90 satislfe


rename v645 age
rename v641 marital_8cat
rename v642 education
rename v644 sex
rename v638 lrs
* vote behaviour last eu election v307

recode marital_8cat (1/2=2) (3=3) (4/5=1) (6=4) (7=5) (8=6) (9=.), gen(marital_status)
recode education (98=10) (97=1) (1/14=1) (15=2) (16=3) (17=4) (18=5) (19=6) (20=7) (21=8) (22/85=9), gen(educ_10cat)

keep eb year month date_interview id_original study_id country wnation wuk satislfe  ///
 age marital_8cat education sex   lrs marital_status educ_10cat 

save	"71.1.dta"	, replace
*************


*************
use "$eb/ZA4972_v3-0-2.dta", clear	/*	Open Data for Eurobarometer71.2	*/

gen eb = 712
gen year = 2009
gen month = 6
rename v459 date_interview

rename v5 id_original
rename v2 study_id
rename v6 country
rename v8 wnation
rename v10 wuk
rename v84 satislfe

rename v428 age
rename v424 marital_14cat
rename v425 education
rename v427 sex
rename v421 lrs

recode marital_14cat (1/4=2) (5/8=3) (9/10=1) (11/12=4) (13/14=6) (15/16=.), gen(marital_status)
recode education (98=10) (97=1) (1/14=1) (15=2) (16=3) (17=4) (18=5) (19=6) (20=7) (21=8) (22/85=9), gen(educ_10cat)

keep eb year month date_interview id_original study_id country wnation wuk satislfe  ///
 age marital_14cat education sex   lrs marital_status educ_10cat 


save	"71.2.dta"	, replace
*************


*************
use "$eb/ZA4973_v3-0-0.dta"	, clear /*	Open Data for Eurobarometer71.3	*/

gen eb = 713
gen year = 2009
gen month = 7
rename v701 date_interview

rename v5 id_original
rename v2 study_id
rename v6 country
rename v8 wnation
rename v10 wuk
rename v104 satislfe

rename v666 age
rename v662 marital_14cat
rename v663 education
rename v665 sex
rename v659 lrs

recode marital_14cat (1/4=2) (5/8=3) (9/10=1) (11/12=4) (13/14=6) (15/16=.), gen(marital_status)
recode education (98=10) (97=1) (1/14=1) (15=2) (16=3) (17=4) (18=5) (19=6) (20=7) (21=8) (22/85=9), gen(educ_10cat)

keep eb year month date_interview id_original study_id country wnation wuk satislfe  ///
 age marital_14cat education sex  lrs marital_status educ_10cat 


save	"71.3.dta"	, replace
*************


*************
use "$eb/ZA4994_v3-0-0.dta"	, clear /*	Open Data for Eurobarometer72.4	*/

gen eb = 724
gen year = 2009
gen month = 10
rename v606 date_interview

rename v5 id_original
rename v2 study_id
rename v6 country
rename v8 wnation
rename v10 wuk
rename v84 satislfe

rename v585 age
rename v580 marital_14cat
rename v582 education
rename v584 sex
rename v577 lrs

recode marital_14cat (1/4=2) (5/8=3) (9/10=1) (11/12=4) (13/14=6) (15/16=.), gen(marital_status)
recode education (98=10) (97=1) (1/14=1) (15=2) (16=3) (17=4) (18=5) (19=6) (20=7) (21=8) (22/85=9), gen(educ_10cat)

keep eb year month date_interview id_original study_id country wnation wuk satislfe  ///
 age marital_14cat education sex  lrs marital_status educ_10cat 

save	"72.4.dta"	, replace
*************


*************
use "$eb/ZA5234_v2-0-1.dta", clear	/*	Open Data for Eurobarometer73.4	*/

gen eb = 734
gen year = 2010
gen month = 5
rename v581 date_interview

rename v5 id_original
rename v2 study_id
rename v6 country
rename v8 wnation
rename v10 wuk
rename v91 satislfe

rename v556 age
rename v551 marital_14cat
rename v553 education
rename v555 sex
rename v548 lrs

recode marital_14cat (1/4=2) (5/8=3) (9/10=1) (11/12=4) (13/14=6) (15/16=.), gen(marital_status)
recode education (98=10) (97=1) (1/14=1) (15=2) (16=3) (17=4) (18=5) (19=6) (20=7) (21=8) (22/85=9), gen(educ_10cat)

keep eb year month date_interview id_original study_id country wnation wuk satislfe  ///
 age marital_14cat education sex   lrs marital_status educ_10cat 

save	"73.4.dta"	, replace
*************


*************
use "$eb/ZA5235_v4-0-0.dta"	, clear /*	Open Data for Eurobarometer73.5	*/

gen eb = 735
gen year = 2010
gen month = 6
rename v417 date_interview

rename v5 id_original
rename v2 study_id
rename v6 country
rename v8 wnation
rename v10 wuk
rename v70 satislfe

rename v386 age
rename v381 marital_14cat
rename v383 education
rename v385 sex

recode marital_14cat (1/4=2) (5/8=3) (9/10=1) (11/12=4) (13/14=6) (15/16=.), gen(marital_status)
recode education (98=10) (97=1) (1/14=1) (15=2) (16=3) (17=4) (18=5) (19=6) (20=7) (21=8) (22/85=9), gen(educ_10cat)

keep eb year month date_interview id_original study_id country wnation wuk satislfe  ///
 age marital_14cat education sex  marital_status educ_10cat 

save	"73.5.dta"	, replace
*************


*************
use "$eb/ZA5449_v2-2-0.dta"	, clear /*	Open Data for Eurobarometer74.2	*/

gen eb = 742
gen year = 2010
gen month = 11
rename v626 date_interview

rename v5 id_original
rename v2 study_id
rename v6 country
rename v8 wnation
rename v10 wuk
rename v91 satislfe

rename v603 age
rename v597 marital_14cat
rename v600 education
rename v602 sex
rename v594 lrs

recode marital_14cat (1/4=2) (5/8=3) (9/10=1) (11/12=4) (13/14=6) (15/16=.), gen(marital_status)
recode education (98=10) (97=1) (1/14=1) (15=2) (16=3) (17=4) (18=5) (19=6) (20=7) (21=8) (22/85=9), gen(educ_10cat)

keep eb year month date_interview id_original study_id country wnation wuk satislfe  ///
 age marital_14cat education sex  lrs marital_status educ_10cat 

save	"74.2.dta"	, replace
*************

*************
use "$eb/ZA5481_v2-0-1.dta", clear	/*	Open Data for Eurobarometer75.3	*/

gen eb = 753
gen year = 2011
gen month = 5
rename v651 date_interview

rename v5 id_original
rename v2 study_id
rename v6 country
rename v8 wnation
rename v10 wuk
rename v109 satislfe

rename v616 age
rename v610 marital_14cat
rename v613 education
rename v615 sex
rename v607 lrs

recode marital_14cat (1/4=2) (5/8=3) (9/10=1) (11/12=4) (13/14=6) (15/16=.), gen(marital_status)
recode education (98=10) (97=1) (1/14=1) (15=2) (16=3) (17=4) (18=5) (19=6) (20=7) (21=8) (22/85=9), gen(educ_10cat)

keep eb year month date_interview id_original study_id country wnation wuk satislfe  ///
 age marital_14cat education sex  lrs marital_status educ_10cat 

save	"75.3.dta"	, replace
*************


*************
use "$eb/ZA5564_v3-0-1.dta", clear	/*	Open Data for Eurobarometer75.4	*/

gen eb = 754
gen year = 2011
gen month = 6
rename v631 date_interview

rename v5 id_original
rename v2 study_id
rename v6 country
rename v8 wnation
rename v10 wuk
rename v186 satislfe

rename v595 age
rename v588 marital_14cat
rename v592 education
rename v594 sex

recode marital_14cat (1/4=2) (5/8=3) (9/10=1) (11/12=4) (13/14=6) (15/16=.), gen(marital_status)
recode education (98=10) (97=1) (1/14=1) (15=2) (16=3) (17=4) (18=5) (19=6) (20=7) (21=8) (22/85=9), gen(educ_10cat)

keep eb year month date_interview id_original study_id country wnation wuk satislfe  ///
 age marital_14cat education sex  marital_status educ_10cat 

save	"75.4.dta"	, replace
*************


*************
use "$eb/ZA5567_v2-0-1.dta", clear	/*	Open Data for Eurobarometer76.3	*/

gen eb = 763
gen year = 2011
gen month = 11
rename p1 date_interview

rename caseid id_original
rename studyno2 study_id
rename country country
rename w1 wnation
rename w4 wuk
rename qa1 satislfe
recode satislfe (5=.)

rename d11 age
rename d7 marital_14cat
rename d8 education
rename d10 sex

recode marital_14cat (1/4=2) (5/8=3) (9/10=1) (11/12=4) (13/14=6) (15/16=.), gen(marital_status)
recode education (98=.) (99=.) (1/14=1) (15=2) (16=3) (17=4) (18=5) (19=6) (20=7) (21=8) (22/85=9), gen(educ_10cat)

keep eb year month date_interview id_original study_id country wnation wuk satislfe  ///
 age marital_14cat education sex  marital_status educ_10cat 

save	"76.3.dta"	, replace
*************


*************
use "$eb/ZA5612_v2-0-0.dta", clear	/*	Open Data for Eurobarometer77.3	*/

gen eb = 773
gen year = 2012
gen month = 5

rename caseid id_original
rename studyno2 study_id
rename country country
rename w1 wnation
rename w4 wuk
rename qa1 satislfe
recode satislfe (5=.)

rename d11 age
rename d7 marital_14cat
rename d8 education
rename d10 sex

recode marital_14cat (1/4=2) (5/8=3) (9/10=1) (11/12=4) (13/14=6) (15/16=.), gen(marital_status)
recode education (98=.) (99=.) (1/14=1) (15=2) (16=3) (17=4) (18=5) (19=6) (20=7) (21=8) (22/85=9), gen(educ_10cat)

keep eb year month  id_original study_id country wnation wuk satislfe  ///
 age marital_14cat education sex  marital_status educ_10cat 

save	"77.3.dta"	, replace
*************


*************
use "$eb/ZA5613_v3-0-0.dta", clear	/*	Open Data for Eurobarometer77.4	*/
gen eb = 774
gen year = 2012
gen month = 6

rename caseid id_original
rename studyno2 study_id
rename country country
rename w1 wnation
rename w4 wuk
rename qb1 satislfe
recode satislfe (5=.)

rename d11 age
rename d7 marital_14cat
rename d8 education
rename d10 sex
rename d1 lrs

recode marital_14cat (1/4=2) (5/8=3) (9/10=1) (11/12=4) (13/14=6) (15/16=.), gen(marital_status)
recode education (98=.) (99=.) (1/14=1) (15=2) (16=3) (17=4) (18=5) (19=6) (20=7) (21=8) (22/85=9), gen(educ_10cat)

keep eb year month  id_original study_id country wnation wuk satislfe age marital_14cat education sex  marital_status educ_10cat 
save	"77.4.dta"	, replace
*************


*************
use "$eb/ZA5685_v2-0-0.dta", clear	/*	Open Data for Eurobarometer78.1	*/
gen eb = 781
gen year = 2012
gen month = 11
rename p1 date_interview

rename caseid id_original
rename studyno2 study_id
rename w1 wnation
rename w4 wuk
rename qa1 satislfe
recode satislfe (5=.)

rename d11 age
rename d7 marital_14cat
rename d8 education
rename d10 sex

recode marital_14cat (1/4=2) (5/8=3) (9/10=1) (11/12=4) (13/14=6) (15/16=.), gen(marital_status)
recode education (98=.) (99=.) (1/14=1) (15=2) (16=3) (17=4) (18=5) (19=6) (20=7) (21=8) (22/85=9), gen(educ_10cat)

keep eb year month date_interview id_original study_id country wnation wuk satislfe   ///
 age marital_14cat education sex  marital_status educ_10cat 

save	"78.1.dta"	, replace
*************


use "$eb/ZA5689_v2-0-0.dta", clear	/*	Open Data for Eurobarometer 79.3	*/
gen eb = 793
gen year = 2013
gen month = 5
rename p1 date_interview

rename caseid id_original
rename studyno1 study_id
rename country country
rename w1 wnation
rename w4 wuk
rename qa1 satislfe
recode satislfe (5=.)

rename d11 age
rename d7 marital_14cat
rename d8 education
rename d10 sex

recode marital_14cat (1/4=2) (5/8=3) (9/10=1) (11/12=4) (13/14=6) (15/16=.), gen(marital_status)
recode education (98=.) (99=.) (1/14=1) (15=2) (16=3) (17=4) (18=5) (19=6) (20=7) (21=8) (22/85=9) (97=10), gen(educ_10cat)

keep eb year month date_interview id_original study_id country wnation wuk satislfe  ///
 age marital_14cat education sex  marital_status educ_10cat 

save	"79.3.dta"	, replace
*****************

use "$eb/ZA5876_v2-0-0.dta"	, clear /*	Open Data for Eurobarometer 80.1	*/
gen eb = 801
gen year = 2013
gen month = 11
rename p1 date_interview

rename caseid id_original
rename studyno1 study_id
rename country country
rename w1 wnation
rename w4 wuk
rename qa1 satislfe
recode satislfe (5=.)

rename d11 age
rename d7 marital_14cat
rename d8 education
rename d10 sex

recode marital_14cat (1/4=2) (5/8=3) (9/10=1) (11/12=4) (13/14=6) (15/16=.), gen(marital_status)
recode education (98=10) (99=.) (97=1) (1/14=1) (15=2) (16=3) (17=4) (18=5) (19=6) (20=7) (21=8) (22/85=9), gen(educ_10cat)

keep eb year month date_interview id_original study_id country wnation wuk satislfe  ///
  age marital_14cat education sex  marital_status educ_10cat 

save	"80.1.dta"	, replace
************


use "$eb/ZA5877_v2-0-0.dta", clear	/*	Open Data for Eurobarometer 80.2	*/
gen eb = 802
gen year = 2013
gen month = 12
rename p1 date_interview

rename caseid id_original
rename studyno1 study_id
rename country country
rename w1 wnation
rename w4 wuk
rename d70 satislfe
recode satislfe (5=.)

rename d11 age
rename d7 marital_14cat
rename d8 education
rename d10 sex

recode marital_14cat (1/4=2) (5/8=3) (9/10=1) (11/12=4) (13/14=6) (15/100=.), gen(marital_status)
recode education (99=.) (0=.) (97=1) (98=10) (1/14=1) (15=2) (16=3) (17=4) (18=5) (19=6) (20=7) (21=8) (22/85=9), gen(educ_10cat)

keep eb year month date_interview id_original study_id country wnation wuk satislfe  ///
  age marital_14cat education sex  marital_status educ_10cat 

save	"80.2.dta"	, replace
************


use "$eb/ZA5913_v2-0-0.dta", clear	/*	Open Data for Eurobarometer 	81.2 */
gen eb = 812
gen year = 2014
gen month = 3
rename p1 date_interview

rename caseid id_original
rename studyno1 study_id
rename country country
rename w1 wnation
rename w4 wuk
rename qa1 satislfe
recode satislfe (5=.)

rename d11 age
rename d7 marital_14cat
rename d8 education
rename d10 sex

recode marital_14cat (1/4=2) (5/8=3) (9/10=1) (11/12=4) (13/14=6) (15/100=.), gen(marital_status)
recode education (99=.) (0=.) (97=1) (98=10) (1/14=1) (15=2) (16=3) (17=4) (18=5) (19=6) (20=7) (21=8) (22/85=9), gen(educ_10cat)

keep eb year month date_interview id_original study_id country wnation wuk satislfe  ///
  age marital_14cat education sex  marital_status educ_10cat 

save	"81.2.dta"	, replace


use "$eb/ZA5928_v3-0-0.dta", clear	/*	Open Data for Eurobarometer 81.4	*/
gen eb = 814
gen year = 2014
gen month = 5

rename caseid id_original
rename studyno1 study_id
rename country country
rename w1 wnation
rename w4 wuk
rename qa1 satislfe
recode satislfe (5=.)

rename d11 age
rename d7 marital_14cat
rename d8 education
rename d10 sex

recode marital_14cat (1/4=2) (5/8=3) (9/10=1) (11/12=4) (13/14=6) (15/100=.), gen(marital_status)
recode education (99=.) (0=.) (97=1) (98=10) (1/14=1) (15=2) (16=3) (17=4) (18=5) (19=6) (20=7) (21=8) (22/85=9), gen(educ_10cat)

keep eb year month  id_original study_id country wnation wuk satislfe  ///
  age marital_14cat education sex  marital_status educ_10cat 

save	"81.4.dta"	, replace


use "$eb/ZA5929_v3-0-0.dta"	, clear /*	Open Data for Eurobarometer 81.5	*/
gen eb = 815
gen year = 2014
gen month = 6

rename caseid id_original
rename studyno1 study_id
rename country country
rename w1 wnation
rename w4 wuk
rename qa1 satislfe
recode satislfe (5=.)

rename d11 age
rename d7 marital_14cat
rename d8 education
rename d10 sex

recode marital_14cat (1/4=2) (5/8=3) (9/10=1) (11/12=4) (13/14=6) (15/100=.), gen(marital_status)
recode education (99=.) (0=.) (97=1) (98=10) (1/14=1) (15=2) (16=3) (17=4) (18=5) (19=6) (20=7) (21=8) (22/85=9), gen(educ_10cat)

keep eb year month  id_original study_id country wnation wuk satislfe  ///
  age marital_14cat education sex  marital_status educ_10cat 

save	"81.5.dta"	, replace


use "$eb/ZA5932_v3-0-0.dta", clear	/*	Open Data for Eurobarometer 82.3	*/
gen eb = 823
gen year = 2014
gen month = 11

rename caseid id_original
rename studyno1 study_id
rename country country
rename w1 wnation
rename w4 wuk
rename d70 satislfe
recode satislfe (5=.)

rename d11 age
rename d7 marital_14cat
rename d8 education
rename d10 sex

recode marital_14cat (1/4=2) (5/8=3) (9/10=1) (11/12=4) (13/14=6) (15/100=.), gen(marital_status)
recode education (99=.) (0=.) (97=1) (98=10) (1/14=1) (15=2) (16=3) (17=4) (18=5) (19=6) (20=7) (21=8) (22/85=9), gen(educ_10cat)

keep eb year month  id_original study_id country wnation wuk satislfe  ///
  age marital_14cat education sex  marital_status educ_10cat 

save	"82.3.dta"	, replace








********************************************************************************


*************
/* Recode the Mannheim Trend File so that it is consistent with the other files about to merged with it */

use "$eb/ZA3521_v2-0-1.dta", clear /* 	Open Trend File 	*/

recode married (9/10=.) (missing=.), gen(marital_status)
rename educ educ_10cat
recode better (1=1) (2=3) (3=2) (missing=.), gen(expec_life)
recode lrs (11/100=.) (missing=.)
rename nation1 country
rename id id_original


/* The trend file includes several waves that do not include a life satisfaction question.
	These waves are dropped from the analysis */

drop if satislfe == .

/* The Trend file does not have the fieldwork month. This is added for each wave (source: EB website) */

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
save "trend.dta", replace

*************

********************************************************************************

/* Combine all of the non-trend file waves to form a 2003-2012 trend dataset */

clear
use  "44.2.dta"
save "non_trend.dta", replace

append using	"58.1.dta"
append using	"60.1.dta"
append using	"62.0.dta"
append using	"62.2.dta"
append using	"63.4.dta"
append using	"64.2.dta"
append using	"65.2.dta"
append using	"66.1.dta"
append using	"67.2.dta"
append using	"68.1.dta"
append using	"69.2.dta"
append using	"70.1.dta"
append using	"71.1.dta"
append using	"71.2.dta"
append using	"71.3.dta"
append using	"72.4.dta"
append using	"73.4.dta"
append using	"73.5.dta"
append using	"74.2.dta"
append using	"75.3.dta"
append using	"75.4.dta"
append using	"76.3.dta"
append using	"77.3.dta"
append using	"77.4.dta"
append using	"78.1.dta"
append using	"79.3.dta"
append using	"80.1.dta"
append using	"80.2.dta"
append using	"81.2.dta"
append using	"81.4.dta"
append using	"81.5.dta"
append using	"82.3.dta"

save "non_trend.dta", replace

/* combine this non-trend file with the original trend file */

append using "trend.dta"

keep study_id id_original wuk country wnation satislfe  lrs marital_status education sex ///
 age  date_interview   eb year month educ_10cat educrec  marital_8cat   ///
    marital_14cat wsample  better finapast lastvote inclvote voteint  voteint voteint_96coding lastvote better closepty feelclo inclvote party polint
 
sort country eb id_original 

gen id = _n

gen day = 1 
gen survey_date = mdy(month, day, year) 
format survey_date %td
drop month day year
gen survey_month = mofd(survey_date)
format survey_month %tm
gen survey_quarter = qofd(survey_date)
format survey_quarter %tq
gen year = yofd(survey_date)

egen country_eb = group(country eb)








**********************
*** Clean up a bit ***
**********************






* The Life Satisfaction variable is coded counter-intuitively.
recode satislfe (4=1) (3=2) (2=3) (1=4) (else=.)
label define Satisfaction 1 "Not at all satisfied" 2 "Not very satisfied " 3 "Fairly satisfied" 4 "Very satisfied"
label values satislfe Satisfaction



label define nation1 1 "FRA" 2 "BEL" 3 "NLD" 4 "DEU-W" 5 "ITA" 6 "LUX" 7 ///
"DNK"8 "IRL" 9 "GBR" 10 "NI" 11 "GRC" 12 "ESP" 13 "PRT" 14 "DEU-E" ///
16 "FIN" 17 "SWE" 18 "AUT", replace
label values country nation1

gen male = (sex==1) if !missing(sex)
gen female = (sex==2) if !missing(sex)


recode educ_10cat (1/2=1) (3/6=2) (7/9=3) (10=4) (11/100=.) (missing=.), gen(educ_4cat)
replace educ_4cat = educrec if !missing(educrec)
label define educ4 1 "Low" 2 "Medium" 3 "High" 4 "Still Studying" 
label values educ_4cat educ4
gen educ_0to15 = (educ_4cat==1) if educ_4cat!=.
gen educ_16to19 = (educ_4cat==2) if educ_4cat!=.
gen educ_20plus = (educ_4cat==3) if educ_4cat!=.
gen educ_stillstudying = (educ_4cat==4) if educ_4cat!=.
                                   
recode marital_status (90/100=.) (missing=.)
gen mar4_single = (marital_status==1) if marital_status!=.
gen mar4_married = (marital_status==2 | marital_status==3)  if marital_status!=.
gen mar4_divsep = (marital_status==4 | marital_status==5) if marital_status!=.
gen mar4_widowed = (marital_status==6) if marital_status!=.

gen pol_far_left = (lrs==1 | lrs==2) if !missing(lrs)
gen pol_centre_left = (lrs==3 | lrs==4) if !missing(lrs)
gen pol_centre = (lrs==5 | lrs==6) if !missing(lrs)
gen pol_centre_right = (lrs==7 | lrs==8) if !missing(lrs)
gen pol_far_right = (lrs==9 | lrs==10) if !missing(lrs)

gen age_sq = age^2



keep study_id id_original wuk wnation satislfe lrs voteint_96coding marital_status  sex age  date_interview  eb  ///
         wsample  better  finapast polint closepty feelclo voteint inclvote lastvote party ///
	  id survey_date survey_month survey_quarter year female male    ///
	 educ* mar* pol_far_left pol_centre_left pol_centre pol_centre_right pol_far_right age_sq ///
	  country_eb   country   

	  
	  
 *********
 
global dem 		female age age_sq mar4_married mar4_divsep mar4_widowed educ_16to19 educ_20plus educ_stillstudying  
lab var female "Female"
lab var age "Age"
lab var age_sq "Age$^2$"
lab var mar4_married "Married/Live as Married (vs. single)"
lab var mar4_divsep "Divorced/Separated (vs. single)"
lab var mar4_widowed "Widow/Widower (vs. single)"
lab var educ_16to19 "Education to age 16-19"
lab var educ_20plus "Education to age 20+"
lab var educ_stillstudying  "Education: Still studying"

*********


 
erase   "44.2.dta"
erase	"58.1.dta"
erase	"60.1.dta"
erase	"62.0.dta"
erase	"62.2.dta"
erase	"63.4.dta"
erase	"64.2.dta"
erase	"65.2.dta"
erase	"66.1.dta"
erase	"67.2.dta"
erase	"68.1.dta"
erase	"69.2.dta"
erase	"70.1.dta"
erase	"71.1.dta"
erase	"71.2.dta"
erase	"71.3.dta"
erase	"72.4.dta"
erase	"73.4.dta"
erase	"73.5.dta"
erase	"74.2.dta"
erase	"75.3.dta"
erase	"75.4.dta"
erase	"76.3.dta"
erase	"77.3.dta"
erase	"77.4.dta"
erase	"78.1.dta"
erase	"79.3.dta"
erase	"80.1.dta"
erase	"80.2.dta"
erase	"81.2.dta"
erase	"81.4.dta"
erase	"81.5.dta"
erase	"82.3.dta"

erase 	"non_trend.dta"
erase 	"trend.dta"


decode country, gen(countrystring)
drop if countrystring ==""
rename country co
rename countrystring country
drop if country=="NI" | country=="DEU-E"
replace country = "DEU" if country=="DEU-W"
drop co
sort country eb
encode country, gen(co)
egen country_year = group(co year)
gen merge_month = mofd(survey_date) 
gen month = mofd(survey_date) 












*********

merge m:m country month using "$vote/cabinet_composition_eurobarometerID.dta"
drop _merge

replace lrs = . if missing(lrs)
gen l = 0 if lrs!=.
replace l = 1 if lrs==1 | lrs==2 | lrs==3
gen r = 0 if lrs!=.
replace r = 1 if lrs==8 | lrs==9 | lrs==10
lab var left_right_cabinet "Right-wingness of Government (0-10)"
gen l_x_leftrightcab = l*left_right_cabinet
gen r_x_leftrightcab = r*left_right_cabinet
lab var l_x_leftrightcab "Left-Wing Indiv' * Right-Wingness of Gov'"
lab var r_x_leftrightcab "Right-Wing Indiv' * Right-Wingness of Gov'"
lab var l "Left-winger (vs. centrist)"
lab var r "Right-winger (vs. centrist)"

su left_right_cabinet, meanonly 
gen left_right_cabinet_01 = (left_right_cabinet - r(min)) / (r(max) - r(min)) 
su lrs, meanonly 
gen lrs_01 = (lrs - r(min)) / (r(max) - r(min)) 
gen ideol_proximity = lrs_01 - left_right_cabinet_01
replace  ideol_proximity = abs(ideol_proximity)
lab var lrs "Left-Right Placement (1-10)"
lab var ideol_proximity	"Ideological Distance from Gov'"


************ Table S7 ************

global dem 		female age age_sq mar4_married mar4_divsep mar4_widowed educ_16to19 educ_20plus educ_stillstudying
global ideol_controls 		lrs ideol_proximity
global ideol_controls1 		l  r left_right_cabinet l_x_leftrightcab  r_x_leftrightcab

eststo clear
xi: reg satislfe  i.eb, cluster(country_eb)
predict satis_resid_nocontrols if e(sample), resid

eststo: xi: reg satislfe $dem  i.eb, cluster(country_eb)
predict satis_resid_dem if e(sample), resid

eststo: xi: reg satislfe $dem $ideol_controls  i.eb, cluster(country_eb)
predict satis_resid_dempluspol if e(sample), resid

eststo: xi: reg satislfe $dem 	$ideol_controls1  i.eb, cluster(country_eb)

********************************



 ** Alternative national SWB measures
gen sat1_pc = (satislfe==1) if satislfe!=.
gen sat2_pc = (satislfe==2) if satislfe!=.
gen sat3_pc = (satislfe==3) if satislfe!=.
gen sat4_pc = (satislfe==4) if satislfe!=.

bysort co eb: egen satislfe_sd = sd(satislfe)

*** Collapse into pseudo-panels by survey 

collapse satislfe  satis_resid* sat1_pc-sat4_pc satislfe_sd survey_date  year study_id , by(co eb)
gen satislfe_sd_overmean = satislfe_sd/satislfe

decode co, gen(country)
drop if satislfe==.
rename satislfe satislfe_survey_mean
bysort co: gen survey_number = _n
xtset co survey_number 
sort co survey_number
gen merge_month = mofd(survey_date)
gen survey_lag_months_inbetw = D.merge_month
drop survey_number

saveold "$eb/eb_aggregates_by_survey.dta", replace


*** Collapse into pseudo-panels by year 

collapse satislfe_survey_mean, by(co year)
decode co, gen(country)

xtset co year 
rename satislfe_survey_mean satislfe_electionyear_mean
gen satislfe_electionyear_mean_L1 = L1.satislfe_electionyear_mean
gen satislfe_electionyear_mean_L2 = L2.satislfe_electionyear_mean
gen satislfe_electionyear_mean_L3 = L3.satislfe_electionyear_mean
gen satislfe_electionyear_mean_L4 = L4.satislfe_electionyear_mean

gen satislfe_electionyear_mean_D1 = D1.satislfe_electionyear_mean
gen satislfe_electionyear_mean_D2 = D2.satislfe_electionyear_mean
gen satislfe_electionyear_mean_D3 = D3.satislfe_electionyear_mean
gen satislfe_electionyear_mean_D4 = D4.satislfe_electionyear_mean


gen satislfe_growthrate = 100*(D1.satislfe_electionyear_mean/L1.satislfe_electionyear_mean)

saveold "$eb/eb_aggregates_by_year.dta", replace


