*	oct03-tables.do
*	Version 2.0 (March 29, 2022)
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
global personUniverses "isAdult adultInternetUser"
global householdUniverses "internetAtHome internetAnywhere noInternetAtHome"

global isPersonVars "internetUser homeInternetUser"
global isAdultVars "internetUser homeInternetUser"
global adultInternetUserVars "jobSearchUser onlineClassUser financeUser eCommerceUser"

global isHouseholderVars "computerAtHome internetAnywhere internetAtHome noInternetAtHome wiredHighSpeedAtHome satelliteAtHome dialUpAtHome homeEverOnline noNeedInterestMainReason tooExpensiveMainReason canUseElsewhereMainReason noComputerMainReason privSecMainReason"
global internetAtHomeVars "internetAnywhere internetAtHome wiredHighSpeedAtHome satelliteAtHome dialUpAtHome"
global internetAnywhereVars "internetAnywhere internetAtHome wiredHighSpeedAtHome satelliteAtHome dialUpAtHome"
global noInternetAtHomeVars "homeEverOnline noNeedInterestMainReason tooExpensiveMainReason canUseElsewhereMainReason noComputerMainReason privSecMainReason"

* Step 1.5: Construct synthetic survey design variables to increase the accuracy of standard errors.
* This is only necessary when replicate weights are unavailable.
generate personStrataID = .
replace personStrataID = (gestfips * 10000) + gemsa if gemsa > 0
replace personStrataID = (gestfips * 1000) + geco if geco > 0 & gemsa == 0
replace personStrataID = gestfips if geco == 0 & gemsa == 0
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
recode ptdtrace (-1 = .) (1 = 0 "White, non-Hispanic") (2 = 1 "Black, non-Hispanic") (99 = 2 "Hispanic") (4 = 3 "Asian, non-Hispanic") (3 = 4 "Am Indian/AK Nat, non-Hispanic") (nonmissing = 5 "Other"), gen(race)
replace race = 2 if pehspnon == 1 // Hispanic ID comes from separate variable
recode gemetsta (2 = 0 "Non-Metropolitan Area") (1 = 1 "Metropolitan Area") (3 = 2 "Unknown"), gen(metro)
bysort qstnum: egen schoolChildrenAtHome = max(prtage <= 17 & prtage >= 6 & perrp >= 4) if hrintsta == 1
label define schoolChildrenAtHome 0 "No" 1 "Yes"
label values schoolChildrenAtHome schoolChildrenAtHome
recode puafever (1 = 1 "Veteran") (nonmissing = 0 "Not a Veteran") if prpertyp != 3 & prtage >= 17, gen(veteran)

* Step 3.5: Remove household with no Supplement data.
drop if qstnum == 5327

* Step 4: Construct variables being written to analyze table. Make sure anything outside the specified universe is set to missing.

* - Person Variables
generate homeInternetUser = (prnet2 == 1) if isPerson
generate internetUser = (prnet1 == 1) if isPerson
generate adultInternetUser = internetUser if isAdult // no longer posting this metric since it's equivilent to internetUser in the isAdult universe, but need it to run online activities metrics
generate jobSearchUser = (pesnetp == 1) if adultInternetUser == 1
generate onlineClassUser = (pesnete == 1) if adultInternetUser == 1
generate financeUser = (pesnetm == 1 | pesnetn == 1) if adultInternetUser == 1
generate eCommerceUser = (pesnetg == 1) if adultInternetUser == 1

* - Household Variables
bysort qstnum: egen internetAnywhere = max(internetUser == 1)
replace internetAnywhere = . if isHouseholder != 1
generate internetAtHome = (hesint1 == 1) if isHouseholder
generate noInternetAtHome = (internetAtHome == 0) if isHouseholder
generate wiredHighSpeedAtHome = (hesint2a == 3 | hesint2a == 4) if isHouseholder
generate satelliteAtHome = (hesint2a == 5) if isHouseholder
generate dialUpAtHome = (hesint2a == 1) if isHouseholder
generate homeEverOnline = (hesevr == 1) if isHouseholder
generate noNeedInterestMainReason = (hesint5a == 3) if isHouseholder
generate tooExpensiveMainReason = (hesint5a == 1) if isHouseholder
generate canUseElsewhereMainReason = (hesint5a == 6) if isHouseholder
generate noComputerMainReason = (hesint5a == 9) if isHouseholder
generate privSecMainReason = (hesint5a == 4) if isHouseholder
generate computerAtHome = (hesc1 == 1) if isHouseholder

* - Respondent Variables
// none
