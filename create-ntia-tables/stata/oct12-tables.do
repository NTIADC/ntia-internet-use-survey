*	oct12-tables.do
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
global personUniverses "isAdult"
global householdUniverses "internetAtHome internetAnywhere noInternetAtHome"

global isPersonVars "homeInternetUser internetUser"
global isAdultVars "homeInternetUser internetUser"

global isHouseholderVars "computerAtHome internetAnywhere internetAtHome noInternetAtHome wiredHighSpeedAtHome satelliteAtHome dialUpAtHome homeEverOnline noNeedInterestMainReason tooExpensiveMainReason canUseElsewhereMainReason unavailableMainReason noComputerMainReason privSecMainReason"
global internetAtHomeVars "internetAnywhere internetAtHome mobileAtHome wiredHighSpeedAtHome satelliteAtHome dialUpAtHome"
global internetAnywhereVars "internetAnywhere internetAtHome wiredHighSpeedAtHome satelliteAtHome dialUpAtHome"
global noInternetAtHomeVars "homeEverOnline noNeedInterestMainReason tooExpensiveMainReason canUseElsewhereMainReason unavailableMainReason noComputerMainReason privSecMainReason"

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
recode hefaminc (-1 = .) (1/7 = 0 "< $25,000") (8/11 = 1 "$25,000-49,999") (12/13 = 2 "$50,000-74,999") (14 = 3 "$75,000-99,999") (15/16 = 4 "$100,000 +"), gen(income)
recode peeduca (-1 = .) (31/38 = 0 "No Diploma") (39 = 1 "High School Diploma") (40/42 = 2 "Some College or AA") (nonmissing = 3 "College Degree or More"), gen(education)
recode pesex (-1 = .) (1 = 0 "Male") (2 = 1 "Female"), gen(sex)
recode ptdtrace (-1 = .) (1 = 0 "White, non-Hispanic") (2 = 1 "Black, non-Hispanic") (99 = 2 "Hispanic") (4 = 3 "Asian, non-Hispanic") (3 = 4 "Am Indian/AK Nat, non-Hispanic") (nonmissing = 5 "Other"), gen(race)
replace race = 2 if pehspnon == 1 // Hispanic ID comes from separate variable
recode prdisflg (-1 = .) (2 = 0 "Not Disabled") (1 = 1 "Disabled"), gen(disability)
recode gtmetsta (2 = 0 "Non-Metropolitan Area") (1 = 1 "Metropolitan Area") (3 = 2 "Unknown"), gen(metro)
bysort qstnum: egen schoolChildrenAtHome = max(prtage <= 17 & prtage >= 6 & perrp >= 4) if hrintsta == 1
label define schoolChildrenAtHome 0 "No" 1 "Yes"
label values schoolChildrenAtHome schoolChildrenAtHome
recode peafever (-1 = .) (2 = 0 "Not a Veteran") (1 = 1 "Veteran"), gen(veteran)

* Step 4: Construct variables being written to analyze table. Make sure anything outside the specified universe is set to missing.

* - Person Variables
recode penet8 (-1 2 = 0 "No") (1 = 1 "Yes") if isPerson, gen(homeInternetUser)
generate internetUser = (penet8 == 1 | penet10 == 1) if isPerson

* - Household Variables
generate internetAnywhere = (henet3 == 1 | henet9 == 1) if isHouseholder
recode henet3 (-1 2 = 0 "No") (1 = 1 "Yes") if isHouseholder, gen(internetAtHome)
generate noInternetAtHome = (internetAtHome == 0) if isHouseholder
generate mobileAtHome = (henet45 == 1) if isHouseholder
generate wiredHighSpeedAtHome = (henet42 == 1 | henet43 == 1 | henet44 == 1) if isHouseholder
generate satelliteAtHome = (henet46 == 1) if isHouseholder
generate dialUpAtHome = (henet41 == 1) if isHouseholder
generate homeEverOnline = (henet3a == 1) if isHouseholder
generate noNeedInterestMainReason = (henet6 == 1 | henet7 == 1) if isHouseholder
generate tooExpensiveMainReason = (henet6 == 2 | henet7 == 2) if isHouseholder
generate canUseElsewhereMainReason = (henet6 == 3 | henet7 == 3) if isHouseholder
generate unavailableMainReason = (henet6 == 4 | henet7 == 4) if isHouseholder
generate noComputerMainReason = (henet6 == 5 | henet7 == 5) if isHouseholder
generate privSecMainReason = (henet6 == 6 | henet7 == 6) if isHouseholder
recode henet2 (-1 0 = 0 "No") (nonmissing = 1 "Yes") if isHouseholder, gen(computerAtHome)

* - Respondent Variables
// none
