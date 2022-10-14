# create-ntia-tables

*Tool used to create the spreadsheet of summary statistics that powers [NTIA Data Explorer](https://www.ntia.gov/data/explorer)*

NTIA uses `create-ntia-tables` to automatically generate a large spreadsheet of summary statistics from NTIA Internet Use Survey datasets. NTIA staff export the resulting file, `ntia-analyze-table.dta`, to a CSV to serve as the data source used by [Data Explorer](https://www.ntia.gov/data/explorer) for all visualizations. Currently, this tool is only written for use with Stata.

Required files include `create-ntia-tables.do`, `master-labels.do`, and a number of dataset-specific files named using the `<monYR>-tables.do` convention. `master-labels.do` adds plain English descriptions for each metric, while the `<monYR>-tables.do` files are used to recode variables in each dataset to yield the common metrics and demographic breakouts tracked in the spreadsheet. Users should also [download all datasets](https://www.ntia.gov/page/download-ntia-internet-use-survey-datasets) they want used in the output in Stata format. Set the working directory to the location of the .do files and type:

``` stata
run create-ntia-tables <monYR>[...] [local | internal]
```

Where `<monYR>` specifies each NTIA Internet Use Survey dataset to be used, with multiple datasets separated by a space. The `local` option indicates that the script should look in the current working directory for all datasets. The alternative `internal` option instead points to the location where NTIA staff happen to store datasets for quick access; if desired, users can change the location indicated in the script from `D:\Stata` to a different location and use `internal` rather than `local`. The script also references a `remote` option that would download datasets as needed from the NTIA website; however, this option has not yet been implemented.

**Please note that `create-ntia-tables` will take a long time to complete (particularly when processing newer datasets that provide replicate weights) and currently does not provide any indications of progress.** Building the entire spreadsheet used in Data Explorer can take several days of compute time.

When it completes, the script will write the results to `ntia-analyze-table.dta`, either in the current working directory (if using the `local` option) or the specified dataset directory (if using `internal`). If an `ntia-analyze-table.dta` dataset already exists at that location, the script will replace only those observations from datasets it just processed, and will add observations from datasets not currently represented in the file; all other existing observations will be preserved. This enables users to, for example, add estimates from a new dataset without needing to re-process datasets already in the file.

## Data Dictionary for ntia-analyze-table

### Overview

The output file contains pre-computed statistics for time-series variables being tracked in the NTIA Internet Use Survey. With this file, data users can quickly look up percentages and population counts across various demographics for variables of interest. The 348 columns for each observation are structured as follows:

1.  *dataset:* Specifies the month and year of the survey as a string, in "Mon YYYY" format. The Current Population Survey (CPS) is a monthly survey, and NTIA periodically sponsors the NTIA Internet Use Survey as a CPS supplement.

2.  *variable:* Contains the standardized name of the variable being measured. NTIA identified the availability of similar data across surveys, and assigned variable names to ease time-series comparisons.

3.  *description:* Provides a concise description of the variable.

4.  *universe:* Specifies the variable representing the universe of persons or households included in the variable's statistics. The specified variable is always included in the file. The only variables lacking universes are isPerson and isHouseholder, as they are themselves the broadest universes measured in the CPS. Note that estimates for many variables are available for multiple universes; for example, estimates of households using different types of home Internet access services are available in terms of all households as well as households reporting home Internet use. Each unique combination of variable, universe, and dataset has its own row in the file.

5.  A large number of *Prop,* *PropSE*, *Count, and* *CountSE* columns comprise the remainder of the columns. For each demographic being measured (see below), four statistics are produced, including the estimated proportion of the group for which the variable is true (*Prop)*, the standard error of that proportion (*PropSE*), the estimated number of persons or households in that group for which the variable is true (*Count*), and the standard error of that count (*CountSE*).

### Demographic Categories

1.  *us:* The usProp, usPropSE, usCount, and usCountSE columns contain statistics about all persons and households in the universe (which represents the population of the fifty states and the District and Columbia). For example, to see how the prevelance of Internet use by Americans has changed over time, look at the usProp column for each survey's internetUser variable.

2.  *age:* The age category is divided into five ranges: ages 3-14, 15-24, 25-44, 45-64, and 65+. The CPS only includes data on Americans ages 3 and older. Also note that household reference persons must be at least 15 years old, so the age314\* columns are blank for household-based variables. Those columns are also blank for person-based variables where the universe is "isAdult" (or a sub-universe of "isAdult"), as the CPS defines adults as persons ages 15 or older. Finally, note that some variables where children are technically in the univese will show zero values for the age314\* columns. This occurs in cases where a variable simply cannot be true of a child (e.g. the workInternetUser variable, as the CPS presumes children under 15 are not eligible to work), but the topic of interest is relevant to children (e.g. locations of Internet use).

3.  *work:* Employment status is divided into "Employed," "Unemployed," and "NILF" (Not in the Labor Force). These three categories reflect the BLS definitions used in official labor force statistics. Note that employment status is only recorded in the CPS for individuals ages 15 and older. As a result, children are excluded from the universe when calculating statistics by work status, even if they are otherwise considered part of the universe for the variable of interest.

4.  *income:* The income category represents annual family income, rather than just an individual person's income. It is divided into five ranges: below \$25K, \$25K-49,999, \$50K-74,999, \$75K-99,999, and \$100K or more. Statistics by income group are only available in this file for Supplements beginning in 2010; prior to 2010, family income range is available in public use datasets, but is not directly comparable to newer datasets due to the 2010 introduction of the practice of allocating "don't know," "refused," and other responses that result in missing data. Prior to 2010, family income is unkown for approximately 20 percent of persons, while in 2010 the Census Bureau began imputing likely income ranges to replace missing data.

5.  *education:* Educational attainment is divided into "No Diploma," "High School Grad," "Some College," and "College Grad." High school graduates are considered to include GED completers, and those with some college include community college attendees (and graduates) and those who have attended certain postsecondary vocational or technical schools--in other words, it signifies additional education beyond high school, but short of attaining a bachelor's degree or equivilent. Note that educational attainment is only recorded in the CPS for individuals ages 15 and older. As a result, children are excluded from the universe when calculating statistics by education, even if they are otherwise considered part of the universe for the variable of interest.

6.  *sex:* "Male" and "Female" are the two groups in this category.

7.  *race:* This category includes "White," "Black," "Hispanic," "Asian," "Am Indian," and "Other" groups. The CPS asks about Hispanic origin separately from racial identification; as a result, all persons identifying as Hispanic are in the Hispanic group, regardless of how else they identify. Furthermore, all non-Hispanic persons identifying with two or more races are tallied in the "Other" group (along with other less-prevelant responses). The Am Indian group includes both American Indians and Alaska Natives.

8.  *disability:* Disability status is divided into "No" and "Yes" groups, indicating whether the person was identified as having a disability. Disabilities screened for in the CPS include hearing impairment, vision impairment (not sufficiently correctable by glasses), cognitive difficulties arising from physical, mental, or emotional conditions, serious difficulty walking or climbing stairs, difficulty dressing or bathing, and difficulties performing errands due to physical, mental, or emotional conditions. The Census Bureau began collecting data on disability status in June 2008; accordingly, this category is unavailable in Supplements prior to that date. Note that disability status is only recorded in the CPS for individuals ages 15 and older. As a result, children are excluded from the universe when calculating statistics by disability status, even if they are otherwise considered part of the universe for the variable of interest.

9.  *metro:* Metropolitan status is divided into "No," "Yes," and "Unkown," reflecting information in the dataset about the household's location. A household located within a metropolitan statistical area is assigned to the Yes group, and those outside such areas are assigned to No. However, due to the risk of de-anonymization, the metropolitan area status of certain households is unidentified in public use datasets. In those cases, the Census Bureau has determined that revealing this geographic information poses a disclosure risk. Such households are tallied in the Unknown group.

10. *scChldHome:* This category represents whether a household has any school-age children living at home, and is divided into "No" and "Yes" groups. School-age children are defined as individuals between the ages of 6 and 17 who are not the household reference person or that person's spouse.

11. *veteran:* Veteran status is divided into "No" and "Yes" groups, indicating whether the person has ever served on active duty in the U.S. armed forces. Because the CPS does not gather data on individuals who are currently on active duty, they are not included in the definition of "veteran." Note that vateran status is only recorded in the CPS for individuals ages 17 and older (as opposed to employment, education, and disability, which are recorded for ages 15 and older). As a result, persons younger than 17 are excluded from the universe when calculating statistics by veteran status, even if they are otherwise considered part of the universe for the variable of interest.

12. *\<state code\>:* Each state has estimates for its own population, denoted by the two-letter state code at the beginning of each field. This includes all 50 states and the District of Columbia.
