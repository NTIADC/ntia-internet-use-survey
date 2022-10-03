* Code for blog post: Majority of Americans Use Multiple Internet-connected Devices, Data Shows
* December 7, 2015
*
* Questions? Email the Data Central team at data@ntia.doc.gov.
* Note: This script assumes all used datasets are located in the current working directory.
*       To download datasets, see http://www.ntia.doc.gov/page/download-digital-nation-datasets.

* July 2011 (Persons)
use jul11-cps, clear
keep if peage >= 3 & prpertyp != 3
* Create variables to identify devices used to go online, add up number of device typed used
generate desktopUser = (pedesk == 1)
generate laptopUser = (pelapt == 1)
generate tabletUser = (petabl == 1)
generate mobilePhoneUser = (pecell == 1)
generate tvBoxUser = (pegame == 1 | petvba == 1)
generate numDevices = desktopUser + laptopUser + tabletUser + mobilePhoneUser + tvBoxUser
* Demographics
recode peage (-1/2 = .) (3/14 = 0 "3-14") (15/24 = 1 "15-24") (25/44 = 2 "25-44") (45/64 = 3 "45-64") (nonmissing = 4 "65+"), gen(ageGroup)
recode hefaminc (-1 = .) (1/7 = 0 "< $25,000") (8/11 = 1 "$25,000-49,999") (12/13 = 2 "$50,000-74,999") (14 = 3 "$75,000-99,999") (15/16 = 4 "$100,000 +"), gen(income)
recode peeduca (-1 = .) (31/38 = 0 "No Diploma") (39 = 1 "High School Diploma") (40/42 = 2 "Some College or AA") (nonmissing = 3 "College Degree or More"), gen(education)
* Set up survey analysis
svyset [iw=pwsswgt], sdrweight(pewgt1-pewgt160) vce(sdr) mse
* Number of device types used to go online
svy: tab numDevices, percent ci
* Specific devices used
svy: prop desktopUser laptopUser tabletUser mobilePhoneUser tvBoxUser
* Desktop use by age group
svy: tab desktopUser ageGroup, col percent ci
* Mean device types used by income, education, and age
svy: mean numDevices, over(income)
svy: mean numDevices, over(education)
svy: mean numDevices, over(ageGroup)
* Devices used by single device type users
svy: prop desktopUser laptopUser tabletUser mobilePhoneUser tvBoxUser if numDevices == 1

* July 2013 (Persons)
use jul13-cps, clear
keep if prtage >= 3 & prpertyp != 3 & hrmis != 1 & hrmis != 5
* Create variables to identify devices used to go online, add up number of device typed used
generate desktopUser = (pedesk == 1)
generate laptopUser = (pelapt == 1)
generate tabletUser = (petabl == 1)
generate mobilePhoneUser = (pecell == 1)
generate tvBoxUser = (pegame == 1 | petvba == 1)
generate numDevices = desktopUser + laptopUser + tabletUser + mobilePhoneUser + tvBoxUser
* Demographics
recode prtage (-1/2 = .) (3/14 = 0 "3-14") (15/24 = 1 "15-24") (25/44 = 2 "25-44") (45/64 = 3 "45-64") (nonmissing = 4 "65+"), gen(ageGroup)
recode hefaminc (-1 = .) (1/7 = 0 "< $25,000") (8/11 = 1 "$25,000-49,999") (12/13 = 2 "$50,000-74,999") (14 = 3 "$75,000-99,999") (15/16 = 4 "$100,000 +"), gen(income)
recode peeduca (-1 = .) (31/38 = 0 "No Diploma") (39 = 1 "High School Diploma") (40/42 = 2 "Some College or AA") (nonmissing = 3 "College Degree or More"), gen(education)
* Set up survey analysis
svyset [iw=pwsupwgt], sdrweight(pewgt1-pewgt160) vce(sdr) mse
* Number of device types used to go online
svy: tab numDevices, percent ci
* Specific devices used
svy: prop desktopUser laptopUser tabletUser mobilePhoneUser tvBoxUser
* Desktop use by age group
svy: tab desktopUser ageGroup, col percent ci
* Mean device types used by income, education, and age
svy: mean numDevices, over(income)
svy: mean numDevices, over(education)
svy: mean numDevices, over(ageGroup)
* Devices used by single device type users
svy: prop desktopUser laptopUser tabletUser mobilePhoneUser tvBoxUser if numDevices == 1
