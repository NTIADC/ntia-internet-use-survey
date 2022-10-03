#	import.ntia.cps.R
#	Version 1.1 (April 6, 2022)
#	National Telecommunications and Information Administration
#
#	'source()' this file and run:
#	[myData <- ] import.ntia.cps("monYR", [save = F | T], [internal = F | T])
#
#	Use the import.ntia.cps() function to import CPS Computer and Internet Use
#	Supplement datasets into R. Specify the desired data collection in monYR form,
#	as a quoted string, e.g., "nov94" or "jul13". The resulting data frame will be
#	returned, and can optionally also be saved as an RDS file by specifying
#	'save = T' as an additional argument. By default, all necessary data files and
#	dictionaries should be located in the current working directory, and if
#	applicable, the final data frame will be saved there as well. Optionally,
#	specify "internal = T" as an additional argument to use NTIA's internal data
#	library; this is probably of no utility to external users (though it could be
#	if the directory locations are modified), but the option is included to enable
#	NTIA to maintain one code base for internal and public use.
#
# Contact the NTIA Internet Use Survey team at <data@ntia.gov>.

import.ntia.cps <- function(dataset, save = F, internal = F) {
	# 1. Determine directory locations.
	if (internal) {
		dictionaryLocation <- getwd()
		rawDataLocation <- "D:/Raw"
		saveLocation <- "D:/R"
	}
	else {
		dictionaryLocation <- getwd()
		rawDataLocation <- getwd()
		saveLocation <- getwd()
	}
	
	# 2. Parse what dataset has been requested.
	if (is.character(dataset) & nchar(dataset) == 5) {
		switch(substr(dataset, 1, 3),
					 jan = surveyMonth <- "January",
					 feb = surveyMonth <- "February",
					 mar = surveyMonth <- "March",
					 apr = surveyMonth <- "April",
					 may = surveyMonth <- "May",
					 jun = surveyMonth <- "June",
					 jul = surveyMonth <- "July",
					 aug = surveyMonth <- "August",
					 sep = surveyMonth <- "September",
					 oct = surveyMonth <- "October",
					 nov = surveyMonth <- "November",
					 dec = surveyMonth <- "December",
					 stop("Invalid month. Specify the dataset in monYR format, with the month being abbreviated as jan, feb, mar, apr, may, jun, jul, aug, sep, oct, nov, or dec."))
	}
	else stop("Specify the dataset as a string in monYR form, e.g., import.ntia.cps(\"nov94\").")
	if (suppressWarnings(is.na(as.integer(substr(dataset, 4, 5)))) == F) {
		surveyYear <- as.integer(substr(dataset, 4, 5))
		if (surveyYear > 93) surveyYear <- 1900 + surveyYear
		else surveyYear <- 2000 + surveyYear
	}
	else stop("Invalid year. Specify the dataset in monYR format, with the year being abbreviated using its last two digits.")
	
	# 3. Verify that needed files exist at the expected locations.
	if (file.exists(file.path(dictionaryLocation, paste0(dataset, "-dictionary.csv"))) == F) stop(paste("No data dictionary for", surveyMonth, surveyYear, "at", dictionaryLocation))
	if (file.exists(file.path(rawDataLocation, paste0(dataset, "-dataset.dat"))) == F) stop(paste("No raw dataset for", surveyMonth, surveyYear, "at", rawDataLocation))
	if (surveyYear == 2000 | surveyYear == 2001) {
		if (file.exists(file.path(dictionaryLocation, "revisedweightsandio-dictionary.csv")) == F) stop(paste("No data dictionary for revised weights and IO at", dictionaryLocation))
		if (file.exists(file.path(rawDataLocation, paste0(dataset, "-revisedweightsandio.dat"))) == F) stop(paste("No raw dataset for", surveyMonth, surveyYear, "revised weights and IO at", rawDataLocation))
	}
	if (surveyYear >= 2011) {
		if (file.exists(file.path(dictionaryLocation, paste0(dataset, "-replicates-person-dictionary.csv"))) == F) stop(paste("No data dictionary for", surveyMonth, surveyYear, "person replicate weights at", dictionaryLocation))
		if (file.exists(file.path(rawDataLocation, paste0(dataset, "-replicates-person.dat"))) == F) stop(paste("No raw dataset for", surveyMonth, surveyYear, "person replicate weights at", rawDataLocation))
	}
	if (surveyYear >= 2012) {
		if (file.exists(file.path(dictionaryLocation, paste0(dataset, "-replicates-respondent-dictionary.csv"))) == F) stop(paste("No data dictionary for", surveyMonth, surveyYear, "respondent replicate weights at", dictionaryLocation))
		if (file.exists(file.path(rawDataLocation, paste0(dataset, "-replicates-respondent.dat"))) == F) stop(paste("No raw dataset for", surveyMonth, surveyYear, "respondent replicate weights at", rawDataLocation))
	}
	
	# 4. Load data files and make implied decimals explicit.
	# 4a. Main dataset
	mainDataset <- openFixedFormatCPSData(file.path(rawDataLocation, paste0(dataset, "-dataset.dat")), file.path(dictionaryLocation, paste0(dataset, "-dictionary.csv")))
	selectedCols <- grep("wgt$", colnames(mainDataset))
	mainDataset[, selectedCols] <- lapply(mainDataset[, selectedCols], function(x) { x[x != -1] <- x[x != -1] / 10000; return(x) })
	selectedCols <- grep("^puernh1c$|^pternh1c$|^peernh2$|^pternh2$|^peernh1o$|^pternh1o$|^prernhly$|^pternhly$|^prernwa$|^pternwa$|^peern$|^ptern$|^puern2$|^ptern2$", colnames(mainDataset))
	mainDataset[, selectedCols] <- lapply(mainDataset[, selectedCols], function(x) { x[x > 0] <- x[x > 0] / 100; return(x) })
	# 4b. Revised weights and IO, if applicable
	if (surveyYear == 2000 | surveyYear == 2001) {
			revisedWeightsIO <- openFixedFormatCPSData(file.path(rawDataLocation, paste0(dataset, "-revisedweightsandio.dat")), file.path(dictionaryLocation, "revisedweightsandio-dictionary.csv"))
			selectedCols <- grep("wgt$", colnames(revisedWeightsIO))
			revisedWeightsIO[, selectedCols] <- lapply(revisedWeightsIO[, selectedCols], function(x) { x[x != -1] <- x[x != -1] / 10000; return(x) })
	}
	# 4c. Person replicate weights, if applicable
	if (surveyYear >= 2011) {
		personReplicates <- openFixedFormatCPSData(file.path(rawDataLocation, paste0(dataset, "-replicates-person.dat")), file.path(dictionaryLocation, paste0(dataset, "-replicates-person-dictionary.csv")))
		selectedCols <- grep("wgt", colnames(personReplicates))
		personReplicates[, selectedCols] <- lapply(personReplicates[, selectedCols], function(x) { x[x != -1] <- x[x != -1] / 10000; return(x) })
	}
	# 4d. Respondent replicate weights, if applicable
	if (surveyYear >= 2012) {
		respondentReplicates <- openFixedFormatCPSData(file.path(rawDataLocation, paste0(dataset, "-replicates-respondent.dat")), file.path(dictionaryLocation, paste0(dataset, "-replicates-respondent-dictionary.csv")))
		selectedCols <- grep("wgt", colnames(respondentReplicates))
		respondentReplicates[, selectedCols] <- lapply(respondentReplicates[, selectedCols], function(x) { x[x != -1] <- x[x != -1] / 10000; return(x) })
	}
	
	# 5. Combine into final dataset, sort, and label.
	finalDataset <- mainDataset
	# 5a. Revised weights and IO, if applicable
	if (surveyYear == 2000 | surveyYear == 2001) {
		names(revisedWeightsIO) <- sub("^n", "p", names(revisedWeightsIO))
		finalDataset <- merge(finalDataset, revisedWeightsIO, by = c("qstnum", "occurnum"), all.x = T)
		# Figure out new household weight by identifying HH member who is weight donor (HWHHWTLN didn't exist yet)
		# See CPS Technical Paper 66 page 10-13.
		finalDataset <- within(finalDataset, {
			hhWgtDonor <- (perrp < 3 & !(pesex == 1 & pemaritl == 1) & pwsswgt.x != 0)
			numDonors <- ave(hhWgtDonor, qstnum, FUN = sum)
			hhWgtDonor[numDonors == 0] <- (perrp[numDonors == 0] == 3 & pwsswgt.x[numDonors == 0] != 0)
			numDonors <- ave(hhWgtDonor, qstnum, FUN = sum)
			hhWgtDonor[numDonors == 0] <- (perrp[numDonors == 0] < 3 & pesex[numDonors == 0] == 1 & pemaritl[numDonors == 0] == 1 & pwsswgt.x[numDonors == 0] != 0)
			numDonors <- ave(hhWgtDonor, qstnum, FUN = sum)
			hhWgtDonor[numDonors == 0] <- (pwsswgt.x[numDonors == 0] == hwhhwgt[numDonors == 0])
			hwhhwgt <- ave((pwsswgt.y * hhWgtDonor), qstnum, FUN = max)
			numDonors <- NULL
			hhWgtDonor <- NULL
		})
		names(finalDataset) <- sub("\\.y$", "", names(finalDataset))
		finalDataset[, grep("\\.x$", colnames(finalDataset))] <- NULL
		finalDataset <- finalDataset[, colnames(mainDataset)]
	}
	# 5b. Person replicate weights (+ derived household replicates), if applicable
	if (surveyYear >= 2011) {
		finalDataset <- merge(finalDataset, personReplicates, by = c("qstnum", "occurnum"), all.x = T)[, union(names(finalDataset), names(personReplicates))]
		hhWgtDonor <- (finalDataset$hwhhwtln == finalDataset$pulineno)
		for (i in 0:160) finalDataset[, paste0("hhwgt", i)] <- ave(finalDataset[, paste0("pewgt", i)] * hhWgtDonor, finalDataset$qstnum, FUN = function(x) ifelse(!all(is.na(x)), max(x, na.rm = T), NA))
	}
	# 5c. Respondent replicate weights, if applicable
	if (surveyYear >= 2012) {
		finalDataset <- merge(finalDataset, respondentReplicates, by = c("qstnum", "occurnum"), all.x = T)[, union(names(finalDataset), names(respondentReplicates))]
	}
	# 5d. Sort and label
	if (is.null(finalDataset$qstnum) == F & is.null(finalDataset$occurnum) == F) finalDataset <- finalDataset[order(finalDataset$qstnum, finalDataset$occurnum),]
	else finalDataset <- finalDataset[order(finalDataset$hrmis, finalDataset$gestfips, finalDataset$hrhhid, finalDataset$hrsersuf, finalDataset$huhhnum, finalDataset$prfamnum, finalDataset$pulineno, finalDataset$hurespli),]
	comment(finalDataset) <- paste(surveyMonth, surveyYear, "Current Population Survey, with Computer and Internet Use Supplement")
	
	# 6. Optionally save.
	if (save) {
		saveRDS(finalDataset, file = file.path(saveLocation, paste0(dataset, "-cps.rds")))
	}

	# 7. Return final dataset
	return(finalDataset)
}

openFixedFormatCPSData <- function(dataPath, dictionaryPath) {
	buffer <- readChar(dataPath, file.info(dataPath)$size, useBytes = T)
	rawData <- unlist(strsplit(buffer, "\n", fixed = T, useBytes = T))
	dataDictionary <- read.csv(dictionaryPath, stringsAsFactors = F)
	theDataset <- as.data.frame(mapply(function(type, start, end) {
		switch(type,
					 int = as.integer(substr(rawData, start, end)),
					 num = as.numeric(substr(rawData, start, end)),
					 char = trimws(substr(rawData, start, end)))
	}, dataDictionary$type, dataDictionary$start, dataDictionary$end, SIMPLIFY = F), stringsAsFactors = F, col.names = dataDictionary$name)
	return(theDataset)
}