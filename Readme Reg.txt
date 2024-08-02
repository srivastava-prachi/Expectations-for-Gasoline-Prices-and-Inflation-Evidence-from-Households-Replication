{\rtf1\ansi\ansicpg1252\cocoartf2761
\cocoatextscaling0\cocoaplatform0{\fonttbl\f0\fmodern\fcharset0 Courier;}
{\colortbl;\red255\green255\blue255;\red0\green0\blue0;}
{\*\expandedcolortbl;;\cssrgb\c0\c0\c0;}
\paperw11900\paperh16840\margl1440\margr1440\vieww25920\viewh15880\viewkind0
\deftab720
\pard\pardeftab720\partightenfactor0

\f0\fs26 \cf0 \expnd0\expndtw0\kerning0
This ReadMe.txt file was generated on [2024-07-25] by [Prachi Srivastava]\
\
\
-------------------\
GENERAL INFORMATION\
-------------------\
\
\
1. Title and DOI of Dataset \
\
Supplementary materials for "Gasoline and Inflation Expectations" \uc0\u8239  \
\
2. Author Information\
\
  Associate or Co-investigator Contact Information\
        Name: Dr Constantin B\'fcrgi\
           Institution: UCD\
           Address: Dublin 4\
           Email: constantin.burgi@ucd.ie\
	   ORCiD: \
\
  Investigator Contact Information\
        Name: Professor Karl Whelan\
           Institution: UCD\
           Address: Dublin 4\
           Email: karl.whelan@ucd.ie\
	   ORCiD: 0000-0002-4831-5269\
\
\
  Associate or Co-investigator Contact Information\
        Name: Prachi Srivastava\
           Institution: UCD\
           Address: Dublin 4\
           Email: prachi.srivastava@ucdconnect.ie\
	   ORCiD: 0000-0003-0984-5336\
\
\
\
3. Data collection \
\
\
The data has been collected from publicly available sources.\
\
\
4. Location of data collection: \
\
The raw data is from three different sources: \
mcs_same_obs.csv, FRBNY-SCE-Public-Microdata-Complete-13-16.csv, FRBNY-SCE-Public-Microdata-Complete-17-19.csv,\
frbny-sce-public-microdata-latest.csv \
and CUSR0000SETB01.csv\
\
\
5. Information about funding sources that supported the collection of the data:\
\
None. All data is publicly available and free to download.\
\
\
\
\
--------------------------\
SHARING/ACCESS INFORMATION\
-------------------------- \
\
\
1. Licenses/restrictions placed on the data:\
\
None.\
\
\
\
---------------------\
DATA & FILE OVERVIEW\
---------------------\
\
\
1. File List in folder \'93data\'94\
   A. Filename: mcs_same_obs.csv     \
      Short description: Michigan Consumer Survey raw data\
\
      Filename: FRBNY-SCE-Public-Microdata-Complete-13-16.csv, FRBNY-SCE-Public-Microdata-Complete-17-19.csv, frbny-sce-public-microdata-latest.csv \
      Short description: New York Fed Survey of Consumer Expectations raw data\
\
      Filename: CUSR0000SETB01.csv and Extend_gas.xls\
      Short description: Actual Gasoline price and gasoline inflation data. In Extend_gas.xls we have final series of actual gasoline prices\
        \
\
\
2. File List in folder \'93R \'93Codes\
   A. Filenames: JMCB_trim_mcs.R      \
      Short description: Cleaning of data for MCS and Regression results      \
\
\
        \
   B. Filenames: JMCB_trim_nyf.R      \
      Short description: Cleaning of data for NY Fed SCE and Regression results      \
     \
\
\
\
\
--------------------------\
METHODOLOGICAL INFORMATION\
--------------------------\
\
\
1. Description of methods used for collection/generation of data: \
\
The data was collected from the Michigan Consumer Survey, NY Fed SCE and Gasoline Data form open sources\
\
\
2. Methods for processing the data: \
\
The data was processed as detailed in the script JMCB_trim_mcs.R and JMCB_trim_nyf.R\
\
\
3. Instrument- or software-specific information needed to interpret the data:\
\
R programming language is required to replicate the analysis.\
\
\
4. People involved with sample collection, processing, analysis and/or submission:\
\
Prachi Srivastava and Constantin B\'fcrgi\
\
\
\
-----------------------------------------\
DATA-SPECIFIC INFORMATION FOR: [mcs_same_obs.csv]\
-----------------------------------------\
\
\
1. Number of variables: 2 (PX1, GAS1)\
2. GAS1 has been changed in to gasoline dollar price called gas_inflation \
\
-----------------------------------------\
DATA-SPECIFIC INFORMATION FOR: [FRBNY-SCE-Public-Microdata-Complete-13-16.csv, FRBNY-SCE-Public-Microdata-Complete-17-19.csv, frbny-sce-public-microdata-latest.csv ]\
-----------------------------------------\
\
\
1. Number of variables: 2 (Q8v2part2, C4_1)\
\
\
\
\
\
\
                                                             \
}