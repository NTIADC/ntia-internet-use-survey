*	oct07-tables.do
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
global householdUniverses "internetAtHome internetAnywhere"

global isPersonVars "internetUser"
global isAdultVars "internetUser"

global isHouseholderVars "internetAnywhere internetAtHome noInternetAtHome dialUpAtHome"
global internetAtHomeVars "internetAnywhere internetAtHome dialUpAtHome"
global internetAnywhereVars "internetAnywhere internetAtHome dialUpAtHome"

* Step 1.5: Construct synthetic survey design variables to increase the accuracy of standard errors.
* This is only necessary when replicate weights are unavailable.
generate personStrataID = .
replace personStrataID = (gestfips * 10000) + gtcbsa if gtcbsa > 0
replace personStrataID = (gestfips * 1000) + gtco if gtco > 0 & gtcbsa == 0
replace personStrataID = gestfips if gtco == 0 & gtcbsa == 0
generate personClusterID = qstnum

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
recode peeduca (-1 = .) (31/38 = 0 "No Diploma") (39 = 1 "High School Diploma") (40/42 = 2 "Some College or AA") (nonmissing = 3 "College Degree or More"), gen(education)
recode pesex (-1 = .) (1 = 0 "Male") (2 = 1 "Female"), gen(sex)
recode ptdtrace (-1 = .) (1 = 0 "White, non-Hispanic") (2 = 1 "Black, non-Hispanic") (99 = 2 "Hispanic") (4 = 3 "Asian, non-Hispanic") (3 = 4 "Am Indian/AK Nat, non-Hispanic") (nonmissing = 5 "Other"), gen(race)
replace race = 2 if pehspnon == 1 // Hispanic ID comes from separate variable
recode gtmetsta (2 = 0 "Non-Metropolitan Area") (1 = 1 "Metropolitan Area") (3 = 2 "Unknown"), gen(metro)
bysort qstnum: egen schoolChildrenAtHome = max(peage <= 17 & peage >= 6 & perrp >= 4) if hrintsta == 1
label define schoolChildrenAtHome 0 "No" 1 "Yes"
label values schoolChildrenAtHome schoolChildrenAtHome
recode peafever (-1 = .) (2 = 0 "Not a Veteran") (1 = 1 "Veteran"), gen(veteran)

* Step 3.5: Assign household Supplement variable values to reference persons who are active-duty military. They were assigned -1 values in this dataset.
foreach x in henet1 henet3 henet4 {
	bysort qstnum: egen correction = max(`x')
	replace `x' = correction if prpertyp == 3
	drop correction
}

* Step 4: Construct variables being written to analyze table. Make sure anything outside the specified universe is set to missing.

* - Person Variables
generate internetUser = (penet2 == 1) if isPerson

* - Household Variables
generate internetAnywhere = (henet1 == 1) if isHouseholder
generate internetAtHome = (henet3 == 1) if isHouseholder
generate noInternetAtHome = (internetAtHome == 0) if isHouseholder
generate dialUpAtHome = (henet4 == 1) if isHouseholder

* - Respondent Variables
// none
