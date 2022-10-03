* Code for blog post: First Look: Internet Use in 2015
* March 21, 2016
*
* Questions? Email the Data Central team at data@ntia.doc.gov.
* Note: This script assumes all used datasets are located in the current working directory.
*       To download datasets, see http://www.ntia.doc.gov/page/download-digital-nation-datasets.

* July 2013 (Persons)
use jul13-cps, clear
* Demographics
recode prtage (-1/2 = .) (3/14 = 0 "3-14") (15/24 = 1 "15-24") (25/44 = 2 "25-44") (45/64 = 3 "45-64") (nonmissing = 4 "65+"), gen(ageGroup)
recode peeduca (-1 = .) (31/38 = 0 "No Diploma") (39 = 1 "High School Diploma") (40/42 = 2 "Some College or AA") (nonmissing = 3 "College Degree or More"), gen(education)
recode ptdtrace (-1 = .) (1 = 0 "White, non-Hispanic") (2 = 1 "Black, non-Hispanic") (99 = 2 "Hispanic") (4 = 3 "Asian, non-Hispanic") (3 = 4 "Am Indian/AK Nat, non-Hispanic") (nonmissing = 5 "Other"), gen(race)
replace race = 2 if pehspnon == 1 // Hispanic ID comes from separate variable
recode hefaminc (-1 = .) (1/7 = 0 "< $25,000") (8/11 = 1 "$25,000-49,999") (12/13 = 2 "$50,000-74,999") (14 = 3 "$75,000-99,999") (15/16 = 4 "$100,000 +"), gen(income)
preserve // so we can subset households later on without having to reload the dataset
keep if prtage >= 3 & prpertyp != 3 & hrmis != 1 & hrmis != 5 // universe: age 3+ civilians in rotation groups that got this Supplement
svyset [iw=pwsupwgt], sdrweight(pewgt1-pewgt160) vce(sdr) mse // use person-level weights (in this Supplement, the specific Supplement weight) and SDR replicates
* Internet use
generate internetUser = (peperscr == 1)
svy: tab internetUser, se format(%8.6f)
svy: tab internetUser ageGroup, col se format(%8.6f)
svy: tab internetUser education, col se format(%8.6f)
svy: tab internetUser race, col se format(%8.6f)

* July 2013 (Households)
restore
keep if perrp > 0 & perrp < 3 & hrhtype > 0 & hrhtype < 9 & hrmis != 1 & hrmis != 5 // universe: household reference persons not in group quarters, in Supplement rotation groups
svyset [iw=hwsupwgt], sdrweight(hhwgt1-hhwgt160) vce(sdr) mse
* Households with Internet use at home
generate internetAtHome = (henet3 == 1)
svy: tab internetAtHome, se format(%8.6f)

* July 2015 (Persons)
use jul15-cps, clear
* Demographics
recode prtage (-1/2 = .) (3/14 = 0 "3-14") (15/24 = 1 "15-24") (25/44 = 2 "25-44") (45/64 = 3 "45-64") (nonmissing = 4 "65+"), gen(ageGroup)
recode peeduca (-1 = .) (31/38 = 0 "No Diploma") (39 = 1 "High School Diploma") (40/42 = 2 "Some College or AA") (nonmissing = 3 "College Degree or More"), gen(education)
recode ptdtrace (-1 = .) (1 = 0 "White, non-Hispanic") (2 = 1 "Black, non-Hispanic") (99 = 2 "Hispanic") (4 = 3 "Asian, non-Hispanic") (3 = 4 "Am Indian/AK Nat, non-Hispanic") (nonmissing = 5 "Other"), gen(race)
replace race = 2 if pehspnon == 1 // Hispanic ID comes from separate variable
recode hefaminc (-1 = .) (1/7 = 0 "< $25,000") (8/11 = 1 "$25,000-49,999") (12/13 = 2 "$50,000-74,999") (14 = 3 "$75,000-99,999") (15/16 = 4 "$100,000 +"), gen(income)
preserve
keep if prtage >= 3 & prpertyp != 3 // universe: age 3+ civilians (the 2015 Supplement went to the full sample)
svyset [iw=pwsswgt], sdrweight(pewgt1-pewgt160) vce(sdr) mse // use person-level weights and SDR replicates
* Internet use
generate internetUser = (peinhome == 1 | peinwork == 1 | peinschl == 1 | peincafe == 1 | peintrav == 1 | peinlico == 1 | peinelho == 1 | peinothr == 1)
svy: tab internetUser, se format(%8.6f)
svy: tab internetUser ageGroup, col se format(%8.6f)
svy: tab internetUser education, col se format(%8.6f)
svy: tab internetUser race, col se format(%8.6f)

* July 2015 (Households)
restore
keep if perrp > 0 & perrp < 3 & hrhtype > 0 & hrhtype < 9 // universe: household reference persons not in group quarters
svyset [iw=hwhhwgt], sdrweight(hhwgt1-hhwgt160) vce(sdr) mse
* Households with Internet use at home
generate internetAtHome = (heinhome == 1)
svy: tab internetAtHome, se format(%8.6f)
* Households relying on dial-up technology at home
generate dialUpOnly = (hehomte1 != 1 & hehomte2 != 1 & hehomte3 != 1 & hehomte4 == 1 & hehomte5 != 1) if heinhome == 1 // set households without home Internet use to missing
svy: tab dialUpOnly, count se format(%9.0f)
