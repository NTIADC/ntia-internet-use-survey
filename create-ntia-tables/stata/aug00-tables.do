*	aug00-tables.do
*	Version 2.0 (March 30, 2022)
*	National Telecommunications and Information Administration
*
*	Contains supporting code for create-ntia-tables.do specific to the named
*	dataset. This Do File recodes variables so that create-ntia-tables.do can be
*	used to extract summary statistics from the dataset in a uniform fashion.
*	
*	Contact the Data Central team at <data@ntia.gov>.

* Step 1: List Person, Household, and Respondent Variables being extracted from this dataset,
* and the appropriate universes of measurement. Exclude isPerson, isAdult, isHouseholder, and
* isRespondent from these lists.
global personUniverses "isAdult"
global householdUniverses "internetAtHome internetAnywhere noInternetAtHome"

global isPersonVars "internetUser homeInternetUser workInternetUser schoolInternetUser libCommInternetUser"
global isAdultVars "internetUser homeInternetUser workInternetUser schoolInternetUser libCommInternetUser"

global isHouseholderVars "computerAtHome internetAnywhere internetAtHome noInternetAtHome wiredHighSpeedAtHome dialUpAtHome homeEverOnline"
global internetAtHomeVars "internetAnywhere internetAtHome wiredHighSpeedAtHome dialUpAtHome"
global internetAnywhereVars "internetAnywhere internetAtHome wiredHighSpeedAtHome dialUpAtHome"
global noInternetAtHomeVars "homeEverOnline"

* Step 1.5: Construct synthetic survey design variables to increase the accuracy of standard errors.
* This is only necessary when replicate weights are unavailable.
generate personStrataID = .
replace personStrataID = (gestfips * 10000) + gtmsa if gtmsa > 0
replace personStrataID = (gestfips * 1000) + gtco if gtco > 0 & gtmsa == 0
replace personStrataID = gestfips if gtco == 0 & gtmsa == 0
generate personClusterID = qstnum

* Step 2: Construct universes for this dataset and standardize weight names (personWeight, householdWeight, respondentWeight). Code is usually the same except in older datasets.
* isPerson and isHouseholder are always required, and isRespondent and isAdult (which are likely the same) are required if pulling from random respondents.
generate isPerson = (prtage >= 3 & prpertyp != 3)
generate isHouseholder = (perrp > 0 & perrp < 3 & hrhtype > 0 & hrhtype < 9)
generate isAdult = (isPerson & prtage >= 15)
rename pwsswgt personWeight
rename hwhhwgt householdWeight

* Step 3: Construct demographic variables. The code can likely be reused except in older datasets.
recode prtage (-1/2 = .) (3/14 = 0 "3-14") (15/24 = 1 "15-24") (25/44 = 2 "25-44") (45/64 = 3 "45-64") (nonmissing = 4 "65+"), gen(ageGroup)
recode pemlr (-1 = .) (1/2 = 0 "Employed") (3/4 = 1 "Unemployed") (5/7 = 2 "Not in Labor Force"), gen(workStatus)
recode peeduca (-1 = .) (31/38 = 0 "No Diploma") (39 = 1 "High School Diploma") (40/42 = 2 "Some College or AA") (nonmissing = 3 "College Degree or More"), gen(education)
recode pesex (-1 = .) (1 = 0 "Male") (2 = 1 "Female"), gen(sex)
recode perace (-1 = .) (1 = 0 "White, non-Hispanic") (2 = 1 "Black, non-Hispanic") (99 = 2 "Hispanic") (4 = 3 "Asian, non-Hispanic") (3 = 4 "Am Indian/AK Nat, non-Hispanic") (nonmissing = 5 "Other"), gen(race)
replace race = 2 if prhspnon == 1 // Hispanic ID comes from separate variable
recode gemetsta (2 = 0 "Non-Metropolitan Area") (1 = 1 "Metropolitan Area") (3 = 2 "Unknown"), gen(metro)
bysort qstnum: egen schoolChildrenAtHome = max(prtage <= 17 & prtage >= 6 & perrp >= 4) if hrintsta == 1
label define schoolChildrenAtHome 0 "No" 1 "Yes"
label values schoolChildrenAtHome schoolChildrenAtHome
recode puafever (1 = 1 "Veteran") (nonmissing = 0 "Not a Veteran") if prpertyp != 3 & prtage >= 17, gen(veteran)

* Step 4: Construct variables being written to analyze table. Make sure anything outside the specified universe is set to missing.

* - Person Variables
generate homeInternetUser = (prs11 == 1) if isPerson
generate workInternetUser = (pesiu15a == 1) if isPerson
generate schoolInternetUser = (pesiu15b == 1 | pesiu15c == 1) if isPerson
generate libCommInternetUser = (pesiu15d == 1 | pesiu15e == 1) if isPerson
generate internetUser = (prs11 == 1 | pes14 == 1) if isPerson

* - Household Variables
bysort qstnum: egen internetAnywhere = max(internetUser == 1)
replace internetAnywhere = . if isHouseholder != 1
generate internetAtHome = (hesiu2 == 3 | hesiu2 == 4 | hesiu3 == 1) if isHouseholder
generate noInternetAtHome = (internetAtHome == 0) if isHouseholder
generate wiredHighSpeedAtHome = (hescu9 == 1 | hescu9 == 2 | hescu9 == 4) if isHouseholder
generate dialUpAtHome = (hescu8 == 1) if isHouseholder
generate homeEverOnline = (hesiu1 == 1 | hesiu4 == 1) if isHouseholder
generate computerAtHome = (hescu1a == 1) if isHouseholder

* - Respondent Variables
// none
