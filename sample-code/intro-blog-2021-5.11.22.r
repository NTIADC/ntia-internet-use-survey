# Code for blog post: New NTIA Data Show Enduring Barriers to Closing
#                     the Digital Divide, Achieving Digital Equity
# May 11, 2022
#
# Questions? Email the Data Central team at data@ntia.gov.
# Note: This script assumes all used datasets are located in the directory defined in setwd().
#       To download datasets, see https://www.ntia.gov/page/download-digital-nation-datasets.

setwd("D:/R") # Change as needed.
library(survey)

dec98 <- readRDS("dec98-cps.rds")
dec98 <- within(dec98, {
	race <- NA
	race[perace == 1] <- 0
	race[perace == 2] <- 1
	race[perace == 4] <- 3
	race[perace == 3] <- 4
	race[prhspnon == 1] <- 2
	race <- factor(race, levels = c(0, 1, 2, 3, 4), labels = c("White", "Black", "Hispanic", "Asian American", "Amer Indian/AK Ntv"))
	internetUser <- ifelse(prtage >= 3 & prpertyp != 3, as.integer(prs11 == 1 | pes14 == 1), NA)
})
dec98.per <- svydesign(~qstnum, weights = ~pwsswgt, strata = ~ifelse(gtmsa == 0, ifelse(gtco == 0, gestfips, gestfips * 1000 + gtco), gestfips * 10000 + gtmsa), data = subset(dec98, prtage >= 3 & prpertyp != 3))

aug00 <- readRDS("aug00-cps.rds")
aug00 <- within(aug00, {
	race <- NA
	race[perace == 1] <- 0
	race[perace == 2] <- 1
	race[perace == 4] <- 3
	race[perace == 3] <- 4
	race[prhspnon == 1] <- 2
	race <- factor(race, levels = c(0, 1, 2, 3, 4), labels = c("White", "Black", "Hispanic", "Asian American", "Amer Indian/AK Ntv"))
	internetUser <- ifelse(prtage >= 3 & prpertyp != 3, as.integer(prs11 == 1 | pes14 == 1), NA)
})
aug00.per <- svydesign(~qstnum, weights = ~pwsswgt, strata = ~ifelse(gtmsa == 0, ifelse(gtco == 0, gestfips, gestfips * 1000 + gtco), gestfips * 10000 + gtmsa), data = subset(aug00, prtage >= 3 & prpertyp != 3))

sep01 <- readRDS("sep01-cps.rds")
sep01 <- within(sep01, {
	race <- NA
	race[perace == 1] <- 0
	race[perace == 2] <- 1
	race[perace == 4] <- 3
	race[perace == 3] <- 4
	race[prhspnon == 1] <- 2
	race <- factor(race, levels = c(0, 1, 2, 3, 4), labels = c("White", "Black", "Hispanic", "Asian American", "Amer Indian/AK Ntv"))
	internetUser <- ifelse(prtage >= 3 & prpertyp != 3, as.integer(prnet1 == 1), NA)
})
sep01.per <- svydesign(~qstnum, weights = ~pwsswgt, strata = ~ifelse(gtmsa == 0, ifelse(gtco == 0, gestfips, gestfips * 1000 + gtco), gestfips * 10000 + gtmsa), data = subset(sep01, prtage >= 3 & prpertyp != 3))

oct03 <- readRDS("oct03-cps.rds")
oct03 <- within(oct03, {
	race <- NA
	race[ptdtrace == 1] <- 0
	race[ptdtrace == 2] <- 1
	race[ptdtrace == 4] <- 3
	race[ptdtrace == 3] <- 4
	race[ptdtrace >= 5] <- 5
	race[pehspnon == 1] <- 2
	race <- factor(race, levels = c(0, 1, 2, 3, 4, 5), labels = c("White", "Black", "Hispanic", "Asian American", "Amer Indian/AK Ntv", "Other"))
	internetUser <- ifelse(prtage >= 3 & prpertyp != 3, as.integer(prnet1 == 1), NA)
})
oct03.per <- svydesign(~qstnum, weights = ~pwsswgt, strata = ~ifelse(gemsa == 0, ifelse(geco == 0, gestfips, gestfips * 1000 + geco), gestfips * 10000 + gemsa), data = subset(oct03, prtage >= 3 & prpertyp != 3))

oct07 <- readRDS("oct07-cps.rds")
oct07 <- within(oct07, {
	race <- NA
	race[ptdtrace == 1] <- 0
	race[ptdtrace == 2] <- 1
	race[ptdtrace == 4] <- 3
	race[ptdtrace == 3] <- 4
	race[ptdtrace >= 5] <- 5
	race[pehspnon == 1] <- 2
	race <- factor(race, levels = c(0, 1, 2, 3, 4, 5), labels = c("White", "Black", "Hispanic", "Asian American", "Amer Indian/AK Ntv", "Other"))
	internetUser <- ifelse(peage >= 3 & prpertyp != 3, as.integer(penet2 == 1), NA)
})
oct07.per <- svydesign(~qstnum, weights = ~pwsswgt, strata = ~ifelse(gtcbsa == 0, ifelse(gtco == 0, gestfips, gestfips * 1000 + gtco), gestfips * 10000 + gtcbsa), data = subset(oct07, peage >= 3 & prpertyp != 3))

oct09 <- readRDS("oct09-cps.rds")
oct09 <- within(oct09, {
	race <- NA
	race[ptdtrace == 1] <- 0
	race[ptdtrace == 2] <- 1
	race[ptdtrace == 4] <- 3
	race[ptdtrace == 3] <- 4
	race[ptdtrace >= 5] <- 5
	race[pehspnon == 1] <- 2
	race <- factor(race, levels = c(0, 1, 2, 3, 4, 5), labels = c("White", "Black", "Hispanic", "Asian American", "Amer Indian/AK Ntv", "Other"))
	internetUser <- ifelse(peage >= 3 & prpertyp != 3, as.integer(penet2 == 1), NA)
})
oct09.per <- svydesign(~qstnum, weights = ~pwsswgt, strata = ~ifelse(gtcbsa == 0, ifelse(gtco == 0, gestfips, gestfips * 1000 + gtco), gestfips * 10000 + gtcbsa), data = subset(oct09, peage >= 3 & prpertyp != 3))

oct10 <- readRDS("oct10-cps.rds")
oct10 <- within(oct10, {
	race <- NA
	race[ptdtrace == 1] <- 0
	race[ptdtrace == 2] <- 1
	race[ptdtrace == 4] <- 3
	race[ptdtrace == 3] <- 4
	race[ptdtrace >= 5] <- 5
	race[pehspnon == 1] <- 2
	race <- factor(race, levels = c(0, 1, 2, 3, 4, 5), labels = c("White", "Black", "Hispanic", "Asian American", "Amer Indian/AK Ntv", "Other"))
	internetUser <- ifelse(peage >= 3 & prpertyp != 3, as.integer(pen2who == 1 | penet6 == 1), NA)
})
oct10.per <- svydesign(~qstnum, weights = ~pwsswgt, strata = ~ifelse(gtcbsa == 0, ifelse(gtco == 0, gestfips, gestfips * 1000 + gtco), gestfips * 10000 + gtcbsa), data = subset(oct10, peage >= 3 & prpertyp != 3))

jul11 <- readRDS("jul11-cps.rds")
jul11 <- within(jul11, {
	race <- NA
	race[ptdtrace == 1] <- 0
	race[ptdtrace == 2] <- 1
	race[ptdtrace == 4] <- 3
	race[ptdtrace == 3] <- 4
	race[ptdtrace >= 5] <- 5
	race[pehspnon == 1] <- 2
	race <- factor(race, levels = c(0, 1, 2, 3, 4, 5), labels = c("White", "Black", "Hispanic", "Asian American", "Amer Indian/AK Ntv", "Other"))
	internetUser <- ifelse(peage >= 3 & prpertyp != 3, as.integer(peperscr == 1), NA)
	desktopUser <- ifelse(peage >= 3 & prpertyp != 3, as.integer(pedesk == 1), NA)
	laptopUser <- ifelse(peage >= 3 & prpertyp != 3, as.integer(pelapt == 1), NA)
	tabletUser <- ifelse(peage >= 3 & prpertyp != 3, as.integer(petabl == 1), NA)
	mobilePhoneUser <- ifelse(peage >= 3 & prpertyp != 3, as.integer(pecell == 1), NA)
	tvBoxUser <- ifelse(peage >= 3 & prpertyp != 3, as.integer(pegame == 1 | petvba == 1), NA)
})
jul11.per <- svrepdesign(weights = ~pwsswgt, repweights = "pewgt[1-9]", type = "successive-difference", mse = T, data = subset(jul11, peage >= 3 & prpertyp != 3))

oct12 <- readRDS("oct12-cps.rds")
oct12 <- within(oct12, {
	race <- NA
	race[ptdtrace == 1] <- 0
	race[ptdtrace == 2] <- 1
	race[ptdtrace == 4] <- 3
	race[ptdtrace == 3] <- 4
	race[ptdtrace >= 5] <- 5
	race[pehspnon == 1] <- 2
	race <- factor(race, levels = c(0, 1, 2, 3, 4, 5), labels = c("White", "Black", "Hispanic", "Asian American", "Amer Indian/AK Ntv", "Other"))
	internetUser <- ifelse(prtage >= 3 & prpertyp != 3, as.integer(penet8 == 1 | penet10 == 1), NA)
})
oct12.per <- svrepdesign(weights = ~pwsswgt, repweights = "pewgt[1-9]", type = "successive-difference", mse = T, data = subset(oct12, prtage >= 3 & prpertyp != 3))

jul13 <- readRDS("jul13-cps.rds")
jul13 <- within(jul13, {
	race <- NA
	race[ptdtrace == 1] <- 0
	race[ptdtrace == 2] <- 1
	race[ptdtrace == 4] <- 3
	race[ptdtrace == 3] <- 4
	race[ptdtrace >= 5] <- 5
	race[pehspnon == 1] <- 2
	race <- factor(race, levels = c(0, 1, 2, 3, 4, 5), labels = c("White", "Black", "Hispanic", "Asian American", "Amer Indian/AK Ntv", "Other"))
	internetUser <- ifelse(prtage >= 3 & prpertyp != 3 & hrmis != 1 & hrmis != 5, as.integer(peperscr == 1), NA)
	desktopUser <- ifelse(prtage >= 3 & prpertyp != 3 & hrmis != 1 & hrmis != 5, as.integer(pedesk == 1), NA)
	laptopUser <- ifelse(prtage >= 3 & prpertyp != 3 & hrmis != 1 & hrmis != 5, as.integer(pelapt == 1), NA)
	tabletUser <- ifelse(prtage >= 3 & prpertyp != 3 & hrmis != 1 & hrmis != 5, as.integer(petabl == 1), NA)
	mobilePhoneUser <- ifelse(prtage >= 3 & prpertyp != 3 & hrmis != 1 & hrmis != 5, as.integer(pecell == 1), NA)
	tvBoxUser <- ifelse(prtage >= 3 & prpertyp != 3 & hrmis != 1 & hrmis != 5, as.integer(pegame == 1 | petvba == 1), NA)
})
jul13.per <- svrepdesign(weights = ~pwsswgt, repweights = "pewgt[1-9]", type = "successive-difference", mse = T, data = subset(jul13, prtage >= 3 & prpertyp != 3 & hrmis != 1 & hrmis != 5))

jul15 <- readRDS("jul15-cps.rds")
jul15 <- within(jul15, {
	race <- NA
	race[ptdtrace == 1] <- 0
	race[ptdtrace == 2] <- 1
	race[ptdtrace == 4] <- 3
	race[ptdtrace == 3] <- 4
	race[ptdtrace >= 5] <- 5
	race[pehspnon == 1] <- 2
	race <- factor(race, levels = c(0, 1, 2, 3, 4, 5), labels = c("White", "Black", "Hispanic", "Asian American", "Amer Indian/AK Ntv", "Other"))
	internetUser <- ifelse(prtage >= 3 & prpertyp != 3, as.integer(peinhome == 1 | peinwork == 1 | peinschl == 1 | peincafe == 1 | peintrav == 1 | peinlico == 1 | peinelho == 1 | peinothr == 1), NA)
	desktopUser <- ifelse(prtage >= 3 & prpertyp != 3, as.integer(pedesktp == 1), NA)
	laptopUser <- ifelse(prtage >= 3 & prpertyp != 3, as.integer(pelaptop == 1), NA)
	tabletUser <- ifelse(prtage >= 3 & prpertyp != 3, as.integer(petablet == 1), NA)
	mobilePhoneUser <- ifelse(prtage >= 3 & prpertyp != 3, as.integer(pemphone == 1 & (peinhome == 1 | peinwork == 1 | peinschl == 1 | peincafe == 1 | peintrav == 1 | peinlico == 1 | peinelho == 1 | peinothr == 1) & (hehomte1 == 1 | heoutmob == 1)), NA)
	tvBoxUser <- ifelse(prtage >= 3 & prpertyp != 3, as.integer(petvbox == 1), NA)
	wearableUser <- ifelse(prtage >= 3 & prpertyp != 3, as.integer(pewearab == 1), NA)
})
jul15.per <- svrepdesign(weights = ~pwsswgt, repweights = "pewgt[1-9]", type = "successive-difference", mse = T, data = subset(jul15, prtage >= 3 & prpertyp != 3))

nov17 <- readRDS("nov17-cps.rds")
nov17 <- within(nov17, {
	race <- NA
	race[ptdtrace == 1] <- 0
	race[ptdtrace == 2] <- 1
	race[ptdtrace == 4] <- 3
	race[ptdtrace == 3] <- 4
	race[ptdtrace >= 5] <- 5
	race[pehspnon == 1] <- 2
	race <- factor(race, levels = c(0, 1, 2, 3, 4, 5), labels = c("White", "Black", "Hispanic", "Asian American", "Amer Indian/AK Ntv", "Other"))
	income <- ifelse(hefaminc != -1, cut(hefaminc, breaks = c(-Inf, 7, 11, 13, 14, Inf), labels = c("< $25K", "$25K-49,999", "$50K-74,999", "$75K-99,999", "$100K +")), NA)
	internetUser <- ifelse(prtage >= 3 & prpertyp != 3, as.integer(peinhome == 1 | peinwork == 1 | peinschl == 1 | peincafe == 1 | peintrav == 1 | peinlico == 1 | peinelho == 1 | peinothr == 1), NA)
	ispStatus <- NA
	ispStatus[hemobdat != 1 & hehomte1 != 1 & hehomte2 != 1 & hehomte4 != 1] <- 0
	ispStatus[hemobdat == 1 & hehomte1 != 1 & hehomte2 != 1 & hehomte4 != 1] <- 1
	ispStatus[hemobdat != 1 & (hehomte1 == 1 | hehomte2 == 1 | hehomte4 == 1)] <- 2
	ispStatus[hemobdat == 1 & (hehomte1 == 1 | hehomte2 == 1 | hehomte4 == 1)] <- 3
	ispStatus <- factor(ispStatus, levels = c(0, 1, 2, 3), labels = c("No ISP", "Mobile Only", "Fixed Only", "Mobile & Fixed"))
	desktopUser <- ifelse(prtage >= 3 & prpertyp != 3, as.integer(pedesktp == 1), NA)
	laptopUser <- ifelse(prtage >= 3 & prpertyp != 3, as.integer(pelaptop == 1), NA)
	tabletUser <- ifelse(prtage >= 3 & prpertyp != 3, as.integer(petablet == 1), NA)
	mobilePhoneUser <- ifelse(prtage >= 3 & prpertyp != 3, as.integer(pemphone == 1), NA)
	tvBoxUser <- ifelse(prtage >= 3 & prpertyp != 3, as.integer(petvbox == 1), NA)
	wearableUser <- ifelse(prtage >= 3 & prpertyp != 3, as.integer(pewearab == 1), NA)
})
nov17.per <- svrepdesign(weights = ~pwsswgt, repweights = "pewgt[1-9]", type = "successive-difference", mse = T, data = subset(nov17, prtage >= 3 & prpertyp != 3))

nov19 <- readRDS("nov19-cps.rds")
nov19 <- within(nov19, {
	race <- NA
	race[ptdtrace == 1] <- 0
	race[ptdtrace == 2] <- 1
	race[ptdtrace == 4] <- 3
	race[ptdtrace == 3] <- 4
	race[ptdtrace >= 5] <- 5
	race[pehspnon == 1] <- 2
	race <- factor(race, levels = c(0, 1, 2, 3, 4, 5), labels = c("White", "Black", "Hispanic", "Asian American", "Amer Indian/AK Ntv", "Other"))
	ageGroup <- ifelse(prtage >= 3 & prpertyp != 3,cut(prtage, breaks = c(-Inf, 14, 24, 44, 64, Inf), labels = c("3-14", "15-24", "25-44", "45-64", "65 +")), NA)
	disability <- ifelse(prdisflg != -1, (prdisflg == 1), NA)
	income <- ifelse(hefaminc != -1, cut(hefaminc, breaks = c(-Inf, 7, 11, 13, 14, Inf), labels = c("< $25K", "$25K-49,999", "$50K-74,999", "$75K-99,999", "$100K +")), NA)
	internetUser <- ifelse(prtage >= 3 & prpertyp != 3, as.integer(peinhome == 1 | peinwork == 1 | peinschl == 1 | peincafe == 1 | peintrav == 1 | peinlico == 1 | peinelho == 1 | peinothr == 1), NA)
	ispStatus <- NA
	ispStatus[hemobdat != 1 & hehomte1 != 1 & hehomte2 != 1 & hehomte4 != 1] <- 0
	ispStatus[hemobdat == 1 & hehomte1 != 1 & hehomte2 != 1 & hehomte4 != 1] <- 1
	ispStatus[hemobdat != 1 & (hehomte1 == 1 | hehomte2 == 1 | hehomte4 == 1)] <- 2
	ispStatus[hemobdat == 1 & (hehomte1 == 1 | hehomte2 == 1 | hehomte4 == 1)] <- 3
	ispStatus <- factor(ispStatus, levels = c(0, 1, 2, 3), labels = c("No ISP", "Mobile Only", "Fixed Only", "Mobile & Fixed"))
	desktopUser <- ifelse(prtage >= 3 & prpertyp != 3, as.integer(pedesktp == 1), NA)
	laptopUser <- ifelse(prtage >= 3 & prpertyp != 3, as.integer(pelaptop == 1), NA)
	tabletUser <- ifelse(prtage >= 3 & prpertyp != 3, as.integer(petablet == 1), NA)
	mobilePhoneUser <- ifelse(prtage >= 3 & prpertyp != 3, as.integer(pemphone == 1), NA)
	tvBoxUser <- ifelse(prtage >= 3 & prpertyp != 3, as.integer(petvbox == 1), NA)
	wearableUser <- ifelse(prtage >= 3 & prpertyp != 3, as.integer(pewearab == 1), NA)
	pcOrTabletUser <- ifelse(prtage >= 3 & prpertyp != 3, as.integer(pedesktp == 1 | pelaptop == 1 | petablet == 1), NA)
})
nov19.per <- svrepdesign(weights = ~pwsswgt, repweights = "pewgt[1-9]", type = "successive-difference", mse = T, data = subset(nov19, prtage >= 3 & prpertyp != 3))

nov21 <- readRDS("nov21-cps.rds")
nov21 <- within(nov21, {
	race <- NA
	race[ptdtrace == 1] <- 0
	race[ptdtrace == 2] <- 1
	race[ptdtrace == 4] <- 3
	race[ptdtrace == 3] <- 4
	race[ptdtrace >= 5] <- 5
	race[pehspnon == 1] <- 2
	race <- factor(race, levels = c(0, 1, 2, 3, 4, 5), labels = c("White", "Black", "Hispanic", "Asian American", "Amer Indian/AK Ntv", "Other"))
	ageGroup <- ifelse(prtage >= 3 & prpertyp != 3,cut(prtage, breaks = c(-Inf, 14, 24, 44, 64, Inf), labels = c("3-14", "15-24", "25-44", "45-64", "65 +")), NA)
	disability <- ifelse(prdisflg != -1, (prdisflg == 1), NA)
	income <- ifelse(hefaminc != -1, cut(hefaminc, breaks = c(-Inf, 7, 11, 13, 14, Inf), labels = c("< $25K", "$25K-49,999", "$50K-74,999", "$75K-99,999", "$100K +")), NA)
	internetUser <- ifelse(prtage >= 3 & prpertyp != 3, as.integer(peinhome == 1 | peinwork == 1 | peinschl == 1 | peincafe == 1 | peintrav == 1 | peinlico == 1 | peinelho == 1 | peinothr == 1), NA)
	ispStatus <- NA
	ispStatus[hemobdat != 1 & hehomte1 != 1 & hehomte2 != 1 & hehomte4 != 1] <- 0
	ispStatus[hemobdat == 1 & hehomte1 != 1 & hehomte2 != 1 & hehomte4 != 1] <- 1
	ispStatus[hemobdat != 1 & (hehomte1 == 1 | hehomte2 == 1 | hehomte4 == 1)] <- 2
	ispStatus[hemobdat == 1 & (hehomte1 == 1 | hehomte2 == 1 | hehomte4 == 1)] <- 3
	ispStatus <- factor(ispStatus, levels = c(0, 1, 2, 3), labels = c("No ISP", "Mobile Only", "Fixed Only", "Mobile & Fixed"))
	desktopUser <- ifelse(prtage >= 3 & prpertyp != 3, as.integer(pedesktp == 1), NA)
	laptopUser <- ifelse(prtage >= 3 & prpertyp != 3, as.integer(pelaptop == 1), NA)
	tabletUser <- ifelse(prtage >= 3 & prpertyp != 3, as.integer(petablet == 1), NA)
	mobilePhoneUser <- ifelse(prtage >= 3 & prpertyp != 3, as.integer(pemphone == 1), NA)
	tvBoxUser <- ifelse(prtage >= 3 & prpertyp != 3, as.integer(petvbox == 1), NA)
	wearableUser <- ifelse(prtage >= 3 & prpertyp != 3, as.integer(pewearab == 1), NA)
	pcOrTabletUser <- ifelse(prtage >= 3 & prpertyp != 3, as.integer(pedesktp == 1 | pelaptop == 1 | petablet == 1), NA)
})
nov21.per <- svrepdesign(weights = ~pwsswgt, repweights = "pewgt[1-9]", type = "successive-difference", mse = T, data = subset(nov21, prtage >= 3 & prpertyp != 3))

# save memory by removing non-subsetted dataset objects
rm(dec98, aug00, sep01, oct03, oct07, oct09, oct10, jul11, oct12, jul13, jul15, nov17, nov19, nov21)


cat("Internet Use, Age 3+ Persons, 2019\n")
print(svymean(~internetUser, nov19.per))
cat("Internet Use, Age 3+ Persons, 2021\n")
print(svymean(~internetUser, nov21.per))
cat("\n")

cat("Internet Use by Age, Age 3+ Persons, 2019\n")
print(svyby(~internetUser, ~ageGroup, nov19.per, FUN = svymean, keep.names = F))
cat("Internet Use by Age, Age 3+ Persons, 2021\n")
print(svyby(~internetUser, ~ageGroup, nov21.per, FUN = svymean, keep.names = F))
cat("\n")

cat("Internet Use by Disability Status, Age 15+ Persons, 2019\n")
print(svyby(~internetUser, ~disability, nov19.per, FUN = svymean, keep.names = F))
cat("Internet Use by Disability Status, Age 15+ Persons, 2021\n")
print(svyby(~internetUser, ~disability, nov21.per, FUN = svymean, keep.names = F))
cat("\n")

cat("Internet Use by Family Income, Age 3+ Persons, 2019\n")
print(svyby(~internetUser, ~income, nov19.per, FUN = svymean, keep.names = F))
cat("Internet Use by Family Income, Age 3+ Persons, 2021\n")
print(svyby(~internetUser, ~income, nov21.per, FUN = svymean, keep.names = F))
cat("\n")

outputNetUseRace <- lapply(list(dec98.per, aug00.per, sep01.per, oct03.per, oct07.per, oct09.per, oct10.per, jul11.per, oct12.per, jul13.per, jul15.per, nov17.per, nov19.per, nov21.per), function(x) data.frame(dataset = paste(month.abb[x$variables$hrmonth[1]], x$variables$hryear4[1]), svyby(~internetUser, ~race, x, FUN = svymean, keep.names = F)))
outputNetUseRace <- do.call(rbind, outputNetUseRace)
cat("Internet Use by Race, Age 3+ Persons, 1998-2021\n")
print(outputNetUseRace)
cat("\n")

cat("Presence of Fixed and Mobile ISPs in Household, Age 3+ Persons, 2017\n")
print(svymean(~ispStatus, nov17.per))
cat("Presence of Fixed and Mobile ISPs in Household, Age 3+ Persons, 2019\n")
print(svymean(~ispStatus, nov19.per))
cat("Presence of Fixed and Mobile ISPs in Household, Age 3+ Persons, 2021\n")
print(svymean(~ispStatus, nov21.per))
cat("\n")

outputISPStatusIncome <- lapply(list(nov17.per, nov19.per, nov21.per), function(x) data.frame(dataset = paste(month.abb[x$variables$hrmonth[1]], x$variables$hryear4[1]), svyby(~ispStatus, ~income, x, FUN = svymean, keep.names = F)))
outputISPStatusIncome <- do.call(rbind, outputISPStatusIncome)
cat("Presence of Fixed and Mobile ISPs in Household by Income, Age 3+ Persons, 2017-2021\n")
print(outputISPStatusIncome)
cat("\n")

outputDesktopUser <- lapply(list(jul11.per, jul13.per, jul15.per, nov17.per, nov19.per, nov21.per), function(x) data.frame(dataset = paste(month.abb[x$variables$hrmonth[1]], x$variables$hryear4[1]), svymean(~desktopUser, x)))
outputDesktopUser <- do.call(rbind, outputDesktopUser)
cat("Desktop Use, Age 3+ Persons, 2011-2021\n")
print(outputDesktopUser)
cat("\n")

outputLaptopUser <- lapply(list(jul11.per, jul13.per, jul15.per, nov17.per, nov19.per, nov21.per), function(x) data.frame(dataset = paste(month.abb[x$variables$hrmonth[1]], x$variables$hryear4[1]), svymean(~laptopUser, x)))
outputLaptopUser <- do.call(rbind, outputLaptopUser)
cat("Laptop Use, Age 3+ Persons, 2011-2021\n")
print(outputLaptopUser)
cat("\n")

outputTabletUser <- lapply(list(jul11.per, jul13.per, jul15.per, nov17.per, nov19.per, nov21.per), function(x) data.frame(dataset = paste(month.abb[x$variables$hrmonth[1]], x$variables$hryear4[1]), svymean(~tabletUser, x)))
outputTabletUser <- do.call(rbind, outputTabletUser)
cat("Tablet Use, Age 3+ Persons, 2011-2021\n")
print(outputTabletUser)
cat("\n")

outputPhoneUser <- lapply(list(jul11.per, jul13.per, jul15.per, nov17.per, nov19.per, nov21.per), function(x) data.frame(dataset = paste(month.abb[x$variables$hrmonth[1]], x$variables$hryear4[1]), svymean(~mobilePhoneUser, x)))
outputPhoneUser <- do.call(rbind, outputPhoneUser)
cat("Smartphone Use, Age 3+ Persons, 2011-2021\n")
print(outputPhoneUser)
cat("\n")

outputTVUser <- lapply(list(jul11.per, jul13.per, jul15.per, nov17.per, nov19.per, nov21.per), function(x) data.frame(dataset = paste(month.abb[x$variables$hrmonth[1]], x$variables$hryear4[1]), svymean(~tvBoxUser, x)))
outputTVUser <- do.call(rbind, outputTVUser)
cat("Smart TV/Device Use, Age 3+ Persons, 2011-2021\n")
print(outputTVUser)
cat("\n")

outputWearableUser <- lapply(list(jul15.per, nov17.per, nov19.per, nov21.per), function(x) data.frame(dataset = paste(month.abb[x$variables$hrmonth[1]], x$variables$hryear4[1]), svymean(~wearableUser, x)))
outputWearableUser <- do.call(rbind, outputWearableUser)
cat("Wearable Use, Age 3+ Persons, 2015-2021\n")
print(outputWearableUser)
cat("\n")

cat("Laptop Use by Age, Age 3+ Persons, 2019\n")
print(svyby(~laptopUser, ~ageGroup, nov19.per, FUN = svymean, keep.names = F))
cat("Laptop Use by Age, Age 3+ Persons, 2021\n")
print(svyby(~laptopUser, ~ageGroup, nov21.per, FUN = svymean, keep.names = F))
cat("\n")

cat("PC or Tablet Use by Disability Status, Age 15+ Persons, 2019\n")
print(svyby(~pcOrTabletUser, ~disability, nov19.per, FUN = svymean, keep.names = F))
cat("PC or Tablet Use by Disability Status, Age 15+ Persons, 2021\n")
print(svyby(~pcOrTabletUser, ~disability, nov21.per, FUN = svymean, keep.names = F))
cat("\n")

cat("PC or Tablet Use by Race, Age 3+ Persons, 2019\n")
print(svyby(~pcOrTabletUser, ~race, nov19.per, FUN = svymean, keep.names = F))
cat("PC or Tablet Use by Race, Age 3+ Persons, 2021\n")
print(svyby(~pcOrTabletUser, ~race, nov21.per, FUN = svymean, keep.names = F))
cat("\n")
