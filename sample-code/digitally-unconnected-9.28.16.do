* Code for blog post: Digitally Unconnected in the U.S.: Who's Not Online and Why?
* September 28, 2016
*
* Questions? Email the Data Central team at data@ntia.doc.gov.
* Note: This script assumes all used datasets are located in the current working directory.
*       To download datasets, see http://www.ntia.doc.gov/page/download-digital-nation-datasets.

* September 2001 (Households)
use sep01-cps, clear
keep if perrp > 0 & perrp < 3 & hrhtype > 0 & hrhtype < 9
svyset [iw=hwhhwgt] // without replicate weights, the best we can do for household-level data is robust standard errors
generate internetAtHome = (hesint1 == 1)
* Main Reason for Non-Use at Home
generate noNeedInterestMainReason = (hesint5a == 1) if internetAtHome == 0
generate tooExpensiveMainReason = (hesint5a == 2) if internetAtHome == 0
generate noComputerMainReason = (hesint5a == 6 | hesint5a == 7) if internetAtHome == 0
svy: prop *MainReason

* October 2003 (Households)
use oct03-cps, clear
keep if perrp > 0 & perrp < 3 & hrhtype > 0 & hrhtype < 9
svyset [iw=hwhhwgt] // without replicate weights, the best we can do for household-level data is robust standard errors
* Main Reason for Non-Use at Home
generate internetAtHome = (hesint1 == 1)
generate noNeedInterestMainReason = (hesint5a == 3) if internetAtHome == 0
generate tooExpensiveMainReason = (hesint5a == 1) if internetAtHome == 0
generate noComputerMainReason = (hesint5a == 9) if internetAtHome == 0
svy: prop *MainReason

* October 2009 (Households)
use oct09-cps, clear
keep if perrp > 0 & perrp < 3 & hrhtype > 0 & hrhtype < 9
svyset [iw=hwhhwgt] // without replicate weights, the best we can do for household-level data is robust standard errors
* Main Reason for Non-Use at Home
generate internetAtHome = (henet3 == 1)
generate noNeedInterestMainReason = (henet5 == 1) if internetAtHome == 0
generate tooExpensiveMainReason = (henet5 == 2) if internetAtHome == 0
generate noComputerMainReason = (henet5 == 5) if internetAtHome == 0
svy: prop *MainReason

* October 2010 (Households)
use oct10-cps, clear
keep if perrp > 0 & perrp < 3 & hrhtype > 0 & hrhtype < 9
svyset [iw=hwhhwgt] // without replicate weights, the best we can do for household-level data is robust standard errors
* Main Reason for Non-Use at Home
generate internetAtHome = (henet2a == 1)
generate noNeedInterestMainReason = (henet4a1 == 1) if internetAtHome == 0
generate tooExpensiveMainReason = (henet4a1 == 2) if internetAtHome == 0
generate noComputerMainReason = (henet4a1 == 5) if internetAtHome == 0
svy: prop *MainReason

* July 2011 (Households)
use jul11-cps, clear
keep if perrp > 0 & perrp < 3 & hrhtype > 0 & hrhtype < 9
svyset [iw=hwhhwgt], sdrweight(hhwgt1-hhwgt160) vce(sdr) mse
* Main Reason for Non-Use at Home
generate internetAtHome = (hesci5 == 1)
generate noNeedInterestMainReason = (hesci18 == 1 | hesci20 == 1) if internetAtHome == 0
generate tooExpensiveMainReason = (hesci18 == 2 | hesci20 == 2) if internetAtHome == 0
generate noComputerMainReason = (hesci18 == 5 | hesci20 == 5) if internetAtHome == 0
svy: prop *MainReason

* October 2012 (Households)
use oct12-cps, clear
keep if perrp > 0 & perrp < 3 & hrhtype > 0 & hrhtype < 9
svyset [iw=hwhhwgt], sdrweight(hhwgt1-hhwgt160) vce(sdr) mse
* Main Reason for Non-Use at Home
recode henet3 (-1 2 = 0 "No") (1 = 1 "Yes"), gen(internetAtHome)
generate noNeedInterestMainReason = (henet6 == 1 | henet7 == 1) if internetAtHome == 0
generate tooExpensiveMainReason = (henet6 == 2 | henet7 == 2) if internetAtHome == 0
generate noComputerMainReason = (henet6 == 5 | henet7 == 5) if internetAtHome == 0
svy: prop *MainReason

* July 2013 (Households)
use jul13-cps, clear
keep if perrp > 0 & perrp < 3 & hrhtype > 0 & hrhtype < 9 & hrmis != 1 & hrmis != 5 // universe: household reference persons not in group quarters, in Supplement rotation groups
svyset [iw=hwsupwgt], sdrweight(hhwgt1-hhwgt160) vce(sdr) mse // use HWSUPWGT since this Supplement didn't go to all rotation groups
generate internetAtHome = (henet3 == 1)
* Main Reason for Non-Use at Home
generate noNeedInterestMainReason = (henet6 == 1 | henet7 == 1) if internetAtHome == 0
generate tooExpensiveMainReason = (henet6 == 2 | henet7 == 2) if internetAtHome == 0
generate noComputerMainReason = (henet6 == 5 | henet7 == 5) if internetAtHome == 0
svy: prop *MainReason

* July 2015 (Households)
use jul15-cps, clear
keep if perrp > 0 & perrp < 3 & hrhtype > 0 & hrhtype < 9 // universe: household reference persons not in group quarters
svyset [iw=hwhhwgt], sdrweight(hhwgt1-hhwgt160) vce(sdr) mse // all households got the 2015 Supplement so we use the usual HWHHWGT
* Internet Use/Non-Use Counts at Home and Anywhere
generate internetAtHome = (heinhome == 1)
generate internetAnywhere = (heinhome == 1 | heinwork == 1 | heinschl == 1 | heincafe == 1 | heintrav == 1 | heinlico == 1 | heinelho == 1 | heinothr == 1)
svy: tab internetAtHome, count se format(%9.0f)
svy: tab internetAtHome, se format(%8.6f)
svy: tab internetAnywhere, count se format(%9.0f)
svy: tab internetAnywhere, se format(%8.6f)
* Main Reason for Non-Use at Home
generate noNeedInterestMainReason = (heprinoh == 1 | heprinoh == 2) if internetAtHome == 0
generate tooExpensiveMainReason = (heprinoh == 3 | heprinoh == 4) if internetAtHome == 0
generate noComputerMainReason = (heprinoh == 7) if internetAtHome == 0
svy: prop *MainReason
* Don't Need vs. Not Interested
generate noNeedDetailedReason = (heprinoh == 1) if internetAtHome == 0
generate notInterestedDetailedReason = (heprinoh == 2) if internetAtHome == 0
svy, subpop(if noNeedInterestMainReason == 1): prop noNeedDetailedReason notInterestedDetailedReason
* Can't Afford It vs. Not Worth the Cost
generate cantAffordDetailedReason = (heprinoh == 3) if internetAtHome == 0
generate notWorthCostDetailedReason = (heprinoh == 4) if internetAtHome == 0
svy, subpop(if tooExpensiveMainReason == 1): prop cantAffordDetailedReason notWorthCostDetailedReason
* Never- vs. Former-Adopters Reasons
generate canUseElsewhereMainReason = (heprinoh == 5) if internetAtHome == 0
generate unavailableMainReason = (heprinoh == 6) if internetAtHome == 0
generate privSecMainReason = (heprinoh == 8 | heprinoh == 9) if internetAtHome == 0
generate movedMainReason = (heprinoh == 10) if internetAtHome == 0
generate otherMainReason = (heprinoh == 11) if internetAtHome == 0
generate formerHomeUse = (heevrhom == 1) if internetAtHome == 0
svy: tab noNeedDetailedReason formerHomeUse, col se format(%8.6f)
svy: tab notInterestedDetailedReason formerHomeUse, col se format(%8.6f)
svy: tab cantAffordDetailedReason formerHomeUse, col se format(%8.6f)
svy: tab notWorthCostDetailedReason formerHomeUse, col se format(%8.6f)
svy: tab noComputerMainReason formerHomeUse, col se format(%8.6f)
svy: tab canUseElsewhereMainReason formerHomeUse, col se format(%8.6f)
svy: tab privSecMainReason formerHomeUse, col se format(%8.6f)
svy: tab unavailableMainReason formerHomeUse, col se format(%8.6f)
svy: tab movedMainReason formerHomeUse, col se format(%8.6f)
svy: tab otherMainReason formerHomeUse, col se format(%8.6f)
* Price Sensitivity
generate wouldBuyAtLowerPrice = (hepsensi == 1) if internetAtHome == 0
svy: tab wouldBuyAtLowerPrice formerHomeUse, col se format(%8.6f)
