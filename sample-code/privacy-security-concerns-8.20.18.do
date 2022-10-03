* Code for blog post: Most Americans Continue to Have Significant Privacy and Security Concerns, NTIA Survey Finds
* August 20, 2018
*
* Questions? Email the Data Central team at data@ntia.doc.gov.
* Note: This script assumes all used datasets are located in the current working directory.
*       To download datasets, see https://www.ntia.doc.gov/page/download-digital-nation-datasets.

* July 2015 (Households)
use jul15-cps, clear
// determine whether each household has any currently employed individuals identified as federal employees
bysort qstnum: egen federalEmployeeInHH = max((pemlr == 1 | pemlr == 2) & (prcow1 == 1 | prcow2 == 1))
label define feds 0 "NoFeds" 1 "FedInHH"
label values federalEmployeeInHH feds
// Universe is Internet-using households
keep if perrp > 0 & perrp < 3 & hrhtype > 0 & hrhtype < 9 & (heinhome == 1 | heinwork == 1 | heinschl == 1 | heincafe == 1 | heintrav == 1 | heinlico == 1 | heinelho == 1 | heinothr == 1)
svyset [iw=hwhhwgt], sdrweight(hhwgt1-hhwgt160) vce(sdr) mse
gen breachVictim = (hecyba == 1)
label define breach 0 "NoBreach" 1 "BreachVictim"
label values breachVictim breach
gen concernedID = (hepscon1 == 1)
gen concernedFraud = (hepscon2 == 1)
gen concernedCoTrack = (hepscon3 == 1)
gen concernedGovTrack = (hepscon4 == 1)
gen concernedLeaks = (hepscon5 == 1)
gen concernedSafety = (hepscon6 == 1)
gen anyConcerns = (concernedID | concernedFraud | concernedCoTrack | concernedGovTrack | concernedLeaks | concernedSafety | (hepscon8 == 1))
gen financeChilled = (hepspre1 == 1)
gen commerceChilled = (hepspre2 == 1)
gen socialChilled = (hepspre3 == 1)
gen discourseChilled = (hepspre4 == 1)
gen anyChilledActivities = (financeChilled | commerceChilled | socialChilled | discourseChilled)
svy: mean anyC* concerned* *Chilled breachVictim
svy: mean anyC* concerned* *Chilled breachVictim, over(federalEmployeeInHH)
svy: mean concerned* *Chilled, over(breachVictim)

* November 2017 (Households)
use nov17-cps, clear
// determine whether each household has any currently employed individuals identified as federal employees
bysort qstnum: egen federalEmployeeInHH = max((pemlr == 1 | pemlr == 2) & (prcow1 == 1 | prcow2 == 1))
label define feds 0 "NoFeds" 1 "FedInHH"
label values federalEmployeeInHH feds
// Universe is Internet-using households
keep if perrp > 0 & perrp < 3 & hrhtype > 0 & hrhtype < 9 & (heinhome == 1 | heinwork == 1 | heinschl == 1 | heincafe == 1 | heintrav == 1 | heinlico == 1 | heinelho == 1 | heinothr == 1)
svyset [iw=hwhhwgt], sdrweight(hhwgt1-hhwgt160) vce(sdr) mse
gen breachVictim = (hepscyba == 1)
label define breach 0 "NoBreach" 1 "BreachVictim"
label values breachVictim breach
gen concernedID = (hepscon1 == 1)
gen concernedFraud = (hepscon2 == 1)
gen concernedCoTrack = (hepscon3 == 1)
gen concernedGovTrack = (hepscon4 == 1)
gen concernedLeaks = (hepscon5 == 1)
gen concernedSafety = (hepscon6 == 1)
gen anyConcerns = (concernedID | concernedFraud | concernedCoTrack | concernedGovTrack | concernedLeaks | concernedSafety | (hepscon8 == 1))
gen financeChilled = (hepspre1 == 1)
gen commerceChilled = (hepspre2 == 1)
gen socialChilled = (hepspre3 == 1)
gen discourseChilled = (hepspre4 == 1)
gen searchChilled = (hepspre5 == 1)
gen anyChilledActivities = (financeChilled | commerceChilled | socialChilled | discourseChilled) // not including searchChilled so time-series comparison is proper
svy: mean anyC* concerned* *Chilled breachVictim
svy: mean anyC* concerned* *Chilled breachVictim, over(federalEmployeeInHH)
svy: mean concerned* *Chilled, over(breachVictim)
