* Code for blog post: Introducing NTIA Data Central
* October 29, 2015
*
* Questions? Email the Data Central team at data@ntia.doc.gov.

* July 2011 (Persons)
use jul11-cps
keep if peage >= 3 & prpertyp != 3 // universe: ages 3+ and not active duty military
svyset [iw=pwsswgt], sdrweight(pewgt1-pewgt160) vce(sdr) mse //survey weighting & variance settings
* Percent of Americans using a mobile phone to go online
generate mobilePhoneUser = (pecell == 1)
svy: tab mobilePhoneUser, percent ci
* Percent of Americans using a desktop to go online
generate desktopUser = (pedesk == 1)
svy: tab desktopUser, percent ci

* October 2012 (Households)
use oct12-cps, clear
keep if perrp > 0 & perrp < 3 & hrhtype > 0 & hrhtype < 9 // universe: HH reference persons not in group quarters
svyset [iw=hwhhwgt], sdrweight(hhwgt1-hhwgt160) vce(sdr) mse
* Percent of households using the Internet at home
generate internetAtHome = (henet3 == 1)
svy: tab internetAtHome, percent ci

* July 2013 (Persons)
use jul13-cps, clear
preserve // so we can come back to the full dataset for household analysis
keep if prtage >= 3 & prpertyp != 3 & hrmis != 1 & hrmis != 5
svyset [iw=pwsupwgt], sdrweight(pewgt1-pewgt160) vce(sdr) mse
* Percent of Americans using a mobile phone to go online
generate mobilePhoneUser = (pecell == 1)
svy: tab mobilePhoneUser, percent ci
* Percent of Americans using a desktop to go online
generate desktopUser = (pedesk == 1)
svy: tab desktopUser, percent ci

* July 2013 (Households)
restore
keep if perrp > 0 & perrp < 3 & hrhtype > 0 & hrhtype < 9 & hrmis != 1 & hrmis != 5
svyset [iw=hwsupwgt], sdrweight(hhwgt1-hhwgt160) vce(sdr) mse
* Percent of households using the Internet at home
generate internetAtHome = (henet3 == 1)
svy: tab internetAtHome, percent ci
