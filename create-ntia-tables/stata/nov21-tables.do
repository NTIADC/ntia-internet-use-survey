*	nov21-tables.do
*	Version 1.0 (April 14, 2022)
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
global respondentUniverses "adultInternetUser"

global isPersonVars "desktopUser laptopUser tabletUser mobilePhoneUser wearableUser tvBoxUser pcOrTabletUser homeInternetUser workInternetUser schoolInternetUser cafeInternetUser travelingInternetUser libCommInternetUser altHomeInternetUser internetUser"
global isAdultVars "desktopUser laptopUser tabletUser mobilePhoneUser wearableUser tvBoxUser pcOrTabletUser homeInternetUser workInternetUser schoolInternetUser cafeInternetUser travelingInternetUser libCommInternetUser altHomeInternetUser internetUser"

global isHouseholderVars "internetAnywhere internetAtHome noInternetAtHome wiredHighSpeedAtHome satelliteAtHome dialUpAtHome mobileDataPlan cableTVSubscription homeEverOnline noNeedInterestMainReason tooExpensiveMainReason canUseElsewhereMainReason unavailableMainReason noComputerMainReason privSecMainReason"
global internetAtHomeVars "internetAnywhere internetAtHome wiredHighSpeedAtHome satelliteAtHome dialUpAtHome mobileDataPlan cableTVSubscription"
global internetAnywhereVars "internetAnywhere internetAtHome wiredHighSpeedAtHome satelliteAtHome dialUpAtHome mobileDataPlan cableTVSubscription"
global noInternetAtHomeVars "homeEverOnline noNeedInterestMainReason tooExpensiveMainReason canUseElsewhereMainReason unavailableMainReason noComputerMainReason privSecMainReason"

global adultInternetUserVars "emailUser textIMUser socialNetworkUser callConfUser videoUser audioUser teleworkUser jobSearchUser onlineClassUser financeUser eCommerceUser homeIOTUser publishingUser requestingServicesUser offeringServicesUser sellingGoodsUser"

* Step 2: Construct universes for this dataset and standardize weight names (personWeight, householdWeight, respondentWeight). Code is usually the same except in older datasets.
* isPerson and isHouseholder are always required, and isRespondent and isAdult (which are likely the same) are required if pulling from random respondents.
generate isPerson = (prtage >= 3 & prpertyp != 3)
generate isHouseholder = ((perrp == 40 | perrp == 41) & hrhtype > 0 & hrhtype < 9)
generate isAdult = (isPerson & prtage >= 15)
generate isRespondent = (puelgflg == 20)
rename pwsswgt personWeight
rename hwhhwgt householdWeight
rename pwprmwgt respondentWeight

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
generate desktopUser = (pedesktp == 1) if isPerson
generate laptopUser = (pelaptop == 1) if isPerson
generate tabletUser = (petablet == 1) if isPerson
generate mobilePhoneUser = (pemphone == 1) if isPerson
generate wearableUser = (pewearab == 1) if isPerson
generate tvBoxUser = (petvbox == 1) if isPerson
generate pcOrTabletUser = (pedesktp == 1 | pelaptop == 1 | petablet == 1) if isPerson
generate homeInternetUser = (peinhome == 1) if isPerson
generate workInternetUser = (peinwork == 1) if isPerson
generate schoolInternetUser = (peinschl == 1) if isPerson
generate cafeInternetUser = (peincafe == 1) if isPerson
generate travelingInternetUser = (peintrav == 1) if isPerson
generate libCommInternetUser = (peinlico == 1) if isPerson
generate altHomeInternetUser = (peinelho == 1) if isPerson
generate internetUser = (peinhome == 1 | peinwork == 1 | peinschl == 1 | peincafe == 1 | peintrav == 1 | peinlico == 1 | peinelho == 1 | peinothr == 1) if isPerson

* - Household Variables
generate internetAnywhere = (heinhome == 1 | heinwork == 1 | heinschl == 1 | heincafe == 1 | heintrav == 1 | heinlico == 1 | heinelho == 1 | heinothr == 1) if isHouseholder
generate internetAtHome = (heinhome == 1) if isHouseholder
generate noInternetAtHome = (internetAtHome == 0) if isHouseholder
generate wiredHighSpeedAtHome = (hehomte1 == 1) if isHouseholder
generate satelliteAtHome = (hehomte2 == 1) if isHouseholder
generate dialUpAtHome = (hehomte3 == 1) if isHouseholder
generate mobileDataPlan = (hemobdat == 1) if isHouseholder
generate cableTVSubscription = (hetradtv == 1) if isHouseholder
generate homeEverOnline = (heevrhom == 1) if isHouseholder
generate noNeedInterestMainReason = (heprinoh == 1) if isHouseholder
generate tooExpensiveMainReason = (heprinoh == 2 | heprinoh == 3) if isHouseholder
generate canUseElsewhereMainReason = (heprinoh == 4) if isHouseholder
generate unavailableMainReason = (heprinoh == 5) if isHouseholder
generate noComputerMainReason = (heprinoh == 6) if isHouseholder
generate privSecMainReason = (heprinoh == 7 | heprinoh == 8) if isHouseholder

* - Respondent Variables
generate emailUser = (peemail == 1) if isRespondent
generate textIMUser = (petextim == 1) if isRespondent
generate socialNetworkUser = (pesocial == 1) if isRespondent
generate callConfUser = (peconfer == 1) if isRespondent
generate videoUser = (pevideo == 1) if isRespondent
generate audioUser = (peaudio == 1) if isRespondent
generate teleworkUser = (petelewk == 1) if isRespondent
generate jobSearchUser = (pejobsch == 1) if isRespondent
generate onlineClassUser = (peedtrai == 1) if isRespondent
generate financeUser = (pefinanc == 1) if isRespondent
generate eCommerceUser = (peecomme == 1) if isRespondent
generate homeIOTUser = (pehomiot == 1) if isRespondent
generate publishingUser = (pepublsh == 1) if isRespondent
generate requestingServicesUser = (peusesvc == 1) if isRespondent
generate offeringServicesUser = (peesrvcs == 1) if isRespondent
generate sellingGoodsUser = (peegoods == 1) if isRespondent
