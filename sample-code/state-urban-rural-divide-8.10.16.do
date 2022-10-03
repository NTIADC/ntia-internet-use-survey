* Code for blog post: The State of the Urban/Rural Digital Divide
* August 10, 2016
*
* Questions? Email the Data Central team at data@ntia.doc.gov.
* Note: This script assumes all used datasets are located in the current working directory.
*       To download datasets, see http://www.ntia.doc.gov/page/download-digital-nation-datasets.

* December 1998 (Persons)
use dec98-cps, clear
* Rural/Urban
recode gemetsta (2 = 0 "Non-Metropolitan Area") (1 = 1 "Metropolitan Area") (3 = 2 "Unknown"), gen(metro)
* Datasets prior to 2011 do not have replicate weights, so we construct
* synthetic strata and use the household ID as the cluster variable to
* calculate standard errors via Taylor series linearization.
* Source: Davern et al. (2006), http://dx.doi.org/10.5034/inquiryjrnl_43.3.283
generate personStrataID = .
replace personStrataID = (gestfips * 10000) + gtmsa if gtmsa > 0
replace personStrataID = (gestfips * 1000) + gtco if gtco > 0 & gtmsa == 0
replace personStrataID = gestfips if gtco == 0 & gtmsa == 0
generate personClusterID = qstnum
keep if prtage >= 3 & prpertyp != 3 // universe: age 3+ civilians
svyset personClusterID [iw=pwsswgt], strata(personStrataID)
* Internet use by rural/urban
generate internetUser = (prs11 == 1 | pes14 == 1)
svy: tab internetUser metro, col se format(%8.6f)

* August 2000 (Persons)
use aug00-cps, clear
* Rural/Urban
recode gemetsta (2 = 0 "Non-Metropolitan Area") (1 = 1 "Metropolitan Area") (3 = 2 "Unknown"), gen(metro)
* Set up standard error calculations
generate personStrataID = .
replace personStrataID = (gestfips * 10000) + gtmsa if gtmsa > 0
replace personStrataID = (gestfips * 1000) + gtco if gtco > 0 & gtmsa == 0
replace personStrataID = gestfips if gtco == 0 & gtmsa == 0
generate personClusterID = qstnum
keep if prtage >= 3 & prpertyp != 3 // universe: age 3+ civilians
svyset personClusterID [iw=pwsswgt], strata(personStrataID)
* Internet use by rural/urban
generate internetUser = (prs11 == 1 | pes14 == 1)
svy: tab internetUser metro, col se format(%8.6f)

* September 2001 (Persons)
use sep01-cps, clear
* Rural/Urban
recode gemetsta (2 = 0 "Non-Metropolitan Area") (1 = 1 "Metropolitan Area") (3 = 2 "Unknown"), gen(metro)
* Set up standard error calculations
generate personStrataID = .
replace personStrataID = (gestfips * 10000) + gtmsa if gtmsa > 0
replace personStrataID = (gestfips * 1000) + gtco if gtco > 0 & gtmsa == 0
replace personStrataID = gestfips if gtco == 0 & gtmsa == 0
generate personClusterID = qstnum
keep if prtage >= 3 & prpertyp != 3 // universe: age 3+ civilians
svyset personClusterID [iw=pwsswgt], strata(personStrataID)
* Internet use by rural/urban
generate internetUser = (prnet1 == 1)
svy: tab internetUser metro, col se format(%8.6f)

* October 2003 (Persons)
use oct03-cps, clear
* Rural/Urban
recode gemetsta (2 = 0 "Non-Metropolitan Area") (1 = 1 "Metropolitan Area") (3 = 2 "Unknown"), gen(metro)
* Set up standard error calculations
generate personStrataID = .
replace personStrataID = (gestfips * 10000) + gemsa if gemsa > 0
replace personStrataID = (gestfips * 1000) + geco if geco > 0 & gemsa == 0
replace personStrataID = gestfips if geco == 0 & gemsa == 0
generate personClusterID = qstnum
keep if prtage >= 3 & prpertyp != 3 // universe: age 3+ civilians
svyset personClusterID [iw=pwsswgt], strata(personStrataID)
* Internet use by rural/urban
generate internetUser = (prnet1 == 1)
svy: tab internetUser metro, col se format(%8.6f)

* October 2007 (Persons)
use oct07-cps, clear
* Rural/Urban
recode gtmetsta (2 = 0 "Non-Metropolitan Area") (1 = 1 "Metropolitan Area") (3 = 2 "Unknown"), gen(metro)
* Set up standard error calculations
generate personStrataID = .
replace personStrataID = (gestfips * 10000) + gtcbsa if gtcbsa > 0
replace personStrataID = (gestfips * 1000) + gtco if gtco > 0 & gtcbsa == 0
replace personStrataID = gestfips if gtco == 0 & gtcbsa == 0
generate personClusterID = qstnum
keep if peage >= 3 & prpertyp != 3 // universe: age 3+ civilians
svyset personClusterID [iw=pwsswgt], strata(personStrataID)
* Internet use by rural/urban
generate internetUser = (penet2 == 1)
svy: tab internetUser metro, col se format(%8.6f)

* October 2009 (Persons)
use oct09-cps, clear
* Rural/Urban
recode gtmetsta (2 = 0 "Non-Metropolitan Area") (1 = 1 "Metropolitan Area") (3 = 2 "Unknown"), gen(metro)
* Set up standard error calculations
generate personStrataID = .
replace personStrataID = (gestfips * 10000) + gtcbsa if gtcbsa > 0
replace personStrataID = (gestfips * 1000) + gtco if gtco > 0 & gtcbsa == 0
replace personStrataID = gestfips if gtco == 0 & gtcbsa == 0
generate personClusterID = qstnum
keep if peage >= 3 & prpertyp != 3 // universe: age 3+ civilians
svyset personClusterID [iw=pwsswgt], strata(personStrataID)
* Internet use by rural/urban
generate internetUser = (penet2 == 1)
svy: tab internetUser metro, col se format(%8.6f)

* October 2010 (Persons)
use oct10-cps, clear
* Rural/Urban
recode gtmetsta (2 = 0 "Non-Metropolitan Area") (1 = 1 "Metropolitan Area") (3 = 2 "Unknown"), gen(metro)
* Set up standard error calculations
generate personStrataID = .
replace personStrataID = (gestfips * 10000) + gtcbsa if gtcbsa > 0
replace personStrataID = (gestfips * 1000) + gtco if gtco > 0 & gtcbsa == 0
replace personStrataID = gestfips if gtco == 0 & gtcbsa == 0
generate personClusterID = qstnum
keep if peage >= 3 & prpertyp != 3 // universe: age 3+ civilians
svyset personClusterID [iw=pwsswgt], strata(personStrataID)
* Internet use by rural/urban
generate internetUser = (pen2who == 1 | penet6 == 1)
svy: tab internetUser metro, col se format(%8.6f)

* July 2011 (Persons)
use jul11-cps, clear
* Rural/Urban
recode gtmetsta (2 = 0 "Non-Metropolitan Area") (1 = 1 "Metropolitan Area") (3 = 2 "Unknown"), gen(metro)
* Set up person-level survey analysis
keep if peage >= 3 & prpertyp != 3 // universe: age 3+ civilians
svyset [iw=pwsswgt], sdrweight(pewgt1-pewgt160) vce(sdr) mse // replicate weights available starting in 2011
* Internet use by rural/urban
generate internetUser = (peperscr == 1)
svy: tab internetUser metro, col se format(%8.6f)

* October 2012 (Persons)
use oct12-cps, clear
* Rural/Urban
recode gtmetsta (2 = 0 "Non-Metropolitan Area") (1 = 1 "Metropolitan Area") (3 = 2 "Unknown"), gen(metro)
* Set up analysis
keep if prtage >= 3 & prpertyp != 3 // universe: age 3+ civilians
svyset [iw=pwsswgt], sdrweight(pewgt1-pewgt160) vce(sdr) mse
* Internet use by rural/urban
generate internetUser = (penet8 == 1 | penet10 == 1)
svy: tab internetUser metro, col se format(%8.6f)

* July 2013 (Persons)
use jul13-cps, clear
* Rural/Urban
recode gtmetsta (2 = 0 "Non-Metropolitan Area") (1 = 1 "Metropolitan Area") (3 = 2 "Unknown"), gen(metro)
* Set up analysis
keep if prtage >= 3 & prpertyp != 3 & hrmis != 1 & hrmis != 5 // households in month-in-sample 1 and 5 didn't get this Supplement
svyset [iw=pwsupwgt], sdrweight(pewgt1-pewgt160) vce(sdr) mse // PWSUPWGT is special weight for this Supplement, given the smaller sample
* Internet use by rural/urban
generate internetUser = (peperscr == 1)
svy: tab internetUser metro, col se format(%8.6f)

* July 2015 (Persons)
use jul15-cps, clear
* Demographics
recode gtmetsta (2 = 0 "Non-Metropolitan Area") (1 = 1 "Metropolitan Area") (3 = 2 "Unknown"), gen(metro)
recode ptdtrace (-1 = .) (1 = 0 "White, non-Hispanic") (2 = 1 "Black, non-Hispanic") (99 = 2 "Hispanic") (4 = 3 "Asian, non-Hispanic") (3 = 4 "Am Indian/AK Nat, non-Hispanic") (nonmissing = 5 "Other"), gen(race)
replace race = 2 if pehspnon == 1 // Hispanic ID comes from separate variable
recode hefaminc (-1 = .) (1/7 = 0 "< $25,000") (8/11 = 1 "$25,000-49,999") (12/13 = 2 "$50,000-74,999") (14 = 3 "$75,000-99,999") (15/16 = 4 "$100,000 +"), gen(income)
recode peeduca (-1 = .) (31/38 = 0 "No Diploma") (39 = 1 "High School Diploma") (40/42 = 2 "Some College or AA") (nonmissing = 3 "College Degree or More"), gen(education)
recode pemlr (-1 = .) (1/2 = 0 "Employed") (3/4 = 1 "Unemployed") (5/7 = 2 "Not in Labor Force"), gen(workStatus)
recode pesex (-1 = .) (1 = 0 "Male") (2 = 1 "Female"), gen(sex)
recode prdisflg (-1 = .) (2 = 0 "Not Disabled") (1 = 1 "Disabled"), gen(disability)
* Set up analysis
preserve // so we can more quickly switch to household analysis later
keep if prtage >= 3 & prpertyp != 3 // universe: age 3+ civilians
svyset [iw=pwsswgt], sdrweight(pewgt1-pewgt160) vce(sdr) mse
* Internet use by rural/urban
generate internetUser = (peinhome == 1 | peinwork == 1 | peinschl == 1 | peincafe == 1 | peintrav == 1 | peinlico == 1 | peinelho == 1 | peinothr == 1)
svy: tab internetUser metro, col se format(%8.6f)
* ...Among specific racial/ethnic groups
svy, subpop(if race == 0): tab internetUser metro, col se format(%8.6f) // White non-Hispanics
svy, subpop(if race == 1): tab internetUser metro, col se format(%8.6f) // African Americans
svy, subpop(if race == 2): tab internetUser metro, col se format(%8.6f) // Hispanics
svy, subpop(if race == 3): tab internetUser metro, col se format(%8.6f) // Asians
svy, subpop(if race == 4): tab internetUser metro, col se format(%8.6f) // American Indians/Alaska Natives
svy, subpop(if race == 5): tab internetUser metro, col se format(%8.6f) // Other
* ...Among specific family income groups
svy, subpop(if income == 4): tab internetUser metro, col se format(%8.6f) // $100K+
svy, subpop(if income == 3): tab internetUser metro, col se format(%8.6f) // $75K-99,999
svy, subpop(if income == 2): tab internetUser metro, col se format(%8.6f) // $50K-74,999
svy, subpop(if income == 1): tab internetUser metro, col se format(%8.6f) // $25K-49,999
svy, subpop(if income == 0): tab internetUser metro, col se format(%8.6f) // <$25K
* ...Among specific educational attainment groups
svy, subpop(if education == 0): tab internetUser metro, col se format(%8.6f) // No Diploma
svy, subpop(if education == 1): tab internetUser metro, col se format(%8.6f) // High School Diploma Only
svy, subpop(if education == 2): tab internetUser metro, col se format(%8.6f) // Some College
svy, subpop(if education == 3): tab internetUser metro, col se format(%8.6f) // College Degree
* Device use by rural/urban
generate desktopUser = (pedesktp == 1)
generate laptopUser = (pelaptop == 1)
generate tabletUser = (petablet == 1)
generate mobilePhoneUser = (pemphone == 1 & (peinhome == 1 | peinwork == 1 | peinschl == 1 | peincafe == 1 | peintrav == 1 | peinlico == 1 | peinelho == 1 | peinothr == 1) & (hehomte1 == 1 | heoutmob == 1))
generate wearableUser = (pewearab == 1)
generate tvBoxUser = (petvbox == 1)
generate numDeviceTypes = desktopUser + laptopUser + tabletUser + mobilePhoneUser + wearableUser + tvBoxUser
svy: tab desktopUser metro, col se format(%8.6f)
svy: tab laptopUser metro, col se format(%8.6f)
svy: tab tabletUser metro, col se format(%8.6f)
svy: tab mobilePhoneUser metro, col se format(%8.6f)
svy: tab numDeviceTypes metro, col se format(%8.6f)
* Internet use locations by rural/urban
generate homeInternetUser = (peinhome == 1)
generate workInternetUser = (peinwork == 1)
svy: tab homeInternetUser metro, col se format(%8.6f)
svy: tab workInternetUser metro, col se format(%8.6f)

* July 2015 (Random Respondents)
restore
preserve
keep if puelgflg == 20
svyset [iw=pwprmwgt], sdrweight(rewgt1-rewgt160) vce(sdr) mse
* Email use by rural/urban
generate emailUser = (peemail == 1)
svy: tab emailUser metro, col se format(%8.6f)
* Social media use by rural/urban
generate socialNetworkUser = (pesocial == 1)
svy: tab socialNetworkUser metro, col se format(%8.6f)
* Online video/voice conferencing by rural/urban
generate callConfUser = (peconfer == 1)
svy: tab callConfUser metro, col se format(%8.6f)
