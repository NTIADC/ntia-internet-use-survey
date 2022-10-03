*	jul11-tables.do
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
global householdUniverses "internetAtHome internetAnywhere noInternetAtHome ispBundle"

global isPersonVars "desktopUser laptopUser tabletUser mobilePhoneUser tvBoxUser pcOrTabletUser homeInternetUser workInternetUser schoolInternetUser internetUser"
global isAdultVars "desktopUser laptopUser tabletUser mobilePhoneUser tvBoxUser pcOrTabletUser homeInternetUser workInternetUser schoolInternetUser internetUser"

global isHouseholderVars "computerAtHome internetAnywhere internetAtHome noInternetAtHome wiredHighSpeedAtHome satelliteAtHome dialUpAtHome homeEverOnline noNeedInterestMainReason tooExpensiveMainReason canUseElsewhereMainReason unavailableMainReason noComputerMainReason privSecMainReason"
global internetAtHomeVars "internetAnywhere internetAtHome speedMostImportant reliabilityMostImportant affordabilityMostImportant serviceMostImportant mobilityMostImportant mobileAtHome wiredHighSpeedAtHome satelliteAtHome dialUpAtHome ispBundle"
global internetAnywhereVars "internetAnywhere internetAtHome wiredHighSpeedAtHome satelliteAtHome dialUpAtHome"
global noInternetAtHomeVars "homeEverOnline noNeedInterestMainReason tooExpensiveMainReason canUseElsewhereMainReason unavailableMainReason noComputerMainReason privSecMainReason"
global ispBundleVars "tvInBundle homePhoneInBundle"

* Step 2: Construct universes for this dataset and standardize weight names (personWeight, householdWeight, respondentWeight). Code is usually the same except in older datasets.
* isPerson and isHouseholder are always required, and isRespondent and isAdult (which are likely the same) are required if pulling from random respondents.
generate isPerson = (peage >= 3 & prpertyp != 3)
generate isHouseholder = (perrp > 0 & perrp < 3 & hrhtype > 0 & hrhtype < 9)
generate isAdult = (isPerson & peage >= 15)
rename pwsswgt personWeight
rename hwhhwgt householdWeight

* Step 3: Construct demographic variables. The code can likely be reused except in older datasets.
recode peage (-1/2 = .) (3/14 = 0 "3-14") (15/24 = 1 "15-24") (25/44 = 2 "25-44") (45/64 = 3 "45-64") (nonmissing = 4 "65+"), gen(ageGroup)
recode pemlr (-1 = .) (1/2 = 0 "Employed") (3/4 = 1 "Unemployed") (5/7 = 2 "Not in Labor Force"), gen(workStatus)
recode hefaminc (-1 = .) (1/7 = 0 "< $25,000") (8/11 = 1 "$25,000-49,999") (12/13 = 2 "$50,000-74,999") (14 = 3 "$75,000-99,999") (15/16 = 4 "$100,000 +"), gen(income)
recode peeduca (-1 = .) (31/38 = 0 "No Diploma") (39 = 1 "High School Diploma") (40/42 = 2 "Some College or AA") (nonmissing = 3 "College Degree or More"), gen(education)
recode pesex (-1 = .) (1 = 0 "Male") (2 = 1 "Female"), gen(sex)
recode ptdtrace (-1 = .) (1 = 0 "White, non-Hispanic") (2 = 1 "Black, non-Hispanic") (99 = 2 "Hispanic") (4 = 3 "Asian, non-Hispanic") (3 = 4 "Am Indian/AK Nat, non-Hispanic") (nonmissing = 5 "Other"), gen(race)
replace race = 2 if pehspnon == 1 // Hispanic ID comes from separate variable
recode prdisflg (-1 = .) (2 = 0 "Not Disabled") (1 = 1 "Disabled"), gen(disability)
recode gtmetsta (2 = 0 "Non-Metropolitan Area") (1 = 1 "Metropolitan Area") (3 = 2 "Unknown"), gen(metro)
bysort qstnum: egen schoolChildrenAtHome = max(peage <= 17 & peage >= 6 & perrp >= 4) if hrintsta == 1
label define schoolChildrenAtHome 0 "No" 1 "Yes"
label values schoolChildrenAtHome schoolChildrenAtHome
recode peafever (-1 = .) (2 = 0 "Not a Veteran") (1 = 1 "Veteran"), gen(veteran)

* Step 4: Construct variables being written to analyze table. Make sure anything outside the specified universe is set to missing.

* - Person Variables
generate desktopUser = (pedesk == 1) if isPerson
generate laptopUser = (pelapt == 1) if isPerson
generate tabletUser = (petabl == 1) if isPerson
generate mobilePhoneUser = (pecell == 1) if isPerson
generate tvBoxUser = (pegame == 1 | petvba == 1) if isPerson
generate pcOrTabletUser = (pedesk == 1 | pelapt == 1 | petabl == 1) if isPerson
generate homeInternetUser = (pehome == 1) if isPerson
generate workInternetUser = (pewrka == 1) if isPerson
generate schoolInternetUser = (peschl == 1) if isPerson
generate internetUser = (peperscr == 1) if isPerson

* - Household Variables
bysort qstnum: egen internetAnywhere = max(peperscr == 1)
replace internetAnywhere = . if isHouseholder != 1
generate internetAtHome = (hesci5 == 1) if isHouseholder
generate noInternetAtHome = (internetAtHome == 0) if isHouseholder
generate speedMostImportant = (hesci17 == 1) if isHouseholder
generate reliabilityMostImportant = (hesci17 == 2) if isHouseholder
generate affordabilityMostImportant = (hesci17 == 3) if isHouseholder
generate serviceMostImportant = (hesci17 == 4) if isHouseholder
generate mobilityMostImportant = (hesci17 == 5) if isHouseholder
generate mobileAtHome = (hesci75 == 1) if isHouseholder
generate wiredHighSpeedAtHome = (hesci72 == 1 | hesci73 == 1 | hesci74 == 1) if isHouseholder
generate satelliteAtHome = (hesci76 == 1) if isHouseholder
generate dialUpAtHome = (hesci71 == 1) if isHouseholder
generate ispBundle = (hesci11 == 1) if isHouseholder
generate tvInBundle = (hesci121 == 1 | hesci122 == 1) if isHouseholder
generate homePhoneInBundle = (hesci123 == 1) if isHouseholder
generate homeEverOnline = (hesci6 == 1) if isHouseholder
generate noNeedInterestMainReason = (hesci18 == 1 | hesci20 == 1) if isHouseholder
generate tooExpensiveMainReason = (hesci18 == 2 | hesci20 == 2) if isHouseholder
generate canUseElsewhereMainReason = (hesci18 == 3 | hesci20 == 3) if isHouseholder
generate unavailableMainReason = (hesci18 == 4 | hesci20 == 4) if isHouseholder
generate noComputerMainReason = (hesci18 == 5 | hesci20 == 5) if isHouseholder
generate privSecMainReason = (hesci18 == 6 | hesci20 == 6) if isHouseholder
generate computerAtHome = (hesci3 > 0) if isHouseholder

* - Respondent Variables
// none
