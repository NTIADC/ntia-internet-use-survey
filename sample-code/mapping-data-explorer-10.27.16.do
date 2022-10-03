* Code for blog post: Mapping Computer and Internet Use by State: Introducing Data Explorer 2.0
* October 27, 2016
*
* Questions? Email the Data Central team at data@ntia.doc.gov.
* Note: This script assumes all used datasets are located in the current working directory.
*       To download datasets, see http://www.ntia.doc.gov/page/download-digital-nation-datasets.

* December 1998 (Persons)
use dec98-cps, clear
* Datasets prior to 2011 do not have replicate weights, so we construct
* synthetic strata and use the household ID as the cluster variable to
* calculate standard errors via Taylor series linearization.
* Source: Davern et al. (2006), http://dx.doi.org/10.5034/inquiryjrnl_43.3.283
generate personStrataID = .
replace personStrataID = (gestfips * 10000) + gtmsa if gtmsa > 0
replace personStrataID = (gestfips * 1000) + gtco if gtco > 0 & gtmsa == 0
replace personStrataID = gestfips if gtco == 0 & gtmsa == 0
generate personClusterID = qstnum
* Set up
keep if prtage >= 3 & prpertyp != 3 // universe: age 3+ civilians
svyset personClusterID [iw=pwsswgt], strata(personStrataID)
* State FIPS code labels (same in all datasets)
label define stateFIPS 1 "AL" 2 "AK" 4 "AZ" 5 "AR" 6 "CA" 8 "CO" 9 "CT" 10 "DE" 11 "DC" 12 "FL" 13 "GA" 15 "HI" 16 "ID" 17 "IL" 18 "IN" 19 "IA" 20 "KS" 21 "KY" 22 "LA" 23 "ME" 24 "MD" 25 "MA" 26 "MI" 27 "MN" 28 "MS" 29 "MO" 30 "MT" 31 "NE" 32 "NV" 33 "NH" 34 "NJ" 35 "NM" 36 "NY" 37 "NC" 38 "ND" 39 "OH" 40 "OK" 41 "OR" 42 "PA" 44 "RI" 45 "SC" 46 "SD" 47 "TN" 48 "TX" 49 "UT" 50 "VT" 51 "VA" 53 "WA" 54 "WV" 55 "WI" 56 "WY"
label values gestfips stateFIPS
* Internet use by state
generate internetUser = (prs11 == 1 | pes14 == 1)
svy: tab gestfips internetUser, row se format(%8.6f)

* July 2011 (Persons)
use jul11-cps, clear
* State FIPS code labels (same in all datasets)
label define stateFIPS 1 "AL" 2 "AK" 4 "AZ" 5 "AR" 6 "CA" 8 "CO" 9 "CT" 10 "DE" 11 "DC" 12 "FL" 13 "GA" 15 "HI" 16 "ID" 17 "IL" 18 "IN" 19 "IA" 20 "KS" 21 "KY" 22 "LA" 23 "ME" 24 "MD" 25 "MA" 26 "MI" 27 "MN" 28 "MS" 29 "MO" 30 "MT" 31 "NE" 32 "NV" 33 "NH" 34 "NJ" 35 "NM" 36 "NY" 37 "NC" 38 "ND" 39 "OH" 40 "OK" 41 "OR" 42 "PA" 44 "RI" 45 "SC" 46 "SD" 47 "TN" 48 "TX" 49 "UT" 50 "VT" 51 "VA" 53 "WA" 54 "WV" 55 "WI" 56 "WY"
label values gestfips stateFIPS
* Set up
keep if peage >= 3 & prpertyp != 3 // universe: age 3+ civilians
svyset [iw=pwsswgt], sdrweight(pewgt1-pewgt160) vce(sdr) mse
* TV box use by state
generate tvBoxUser = (pegame == 1 | petvba == 1)
svy: tab gestfips tvBoxUser, row se format(%8.6f)

* July 2013 (Random Respondents)
use jul13-cps, clear
* State FIPS code labels (same in all datasets)
label define stateFIPS 1 "AL" 2 "AK" 4 "AZ" 5 "AR" 6 "CA" 8 "CO" 9 "CT" 10 "DE" 11 "DC" 12 "FL" 13 "GA" 15 "HI" 16 "ID" 17 "IL" 18 "IN" 19 "IA" 20 "KS" 21 "KY" 22 "LA" 23 "ME" 24 "MD" 25 "MA" 26 "MI" 27 "MN" 28 "MS" 29 "MO" 30 "MT" 31 "NE" 32 "NV" 33 "NH" 34 "NJ" 35 "NM" 36 "NY" 37 "NC" 38 "ND" 39 "OH" 40 "OK" 41 "OR" 42 "PA" 44 "RI" 45 "SC" 46 "SD" 47 "TN" 48 "TX" 49 "UT" 50 "VT" 51 "VA" 53 "WA" 54 "WV" 55 "WI" 56 "WY"
label values gestfips stateFIPS
* Set up
keep if puelgflg == 20 & hrmis != 1 & hrmis != 5
svyset [iw=pwprmwgt], sdrweight(rewgt1-rewgt160) vce(sdr) mse
* Location-based services use by state
generate locationServicesUser = (peprm313 == 1) if peperscr == 1
svy: tab gestfips locationServicesUser, row se format(%8.6f)

* July 2015 (Persons)
use jul15-cps, clear
* State FIPS code labels (same in all datasets)
label define stateFIPS 1 "AL" 2 "AK" 4 "AZ" 5 "AR" 6 "CA" 8 "CO" 9 "CT" 10 "DE" 11 "DC" 12 "FL" 13 "GA" 15 "HI" 16 "ID" 17 "IL" 18 "IN" 19 "IA" 20 "KS" 21 "KY" 22 "LA" 23 "ME" 24 "MD" 25 "MA" 26 "MI" 27 "MN" 28 "MS" 29 "MO" 30 "MT" 31 "NE" 32 "NV" 33 "NH" 34 "NJ" 35 "NM" 36 "NY" 37 "NC" 38 "ND" 39 "OH" 40 "OK" 41 "OR" 42 "PA" 44 "RI" 45 "SC" 46 "SD" 47 "TN" 48 "TX" 49 "UT" 50 "VT" 51 "VA" 53 "WA" 54 "WV" 55 "WI" 56 "WY"
label values gestfips stateFIPS
* Set up
preserve // so we can more quickly switch to random respondent analysis later
keep if prtage >= 3 & prpertyp != 3 // universe: age 3+ civilians
svyset [iw=pwsswgt], sdrweight(pewgt1-pewgt160) vce(sdr) mse
* Internet use by state
generate internetUser = (peinhome == 1 | peinwork == 1 | peinschl == 1 | peincafe == 1 | peintrav == 1 | peinlico == 1 | peinelho == 1 | peinothr == 1)
svy: tab gestfips internetUser, row se format(%8.6f)
* TV box use by state
generate tvBoxUser = (petvbox == 1)
svy: tab gestfips tvBoxUser, row se format(%8.6f)

* July 2015 (Random Respondents)
restore
keep if puelgflg == 20
svyset [iw=pwprmwgt], sdrweight(rewgt1-rewgt160) vce(sdr) mse
* Location-based services use by state
generate locationServicesUser = (peontheg == 1)
svy: tab gestfips locationServicesUser, row se format(%8.6f)
