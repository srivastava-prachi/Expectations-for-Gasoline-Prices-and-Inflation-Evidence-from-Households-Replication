# Replication codes for Gasoline and Inflation Expectations

This git repository contains all the code to replicate the results of the paper: "Gasoline and Inflation Expectations". 
The working-paper version is available here. Virtually all code is based on the R platform.

The present replication package is built as an R package that can be easily installed on any system. The data is used from publically available data sourcces.
1. https://data.sca.isr.umich.edu/ - Michigan Consumer Survey
2. https://www.newyorkfed.org/microeconomics/databank.html - NY Fed Survey of Consumer Expectations
3. https://fred.stlouisfed.org/series/ - St Louis Fed data for Gasoline CPI series and Gasoline prices.

If you have any questions or comments, please contact us or use directly the issue page on the GitHub repository.

# Overview of the replication package

## Organization of the code

VARreplicationdata.xlsx contains the data used for Figures 1 & 2 as well as to produce Table 3 in the paper. 
VARreplication.r is the r-script used to produce Table 3 based on the data in VARreplicationdata.xlsx.

For Household surveys, we use two different data sources as mentioned:

### 1. FRBNY SCE data set has three microdata files: which contain data used in Tables 1 and 2

frbny-sce-public-microdata-latest.csv, 
FRBNY-SCE-Public-Microdata-Complete-17-19.csv,
FRBNY-SCE-Public-Microdata-Complete-13-16.csv

JMCB_NyFed_rep.R contains the codes used to produce these regression results using the three above data sources. The files also clean the data sets by trimming them at 5-95 per cent.

### 2. Michigan Consumer Survey:

mcs_same_obs.csv is the microdata used to get the results for Tables 1 and  2 
JMCB_MCS_rep.R contains the codes used to produce these regression results using the above data sources. The files also clean the data sets by trimming them at 5-95 per cent.

In addition to this, there is another data (Extend_gas.xls) we have used to extend the gasoline price series which has been used in Michigan to convert cents to dollars for changes in 
gasoline price expectations.

We also have CUSR0000SETB01.csv data on Actual gasoline inflation.


