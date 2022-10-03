* Code for blog post: Cutting the Cord: NTIA Data Show Shift to Streaming Video as Consumers Drop Pay-TV
* May 21, 2019
*
* Questions? Email the Data Central team at data@ntia.gov.
* Note: This script assumes all used datasets are located in the current working directory.
*       To download datasets, see https://www.ntia.gov/page/download-digital-nation-datasets.

* July 2013 (Random Respondents)
use jul13-cps, clear
keep if puelgflg == 20 & hrmis != 1 & hrmis != 5
svyset [iw=pwprmwgt], sdrweight(rewgt1-rewgt160) vce(sdr) mse
recode prtage (-1/2 = .) (3/14 = 0 "3-14") (15/24 = 1 "15-24") (25/44 = 2 "25-44") (45/64 = 3 "45-64") (nonmissing = 4 "65+"), gen(ageGroup)
generate videoUser = (peprm33 == 1) if peperscr == 1
svy: tab videoUser ageGroup, col se format(%8.6f)

* July 2015 (Random Respondents)
use jul15-cps, clear
keep if puelgflg == 20
svyset [iw=pwprmwgt], sdrweight(rewgt1-rewgt160) vce(sdr) mse
recode prtage (-1/2 = .) (3/14 = 0 "3-14") (15/24 = 1 "15-24") (25/44 = 2 "25-44") (45/64 = 3 "45-64") (nonmissing = 4 "65+"), gen(ageGroup)
generate videoUser = (pevideo == 1)
svy: tab videoUser ageGroup, col se format(%8.6f)

* November 2017 (Random Respondents)
use nov17-cps, clear
recode prtage (-1/2 = .) (3/14 = 0 "3-14") (15/24 = 1 "15-24") (25/44 = 2 "25-44") (45/64 = 3 "45-64") (nonmissing = 4 "65+"), gen(ageGroup)
generate cableSubStatus = 1 if hetradtv == 1
replace cableSubStatus = 2 if heprevtv == 1
replace cableSubStatus = 3 if heprevtv == 2
label define cableSubStatus 1 "Cable/Sat Subscriber" 2 "Cord Cutter" 3 "Cord Never"
label values cableSubStatus cableSubStatus
preserve
keep if puelgflg == 20
svyset [iw=pwprmwgt], sdrweight(rewgt1-rewgt160) vce(sdr) mse
generate videoUser = (pevideo == 1)
svy: tab videoUser ageGroup, col se format(%8.6f)
svy: tab videoUser cableSubStatus, col se format(%8.6f)

* November 2017 (Households)
restore
bysort qstnum: egen schoolChildrenAtHome = max(prtage <= 17 & prtage >= 6 & perrp >= 4) if hrintsta == 1
label define schoolChildrenAtHome 0 "No" 1 "Yes"
label values schoolChildrenAtHome schoolChildrenAtHome
keep if perrp > 0 & perrp < 3 & hrhtype > 0 & hrhtype < 9
svyset [iw=hwhhwgt], sdrweight(hhwgt1-hhwgt160) vce(sdr) mse
recode hefaminc (-1 = .) (1/7 = 0 "< $25,000") (8/11 = 1 "$25,000-49,999") (12/13 = 2 "$50,000-74,999") (14 = 3 "$75,000-99,999") (15/16 = 4 "$100,000 +"), gen(income)
recode peeduca (-1 = .) (31/38 = 0 "No Diploma") (39 = 1 "High School Diploma") (40/42 = 2 "Some College or AA") (nonmissing = 3 "College Degree or More"), gen(education)
recode ptdtrace (-1 = .) (1 = 0 "White, non-Hispanic") (2 = 1 "Black, non-Hispanic") (99 = 2 "Hispanic") (4 = 3 "Asian, non-Hispanic") (3 = 4 "Am Indian/AK Nat, non-Hispanic") (nonmissing = 5 "Other"), gen(race)
replace race = 2 if pehspnon == 1 // Hispanic ID comes from separate variable
recode gtmetsta (2 = 0 "Non-Metropolitan Area") (1 = 1 "Metropolitan Area") (3 = 2 "Unknown"), gen(metro)
generate internetAtHome = (heinhome == 1)
svy: tab cableSubStatus, se format(%8.6f)
svy: tab cableSubStatus, count se format(%9.0f)
svy, subpop(if cableSubStatus != 1): tab cableSubStatus, se format(%8.6f)
gen reasonNetVideo = (henotv1 == 1) if hetradtv != 1
gen reasonCost = (henotv3 == 1 | henotv4 == 1) if hetradtv != 1
gen reasonLackInterest = (henotv2 == 1) if hetradtv != 1
svy: mean reason*
svy: mean reasonNetVideo, over(ageGroup)
svy: mean reasonNetVideo, over(cableSubStatus)
gen incomeUnder25K = (hefaminc < 8)
gen rural = (gtmetsta == 2)
gen noPostEdu = (peeduca < 40)
gen whiteNonHisp = (ptdtrace == 1 & pehspnon != 1)
svy: mean incomeUnder25K schoolChildrenAtHome rural prtage noPostEdu whiteNonHisp internetAtHome, over(cableSubStatus)
