* Code for blog post: Unplugged: NTIA Survey Finds Some Americans Still Avoid Home Internet Use
* April 15, 2019
*
* Questions? Email the Data Central team at data@ntia.gov.
* Note: This script assumes all used datasets are located in the current working directory.
*       To download datasets, see https://www.ntia.gov/page/download-digital-nation-datasets.

* September 2001 (Households)
use sep01-cps, clear
keep if perrp > 0 & perrp < 3 & hrhtype > 0 & hrhtype < 9
svyset [iw=hwhhwgt] // without replicate weights, the best we can do for household-level data is robust standard errors
generate internetAtHome = (hesint1 == 1)
* Main Reason for Non-Use at Home
recode hesint5a (1 = 1 "No Need/Interest") (2 = 2 "Too Expensive") (6/7 = 3 "No Computer") (nonmissing = 4 "Other") if internetAtHome == 0, gen(mainReason)
svy: tab mainReason, se format(%8.6f)

* October 2003 (Households)
use oct03-cps, clear
keep if perrp > 0 & perrp < 3 & hrhtype > 0 & hrhtype < 9
svyset [iw=hwhhwgt] // without replicate weights, the best we can do for household-level data is robust standard errors
generate internetAtHome = (hesint1 == 1)
* Main Reason for Non-Use at Home
recode hesint5a (3 = 1 "No Need/Interest") (1 = 2 "Too Expensive") (9 = 3 "No Computer") (nonmissing = 4 "Other") if internetAtHome == 0, gen(mainReason)
svy: tab mainReason, se format(%8.6f)

* October 2009 (Households)
use oct09-cps, clear
keep if perrp > 0 & perrp < 3 & hrhtype > 0 & hrhtype < 9
svyset [iw=hwhhwgt] // without replicate weights, the best we can do for household-level data is robust standard errors
generate internetAtHome = (henet3 == 1)
* Main Reason for Non-Use at Home
recode henet5 (1 = 1 "No Need/Interest") (2 = 2 "Too Expensive") (5 = 3 "No Computer") (nonmissing = 4 "Other") if internetAtHome == 0, gen(mainReason)
svy: tab mainReason, se format(%8.6f)

* October 2010 (Households)
use oct10-cps, clear
keep if perrp > 0 & perrp < 3 & hrhtype > 0 & hrhtype < 9
svyset [iw=hwhhwgt] // without replicate weights, the best we can do for household-level data is robust standard errors
generate internetAtHome = (henet2a == 1)
* Main Reason for Non-Use at Home
recode henet4a1 (1 = 1 "No Need/Interest") (2 = 2 "Too Expensive") (5 = 3 "No Computer") (nonmissing = 4 "Other") if internetAtHome == 0, gen(mainReason)
svy: tab mainReason, se format(%8.6f)

* July 2011 (Households)
use jul11-cps, clear
keep if perrp > 0 & perrp < 3 & hrhtype > 0 & hrhtype < 9
svyset [iw=hwhhwgt], sdrweight(hhwgt1-hhwgt160) vce(sdr) mse
generate internetAtHome = (hesci5 == 1)
* Main Reason for Non-Use at Home
gen mainReason = 1 if (hesci18 == 1 | hesci20 == 1) & internetAtHome == 0
replace mainReason = 2 if (hesci18 == 2 | hesci20 == 2) & internetAtHome == 0
replace mainReason = 3 if (hesci18 == 5 | hesci20 == 5) & internetAtHome == 0
replace mainReason = 4 if mainReason == . & internetAtHome == 0
label define mainReason 1 "No Need/Interest" 2 "Too Expensive" 3 "No Computer" 4 "Other"
label values mainReason mainReason
svy: tab mainReason, se format(%8.6f)

* October 2012 (Households)
use oct12-cps, clear
keep if perrp > 0 & perrp < 3 & hrhtype > 0 & hrhtype < 9
svyset [iw=hwhhwgt], sdrweight(hhwgt1-hhwgt160) vce(sdr) mse
recode henet3 (-1 2 = 0 "No") (1 = 1 "Yes"), gen(internetAtHome)
* Main Reason for Non-Use at Home
gen mainReason = 1 if (henet6 == 1 | henet7 == 1) & internetAtHome == 0
replace mainReason = 2 if (henet6 == 2 | henet7 == 2) & internetAtHome == 0
replace mainReason = 3 if (henet6 == 5 | henet7 == 5) & internetAtHome == 0
replace mainReason = 4 if mainReason == . & internetAtHome == 0
label define mainReason 1 "No Need/Interest" 2 "Too Expensive" 3 "No Computer" 4 "Other"
label values mainReason mainReason
svy: tab mainReason, se format(%8.6f)

* July 2013 (Households)
use jul13-cps, clear
keep if perrp > 0 & perrp < 3 & hrhtype > 0 & hrhtype < 9 & hrmis != 1 & hrmis != 5 // universe: household reference persons not in group quarters, in Supplement rotation groups
svyset [iw=hwsupwgt], sdrweight(hhwgt1-hhwgt160) vce(sdr) mse // use HWSUPWGT since this Supplement didn't go to all rotation groups
generate internetAtHome = (henet3 == 1)
* Main Reason for Non-Use at Home
generate mainReason = 1 if (henet6 == 1 | henet7 == 1) & internetAtHome == 0
replace mainReason = 2 if (henet6 == 2 | henet7 == 2) & internetAtHome == 0
replace mainReason = 3 if (henet6 == 5 | henet7 == 5) & internetAtHome == 0
replace mainReason = 4 if mainReason == . & internetAtHome == 0
label define mainReason 1 "No Need/Interest" 2 "Too Expensive" 3 "No Computer" 4 "Other"
label values mainReason mainReason
svy: tab mainReason, se format(%8.6f)

* July 2015 (Households)
use jul15-cps, clear
keep if perrp > 0 & perrp < 3 & hrhtype > 0 & hrhtype < 9 // universe: household reference persons not in group quarters
svyset [iw=hwhhwgt], sdrweight(hhwgt1-hhwgt160) vce(sdr) mse // all households got the 2015 Supplement so we use the usual HWHHWGT
generate internetAtHome = (heinhome == 1)
* Main Reason for Non-Use at Home
recode heprinoh (1/2 = 1 "No Need/Interest") (3/4 = 2 "Too Expensive") (7 = 3 "No Computer") (nonmissing = 4 "Other") if internetAtHome == 0, gen(mainReason)
svy: tab mainReason, se format(%8.6f)

* November 2017 (Households)
use nov17-cps, clear
* Need to calculate which HHs have school-age children before dropping non-reference persons
bysort qstnum: egen schoolChildrenAtHome = max(prtage <= 17 & prtage >= 6 & perrp >= 4) if hrintsta == 1
label define schoolChildrenAtHome 0 "No" 1 "Yes"
label values schoolChildrenAtHome schoolChildrenAtHome
* Prepare household-level dataset
keep if perrp > 0 & perrp < 3 & hrhtype > 0 & hrhtype < 9
svyset [iw=hwhhwgt], sdrweight(hhwgt1-hhwgt160) vce(sdr) mse
* Set up needed variables
generate internetAtHome = (heinhome == 1)
recode heprinoh (1 = 1 "No Need/Interest") (2/3 = 2 "Too Expensive") (6 = 3 "No Computer") (nonmissing = 4 "Other") if internetAtHome == 0, gen(mainReason)
gen incomeUnder25K = (hefaminc < 8)
gen rural = (gtmetsta == 2)
gen noPostEdu = (peeduca < 40)
gen whiteNonHisp = (ptdtrace == 1 & pehspnon != 1)
gen internetOutsideHome = (heinwork == 1 | heinschl == 1 | heincafe == 1 | heintrav == 1 | heinlico == 1 | heinelho == 1 | heinothr == 1)
generate homeEverOnline = (heevrhom == 1) if internetAtHome == 0
generate wouldBuyAtLowerPrice = (hepsensi == 1) if internetAtHome == 0
* Calculations
svy: tab internetAtHome, se format(%8.6f)
svy: tab internetAtHome, count se format(%9.0f)
svy: tab mainReason, se format(%8.6f)
svy: tab mainReason, count se format(%9.0f)
svy, subpop(internetAtHome): mean incomeUnder25K schoolChildrenAtHome rural prtage noPostEdu whiteNonHisp internetOutsideHome
svy, subpop(if mainReason == 1): mean incomeUnder25K schoolChildrenAtHome rural prtage noPostEdu whiteNonHisp internetOutsideHome homeEverOnline wouldBuyAtLowerPrice
svy, subpop(if mainReason == 2): mean incomeUnder25K schoolChildrenAtHome rural prtage noPostEdu whiteNonHisp internetOutsideHome homeEverOnline wouldBuyAtLowerPrice
