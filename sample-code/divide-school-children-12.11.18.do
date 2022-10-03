* Code for blog post: Digital Divide Among School-Age Children Narrows, but Millions Still Lack Internet Connections
* December 11, 2018
*
* Questions? Email the Data Central team at data@ntia.doc.gov.
* Note: This script assumes all used datasets are located in the current working directory.
*       To download datasets, see https://www.ntia.doc.gov/page/download-digital-nation-datasets.

* December 1998 (Persons)
use dec98-cps, clear
* Datasets prior to 2011 do not have replicate weights, so we construct
* synthetic strata and use the household ID as the cluster variable to
* calculate standard errors via Taylor series linearization.
* Source: Davern et al. (2006), http://dx.doi.org/10.5034/inquiryjrnl_43.3.283
generate personStrataID = .
replace personStrataID = (gestfips * 10000) + gtmsa if gtmsa > 0
replace personStrataID = (gestfips * 1000) + gtco if gtco > 0 & gtmsa == 0
replace personStrataID = gestfips if gtco == 0 & gtmsa == 0
generate personClusterID = qstnum
keep if prtage >= 6 & prtage <= 17 & prpertyp != 3 // universe: age 6-17 civilians
svyset personClusterID [iw=pwsswgt], strata(personStrataID)
* Demographic variables
recode perace (-1 = .) (1 = 0 "White, non-Hispanic") (2 = 1 "Black, non-Hispanic") (99 = 2 "Hispanic") (4 = 3 "Asian, non-Hispanic") (3 = 4 "Am Indian/AK Nat, non-Hispanic") (nonmissing = 5 "Other"), gen(race)
replace race = 2 if prhspnon == 1 // Hispanic ID comes from separate variable
recode gemetsta (2 = 0 "Non-Metropolitan Area") (1 = 1 "Metropolitan Area") (3 = 2 "Unknown"), gen(metro)
* Living in a household with home Internet service
generate inConnectedHH = (hesiu2 == 3 | hesiu2 == 4 | hesiu3 == 1)
svy: tab inConnectedHH race, col se format(%8.6f)
svy: tab inConnectedHH metro, col se format(%8.6f)

* August 2000 (Persons)
use aug00-cps, clear
generate personStrataID = .
replace personStrataID = (gestfips * 10000) + gtmsa if gtmsa > 0
replace personStrataID = (gestfips * 1000) + gtco if gtco > 0 & gtmsa == 0
replace personStrataID = gestfips if gtco == 0 & gtmsa == 0
generate personClusterID = qstnum
keep if prtage >= 6 & prtage <= 17 & prpertyp != 3 // universe: age 6-17 civilians
svyset personClusterID [iw=pwsswgt], strata(personStrataID)
* Demographic variables
recode perace (-1 = .) (1 = 0 "White, non-Hispanic") (2 = 1 "Black, non-Hispanic") (99 = 2 "Hispanic") (4 = 3 "Asian, non-Hispanic") (3 = 4 "Am Indian/AK Nat, non-Hispanic") (nonmissing = 5 "Other"), gen(race)
replace race = 2 if prhspnon == 1 // Hispanic ID comes from separate variable
recode gemetsta (2 = 0 "Non-Metropolitan Area") (1 = 1 "Metropolitan Area") (3 = 2 "Unknown"), gen(metro)
* Living in a household with home Internet service
generate inConnectedHH = (hesiu2 == 3 | hesiu2 == 4 | hesiu3 == 1)
svy: tab inConnectedHH race, col se format(%8.6f)
svy: tab inConnectedHH metro, col se format(%8.6f)

* September 2001 (Persons)
use sep01-cps, clear
generate personStrataID = .
replace personStrataID = (gestfips * 10000) + gtmsa if gtmsa > 0
replace personStrataID = (gestfips * 1000) + gtco if gtco > 0 & gtmsa == 0
replace personStrataID = gestfips if gtco == 0 & gtmsa == 0
generate personClusterID = qstnum
keep if prtage >= 6 & prtage <= 17 & prpertyp != 3 // universe: age 6-17 civilians
svyset personClusterID [iw=pwsswgt], strata(personStrataID)
* Demographic variables
recode perace (-1 = .) (1 = 0 "White, non-Hispanic") (2 = 1 "Black, non-Hispanic") (99 = 2 "Hispanic") (4 = 3 "Asian, non-Hispanic") (3 = 4 "Am Indian/AK Nat, non-Hispanic") (nonmissing = 5 "Other"), gen(race)
replace race = 2 if prhspnon == 1 // Hispanic ID comes from separate variable
recode gemetsta (2 = 0 "Non-Metropolitan Area") (1 = 1 "Metropolitan Area") (3 = 2 "Unknown"), gen(metro)
* Living in a household with home Internet service
generate inConnectedHH = (hesint1 == 1)
svy: tab inConnectedHH race, col se format(%8.6f)
svy: tab inConnectedHH metro, col se format(%8.6f)

* October 2003 (Persons)
use oct03-cps, clear
* Set up standard error calculations
generate personStrataID = .
replace personStrataID = (gestfips * 10000) + gemsa if gemsa > 0
replace personStrataID = (gestfips * 1000) + geco if geco > 0 & gemsa == 0
replace personStrataID = gestfips if geco == 0 & gemsa == 0
generate personClusterID = qstnum
keep if prtage >= 6 & prtage <= 17 & prpertyp != 3 // universe: age 6-17 civilians
svyset personClusterID [iw=pwsswgt], strata(personStrataID)
* Demographic variables
recode ptdtrace (-1 = .) (1 = 0 "White, non-Hispanic") (2 = 1 "Black, non-Hispanic") (99 = 2 "Hispanic") (4 = 3 "Asian, non-Hispanic") (3 = 4 "Am Indian/AK Nat, non-Hispanic") (nonmissing = 5 "Other"), gen(race)
replace race = 2 if pehspnon == 1 // Hispanic ID comes from separate variable
recode gemetsta (2 = 0 "Non-Metropolitan Area") (1 = 1 "Metropolitan Area") (3 = 2 "Unknown"), gen(metro)
* Living in a household with home Internet service
generate inConnectedHH = (hesint1 == 1)
svy: tab inConnectedHH race, col se format(%8.6f)
svy: tab inConnectedHH metro, col se format(%8.6f)

* October 2007 (Persons)
use oct07-cps, clear
generate personStrataID = .
replace personStrataID = (gestfips * 10000) + gtcbsa if gtcbsa > 0
replace personStrataID = (gestfips * 1000) + gtco if gtco > 0 & gtcbsa == 0
replace personStrataID = gestfips if gtco == 0 & gtcbsa == 0
generate personClusterID = qstnum
keep if peage >= 6 & peage <= 17 & prpertyp != 3 // universe: age 6-17 civilians
svyset personClusterID [iw=pwsswgt], strata(personStrataID)
* Demographic variables
recode ptdtrace (-1 = .) (1 = 0 "White, non-Hispanic") (2 = 1 "Black, non-Hispanic") (99 = 2 "Hispanic") (4 = 3 "Asian, non-Hispanic") (3 = 4 "Am Indian/AK Nat, non-Hispanic") (nonmissing = 5 "Other"), gen(race)
replace race = 2 if pehspnon == 1 // Hispanic ID comes from separate variable
recode gtmetsta (2 = 0 "Non-Metropolitan Area") (1 = 1 "Metropolitan Area") (3 = 2 "Unknown"), gen(metro)
* Living in a household with home Internet service
generate inConnectedHH = (henet3 == 1)
svy: tab inConnectedHH race, col se format(%8.6f)
svy: tab inConnectedHH metro, col se format(%8.6f)

* October 2009 (Persons)
use oct09-cps, clear
generate personStrataID = .
replace personStrataID = (gestfips * 10000) + gtcbsa if gtcbsa > 0
replace personStrataID = (gestfips * 1000) + gtco if gtco > 0 & gtcbsa == 0
replace personStrataID = gestfips if gtco == 0 & gtcbsa == 0
generate personClusterID = qstnum
keep if peage >= 6 & peage <= 17 & prpertyp != 3 // universe: age 6-17 civilians
svyset personClusterID [iw=pwsswgt], strata(personStrataID)
* Demographic variables
recode ptdtrace (-1 = .) (1 = 0 "White, non-Hispanic") (2 = 1 "Black, non-Hispanic") (99 = 2 "Hispanic") (4 = 3 "Asian, non-Hispanic") (3 = 4 "Am Indian/AK Nat, non-Hispanic") (nonmissing = 5 "Other"), gen(race)
replace race = 2 if pehspnon == 1 // Hispanic ID comes from separate variable
recode gtmetsta (2 = 0 "Non-Metropolitan Area") (1 = 1 "Metropolitan Area") (3 = 2 "Unknown"), gen(metro)
* Living in a household with home Internet service
generate inConnectedHH = (henet3 == 1)
svy: tab inConnectedHH race, col se format(%8.6f)
svy: tab inConnectedHH metro, col se format(%8.6f)

* October 2010 (Persons)
use oct10-cps, clear
generate personStrataID = .
replace personStrataID = (gestfips * 10000) + gtcbsa if gtcbsa > 0
replace personStrataID = (gestfips * 1000) + gtco if gtco > 0 & gtcbsa == 0
replace personStrataID = gestfips if gtco == 0 & gtcbsa == 0
generate personClusterID = qstnum
keep if peage >= 6 & peage <= 17 & prpertyp != 3 // universe: age 6-17 civilians
svyset personClusterID [iw=pwsswgt], strata(personStrataID)
* Demographic variables
recode ptdtrace (-1 = .) (1 = 0 "White, non-Hispanic") (2 = 1 "Black, non-Hispanic") (99 = 2 "Hispanic") (4 = 3 "Asian, non-Hispanic") (3 = 4 "Am Indian/AK Nat, non-Hispanic") (nonmissing = 5 "Other"), gen(race)
replace race = 2 if pehspnon == 1 // Hispanic ID comes from separate variable
recode gtmetsta (2 = 0 "Non-Metropolitan Area") (1 = 1 "Metropolitan Area") (3 = 2 "Unknown"), gen(metro)
* Living in a household with home Internet service
generate inConnectedHH = (henet2a == 1)
svy: tab inConnectedHH race, col se format(%8.6f)
svy: tab inConnectedHH metro, col se format(%8.6f)

* July 2011 (Persons)
use jul11-cps, clear
keep if peage >= 6 & peage <= 17 & prpertyp != 3 // universe: age 6-17 civilians
svyset [iw=pwsswgt], sdrweight(pewgt1-pewgt160) vce(sdr) mse // replicate weights available starting in 2011
* Demographic variables
recode ptdtrace (-1 = .) (1 = 0 "White, non-Hispanic") (2 = 1 "Black, non-Hispanic") (99 = 2 "Hispanic") (4 = 3 "Asian, non-Hispanic") (3 = 4 "Am Indian/AK Nat, non-Hispanic") (nonmissing = 5 "Other"), gen(race)
replace race = 2 if pehspnon == 1 // Hispanic ID comes from separate variable
recode gtmetsta (2 = 0 "Non-Metropolitan Area") (1 = 1 "Metropolitan Area") (3 = 2 "Unknown"), gen(metro)
* Living in a household with home Internet service
generate inConnectedHH = (hesci5 == 1)
svy: tab inConnectedHH race, col se format(%8.6f)
svy: tab inConnectedHH metro, col se format(%8.6f)

* October 2012 (Persons)
use oct12-cps, clear
keep if prtage >= 6 & prtage <= 17 & prpertyp != 3 // universe: age 6-17 civilians
svyset [iw=pwsswgt], sdrweight(pewgt1-pewgt160) vce(sdr) mse
* Demographic variables
recode ptdtrace (-1 = .) (1 = 0 "White, non-Hispanic") (2 = 1 "Black, non-Hispanic") (99 = 2 "Hispanic") (4 = 3 "Asian, non-Hispanic") (3 = 4 "Am Indian/AK Nat, non-Hispanic") (nonmissing = 5 "Other"), gen(race)
replace race = 2 if pehspnon == 1 // Hispanic ID comes from separate variable
recode gtmetsta (2 = 0 "Non-Metropolitan Area") (1 = 1 "Metropolitan Area") (3 = 2 "Unknown"), gen(metro)
* Living in a household with home Internet service
generate inConnectedHH = (henet3 == 1)
svy: tab inConnectedHH race, col se format(%8.6f)
svy: tab inConnectedHH metro, col se format(%8.6f)

* July 2013 (Persons)
use jul13-cps, clear
keep if prtage >= 6 & prtage <= 17 & prpertyp != 3 & hrmis != 1 & hrmis != 5 // households in month-in-sample 1 and 5 didn't get this Supplement
svyset [iw=pwsupwgt], sdrweight(pewgt1-pewgt160) vce(sdr) mse // PWSUPWGT is special weight for this Supplement, given the smaller sample
* Demographic variables
recode ptdtrace (-1 = .) (1 = 0 "White, non-Hispanic") (2 = 1 "Black, non-Hispanic") (99 = 2 "Hispanic") (4 = 3 "Asian, non-Hispanic") (3 = 4 "Am Indian/AK Nat, non-Hispanic") (nonmissing = 5 "Other"), gen(race)
replace race = 2 if pehspnon == 1 // Hispanic ID comes from separate variable
recode gtmetsta (2 = 0 "Non-Metropolitan Area") (1 = 1 "Metropolitan Area") (3 = 2 "Unknown"), gen(metro)
* Living in a household with home Internet service
generate inConnectedHH = (henet3 == 1)
svy: tab inConnectedHH race, col se format(%8.6f)
svy: tab inConnectedHH metro, col se format(%8.6f)

* July 2015 (Persons)
use jul15-cps, clear
keep if prtage >= 6 & prtage <= 17 & prpertyp != 3 // universe: age 6-17 civilians
svyset [iw=pwsswgt], sdrweight(pewgt1-pewgt160) vce(sdr) mse
* Demographic variables
recode ptdtrace (-1 = .) (1 = 0 "White, non-Hispanic") (2 = 1 "Black, non-Hispanic") (99 = 2 "Hispanic") (4 = 3 "Asian, non-Hispanic") (3 = 4 "Am Indian/AK Nat, non-Hispanic") (nonmissing = 5 "Other"), gen(race)
replace race = 2 if pehspnon == 1 // Hispanic ID comes from separate variable
recode gtmetsta (2 = 0 "Non-Metropolitan Area") (1 = 1 "Metropolitan Area") (3 = 2 "Unknown"), gen(metro)
* Living in a household with home Internet service
generate inConnectedHH = (heinhome == 1)
svy: tab inConnectedHH race, col se format(%8.6f)
svy: tab inConnectedHH metro, col se format(%8.6f)

* November 2017 (Persons)
use nov17-cps, clear
keep if prtage >= 6 & prtage <= 17 & prpertyp != 3 // universe: age 6-17 civilians
svyset [iw=pwsswgt], sdrweight(pewgt1-pewgt160) vce(sdr) mse
* Demographic variables
recode ptdtrace (-1 = .) (1 = 0 "White, non-Hispanic") (2 = 1 "Black, non-Hispanic") (99 = 2 "Hispanic") (4 = 3 "Asian, non-Hispanic") (3 = 4 "Am Indian/AK Nat, non-Hispanic") (nonmissing = 5 "Other"), gen(race)
replace race = 2 if pehspnon == 1 // Hispanic ID comes from separate variable
recode gtmetsta (2 = 0 "Non-Metropolitan Area") (1 = 1 "Metropolitan Area") (3 = 2 "Unknown"), gen(metro)
recode hefaminc (-1 = .) (1/7 = 0 "< $25,000") (8/11 = 1 "$25,000-49,999") (12/13 = 2 "$50,000-74,999") (14 = 3 "$75,000-99,999") (15/16 = 4 "$100,000 +"), gen(income)
* Living in a household with home Internet service
generate inConnectedHH = (heinhome == 1)
svy: tab inConnectedHH race, col se format(%8.6f)
svy: tab inConnectedHH metro, col se format(%8.6f)
svy: tab inConnectedHH income, col se format(%8.6f)
svy: tab inConnectedHH income, row se format(%8.6f)
* Using the Internet at school
generate schoolInternetUser = (peinschl == 1)
svy: tab schoolInternetUser inConnectedHH, col se format(%8.6f)
* Using the Internet at a library or community center
generate libCommInternetUser = (peinlico == 1)
svy: tab libCommInternetUser inConnectedHH, col se format(%8.6f)
* Using the Internet at all
generate internetUser = (peinhome == 1 | peinwork == 1 | peinschl == 1 | peincafe == 1 | peintrav == 1 | peinlico == 1 | peinelho == 1 | peinothr == 1)
svy: tab internetUser inConnectedHH, col se format(%8.6f)
svy: tab internetUser inConnectedHH, count se format(%9.0f)
