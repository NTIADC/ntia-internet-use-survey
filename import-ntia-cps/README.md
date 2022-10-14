# import-ntia-cps

*Tool for reading the raw NTIA Internet Use Survey datasets supplied by the U.S. Census Bureau and saving them in a native format*

NTIA uses `import-ntia-cps` to import the public use datasets supplied by the Census Bureau into native formats for use with R and Stata. The Census Bureau delivers NTIA Internet Use Survey datasets in a fixed ASCII format where each observation is contained on a separate line, and each variable is recorded at a particular set of byte locations on each line. Those locations are defined in a separate data dictionary, which is available as part of the [technical documentation](https://github.com/NTIADC/ntia-internet-use-survey/tree/main/tech-docs) accompanying each data release. For example, the first line of a data file might begin with the following text:

| 610905110108708112021

And the corresponding data dictionary might define the first few variables:

| Name    | Size | Description          | Location |
|---------|------|----------------------|----------|
| HRHHID  | 15   | Household Identifier | 1--15    |
| HRMONTH | 2    | Month of Interview   | 16--17   |
| HRYEAR4 | 4    | Year of Interview    | 18--21   |

The first observation in the dataset should therefore be assigned an HRHHID value of `610905110108708`, an HRMONTH value of `11`, and an HRYEAR4 value of `2021`. The same pattern is repeated for every line in the file.

In addition to the main data file, the Census Bureau also supplies additional files containing replicate weights, and in a couple of cases has also included auxiliary files that provide additional useful information. `import-ntia-cps` combines all files pertaining to a particular data collection into a single dataset in native format, and also performs a few other transformations to ease analysis, e.g., inserting decimal points where specified in the data dictionary. The resulting datasets are used by NTIA staff internally and are also [posted for public download](https://www.ntia.gov/page/download-ntia-internet-use-survey-datasets).

To use the R version of `import-ntia-cps`, `source("import.ntia.cps.R")` in the directory containing that file, and then run:

``` r
[myData <- ] import.ntia.cps("monYR", [save = F | T], [internal = F | T])
```

`import.ntia.cps()` takes three arguments, the last two of which are optional. First, specify the dataset to be imported as a string in `monYR` fomat, e.g., "nov21" for the November 2021 NTIA Internet Use Survey. `save` defaults to `false`, and if set to `true` will result in the created data.frame being saved as an RDS file in the current working directory (or in the hard-coded saveLocation directory, if `internal` is set to `true`). `internal` also defaults to `false`, and if set to `true` will use the locations for finding raw data files and for saving complete datasets that are specified in `import.ntia.cps.R`. Irrespective of these settings, `import.ntia.cps()` returns a data.frame containing the full imported data.

The Stata version of `import-ntia-cps` operates in a similar fashion. In a directory containing `import-ntia-cps.do`, type:

``` stata
run import-ntia-cps <monYR> [local | internal]
```

Where `<monYR>` specifies which NTIA Internet Use Survey dataset to import, and where choosing between the `local` and `internal` options works identically to the R version. Note however that the Stata version of this script will always save the resulting data as a DTA in either the current working directory or the hard-coded save location, as appropriate.

When using either version of this `import-ntia-cps`, it is important to include the supplied CSV (for R) or DCT (for Stata) files in the same directory as the script. These are the data dictionaries for the raw files provided by the Census Bureau in machine-readable formats appropriate to each software package.
