* Code for blog post: Language and Citizenship as Factors Contributing to Low Internet Use Among Hispanics
* November 17, 2015
*
* Questions? Email the Data Central team at data@ntia.doc.gov.
* Note: This script assumes all used datasets are located in the current working directory.
*       To download datasets, see http://www.ntia.doc.gov/page/download-digital-nation-datasets.

* October 2010 (Persons)
use oct10-cps
* Need to create school-age children at home variable before deleting obs out of universe so we have them all
bysort qstnum: egen schoolChildrenAtHome = max(peage <= 17 & peage >= 6 & perrp >= 4) if hrintsta == 1
keep if peage >= 15 & prpertyp != 3 // universe: ages 15+ and not active duty military
* Set up needed variables
generate internetUser = (pen2who == 1 | penet6 == 1)
recode huspnish (1 = 1) (nonmissing = 0), gen(spanishOnly)
recode hefaminc (-1 = .) (1/7 = 0 "< $25,000") (8/11 = 1 "$25,000-49,999") (12/13 = 2 "$50,000-74,999") (14 = 3 "$75,000-99,999") (15/16 = 4 "$100,000 +"), gen(income)
recode peeduca (-1 = .) (31/38 = 0 "No Diploma") (39 = 1 "High School Diploma") (40/42 = 2 "Some College or AA") (nonmissing = 3 "College Degree or More"), gen(education)
generate ageSquared = peage * peage
recode ptdtrace (-1 = .) (1 = 0 "White, non-Hispanic") (2 = 1 "Black, non-Hispanic") (99 = 2 "Hispanic") (4 = 3 "Asian, non-Hispanic") (3 = 4 "Am Indian/AK Nat, non-Hispanic") (nonmissing = 5 "Other"), gen(race)
replace race = 2 if pehspnon == 1 // Hispanic ID comes from separate variable
recode pesex (2 = 1) (nonmissing = 0), gen(female)
recode prdisflg (-1 = .) (2 = 0 "Not Disabled") (1 = 1 "Disabled"), gen(disability)
recode pemlr (-1 = .) (1/2 = 0 "Employed") (3/4 = 1 "Unemployed") (5/7 = 2 "Not in Labor Force"), gen(workStatus)
recode gtmetsta (2 = 0 "Non-Metropolitan Area") (1 = 1 "Metropolitan Area") (3 = 2 "Unknown"), gen(metro)
* As replicate weights are unavailable for older datasets, we use the variance estimation method outlined in Davern et al (2006)
generate personStrataID = .
replace personStrataID = (gestfips * 10000) + gtcbsa if gtcbsa > 0
replace personStrataID = (gestfips * 1000) + gtco if gtco > 0 & gtcbsa == 0
replace personStrataID = gestfips if gtco == 0 & gtcbsa == 0
generate personClusterID = qstnum
svyset personClusterID [iw=pwsswgt], strata(personStrataID)
* Regression of Internet use on demographic characteristics
svy: regress internetUser spanishOnly i.prcitshp i.income i.education peage ageSquared i.race female disability i.workStatus schoolChildrenAtHome i.metro i.gereg

* July 2011 (Persons)
use jul11-cps, clear
keep if peage >= 3 & prpertyp != 3
svyset [iw=pwsswgt], sdrweight(pewgt1-pewgt160) vce(sdr) mse
* Internet use by race/ethnicity
recode ptdtrace (-1 = .) (1 = 0 "White, non-Hispanic") (2 = 1 "Black, non-Hispanic") (99 = 2 "Hispanic") (4 = 3 "Asian, non-Hispanic") (3 = 4 "Am Indian/AK Nat, non-Hispanic") (nonmissing = 5 "Other"), gen(race)
replace race = 2 if pehspnon == 1 // Hispanic ID comes from separate variable
generate internetUser = (peperscr == 1)
svy: tab internetUser race, col percent ci

* July 2013 (Persons)
use jul13-cps, clear
keep if prtage >= 3 & prpertyp != 3 & hrmis != 1 & hrmis != 5
svyset [iw=pwsupwgt], sdrweight(pewgt1-pewgt160) vce(sdr) mse
* Internet use by race/ethnicity
recode ptdtrace (-1 = .) (1 = 0 "White, non-Hispanic") (2 = 1 "Black, non-Hispanic") (99 = 2 "Hispanic") (4 = 3 "Asian, non-Hispanic") (3 = 4 "Am Indian/AK Nat, non-Hispanic") (nonmissing = 5 "Other"), gen(race)
replace race = 2 if pehspnon == 1 // Hispanic ID comes from separate variable
generate internetUser = (peperscr == 1)
svy: tab internetUser race, col percent ci
* Internet use by citizenship status
label define citizenship 1 "Native, Born in US" 2 "Native, Born in PR or Other Island Areas" 3 "Native, Born Abroad" 4 "Foreign Born, Naturalized" 5 "Foreign Born, Non-Citizen"
label values prcitshp citizenship
svy: tab internetUser prcitshp, col percent ci
* Internet use by whether individual lives in a household where persons 15+ only speak Spanish
recode huspnish (1 = 1) (nonmissing = 0), gen(spanishOnly)
svy: tab internetUser spanishOnly, col percent ci
* Regressions of Internet use on demographic characteristics
bysort qstnum: egen schoolChildrenAtHome = max(prtage <= 17 & prtage >= 6 & perrp >= 4) if hrintsta == 1
keep if prtage >= 15
recode hefaminc (-1 = .) (1/7 = 0 "< $25,000") (8/11 = 1 "$25,000-49,999") (12/13 = 2 "$50,000-74,999") (14 = 3 "$75,000-99,999") (15/16 = 4 "$100,000 +"), gen(income)
recode peeduca (-1 = .) (31/38 = 0 "No Diploma") (39 = 1 "High School Diploma") (40/42 = 2 "Some College or AA") (nonmissing = 3 "College Degree or More"), gen(education)
generate ageSquared = prtage * prtage
recode pesex (2 = 1) (nonmissing = 0), gen(female)
recode prdisflg (-1 = .) (2 = 0 "Not Disabled") (1 = 1 "Disabled"), gen(disability)
recode pemlr (-1 = .) (1/2 = 0 "Employed") (3/4 = 1 "Unemployed") (5/7 = 2 "Not in Labor Force"), gen(workStatus)
recode gtmetsta (2 = 0 "Non-Metropolitan Area") (1 = 1 "Metropolitan Area") (3 = 2 "Unknown"), gen(metro)
svy: regress internetUser i.income i.education prtage ageSquared i.race female disability i.workStatus schoolChildrenAtHome i.metro i.gereg
svy: regress internetUser i.prcitshp i.income i.education prtage ageSquared i.race female disability i.workStatus schoolChildrenAtHome i.metro i.gereg
svy: regress internetUser spanishOnly i.prcitshp i.income i.education prtage ageSquared i.race female disability i.workStatus schoolChildrenAtHome i.metro i.gereg
