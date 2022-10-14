# Code for blog post: New Analysis Shows Offline Households Are Willing to Pay $10-a-Month on Average for Home Internet Service, Though Three in Four Say Any Cost is Too Much
# https://ntia.gov/blog/2022/new-analysis-shows-offline-households-are-willing-pay-10-month-average-home-internet
# October 6, 2022
#
# Questions? Email the Data Central team at data@ntia.gov.
# Note: This script assumes all used datasets are located in the directory defined in setwd(). Download datasets: https://www.ntia.gov/page/download-ntia-internet-use-survey-datasets.

setwd("D:/R") # Change as needed.
library(survey)

nov21 <- readRDS("nov21-cps.rds")
nov21.hh.offline <- svrepdesign(weights = ~hwhhwgt, repweights = "hhwgt[1-9]", type = "successive-difference", mse = T, data = subset(nov21, (perrp == 40 | perrp == 41) & hrhtype > 0 & hrhtype < 9 & heinhome == 2))
nov21.hh.offline <- update(nov21.hh.offline, 
													 mainReason = cut(heprinoh, breaks = c(-Inf, 1, 3, +Inf), labels = c("No Need/Interest", "Too Expensive", "Other")),
													 wtp = heloprce)

# Interview status (hrintsta) always == 1 in this subset of the data, so this produces the total number of offline households
cat("Total households not using the Internet from home, 2021\n")
print(svytotal(~hrintsta, nov21.hh.offline))
cat("\n")

cat("Mean willingness to pay and percent of offline households where WTP = $0, All offline households and by main reason for non-use, 2021\n")
print(svymean(~wtp, nov21.hh.offline))
print(svymean(~wtp == 0, nov21.hh.offline))
print(svyby(~wtp, ~mainReason, nov21.hh.offline, svymean))
print(svyby(~wtp == 0, ~mainReason, nov21.hh.offline, svymean))
cat("\n")

cumulativeWTP <- do.call(rbind, lapply(list(50, 40, 30, 20, 10, 1, 0), function(x) data.frame(price = paste0("$", x), svyby(~as.integer(wtp >= x), ~mainReason, nov21.hh.offline, svytotal, keep.names = F))))
cat("Cumulative Willingness to Pay for Home Internet Service at Selected Prices by Main Reason for Non-Use, Total Offline Households, 2021\n")
print(cumulativeWTP, digits = 6)
