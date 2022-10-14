* Code for blog post: Switched Off: Why Are One in Five U.S. Households Not Online?
* https://www.ntia.gov/blog/2022/switched-why-are-one-five-us-households-not-online
* October 5, 2022
*
* Questions? Email the Data Central team at data@ntia.gov.
* Note: This script assumes all used datasets are located in the current working directory.
*       To download datasets, see https://www.ntia.gov/page/download-ntia-internet-use-survey-datasets.

* Use analyze table to quickly pull basic time-series stats on reasons for non-use
use ntia-analyze-table, clear
list dataset usProp usCount if variable == "noInternetAtHome" & universe == "isHouseholder", clean noobs
list dataset usProp usPropSE if variable == "noNeedInterestMainReason" & universe == "noInternetAtHome", clean noobs
list dataset usProp usPropSE if variable == "tooExpensiveMainReason" & universe == "noInternetAtHome", clean noobs
list dataset usProp usPropSE if variable == "noComputerMainReason" & universe == "noInternetAtHome", clean noobs
list dataset usProp usPropSE if variable == "unavailableMainReason" & universe == "noInternetAtHome", clean noobs


* 2021
use nov21-cps, clear
gen incomeUnder25K = (hefaminc < 8) if hefaminc != -1
bysort qstnum: egen schoolChildrenAtHome = max(prtage <= 17 & prtage >= 6 & perrp >= 4) if hrintsta == 1
label define schoolChildrenAtHome 0 "No" 1 "Yes"
label values schoolChildrenAtHome schoolChildrenAtHome
recode gtmetsta (2 = 0 "Non-Metropolitan Area") (1 = 1 "Metropolitan Area") (3 = 2 "Unknown"), gen(metro)
gen noPostSecondaryEdu = (peeduca < 40) if peeduca != -1
recode ptdtrace (-1 = .) (1 = 0 "White, non-Hispanic") (2 = 1 "Black, non-Hispanic") (99 = 2 "Hispanic") (4 = 3 "Asian, non-Hispanic") (3 = 4 "Am Indian/AK Nat, non-Hispanic") (nonmissing = 5 "Other"), gen(race)
replace race = 2 if pehspnon == 1 // Hispanic ID comes from separate variable
keep if ((perrp == 40 | perrp == 41) & hrhtype > 0 & hrhtype < 9)
svyset [iw=hwhhwgt], sdrweight(hhwgt1-hhwgt160) vce(sdr) mse
generate internetAtHome = (heinhome == 1)
generate internetOutsideHome = (heinwork == 1) | (heinschl == 1) | (heincafe == 1) | (heintrav == 1) | (heinlico == 1) | (heinelho == 1) | (heinothr == 1) if heinschl != -1
generate previousHomeUse = (heevrhom == 1) if heevrhom != -1
recode heprinoh (1 = 1 "No Need/Interest") (2/3 = 2 "Too Expensive") (6 = 3 "No Computer") (5 = 4 "Not Available") (nonmissing = 5 "Other") if internetAtHome == 0, gen(mainReason)
generate wtp = heloprce if heloprce != -1
generate zeroWTP = (wtp == 0) if wtp != .
generate netGroup = .
replace netGroup = 1 if internetAtHome == 1
replace netGroup = 2 if mainReason == 1
replace netGroup = 3 if mainReason == 2
label define netGroup 1 "Internet at Home" 2 "No Need/Interest" 3 "Too Expensive"
label values netGroup netGroup
svy: tab internetAtHome, count se format(%9.0f)
svy: tab internetAtHome, se format(%8.6f)
svy: tab mainReason, se format(%8.6f)
svy: tab mainReason, count se format(%9.0f)
svy: tab incomeUnder25K internetAtHome, col se format (%8.6f)
svy: tab zeroWTP mainReason, col se format (%8.6f)
svy: tab netGroup, count se format(%9.0f)
svy: prop incomeUnder25K schoolChildrenAtHome metro internetOutsideHome noPostSecondaryEdu race, over(netGroup)
svy: prop previousHomeUse zeroWTP, over(netGroup)
svy: mean prtage wtp, over(netGroup)
