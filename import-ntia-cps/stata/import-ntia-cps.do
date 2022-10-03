*	import-ntia-cps.do
*	Version 1.1 (March 26, 2018)
*	National Telecommunications and Information Administration
*	
*	Syntax: run import-ntia-cps <monYR> [remote | local | internal]
*	Use this Do File to import CPS Computer and Internet Use Supplement datasets
*	into Stata. Specify the desired data collection in monYR form, e.g. nov94 or
*	or jul13. By default, all necessary data files and dictionaries will be
*	downloaded from NTIA. If you'd rather use files that have been downloaded
*	to the current working directory, specify "local" as the second argument.
*	The "internal" option directs Stata to NTIA's internal data library and is
*	probably of no utility to external users, but the option is included here to
*	enable NTIA to maintain one code base for internal and public use.
*
*	Note that the "remote" option has not yet been implemented.
*	
*	Contact the NTIA Internet Use Survey team at <data@ntia.gov>.

local dataset = "`1'"
local location = "`2'"
if "`location'" == "" {
	local location = "remote"
}
local dictionaryLocation = "https://raw.githubusercontent.com/NTIADC/ntia-internet-use-survey/main/import-ntia-cps/stata/"
local rawDataLocation = "https://ntia.gov/files/ntia/data_central_downloads/datasets/"
local saveLocation = "`c(pwd)'"
tempfile revisedWeightsIO personReplicates respondentReplicates

* If no options specified, explain how to use this Do File.
if "`dataset'" == "" {
	noisily display
	noisily display "{ul:Syntax:} run import-ntia-cps {it:monYR} [remote | local | internal]"
	noisily display
	noisily display `"Use this Do File to import CPS Computer and Internet Use Supplement datasets"'
	noisily display `"into Stata. Specify the desired data collection in monYR form, e.g. nov94 or"'
	noisily display `"jul13. By default, all necessary data files and dictionaries will be"'
	noisily display `"downloaded from NTIA. If you'd rather use files that have been downloaded"'
	noisily display `"to the current working directory, specify "local" as the second argument."'
	noisily display `"The "internal" option directs Stata to NTIA's internal data library and is"'
	noisily display `"probably of no utility to external users, but the option is included here to"'
	noisily display `"enable NTIA to maintain one code base for internal and public use."'
	noisily display
	noisily display "{error}No data collection specified."
	exit
}

* Set directory locations for the data dictionary, raw data files, and imported dataset.
if "`location'" == "local" {
	local dictionaryLocation = "`c(pwd)'"
	local rawDataLocation = "`c(pwd)'"
}
else if "`location'" == "internal" {
	local dictionaryLocation = "`c(pwd)'"
	local rawDataLocation = "D:\Raw"
	local saveLocation = "D:\Stata"
}
else if "`location'" != "remote" {
	noisily display "{error}Unknown option '`location'.'"
	exit
}

* Figure out what month and year to stamp on the dataset, and return error if monYR format not used.
if strlen("`dataset'") != 5 {
	noisily display "{error}Invalid dataset name. Specify the dataset in {it:monYR} format."
	exit
}
local surveyMonth = lower(substr("`dataset'", 1, 3))
local surveyYear = string(real(substr("`dataset'", 4, 2)), "%02.0f")
if "`surveyMonth'" == "jan" {
	local surveyMonth = "January"
}
else if "`surveyMonth'" == "feb" {
	local surveyMonth = "February"
}
else if "`surveyMonth'" == "mar" {
	local surveyMonth = "March"
}
else if "`surveyMonth'" == "apr" {
	local surveyMonth = "April"
}
else if "`surveyMonth'" == "may" {
	local surveyMonth = "May"
}
else if "`surveyMonth'" == "jun" {
	local surveyMonth = "June"
}
else if "`surveyMonth'" == "jul" {
	local surveyMonth = "July"
}
else if "`surveyMonth'" == "aug" {
	local surveyMonth = "August"
}
else if "`surveyMonth'" == "sep" {
	local surveyMonth = "September"
}
else if "`surveyMonth'" == "oct" {
	local surveyMonth = "October"
}
else if "`surveyMonth'" == "nov" {
	local surveyMonth = "November"
}
else if "`surveyMonth'" == "dec" {
	local surveyMonth = "December"
}
else {
	noisily display "{error}Invalid month '`surveyMonth'.' Specify the dataset in {it:monYR} format, with the month"
	noisily display "{error}being abbreviated as jan, feb, mar, apr, may, jun, jul, aug, sep, oct, nov,"
	noisily display "{error}or dec."
	exit
}
if "`surveyYear'" == "." {
	noisily display "{error}Invalid year '" substr("`dataset'", 4, 2) ".' Specify the dataset in {it:monYR} format, with the year"
	noisily display "{error}being abbreviated using its last two digits."
	exit
}
if real("`surveyYear'") > 93 {
	local surveyYear = "19`surveyYear'"
}
else {
	local surveyYear = "20`surveyYear'"
}

* Make sure the files we need actually exist at the specified locations.
* In the case of remote download, download to temp files, unzip, and change locations accordingly.
* In the future, we may want to download a list of datasets and notify whether the unfound dataset exists.
if "`location'" != "remote" {
	capture confirm file "`dictionaryLocation'/`dataset'-dictionary.dct"
	if _rc != 0 {
		noisily display "{error}No data dictionary for `surveyMonth' `surveyYear' at `dictionaryLocation'."
		exit
	}
	capture confirm file "`rawDataLocation'/`dataset'-dataset.dat"
	if _rc != 0 {
		noisily display "{error}No raw dataset for `surveyMonth' `surveyYear' at `rawDataLocation'."
		exit
	}
	if "`surveyYear'" == "2000" | "`surveyYear'" == "2001" {
		capture confirm file "`dictionaryLocation'/revisedweightsandio-dictionary.dct"
		if _rc != 0 {
			noisily display "{error}No data dictionary for revised weights and IO at `dictionaryLocation'."
			exit
		}
		capture confirm file "`rawDataLocation'/`dataset'-revisedweightsandio.dat"
		if _rc != 0 {
			noisily display "{error}No raw dataset for `surveyMonth' `surveyYear' revised weights and IO at `rawDataLocation'."
			exit
		}
	}
	if real("`surveyYear'") >= 2011 {
		capture confirm file "`dictionaryLocation'/`dataset'-replicates-person-dictionary.dct"
		if _rc != 0 {
			noisily display "{error}No data dictionary for person replicate weights at `dictionaryLocation'."
			exit
		}
		capture confirm file "`rawDataLocation'/`dataset'-replicates-person.dat"
		if _rc != 0 {
			noisily display "{error}No raw dataset for `surveyMonth' `surveyYear' person replicate weights at `rawDataLocation'."
			exit
		}
	}
	if real("`surveyYear'") >= 2012 {
		capture confirm file "`dictionaryLocation'/`dataset'-replicates-respondent-dictionary.dct"
		if _rc != 0 {
			noisily display "{error}No data dictionary for respondent replicate weights at `dictionaryLocation'."
			exit
		}
		capture confirm file "`rawDataLocation'/`dataset'-replicates-respondent.dat"
		if _rc != 0 {
			noisily display "{error}No raw dataset for `surveyMonth' `surveyYear' respondent replicate weights at `rawDataLocation'."
			exit
		}
	}
}
else {
	noisily display "{error}The remote download option has not yet been implemented. In the meantime,"
	noisily display "{error}please download the necessary files from NTIA's web site and use the "
	noisily display "{error}'local' option."
	exit
}

* Create revised weights and IO file, if applicable
if "`surveyYear'" == "2000" | "`surveyYear'" == "2001" {
	infix using "`dictionaryLocation'/revisedweightsandio-dictionary.dct", using("`rawDataLocation'/`dataset'-revisedweightsandio.dat")
	foreach z of varlist *wgt {
		replace `z' = `z' / 10000 if `z' != -1
	}
	compress
	sort qstnum occurnum
	save `revisedWeightsIO'
	clear
}

* Create replicate weights files, if applicable.
if real("`surveyYear'") >= 2011 {
	infile using "`dictionaryLocation'/`dataset'-replicates-person-dictionary.dct", using("`rawDataLocation'/`dataset'-replicates-person.dat")
	compress
	sort qstnum occurnum
	save `personReplicates'
	clear
}
if real("`surveyYear'") >= 2012 {
	infile using "`dictionaryLocation'/`dataset'-replicates-respondent-dictionary.dct", using("`rawDataLocation'/`dataset'-replicates-respondent.dat")
	compress
	sort qstnum occurnum
	save `respondentReplicates'
	clear
}

* Import the dataset, make implied deciminals explicit, compress, sort, and label the dataset.
infix using "`dictionaryLocation'/`dataset'-dictionary.dct", using("`rawDataLocation'/`dataset'-dataset.dat")
foreach y in puernh1c pternh1c peernh2 pternh2 peernh1o pternh1o prernhly pternhly prernwa pternwa peern ptern puern2 ptern2 {
	capture confirm var `y'
	if _rc == 0 {
		replace `y' = `y' / 100 if `y' > 0
	}
}
foreach z of varlist *wgt {
	replace `z' = `z' / 10000 if `z' != -1
}
compress
capture sort qstnum occurnum
if _rc != 0 {
	sort hrmis gestfips hrhhid hrsersuf huhhnum prfamnum pulineno hurespli
}
label data "`surveyMonth' `surveyYear' CPS w/ Computer and Internet Use Supplement"

* Add revised weights and IO, if applicable
if "`surveyYear'" == "2000" | "`surveyYear'" == "2001" {
	merge 1:1 qstnum occurnum using `revisedWeightsIO'
	drop if _merge == 2
	drop _merge
	foreach y of varlist neio1icd-neernlab {
		if "`y'" == "nwsswgt" {
			rename pwsswgt old_pwsswgt
			rename nwsswgt pwsswgt
		}
		else {
			local replacement = "p" + substr("`y'", 2, .)
			drop `replacement'
			rename `y' `replacement'
		}
	}
	rename hwhhwgt old_hwhhwgt
	// If the reference person is not a married male and has a second stage weight, that's the donor
	gen hhWgtDonor = (perrp < 3 & !(pesex == 1 & pemaritl == 1) & pwsswgt != 0)
	// Figure out in which households we've identified the donor
	bysort qstnum: egen numDonors = total(hhWgtDonor)
	// If we don't yet know the donor in a household and we find the reference person's spouse who has a second stage weight, that's the donor
	replace hhWgtDonor = 1 if numDonors == 0 & perrp == 3 & pwsswgt != 0
	// Now see where we've identified the donor
	drop numDonors
	bysort qstnum: egen numDonors = total(hhWgtDonor)
	// If we still don't have a donor and the reference person is a married male with a weight, then it's him because the spouse has no weight
	replace hhWgtDonor = 1 if numDonors == 0 & perrp < 3 & pesex == 1 & pemaritl == 1 & pwsswgt != 0
	// Now see where we've identified the donor
	drop numDonors
	bysort qstnum: egen numDonors = total(hhWgtDonor)
	// Finally, if we still don't have a donor, it's the one where the old person and household weights were equal
	replace hhWgtDonor = 1 if numDonors == 0 & old_pwsswgt == old_hwhhwgt
	drop numDonors
	// Use the donor's person weight as the household weight
	bysort qstnum: egen double hwhhwgt = max(pwsswgt * hhWgtDonor)
	drop hhWgtDonor old_pwsswgt old_hwhhwgt
}

* Add replicate weights, if applicable.
if real("`surveyYear'") >= 2011 {
	merge 1:1 qstnum occurnum using `personReplicates'
	drop if _merge == 2
	drop _merge
	gen hhWgtDonor = (hwhhwtln == pulineno)
	foreach x of numlist 0/160 {
		bysort qstnum: egen double hhwgt`x' = max(pewgt`x' * hhWgtDonor)
	}
	drop hhWgtDonor
}
if real("`surveyYear'") >= 2012 {
	merge 1:1 qstnum occurnum using `respondentReplicates'
	drop if _merge == 2
	drop _merge
}

* Sign, save, and checksum the dataset.
datasignature set, saving("`saveLocation'/`dataset'-cps")
save "`saveLocation'/`dataset'-cps.dta", replace
checksum "`saveLocation'/`dataset'-cps.dta", saving("`saveLocation'/`dataset'-cps.sum", replace)
