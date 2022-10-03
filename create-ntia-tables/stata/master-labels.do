*	master-labels.do
*	Version 1.1 (May 30, 2018)
*	National Telecommunications and Information Administration
*
*	Contains supporting code for create-ntia-tables.do that enters appropriate
*	description and universe labels for each variable. All variables in the
*	analyze table must have entries here.
*	
*	Contact: Rafi Goldberg, <rgoldberg@ntia.doc.gov>

* Fill descriptions.
capture replace description = "Person in Universe: Ages 3+ Not Active-Duty Military" if variable == "isPerson"
capture replace description = "Household Reference Person in Universe: Non-Institutional" if variable == "isHouseholder"
capture replace description = "Person Ages 15+" if variable == "isAdult"
capture replace description = "Uses a Desktop Computer" if variable == "desktopUser"
capture replace description = "Uses a Laptop Computer" if variable == "laptopUser"
capture replace description = "Uses a Tablet or e-Book Reader" if variable == "tabletUser"
capture replace description = "Uses a Mobile Phone" if variable == "mobilePhoneUser"
capture replace description = "Uses a Wearable Device" if variable == "wearableUser"
capture replace description = "Uses a Smart TV or Connected Device" if variable == "tvBoxUser"
capture replace description = "Uses a Desktop, Laptop, or Tablet Computer" if variable == "pcOrTabletUser"
capture replace description = "Uses the Internet at Home" if variable == "homeInternetUser"
capture replace description = "Uses the Internet at Work" if variable == "workInternetUser"
capture replace description = "Uses the Internet at School" if variable == "schoolInternetUser"
capture replace description = "Uses the Internet at a Coffee Shop or Other Business" if variable == "cafeInternetUser"
capture replace description = "Uses the Internet While Traveling Between Places" if variable == "travelingInternetUser"
capture replace description = "Uses the Internet at a Public Place Like the Library, Community Center, Park" if variable == "libCommInternetUser"
capture replace description = "Uses the Internet at Someone Else's Home" if variable == "altHomeInternetUser"
capture replace description = "Uses the Internet (Any Location)" if variable == "internetUser"
//capture replace description = "Ages 15+: Uses the Internet (Any Location)" if variable == "adultInternetUser"
capture replace description = "Anyone in Household Uses Internet From Any Location" if variable == "internetAnywhere"
capture replace description = "Anyone in Household Uses Internet at Home" if variable == "internetAtHome"
capture replace description = "No One in Household Uses Internet at Home" if variable == "noInternetAtHome"
capture replace description = "Subscription to Private ISP Service at Home" if variable == "homeSubPrivateISP"
capture replace description = "Subscription to Public, Nonprofit, or Coop ISP Service at Home" if variable == "homeSubPublicISP"
capture replace description = "Internet Service Provided for Entire Building/Campus/Community at Home" if variable == "homeIncludedInternet"
capture replace description = "Publicly-Available Free Internet Service at Home" if variable == "homePublicFreeInternet"
capture replace description = "Service Speed is Most Important Factor for Home Internet Service" if variable == "speedMostImportant"
capture replace description = "Reliability is Most Important Factor for Home Internet Service" if variable == "reliabilityMostImportant"
capture replace description = "Affordability is Most Important Factor for Home Internet Service" if variable == "affordabilityMostImportant"
capture replace description = "Customer Service is Most Important Factor for Home Internet Service" if variable == "serviceMostImportant"
capture replace description = "Mobility is Most Important Factor for Home Internet Service" if variable == "mobilityMostImportant"
capture replace description = "Data Cap is Most Important Factor for Home Internet Service" if variable == "dataCapMostImportant"
capture replace description = "Mobile Internet Service Used at Home" if variable == "mobileAtHome"
capture replace description = "Wired High-Speed Internet Service Used at Home" if variable == "wiredHighSpeedAtHome"
capture replace description = "Satellite Internet Service Used at Home" if variable == "satelliteAtHome"
capture replace description = "Dial-up Internet Service Used at Home" if variable == "dialUpAtHome"
capture replace description = "Household Subscribes to Cable or Satellite TV Service" if variable == "cableTVSubscription"
capture replace description = "Home Internet is Part of a Bundle" if variable == "ispBundle"
capture replace description = "TV Channels Bundled with Internet at Home" if variable == "tvInBundle"
capture replace description = "Home Phone Service Bundled with Internet at Home" if variable == "homePhoneInBundle"
capture replace description = "Mobile Phone Service Bundled with Internet at Home" if variable == "mobilePhoneInBundle"
capture replace description = "Home Security or Monitoring Bundled with Internet at Home" if variable == "homeSecInBundle"
capture replace description = "Mobile Internet Service Used Outside the Home" if variable == "mobileOutsideHome"
capture replace description = "Uses Email" if variable == "emailUser"
capture replace description = "Uses Text Messaging or Instant Messaging" if variable == "textIMUser"
capture replace description = "Uses Online Social Networks" if variable == "socialNetworkUser"
capture replace description = "Participates in Online Video or Voice Calls or Conferencing" if variable == "callConfUser"
capture replace description = "Browses the Web" if variable == "webUser"
capture replace description = "Watches Videos Online" if variable == "videoUser"
capture replace description = "Streams or Downloads Music, Radio, Podcasts, etc." if variable == "audioUser"
capture replace description = `"Uses Online Location-Based (On-the-Go) Services"' if variable == "locationServicesUser"
capture replace description = "Telecommutes Using the Internet" if variable == "teleworkUser"
capture replace description = "Searches for a Job Online" if variable == "jobSearchUser"
capture replace description = "Takes Class or Participates in Job Training Online" if variable == "onlineClassUser"
capture replace description = "Uses Online Financial Services Like Banking, Investing, Paying Bills" if variable == "financeUser"
capture replace description = "Shops, Makes Travel Reservations, or Uses Other Consumer Services Online" if variable == "eCommerceUser"
capture replace description = "Interacts with Household Equipment Using the Internet" if variable == "homeIOTUser"
capture replace description = "Researches Health Information Online" if variable == "healthInfoUser"
capture replace description = "Access Electronic Health Records or Insurance Records, or Talks w Doctor Online" if variable == "healthRecordsUser"
capture replace description = "Uses Health Monitoring Service that Connects to the Internet" if variable == "healthMonitoringUser"
capture replace description = "Household Used to Go Online from Home" if variable == "homeEverOnline"
capture replace description = "Main Reason for Household Not Online at Home: Don't Need It or Not Interested" if variable == "noNeedInterestMainReason"
capture replace description = "Main Reason for Household Not Online at Home: Too Expensive" if variable == "tooExpensiveMainReason"
capture replace description = "Main Reason for Household Not Online at Home: Can Use Elsewhere" if variable == "canUseElsewhereMainReason"
capture replace description = "Main Reason for Household Not Online at Home: Not Available in Area" if variable == "unavailableMainReason"
capture replace description = "Main Reason for Household Not Online at Home: No/Inadequate Computer" if variable == "noComputerMainReason"
capture replace description = "Main Reason for Household Not Online at Home: Privacy or Security Concerns" if variable == "privSecMainReason"
capture replace description = "Anyone in Household Uses a Desktop, Laptop, or Tablet at Home" if variable == "computerAtHome"
capture replace description = "Mobile Data Plan Used from Any Location" if variable == "mobileDataPlan"
capture replace description = "Posts or Uploads Blog Posts, Videos, or Other Original Content" if variable == "publishingUser"
capture replace description = "Requests Services Provided by Other People via the Internet" if variable == "requestingServicesUser"
capture replace description = "Offers Services for Sale via the Internet" if variable == "offeringServicesUser"
capture replace description = "Uses the Internet to Sell Goods" if variable == "sellingGoodsUser"

/* Fill universes.
capture replace universe = "" if variable == "isPerson"
capture replace universe = "" if variable == "isHouseholder"
capture replace universe = "isPerson" if variable == "isAdult"
capture replace universe = "isPerson" if variable == "desktopUser"
capture replace universe = "isPerson" if variable == "laptopUser"
capture replace universe = "isPerson" if variable == "tabletUser"
capture replace universe = "isPerson" if variable == "mobilePhoneUser"
capture replace universe = "isPerson" if variable == "wearableUser"
capture replace universe = "isPerson" if variable == "tvBoxUser"
capture replace universe = "isPerson" if variable == "homeInternetUser"
capture replace universe = "isPerson" if variable == "workInternetUser"
capture replace universe = "isPerson" if variable == "schoolInternetUser"
capture replace universe = "isPerson" if variable == "cafeInternetUser"
capture replace universe = "isPerson" if variable == "travelingInternetUser"
capture replace universe = "isPerson" if variable == "libCommInternetUser"
capture replace universe = "isPerson" if variable == "altHomeInternetUser"
capture replace universe = "isPerson" if variable == "internetUser"
capture replace universe = "isAdult" if variable == "adultInternetUser"
capture replace universe = "isHouseholder" if variable == "internetAnywhere"
capture replace universe = "isHouseholder" if variable == "internetAtHome"
capture replace universe = "isHouseholder" if variable == "noInternetAtHome"
capture replace universe = "internetAtHome" if variable == "homeSubPrivateISP"
capture replace universe = "internetAtHome" if variable == "homeSubPublicISP"
capture replace universe = "internetAtHome" if variable == "homeIncludedInternet"
capture replace universe = "internetAtHome" if variable == "homePublicFreeInternet"
capture replace universe = "internetAtHome" if variable == "speedMostImportant"
capture replace universe = "internetAtHome" if variable == "reliabilityMostImportant"
capture replace universe = "internetAtHome" if variable == "affordabilityMostImportant"
capture replace universe = "internetAtHome" if variable == "serviceMostImportant"
capture replace universe = "internetAtHome" if variable == "mobilityMostImportant"
capture replace universe = "internetAtHome" if variable == "dataCapMostImportant"
capture replace universe = "internetAtHome" if variable == "mobileAtHome"
capture replace universe = "internetAtHome" if variable == "wiredHighSpeedAtHome"
capture replace universe = "internetAtHome" if variable == "satelliteAtHome"
capture replace universe = "internetAtHome" if variable == "dialUpAtHome"
capture replace universe = "internetAtHome" if variable == "ispBundle"
capture replace universe = "ispBundle" if variable == "tvInBundle"
capture replace universe = "ispBundle" if variable == "homePhoneInBundle"
capture replace universe = "ispBundle" if variable == "mobilePhoneInBundle"
capture replace universe = "ispBundle" if variable == "homeSecInBundle"
capture replace universe = "internetAnywhere" if variable == "mobileOutsideHome"
capture replace universe = "adultInternetUser" if variable == "emailUser"
capture replace universe = "adultInternetUser" if variable == "textIMUser"
capture replace universe = "adultInternetUser" if variable == "socialNetworkUser"
capture replace universe = "adultInternetUser" if variable == "callConfUser"
capture replace universe = "adultInternetUser" if variable == "webUser"
capture replace universe = "adultInternetUser" if variable == "videoUser"
capture replace universe = "adultInternetUser" if variable == "audioUser"
capture replace universe = "adultInternetUser" if variable == "locationServicesUser"
capture replace universe = "adultInternetUser" if variable == "teleworkUser"
capture replace universe = "adultInternetUser" if variable == "jobSearchUser"
capture replace universe = "adultInternetUser" if variable == "onlineClassUser"
capture replace universe = "adultInternetUser" if variable == "financeUser"
capture replace universe = "adultInternetUser" if variable == "eCommerceUser"
capture replace universe = "adultInternetUser" if variable == "homeIOTUser"
capture replace universe = "adultInternetUser" if variable == "healthInfoUser"
capture replace universe = "adultInternetUser" if variable == "healthRecordsUser"
capture replace universe = "adultInternetUser" if variable == "healthMonitoringUser"
capture replace universe = "noInternetAtHome" if variable == "homeEverOnline"
capture replace universe = "noInternetAtHome" if variable == "noNeedInterestMainReason"
capture replace universe = "noInternetAtHome" if variable == "tooExpensiveMainReason"
capture replace universe = "noInternetAtHome" if variable == "canUseElsewhereMainReason"
capture replace universe = "noInternetAtHome" if variable == "unavailableMainReason"
capture replace universe = "noInternetAtHome" if variable == "noComputerMainReason"
capture replace universe = "noInternetAtHome" if variable == "privSecMainReason"
capture replace universe = "isHouseholder" if variable == "computerAtHome"
capture replace universe = "internetAnywhere" if variable == "mobileDataPlan"
capture replace universe = "adultInternetUser" if variable == "publishingUser"
capture replace universe = "adultInternetUser" if variable == "requestingServicesUser"
capture replace universe = "adultInternetUser" if variable == "offeringServicesUser"
capture replace universe = "adultInternetUser" if variable == "sellingGoodsUser"
*/
