* Code for blog post: New Insights into the Emerging Internet of Things
* June 15, 2016
*
* Questions? Email the Data Central team at data@ntia.doc.gov.
* Note: This script assumes all used datasets are located in the current working directory.
*       To download datasets, see http://www.ntia.doc.gov/page/download-digital-nation-datasets.

* July 2015 (Persons)
use jul15-cps, clear
* Demographics
recode gtmetsta (2 = 0 "Non-Metropolitan Area") (1 = 1 "Metropolitan Area") (3 = 2 "Unknown"), gen(metro)
recode hefaminc (-1 = .) (1/7 = 0 "< $25,000") (8/11 = 1 "$25,000-49,999") (12/13 = 2 "$50,000-74,999") (14 = 3 "$75,000-99,999") (15/16 = 4 "$100,000 +"), gen(income)
recode peeduca (-1 = .) (31/38 = 0 "No Diploma") (39 = 1 "High School Diploma") (40/42 = 2 "Some College or AA") (nonmissing = 3 "College Degree or More"), gen(education)
recode prdisflg (-1 = .) (2 = 0 "Not Disabled") (1 = 1 "Disabled"), gen(disability)
* Devices used
generate desktopUser = (pedesktp == 1) if prtage >= 3 & prpertyp != 3
generate laptopUser = (pelaptop == 1) if prtage >= 3 & prpertyp != 3
generate tabletUser = (petablet == 1) if prtage >= 3 & prpertyp != 3
// Note: mobilePhoneUser metric limited to use of Internet-enabled mobile phones, consistent with 2011 and 2013
generate mobilePhoneUser = (pemphone == 1 & (peinhome == 1 | peinwork == 1 | peinschl == 1 | peincafe == 1 | peintrav == 1 | peinlico == 1 | peinelho == 1 | peinothr == 1) & (hehomte1 == 1 | heoutmob == 1)) if prtage >= 3 & prpertyp != 3
generate wearableUser = (pewearab == 1) if prtage >= 3 & prpertyp != 3
generate tvBoxUser = (petvbox == 1) if prtage >= 3 & prpertyp != 3
* Preserve so we can use these variables again later, then subset to just look at valid person records
preserve
keep if prtage >= 3 & prpertyp != 3 // universe: age 3+ civilians
svyset [iw=pwsswgt], sdrweight(pewgt1-pewgt160) vce(sdr) mse // use person-level weights and SDR replicates
* Wearable users (vs. all Americans)
svy: tab wearableUser, se format(%8.6f)
svy: tab metro wearableUser, col se format(%8.6f)
svy: tab income wearableUser, col se format(%8.6f)
svy: tab education wearableUser, col se format(%8.6f)
svy: tab disability wearableUser, col se format(%8.6f)
svy: tab mobilePhoneUser wearableUser, col se format(%8.6f)
svy: tab desktopUser wearableUser, col se format(%8.6f)

* July 2015 (Random Respondents)
restore
keep if puelgflg == 20 // universe: 15+ civilian Internet users; one randomly selected in each household
svyset [iw=pwprmwgt], sdrweight(rewgt1-rewgt160) vce(sdr) mse // use respondent-level weights and SDR replicates
* Interacting with household equipment via the Internet
generate homeIOTUser = (pehomiot == 1)
svy: tab homeIOTUser, se format(%8.6f)
svy: tab homeIOTUser, count se format(%9.0f)
svy: tab homeIOTUser desktopUser, col se format(%8.6f)
svy: tab homeIOTUser laptopUser, col se format(%8.6f)
svy: tab homeIOTUser tabletUser, col se format(%8.6f)
svy: tab homeIOTUser mobilePhoneUser, col se format(%8.6f)
svy: tab homeIOTUser tvBoxUser, col se format(%8.6f)
svy: tab homeIOTUser wearableUser, col se format(%8.6f)
