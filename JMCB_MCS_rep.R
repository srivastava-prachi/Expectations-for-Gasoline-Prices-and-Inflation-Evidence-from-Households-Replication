#---------------------------------------------------------------#
#-----------MCS Gasoline and Inflation Expectations-------------#
#-----C. Burgi, P.Srivastava, K. Whelan (R&R JMCB)--------------#
#-------------------Replication File----------------------------#
#---------------------------------------------------------------#

rm(list = ls())

setwd("/Users/prachisrivastava/Desktop/Thesis/Project 1 Inflation and oil/Michigan Data")
if (!require("pacman")) install.packages("pacman")
pacman::p_load("readr", "tidyverse", "dplyr", "stargazer", "lubridate","vars", "readxl", "purrr", "fixest",
               "data.table")


#=============================================================#
#                  Michigan Consumer Survey                   #
#=============================================================#

# Load the Michigan Consumer Data------------

data <- read_csv("~/Desktop/Project 1/1_Clean/A_Input/data/MCS/mcs_same_obs.csv")%>% filter(YYYY %in% (1980:2022)) 

data$month <- as.numeric(substr(data$YYYYMM,5, 6))
data$obs_date <- as.Date(paste(data$YYYY, data$month, "01", sep = "-"))

data$PX1[abs(data$PX1) >= 96]=NA #NA are recoded as 96-99 VALUE LABEL -97 DK how much down 96 DK #how much up 98 DK whether up or down 99 NA Data type: numeric Missing-data codes: -97,96-* Record/columns: 1/115-117



# Load Gasoline in dollar price data----

gas_price <- read_excel("~/Desktop/Project 1/1_Clean/A_Input/data/Gasoline/Extend_gas.xls", sheet = "extending_gas")
gas_price$observation_date <- as.Date(gas_price$observation_date, format = "%Y-%m-%d")

colnames(gas_price)[4] <- "gas_price"



# Merge gasoline data and then subset for relevant variables----

data_mcs_subset <- merge(data, gas_price, by.x = "obs_date", by.y = "observation_date", all.x= TRUE)

# Creating gasoline expectations series---

data_mcs_subset$gas_cent_dollar = data_mcs_subset$GAS1/100
data_mcs_subset$gas_inflation   = (data_mcs_subset$gas_cent_dollar/data_mcs_subset$gas_price)*100


# Subset relevant series-----

data_mcs_subset <- data_mcs_subset%>% dplyr::select(c("obs_date", "newvar", "YYYY", "YYYYMM",
                                                      "PX1", "GAS1", "gas_price","gas_cent_dollar" ,
                                                      "gas_inflation"))






#================================================
#           Regression on Outliers               #
#================================================#


# Before removing outliers we study the relationshio between gas inflation and inflation expectations

mcs_full1 <- feols(PX1 ~ gas_inflation | newvar , data = data_mcs_subset)
mcs_full2 <- feols(PX1 ~ gas_inflation | newvar + YYYYMM, data = data_mcs_subset)

etable(mcs_full1,mcs_full2,  tex = FALSE)



# 2. Sample Period 1982-1992 and 2005-2013 (Stop before NY Fed)--------

mcs_sub_2_out <- data_mcs_subset %>% filter(YYYY %in% c(1982:2013))
mcs_sub_2_out <- mcs_sub_2_out %>% filter(YYYYMM <= "201305")
unique(mcs_sub_2_out$YYYYMM)


# Gasoline comes in April 1982 onwards
reg_s21o <- feols(PX1 ~ gas_inflation| newvar , data = mcs_sub_2_out) 
reg_s22o <- feols(PX1 ~ gas_inflation| newvar + YYYYMM, data = mcs_sub_2_out)

etable(reg_s21o,reg_s22o,  tex = FALSE)


# 3. Sample period from 1982 to 1992--------

mcs_sub_3_out <- data_mcs_subset%>% filter(YYYYMM >= "198201" & YYYYMM <= "199212")
unique(mcs_sub_3_out$YYYYMM) 

reg_s31o <- feols(PX1 ~ gas_inflation| newvar , data = mcs_sub_3_out)
reg_s32o <- feols(PX1 ~ gas_inflation| newvar + YYYYMM, data = mcs_sub_3_out)

etable(reg_s31o,reg_s32o, tex= FALSE)


# 4. Sample period from 2005 to 2013 May----------

mcs_sub_4_out <- data_mcs_subset%>% filter(YYYYMM >= "200501" & YYYYMM <= "201305") 

reg_s41o <- feols(PX1 ~ gas_inflation| newvar , data = mcs_sub_4_out)
reg_s42o <- feols(PX1 ~ gas_inflation| newvar + YYYYMM, data = mcs_sub_4_out)

etable(reg_s41o,reg_s42o, tex= FALSE)



# 5. Sample Period from 2005 to 2022-------

mcs_sub_5_out <- data_mcs_subset %>% filter(YYYY >= "2005")
unique(mcs_sub_5_out$YYYYMM)

reg_s51o <- feols(PX1 ~ gas_inflation| newvar , data = mcs_sub_5_out)
reg_s52o <- feols(PX1 ~ gas_inflation| newvar + YYYYMM, data = mcs_sub_5_out)

etable(reg_s51o,reg_s52o, tex= FALSE)


# 6. MCS with sample size overlapping NY Fed from 2013 June to 2022 Dec--------

mcs_sub_6_out <- data_mcs_subset %>% filter(YYYYMM >= "201306" & YYYYMM <= "202212")
unique(mcs_sub_6_out$YYYYMM)

reg_s61o <- feols(PX1 ~ gas_inflation| newvar , data = mcs_sub_6_out)
reg_s62o <- feols(PX1 ~ gas_inflation| newvar + YYYYMM, data = mcs_sub_6_out)


etable(reg_s61o , reg_s62o, tex= FALSE)




#-------Etable for Sample Split including Outliers----------

etable(mcs_full2, reg_s22o, reg_s32o,reg_s42o,reg_s52o , reg_s62o,tex= FALSE)




#============================================================================
#                      Cleaning for Outliers (Gas and Inf)                  #
#===========================================================================#


# Cleaning data function-----

calculate_min_max <- function(variable, x, y) {
  min_value <- min(variable, na.rm = TRUE)
  max_value <- max(variable, na.rm = TRUE)
  num_obs <- sum(!is.na(variable))
  num_obs_min <- sum(variable == min_value, na.rm = TRUE)
  num_obs_max <- sum(variable == max_value, na.rm = TRUE)
  perc_x <- quantile(variable, x, na.rm = TRUE)
  perc_y <- quantile(variable, y, na.rm = TRUE)
  num_obs_between_x_and_y <- sum(variable >= perc_x & variable <= perc_y, na.rm = TRUE)
  
  result <- data.frame(
    min_value = min_value,
    max_value = max_value,
    num_obs = num_obs,
    num_obs_min = num_obs_min,
    num_obs_max = num_obs_max,
    perc_x = perc_x,
    perc_y = perc_y,
    num_obs_between_x_and_y = num_obs_between_x_and_y)
  
  return(result)
}

# Core variables as inflation expectations and gas price inflation expectations-----

mcs_variables <- c("PX1", "GAS1","gas_inflation")
lapply(data_mcs_subset[mcs_variables], calculate_min_max, x = 0.05, y = 0.95)


# Trimming the data at top and bottom 5 percent-------

data_mcs_cleaned <- data_mcs_subset # Copy the original dataset


trim_limits <- lapply(data_mcs_cleaned[mcs_variables], function(var) {
  list(
    lower = quantile(var, 0.05, na.rm = TRUE),
    upper = quantile(var, 0.95, na.rm = TRUE)
  )
}) # We trim here at top and bottom 5 percent


for (var in mcs_variables) {
  lower_limit <- trim_limits[[var]]$lower
  upper_limit <- trim_limits[[var]]$upper
  
  data_mcs_cleaned <- data_mcs_cleaned %>%
    filter(!!sym(var) >= lower_limit & !!sym(var) <= upper_limit)
}

# Verify the trimming
trimmed_stats <- lapply(data_mcs_cleaned[mcs_variables], calculate_min_max, x = 0.0, y = 1)
print(trimmed_stats)



#================================================================
#   Regressions Michigan Consumer Survey  5%-95% trimmed        #
#===============================================================#


# 1. Full Sample 1990-09 to 2022-12--------
unique(data_mcs_cleaned$YYYYMM)

reg_1 <- feols(PX1 ~ gas_inflation | newvar, data = data_mcs_cleaned)
reg_2 <- feols(PX1 ~ gas_inflation | newvar  + obs_date , data = data_mcs_cleaned)

etable(reg_1, reg_2 , tex = FALSE, 
       dict = c( PX1 = "\\$E_{t}\\pi_{t+12|t}\\$",
                 gas_exp = "\\$E_{t}\\pi_{t+12|t}\\^{gas}$"), title = "Michigan Consumer Survey")



# 2. Sample Period 1982-1992 and 2005-2013 (Stop before NY Fed)--------

mcs_sub_2 <- data_mcs_cleaned %>% filter(YYYY %in% c(1982:2013))
mcs_sub_2 <- mcs_sub_2 %>% filter(YYYYMM <= "201305")
unique(mcs_sub_2$YYYYMM)


# Gasoline comes in April 1982 onwards
reg_s21 <- feols(PX1 ~ gas_inflation| newvar , data = mcs_sub_2) 
reg_s22 <- feols(PX1 ~ gas_inflation| newvar + YYYYMM, data = mcs_sub_2)

etable(reg_s21,reg_s22,  tex = FALSE, 
       dict = c( PX1 = "\\$E_{t}\\pi_{t+12|t}\\$",
                 gas_exp = "\\$E_{t}\\pi_{t+12|t}\\^{gas}$"), title = "")


# 3. Sample period from 1982 to 1992--------

mcs_sub_3 <- data_mcs_cleaned%>% filter(YYYYMM >= "198201" & YYYYMM <= "199212")
unique(mcs_sub_3$YYYYMM) 
# 
reg_s31 <- feols(PX1 ~ gas_inflation| newvar , data = mcs_sub_3)
reg_s32 <- feols(PX1 ~ gas_inflation| newvar + YYYYMM, data = mcs_sub_3)
# 
etable(reg_s31,reg_s32, tex= FALSE)


# 4. Sample period from 2005 to 2013 May----------

mcs_sub_4 <- data_mcs_cleaned%>% filter(YYYYMM >= "200501" & YYYYMM <= "201305") 

reg_s41 <- feols(PX1 ~ gas_inflation| newvar , data = mcs_sub_4)
reg_s42 <- feols(PX1 ~ gas_inflation| newvar + YYYYMM, data = mcs_sub_4)

etable(reg_s41,reg_s42, tex= FALSE)



# 5. Sample Period from 2005 to 2022-------

mcs_sub_5 <- data_mcs_cleaned %>% filter(YYYY >= "2005")
unique(mcs_sub_5$YYYYMM)

reg_s51 <- feols(PX1 ~ gas_inflation| newvar , data = mcs_sub_5)
reg_s52 <- feols(PX1 ~ gas_inflation| newvar + YYYYMM, data = mcs_sub_5)

etable(reg_s51,reg_s52, tex= FALSE)


# 6. MCS with sample size overlapping NY Fed from 2013 June to 2022 Dec--------

mcs_sub_6 <- data_mcs_cleaned %>% filter(YYYYMM >= "201306" & YYYYMM <= "202212")
unique(mcs_sub_6$YYYYMM)

reg_s61 <- feols(PX1 ~ gas_inflation| newvar , data = mcs_sub_6)
reg_s62 <- feols(PX1 ~ gas_inflation| newvar + YYYYMM, data = mcs_sub_6)


etable(reg_s61 , reg_s62, tex= FALSE)




#-------Etable for Sample Split----------

etable(reg_2, reg_s22,reg_s32,reg_s42,reg_s52 , reg_s62, tex= FALSE)





#========================================================================
#               APPENDIX with Actual Gasoline Prics                      #
#========================================================================#

actual_gas_inf <-   read_csv("~/Desktop/Project 1/1_Clean/A_Input/data/Gasoline/CUSR0000SETB01.csv")
colnames(actual_gas_inf)[2] <- "actual_gas_inf"



# Michigan CS Appendix

actual_gas_mcs <- merge(data_mcs_cleaned, actual_gas_inf, by.x = "obs_date", by.y = "DATE", all.x = TRUE)
lapply(actual_gas_mcs[mcs_variables], calculate_min_max, x = 0.0, y = 1)


#=======================================================#
#             Regression for Appendix                   #
#=======================================================#
# 1. Full Sample 1990-09 to 2022-12--------
unique(actual_gas_mcs$YYYYMM)

reg_1a <- feols(PX1 ~ actual_gas_inf | newvar, data = actual_gas_mcs)

# 2. Sample Period 1982-1992 and 2005-2013 (Stop before NY Fed)--------

mcs_sub_2a <- actual_gas_mcs %>% filter(YYYY %in% c(1982:2013))
mcs_sub_2a <- mcs_sub_2a %>% filter(YYYYMM <= "201305")
unique(mcs_sub_2a$YYYYMM)

reg_2a <- feols(PX1 ~ actual_gas_inf| newvar , data = mcs_sub_2a) 


# 3. Sample period from 1982 to 1992--------

mcs_sub_3a <- actual_gas_mcs%>% filter(YYYYMM >= "198201" & YYYYMM <= "199212")
unique(mcs_sub_3a$YYYYMM) 

reg_3a <- feols(PX1 ~ actual_gas_inf| newvar , data = mcs_sub_3a)


# 4. Sample period from 2005 to 2013 May----------

mcs_sub_4a <- actual_gas_mcs%>% filter(YYYYMM >= "200501" & YYYYMM <= "201305") 

reg_4a <- feols(PX1 ~ actual_gas_inf| newvar , data = mcs_sub_4a)



# 5. Sample Period from 2005 to 2022-------

mcs_sub_5a <- actual_gas_mcs %>% filter(YYYY >= "2005")
unique(mcs_sub_5a$YYYYMM)

reg_5a <- feols(PX1 ~ actual_gas_inf| newvar , data = mcs_sub_5a)


# 6. MCS with sample size overlapping NY Fed from 2013 June to 2022 Dec--------

mcs_sub_6a <- actual_gas_mcs %>% filter(YYYYMM >= "201306" & YYYYMM <= "202212")
unique(mcs_sub_6a$YYYYMM)

reg_6a <- feols(PX1 ~ actual_gas_inf| newvar , data = mcs_sub_6a)



#-------Etable for Sample Split----------

etable(reg_1a, reg_2a, reg_3a,reg_4a,reg_5a,reg_6a,
       tex= FALSE, title = "Michigan Consumer Survey: Different sample periods ")

