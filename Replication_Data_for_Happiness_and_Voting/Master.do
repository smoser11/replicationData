
* replace line 3 using your working directory...
  global path = "/Users/sm38679/Documents/GitHub/replicationData/Replication_Data_for_Happiness_and_Voting"
  
global raw = "$path/Raw Data"
global do = "$path"
global clean = "$path/Clean Data" 

global bhps = "$raw/BHPS"
global soep = "$raw/SOEP"
global eb = "$raw/EB"
global vote = "$raw/Voting"

global res = "$path/Results"

cd "$path"

* User-written commands, in case you don't have them already

ssc install carryforward, replace 
ssc install tsspell, replace 
net install dm7,from(http://www.stata.com/stb/stb7/)
ssc install estout
ssc install cibar

do "$do/nearmrgstable.ado"

* Cleaning 

do "$do/Cleaner_votingdata.do"
do "$do/Cleaner_swb.do"
do "$do/DatasetBuilder_EB_Macro.do"
do "$do/DatasetBuilder_EB_Micro.do"
do "$do/DatasetBuilder_BHPS.do"
do "$do/DatasetBuilder_SOEP.do"

* Analysis 

log using "$res/results.smcl", replace
do "$do/Analysis_EB_Macro.do"
do "$do/Analysis_EB_Micro.do"
do "$do/Analysis_Panels.do"
log close 

