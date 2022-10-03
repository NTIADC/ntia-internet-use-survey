* Code for blog post: Evolving Technologies Change the Nature of Internet Use
* April 19, 2016
*
* Questions? Email the Data Central team at data@ntia.doc.gov.
* Note: This script assumes all used datasets are located in the current working directory.
*       To download datasets, see http://www.ntia.doc.gov/page/download-digital-nation-datasets.

* July 2013 (Households)
use jul13-cps, clear
recode hefaminc (-1 = .) (1/7 = 0 "< $25,000") (8/11 = 1 "$25,000-49,999") (12/13 = 2 "$50,000-74,999") (14 = 3 "$75,000-99,999") (15/16 = 4 "$100,000 +"), gen(income)
preserve
keep if perrp > 0 & perrp < 3 & hrhtype > 0 & hrhtype < 9 & hrmis != 1 & hrmis != 5 // universe: household reference persons not in group quarters, in Supplement rotation groups
svyset [iw=hwsupwgt], sdrweight(hhwgt1-hhwgt160) vce(sdr) mse // use HWSUPWGT since this Supplement didn't go to all rotation groups
* Technologies used to go online at home
generate homeTechType = 4 if henet3 == 1 // set households without home Internet use to missing
replace homeTechType = 1 if henet41 != 1 & (henet42 == 1 | henet43 == 1 | henet44 == 1) & henet46 != 1 & henet47 != 1
replace homeTechType = 2 if henet41 != 1 & henet42 != 1 & henet43 != 1 & henet44 != 1 & henet45 == 1 & henet46 != 1 & henet47 != 1
replace homeTechType = 3 if henet41 != 1 & henet42 != 1 & henet43 != 1 & henet44 != 1 & henet46 == 1 & henet47 != 1
label define techTypes 1 "Wired Only or Wired and Mobile" 2 "Mobile Only" 3 "Satellite Only or Satellite and Mobile" 4 "Other Combinations"
label values homeTechType techTypes
svy: tab homeTechType, se format(%8.6f)
svy: tab homeTechType income, col se format(%8.6f)

* July 2013 (Persons)
restore
keep if prtage >= 3 & prpertyp != 3 & hrmis != 1 & hrmis != 5 // universe: age 3+ civilians in rotation groups that got this Supplement
svyset [iw=pwsupwgt], sdrweight(pewgt1-pewgt160) vce(sdr) mse // use PWSUPWGT since this Supplement didn't go to all rotation groups
* Devices used
generate desktopUser = (pedesk == 1)
generate laptopUser = (pelapt == 1)
generate tabletUser = (petabl == 1)
generate mobilePhoneUser = (pecell == 1)
generate tvBoxUser = (pegame == 1 | petvba == 1)
generate numDeviceTypes = desktopUser + laptopUser + tabletUser + mobilePhoneUser + tvBoxUser
svy: prop desktopUser laptopUser tabletUser mobilePhoneUser tvBoxUser
svy: tab numDeviceTypes, se format(%8.6f)

* July 2015 (Households)
use jul15-cps, clear
recode hefaminc (-1 = .) (1/7 = 0 "< $25,000") (8/11 = 1 "$25,000-49,999") (12/13 = 2 "$50,000-74,999") (14 = 3 "$75,000-99,999") (15/16 = 4 "$100,000 +"), gen(income)
preserve
keep if perrp > 0 & perrp < 3 & hrhtype > 0 & hrhtype < 9 // universe: household reference persons not in group quarters
svyset [iw=hwhhwgt], sdrweight(hhwgt1-hhwgt160) vce(sdr) mse // all households got the 2015 Supplement so we use the usual HWHHWGT
* Technologies used to go online at home
generate homeTechType = 4 if heinhome == 1 // set households without home Internet use to missing
replace homeTechType = 1 if hehomte2 == 1 & hehomte3 != 1 & hehomte4 != 1 & hehomte5 != 1
replace homeTechType = 2 if hehomte1 == 1 & hehomte2 != 1 & hehomte3 != 1 & hehomte4 != 1 & hehomte5 != 1
replace homeTechType = 3 if hehomte2 != 1 & hehomte3 == 1 & hehomte4 != 1 & hehomte5 != 1
label define techTypes 1 "Wired Only or Wired and Mobile" 2 "Mobile Only" 3 "Satellite Only or Satellite and Mobile" 4 "Other Combinations"
label values homeTechType techTypes
svy: tab homeTechType, se format(%8.6f)
svy: tab homeTechType income, col se format(%8.6f)
* Household with Internet use at home
generate internetAtHome = (heinhome == 1)
svy: tab internetAtHome, se format(%8.6f)

* July 2015 (Persons)
restore
keep if prtage >= 3 & prpertyp != 3 // universe: age 3+ civilians (the 2015 Supplement went to the full sample)
svyset [iw=pwsswgt], sdrweight(pewgt1-pewgt160) vce(sdr) mse // use the usual PWSSWGT since this Supplement went to the full sample
* Devices used
generate desktopUser = (pedesktp == 1)
generate laptopUser = (pelaptop == 1)
generate tabletUser = (petablet == 1)
generate mobilePhoneUser = (pemphone == 1 & (peinhome == 1 | peinwork == 1 | peinschl == 1 | peincafe == 1 | peintrav == 1 | peinlico == 1 | peinelho == 1 | peinothr == 1) & (hehomte1 == 1 | heoutmob == 1))
generate wearableUser = (pewearab == 1)
generate tvBoxUser = (petvbox == 1)
generate numDeviceTypes = desktopUser + laptopUser + tabletUser + mobilePhoneUser + wearableUser + tvBoxUser
svy: prop desktopUser laptopUser tabletUser mobilePhoneUser tvBoxUser wearableUser
svy: tab numDeviceTypes, se format(%8.6f)
