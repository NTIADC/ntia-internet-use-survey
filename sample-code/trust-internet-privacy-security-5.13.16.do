* Code for blog post: Lack of Trust in Internet Privacy and Security May Deter Economic and Other Online Activities
* May 13, 2016
*
* Questions? Email the Data Central team at data@ntia.doc.gov.
* Note: This script assumes all used datasets are located in the current working directory.
*       To download datasets, see http://www.ntia.doc.gov/page/download-digital-nation-datasets.

* July 2015 (Households)
use jul15-cps, clear
* Set up
// mobilePhoneUser variable limited to users of Internet-enabled mobile phones
generate mobilePhoneUser = (pemphone == 1 & (peinhome == 1 | peinwork == 1 | peinschl == 1 | peincafe == 1 | peintrav == 1 | peinlico == 1 | peinelho == 1 | peinothr == 1) & (hehomte1 == 1 | heoutmob == 1)) if prtage >= 3 & prpertyp != 3
bysort qstnum: egen anyMobilePhonesInHH = max(mobilePhoneUser == 1)
* Our universe is Internet-using households
keep if perrp > 0 & perrp < 3 & hrhtype > 0 & hrhtype < 9 & (heinhome == 1 | heinwork == 1 | heinschl == 1 | heincafe == 1 | heintrav == 1 | heinlico == 1 | heinelho == 1 | heinothr == 1)
svyset [iw=hwhhwgt], sdrweight(hhwgt1-hhwgt160) vce(sdr) mse
* Online security breaches
gen breachVictim = (hecyba == 1)
gen rawNumDeviceTypes = (hedesktp == 1) + (helaptop == 1) + (anyMobilePhonesInHH == 1) + (hetablet == 1) + (hewearab == 1) + (hetvbox == 1)
recode rawNumDeviceTypes (6 = 5 "5+"), gen(numDeviceTypes) // top code because there are so few
gen mobileDataOutsideHome = (heoutmob == 1)
svy: tab breachVictim, se format(%8.6f)
svy: tab breachVictim, count se format(%9.0f)
svy: tab breachVictim numDeviceTypes, col se format(%8.6f)
svy: tab breachVictim mobileDataOutsideHome, col se format(%8.6f)
tab heinhome if numDeviceTypes == 0
* Biggest concerns about online privacy and security risks
gen concernedID = (hepscon1 == 1)
gen concernedFraud = (hepscon2 == 1)
gen concernedCoTrack = (hepscon3 == 1)
gen concernedGovTrack = (hepscon4 == 1)
gen concernedLeaks = (hepscon5 == 1)
gen concernedSafety = (hepscon6 == 1)
gen numConcerns = concernedID + concernedFraud + concernedCoTrack + concernedGovTrack + concernedLeaks + concernedSafety + (hepscon8 == 1)
svy: tab numConcerns, se format(%8.6f)
svy: prop concerned*
svy: tab concernedID breachVictim, col se format(%8.6f)
svy: tab concernedCoTrack breachVictim, col se format(%8.6f)
* Privacy and security concerns deterred online activities
gen financeChilled = (hepspre1 == 1)
gen commerceChilled = (hepspre2 == 1)
gen socialChilled = (hepspre3 == 1)
gen discourseChilled = (hepspre4 == 1)
gen numChilledActivities = financeChilled + commerceChilled + socialChilled + discourseChilled
gen twoPlusConcerns = (numConcerns >= 2)
svy: tab numChilledActivities, se format(%8.6f)
svy: prop *Chilled
svy, subpop(if numConcerns >= 2): prop *Chilled
svy, subpop(if breachVictim == 1): prop *Chilled
svy: tab financeChilled concernedID, col se format(%8.6f)
svy: tab commerceChilled concernedFraud, col se format(%8.6f)
svy: tab discourseChilled concernedGovTrack, col se format(%8.6f)
svy: tab twoPlusConcerns breachVictim, col format(%8.6f)
svy: tab breachVictim twoPlusConcerns, col format(%8.6f)
