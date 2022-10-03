*	create-ntia-tables.do
*	Version 2.0 (March 31, 2022)
*	National Telecommunications and Information Administration
*
*	Syntax: run create-ntia-tables <monYR>[...] [remote | local | internal]
*	Use this Do File to create, update, or add to a summary dataset containing
*	the statistics tracked by NTIA in its official tables. Specify the desired
*	data collections, separated by a space, in monYR form, e.g. nov94 or jul13.
*	By default, all necessary datasets and supporting code will be downloaded
*	from NTIA. If you'd rather use files that have been downloaded to the
*	current working directory, specify "local" as the second argument. The
*	"internal" option directs Stata to NTIA's internal data library and is
*	probably of no utility to external users, but the option is included here to
*	enable NTIA to maintain one code base for internal and public use. Note that
*	statistics are saved to a file called "ntia-analyze-table.dta" in the
*	current working directory (unless the "internal" option is used to direct
*	Stata to NTIA's internal data library), so ensure the existing dataset
*	remains at that location if attempting to update or add to it.
*	
*	Note that the "remote" option has not yet been implemented.
*
*	Contact the NTIA Internet Use Survey team at <data@ntia.gov>.

local numArgs :word count `0'
local dataLocation = "https://ntia.gov/files/ntia/data_central_downloads/datasets/"
local codeLocation = "https://raw.githubusercontent.com/NTIADC/ntia-internet-use-survey/main/create-ntia-tables/stata/"
local location numDatasets
tempname output
tempfile generatedTables

* Variables used in analyze table
local demographics "ageGroup workStatus income education sex race disability metro schoolChildrenAtHome veteran gestfips"

* If no options specified, explain how to use this Do File.
if `numArgs' == 0 {
	noisily display
	noisily display "{ul:Syntax:} run create-ntia-tables {it:monYR[...]} [remote | local | internal]"
	noisily display
	noisily display `"Use this Do File to create, update, or add to a summary dataset containing"'
	noisily display `"the statistics tracked by NTIA in its official tables. Specify the desired"'
	noisily display `"data collections, separated by a space, in monYR form, e.g. nov94 or jul13."'
	noisily display `"By default, all necessary datasets and supporting code will be downloaded"'
	noisily display `"from NTIA. If you'd rather use files that have been downloaded to the"'
	noisily display `"current working directory, specify "local" as the second argument. The"'
	noisily display `""internal" option directs Stata to NTIA's internal data library and is"'
	noisily display `"probably of no utility to external users, but the option is included here to"'
	noisily display `"enable NTIA to maintain one code base for internal and public use. Note that"'
	noisily display `"statistics are saved to a file called "ntia-analyze-table.dta" in the"'
	noisily display `"current working directory (unless the "internal" option is used to direct"'
	noisily display `"Stata to NTIA's internal data library), so ensure the existing dataset"'
	noisily display `"remains at that location if attempting to update or add to it."'
	noisily display
	noisily display "{error}No data collections specified."
	exit
}

* Figure out the number of datasets requested (which must be > 0), and locations for datasets and code.
if "``numArgs''" == "local" | "``numArgs''" == "internal" | "``numArgs''" == "remote" {
	local numDatasets = `numArgs' - 1
	local location = "``numArgs''"
}
else {
	local numDatasets = `numArgs'
	local location = "remote"
}
if `numDatasets' == 0 {
	noisily display "{error}No data collections specified."
	exit
}

* Make sure all requested datasets are specified in monYR format.
foreach x of numlist 1/`numDatasets' {
	if strlen("``x''") != 5 {
		noisily display "{error}Invalid dataset name '``x''.' Specify the dataset in {it:monYR} format."
		exit
	}
	local surveyMonth = lower(substr("``x''", 1, 3))
	local surveyYear = string(real(substr("``x''", 4, 2)), "%02.0f")
	if "`surveyMonth'" != "jan" & "`surveyMonth'" != "feb" & "`surveyMonth'" != "mar" & "`surveyMonth'" != "apr" & ///
	 "`surveyMonth'" != "may" & "`surveyMonth'" != "jun" & "`surveyMonth'" != "jul" & "`surveyMonth'" != "aug" & ///
	 "`surveyMonth'" != "sep" & "`surveyMonth'" != "oct" & "`surveyMonth'" != "nov" & "`surveyMonth'" != "dec" {
		noisily display "{error}Invalid month '`surveyMonth'.' Specify the dataset in {it:monYR} format, with the month"
		noisily display "{error}being abbreviated as jan, feb, mar, apr, may, jun, jul, aug, sep, oct, nov,"
		noisily display "{error}or dec."
		exit
	}
	if "`surveyYear'" == "." {
		noisily display "{error}Invalid year '" substr("``x''", 4, 2) ".' Specify the dataset in {it:monYR} format, with the year"
		noisily display "{error}being abbreviated using its last two digits."
		exit
	}
}

* Set directory locations for the datasets and supporting code.
if "`location'" == "local" {
	local dataLocation = "`c(pwd)'"
	local codeLocation = "`c(pwd)'"
}
else if "`location'" == "internal" {
	local dataLocation = "D:\Stata"
	local codeLocation = "`c(pwd)'"
}
else if "`location'" != "remote" {
	noisily display "{error}Unknown option '`location'.'"
	exit
}

* Make sure the files we need actually exist at the specified locations.
* In the case of remote download, download to temp files, unzip, and change locations accordingly.
* In the future, we may want to download a list of datasets and notify whether the unfound dataset exists.
if "`location'" != "remote" {
	foreach x of numlist 1/`numDatasets' {
		capture confirm file "`dataLocation'/``x''-cps.dta"
		if _rc != 0 {
			noisily display "{error}No dataset for ``x'' at `dataLocation'."
			exit
		}
		capture confirm file "`codeLocation'/``x''-tables.do"
		if _rc != 0 {
			noisily display "{error}No analyze table code for ``x'' at `codeLocation'."
			exit
		}
	}
	capture confirm file "`codeLocation'/master-labels.do"
		if _rc != 0 {
			noisily display "{error}No labeling code (master-labels.do) at `codeLocation'."
			exit
		}
}
else {
	noisily display "{error}The remote download option has not yet been implemented. In the meantime,"
	noisily display "{error}please download the necessary datasets from NTIA's web site and use the "
	noisily display "{error}'local' option."
	exit
}

* For each requested dataset, open the dataset, execute supporting code, perform calculations, and write to analyze table.
postfile `output' str80(dataset variable description universe) double(usProp usPropSE usCount usCountSE ///
 age314Prop			age314PropSE			age314Count			age314CountSE			age1524Prop			age1524PropSE		age1524Count		age1524CountSE ///
 age2544Prop		age2544PropSE 			age2544Count		age2544CountSE			age4564Prop			age4564PropSE		age4564Count		age4564CountSE ///
 age65pProp			age65pPropSE			age65pCount			age65pCountSE			workEmployedProp	workEmployedPropSE	workEmployedCount	workEmployedCountSE ///
 workUnemployedProp	workUnemployedPropSE	workUnemployedCount	workUnemployedCountSE	workNILFProp		workNILFPropSE		workNILFCount		workNILFCountSE ///
 incomeU25Prop		incomeU25PropSE			incomeU25Count		incomeU25CountSE		income2549Prop		income2549PropSE	income2549Count		income2549CountSE ///
 income5074Prop		income5074PropSE		income5074Count		income5074CountSE		income7599Prop		income7599PropSE	income7599Count		income7599CountSE ///
 income100pProp		income100pPropSE		income100pCount		income100pCountSE		edNoDiplomaProp		edNoDiplomaPropSE	edNoDiplomaCount	edNoDiplomaCountSE ///
 edHSGradProp		edHSGradPropSE			edHSGradCount		edHSGradCountSE			edSomeCollegeProp	edSomeCollegePropSE	edSomeCollegeCount	edSomeCollegeCountSE ///
 edCollegeGradProp	edCollegeGradPropSE		edCollegeGradCount	edCollegeGradCountSE 	sexMaleProp			sexMalePropSE		sexMaleCount		sexMaleCountSE ///
 sexFemaleProp		sexFemalePropSE			sexFemaleCount		sexFemaleCountSE		raceWhiteProp		raceWhitePropSE		raceWhiteCount		raceWhiteCountSE ///
 raceBlackProp		raceBlackPropSE			raceBlackCount		raceBlackCountSE		raceHispanicProp	raceHispanicPropSE	raceHispanicCount	raceHispanicCountSE ///
 raceAsianProp		raceAsianPropSE			raceAsianCount		raceAsianCountSE		raceAmIndianProp	raceAmIndianPropSE	raceAmIndianCount	raceAmIndianCountSE ///
 raceOtherProp		raceOtherPropSE			raceOtherCount		raceOtherCountSE		disabilityNoProp	disabilityNoPropSE	disabilityNoCount	disabilityNoCountSE ///
 disabilityYesProp	disabilityYesPropSE		disabilityYesCount	disabilityYesCountSE	metroNoProp			metroNoPropSE		metroNoCount		metroNoCountSE ///
 metroYesProp		metroYesPropSE			metroYesCount		metroYesCountSE			metroUnknownProp	metroUnknownPropSE	metroUnknownCount	metroUnknownCountSE ///
 scChldHomeNoProp	scChldHomeNoPropSE		scChldHomeNoCount	scChldHomeNoCountSE		scChldHomeYesProp	scChldHomeYesPropSE	scChldHomeYesCount	scChldHomeYesCountSE ///
 veteranNoProp		veteranNoPropSE			veteranNoCount		veteranNoCountSE		veteranYesProp		veteranYesPropSE	veteranYesCount		veteranYesCountSE ///
 ALProp				ALPropSE				ALCount				ALCountSE				AKProp				AKPropSE			AKCount				AKCountSE ///
 AZProp				AZPropSE				AZCount				AZCountSE				ARProp				ARPropSE			ARCount				ARCountSE ///
 CAProp				CAPropSE				CACount				CACountSE				COProp				COPropSE			COCount				COCountSE ///
 CTProp				CTPropSE				CTCount				CTCountSE				DEProp				DEPropSE			DECount				DECountSE ///
 DCProp				DCPropSE				DCCount				DCCountSE				FLProp				FLPropSE			FLCount				FLCountSE ///
 GAProp				GAPropSE				GACount				GACountSE				HIProp				HIPropSE			HICount				HICountSE ///
 IDProp				IDPropSE				IDCount				IDCountSE				ILProp				ILPropSE			ILCount				ILCountSE ///
 INProp				INPropSE				INCount				INCountSE				IAProp				IAPropSE			IACount				IACountSE ///
 KSProp				KSPropSE				KSCount				KSCountSE				KYProp				KYPropSE			KYCount				KYCountSE ///
 LAProp				LAPropSE				LACount				LACountSE				MEProp				MEPropSE			MECount				MECountSE ///
 MDProp				MDPropSE				MDCount				MDCountSE				MAProp				MAPropSE			MACount				MACountSE ///
 MIProp				MIPropSE				MICount				MICountSE				MNProp				MNPropSE			MNCount				MNCountSE ///
 MSProp				MSPropSE				MSCount				MSCountSE				MOProp				MOPropSE			MOCount				MOCountSE ///
 MTProp				MTPropSE				MTCount				MTCountSE				NEProp				NEPropSE			NECount				NECountSE ///
 NVProp				NVPropSE				NVCount				NVCountSE				NHProp				NHPropSE			NHCount				NHCountSE ///
 NJProp				NJPropSE				NJCount				NJCountSE				NMProp				NMPropSE			NMCount				NMCountSE ///
 NYProp				NYPropSE				NYCount				NYCountSE				NCProp				NCPropSE			NCCount				NCCountSE ///
 NDProp				NDPropSE				NDCount				NDCountSE				OHProp				OHPropSE			OHCount				OHCountSE ///
 OKProp				OKPropSE				OKCount				OKCountSE				ORProp				ORPropSE			ORCount				ORCountSE ///
 PAProp				PAPropSE				PACount				PACountSE				RIProp				RIPropSE			RICount				RICountSE ///
 SCProp				SCPropSE				SCCount				SCCountSE				SDProp				SDPropSE			SDCount				SDCountSE ///
 TNProp				TNPropSE				TNCount				TNCountSE				TXProp				TXPropSE			TXCount				TXCountSE ///
 UTProp				UTPropSE				UTCount				UTCountSE				VTProp				VTPropSE			VTCount				VTCountSE ///
 VAProp				VAPropSE				VACount				VACountSE				WAProp				WAPropSE			WACount				WACountSE ///
 WVProp				WVPropSE				WVCount				WVCountSE				WIProp				WIPropSE			WICount				WICountSE ///
 WYProp				WYPropSE				WYCount				WYCountSE) using `generatedTables'
global baseUniverse "none"
foreach x of numlist 1/`numDatasets' {
	use "`dataLocation'/``x''-cps.dta", clear
	run "`codeLocation'/``x''-tables.do"
	capture confirm variable disability
	local disabilityInDatasetRC = _rc
	capture confirm variable income
	local incomeInDatasetRC = _rc
	capture confirm variable hhwgt1
	if _rc == 0 {
		svyset [iw=householdWeight], sdrweight(hhwgt1-hhwgt160) vce(sdr) mse
	}
	else {
		svyset [iw=householdWeight]
	}
	foreach universe in $baseUniverse isHouseholder $householdUniverses {
		global noneVars "isHouseholder"
		local ifUniverse = "`universe'"
		if "`ifUniverse'" == "none" {
			local ifUniverse = "isHouseholder"
		}
		foreach q in $`universe'Vars {
			* pull overall numbers
			* noisily disp "$S_TIME universe: `universe'; ifUniverse: `ifUniverse'; q: `q'" // diagnostic
			svy: mean `q' if `ifUniverse' == 1
			matrix temp = e(b)
			local theStat = temp[1,1]
			local varStats "(`theStat')"
			matrix temp = e(V)
			local theStat = sqrt(temp[1,1])
			local varStats "`varStats' (`theStat')"
			svy: total `q' if `ifUniverse' == 1
			matrix temp = e(b)
			local theStat = temp[1,1]
			local varStats "`varStats' (`theStat')"
			matrix temp = e(V)
			local theStat = sqrt(temp[1,1])
			local varStats "`varStats' (`theStat')"
			foreach z in `demographics' {
				* pull var by each demographic
				if `disabilityInDatasetRC' != 0 & "`z'" == "disability" {
					local varStats "`varStats' (.) (.) (.) (.) (.) (.) (.) (.)"
				}
				else if `incomeInDatasetRC' != 0 & "`z'" == "income" {
					local varStats "`varStats' (.) (.) (.) (.) (.) (.) (.) (.) (.) (.) (.) (.) (.) (.) (.) (.) (.) (.) (.) (.)"
				}
				else {
					if "`z'" == "ageGroup" {
						local varStats "`varStats' (.) (.) (.) (.)" // no householders ages 3-14
					}
					svy: mean `q'  if `ifUniverse' == 1, over(`z')
					matrix tempEstProp = e(b)
					matrix tempVarProp = e(V)
					svy: total `q'  if `ifUniverse' == 1, over(`z')
					matrix tempEstCount = e(b)
					matrix tempVarCount = e(V)
					local numCats = colsof(tempEstProp)
					foreach catNum of numlist 1/`numCats' {
						local theStat = tempEstProp[1,`catNum']
						local varStats "`varStats' (`theStat')"
						local theStat = sqrt(tempVarProp[`catNum',`catNum'])
						local varStats "`varStats' (`theStat')"
						local theStat = tempEstCount[1,`catNum']
						local varStats "`varStats' (`theStat')"
						local theStat = sqrt(tempVarCount[`catNum',`catNum'])
						local varStats "`varStats' (`theStat')"
					}
					if "`z'" == "race" {
						count if race == 5
						if r(N) == 0 { // no "Other" category"
							local varStats "`varStats' (.) (.) (.) (.)"
						}
					}
				}
			}
			if "`q'" == "isHouseholder" {
				post `output' ("``x''") ("`q'") ("") ("") `varStats'
			}
			else {
				post `output' ("``x''") ("`q'") ("") ("`universe'") `varStats'
			}
		}
	}
	capture confirm variable pewgt1
	if _rc == 0 {
		svyset [iw=personWeight], sdrweight(pewgt1-pewgt160) vce(sdr) mse
	}
	else {
		capture svyset personClusterID [iw=personWeight], strata(personStrataID)
		if _rc != 0 {
			svyset [iw=personWeight]
		}
	}
	foreach universe in $baseUniverse isPerson $personUniverses {
		global noneVars "isPerson isAdult"
		local ifUniverse = "`universe'"
		if "`ifUniverse'" == "none" {
			local ifUniverse = "isPerson"
		}
		foreach q in $`universe'Vars {
			* pull overall numbers
			* noisily disp "$S_TIME universe: `universe'; ifUniverse: `ifUniverse'; q: `q'" // diagnostic
			/*if "`q'" == "isAdult" {
				local ifUniverse = "isPerson"
			}
			else if "`ifUniverse'" == "none" {
				local ifUniverse = "isPerson"
			}*/
			svy: mean `q' if `ifUniverse' == 1
			matrix temp = e(b)
			local theStat = temp[1,1]
			local varStats "(`theStat')"
			matrix temp = e(V)
			local theStat = sqrt(temp[1,1])
			local varStats "`varStats' (`theStat')"
			svy: total `q' if `ifUniverse' == 1
			matrix temp = e(b)
			local theStat = temp[1,1]
			local varStats "`varStats' (`theStat')"
			matrix temp = e(V)
			local theStat = sqrt(temp[1,1])
			local varStats "`varStats' (`theStat')"
			foreach z in `demographics' {
				* pull var by each demographic
				if `disabilityInDatasetRC' != 0 & "`z'" == "disability" {
					local varStats "`varStats' (.) (.) (.) (.) (.) (.) (.) (.)"
				}
				else if `incomeInDatasetRC' != 0 & "`z'" == "income" {
					local varStats "`varStats' (.) (.) (.) (.) (.) (.) (.) (.) (.) (.) (.) (.) (.) (.) (.) (.) (.) (.) (.) (.)"
				}
				else {
					if "`z'" == "ageGroup" {
						count if `q' != . & `ifUniverse' & ageGroup == 0
						if r(N) == 0 {	// this is an age 15+ variable
							local varStats "`varStats' (.) (.) (.) (.)"
						}
					}
					svy: mean `q' if `ifUniverse' == 1, over(`z')
					matrix tempEstProp = e(b)
					matrix tempVarProp = e(V)
					svy: total `q' if `ifUniverse' == 1, over(`z')
					matrix tempEstCount = e(b)
					matrix tempVarCount = e(V)
					local numCats = colsof(tempEstProp)
					foreach catNum of numlist 1/`numCats' {
						local theStat = tempEstProp[1,`catNum']
						local varStats "`varStats' (`theStat')"
						local theStat = sqrt(tempVarProp[`catNum',`catNum'])
						local varStats "`varStats' (`theStat')"
						local theStat = tempEstCount[1,`catNum']
						local varStats "`varStats' (`theStat')"
						local theStat = sqrt(tempVarCount[`catNum',`catNum'])
						local varStats "`varStats' (`theStat')"
					}
					if "`z'" == "race" {
						count if race == 5
						if r(N) == 0 { // no "Other" category"
							local varStats "`varStats' (.) (.) (.) (.)"
						}
					}
				}
			}
			if "`q'" == "isPerson" {
				post `output' ("``x''") ("`q'") ("") ("") `varStats'
			}
			else if "`q'" == "isAdult" {
				post `output' ("``x''") ("`q'") ("") ("isPerson") `varStats'
			}
			else {
				post `output' ("``x''") ("`q'") ("") ("`universe'") `varStats'
			}
		}
	}
	capture confirm variable isRespondent
	if _rc == 0 {
		keep if isRespondent
		capture confirm variable rewgt1
		if _rc == 0 {
			svyset [iw=respondentWeight], sdrweight(rewgt1-rewgt160) vce(sdr) mse
		}
		else {
			svyset [iw=respondentWeight]
		}
		foreach q in $adultInternetUserVars { // rework if random respondent variables get multiple universes
			* pull overall numbers
			* noisily disp "$S_TIME q: `q'" // diagnostic
			svy: mean `q'
			matrix temp = e(b)
			local theStat = temp[1,1]
			local varStats "(`theStat')"
			matrix temp = e(V)
			local theStat = sqrt(temp[1,1])
			local varStats "`varStats' (`theStat')"
			svy: total `q'
			matrix temp = e(b)
			local theStat = temp[1,1]
			local varStats "`varStats' (`theStat')"
			matrix temp = e(V)
			local theStat = sqrt(temp[1,1])
			local varStats "`varStats' (`theStat')"
			foreach z in `demographics' {
				* pull var by each demographic
				if "`z'" == "ageGroup" {
					local varStats "`varStats' (.) (.) (.) (.)" // no random respondents ages 3-14
				}
				svy: mean `q', over(`z')
				matrix tempEstProp = e(b)
				matrix tempVarProp = e(V)
				svy: total `q', over(`z')
				matrix tempEstCount = e(b)
				matrix tempVarCount = e(V)
				local numCats = colsof(tempEstProp)
				foreach catNum of numlist 1/`numCats' {
					local theStat = tempEstProp[1,`catNum']
					local varStats "`varStats' (`theStat')"
					local theStat = sqrt(tempVarProp[`catNum',`catNum'])
					local varStats "`varStats' (`theStat')"
					local theStat = tempEstCount[1,`catNum']
					local varStats "`varStats' (`theStat')"
					local theStat = sqrt(tempVarCount[`catNum',`catNum'])
					local varStats "`varStats' (`theStat')"
				}
			}
			post `output' ("``x''") ("`q'") ("") ("adultInternetUser") `varStats'
		}
	}
}
postclose `output'

* Convert the dataset variable to date format, format stats appropriately, and add description and universe labels.
clear
use `generatedTables'
replace dataset = string(date(dataset, "MY", 2093))
destring dataset, replace
format dataset %tdMon_CCYY
format *Count %12.0f
format *CountSE %12.0f
format *Prop %7.6f
format *PropSE %7.6f
run "`codeLocation'/master-labels.do"
save, replace

* Add the generated statistics to ntia-analyze-table, deleting any previous observations for the selected datasets.
clear
capture use "`dataLocation'/ntia-analyze-table.dta"
if _rc == 0 {
	foreach x of numlist 1/`numDatasets' {
		drop if dataset == date("``x''", "MY", 2093)
	}
}
append using `generatedTables'
sort dataset universe description
save "`dataLocation'/ntia-analyze-table.dta", replace

* Clean up by dropping global macros.
macro drop _all
