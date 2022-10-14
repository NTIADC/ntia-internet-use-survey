# ntia-internet-use-survey

*Sample Code and Tools for Working with NTIA Internet Use Survey Datasets*

This repository primarily consists of code written written by [NTIA](https://www.ntia.gov) staff to work with and analyze data from the [NTIA Internet Use Survey](https://www.ntia.gov/data). NTIA uses two different statistics packages when working with NTIA Internet Use Survey data, namely [Stata](https://www.stata.com) and [R](https://www.r-project.org). The files found here therefore are generally intended for use with one of those programs. We recommend that anyone interested in using NTIA Internet Use Survey datasets first [consult our overview](https://github.com/NTIADC/ntia-internet-use-survey/blob/main/tech-docs/README.md#new-to-the-ntia-internet-use-survey-important-notes-for-researchers), as well as the technical documentation provided for each dataset and the U.S. Census Bureau's [Technical Paper 77](https://www2.census.gov/programs-surveys/cps/methodology/CPS-Tech-Paper-77.pdf) (given that the NTIA Internet Use Survey is administered as a supplement to the Current Population Survey).

Note that the actual NTIA Internet Use Survey datasets are hosted within the [Data Central](https://www.ntia.gov/data) section of NTIA's website, specifically at <https://www.ntia.gov/page/download-ntia-internet-use-survey-datasets>. NTIA makes datasets available in Stata, R, and CSV formats, as well as in the original raw format provided by the Census Bureau.

## Contents of this Repository

-   [**create-ntia-tables**](https://github.com/NTIADC/ntia-internet-use-survey/tree/main/create-ntia-tables)**:** Used to produce the "analyze table" spreadsheet of pre-computed statistics used by [NTIA Data Explorer](https://www.ntia.gov/data/explorer). Currently only written in Stata.
-   [**import-ntia-cps**](https://github.com/NTIADC/ntia-internet-use-survey/tree/main/import-ntia-cps)**:** Takes the raw data files provided by the Census Bureau and produces datasets in native format, including through the addition of replicate weights and any other ancillary files as appropriate. Available for both R and Stata.
-   [**sample-code**](https://github.com/NTIADC/ntia-internet-use-survey/tree/main/sample-code)**:** Demonstration scripts that can be used to reproduce the calculations that appear in many [Data Central Blog](https://ntia.gov/data/blogs) posts. While most are currently written in Stata, more R scripts will appear here over time.
-   [**tech-docs**](https://github.com/NTIADC/ntia-internet-use-survey/tree/main/tech-docs)**:** All of the technical documents produced by the Census Bureau to accompany NTIA Internet Use Survey [public use datasets](https://www.ntia.gov/page/download-ntia-internet-use-survey-datasets), as well as additional information provided by NTIA.

**Questions?** Please don't hesitate to contact the NTIA Internet Use Survey team at [data\@ntia.gov](mailto:data@ntia.gov).
