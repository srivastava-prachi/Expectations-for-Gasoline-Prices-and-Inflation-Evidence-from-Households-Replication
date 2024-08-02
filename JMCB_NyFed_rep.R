#---------------------------------------------------------------#
#-----------NY Fed Gasoline and Inflation Expectations----------#
#-----C. Burgi, P.Srivastava, K. Whelan (R&R JMCB)--------------#
#-------------------Replication File----------------------------#
#---------------------------------------------------------------#

rm(list = ls())


if (!require("pacman")) install.packages("pacman")
pacman::p_load("readr", "tidyverse", "dplyr", "stargazer", "lubridate","vars", "readxl", "purrr", "fixest",
               "data.table")


#====================================================#
#---------New York Fed Data (already cleaned)--------#
#=====================================================#


# Load SCE csv files-------

mydata1 <- fread("/Users/prachisrivastava/Desktop/Replication/data/NY Fed/FRBNY-SCE-Public-Microdata-Complete-13-16.csv") #56444
mydata2 <- fread("/Users/prachisrivastava/Desktop/Replication/data/NY Fed/FRBNY-SCE-Public-Microdata-Complete-17-19.csv") #47681
mydata3 <- fread("/Users/prachisrivastava/Desktop/Replication/data/NY Fed/frbny-sce-public-microdata-latest.csv") # 54500

mydata = unique(rbindlist(list(mydata1, mydata2, mydata3), use.names = TRUE, fill = TRUE)) #158625

# Formatting the date

mydata$year        <- paste(substr(mydata$date, 1, 4))
mydata$month       <- paste(substr(mydata$date, 5, 6))

mydata$date_char   <- paste(substr(mydata$date, 1, 4), "-", substr(mydata$date, 5, 6), sep = "")
mydata$date_char   <- as.Date(mydata$date_char, format = "%Y-%m")

mydata$date_char   <- ymd(paste0(mydata$date , "01"))
mydata$yearmon     <- format(mydata$date_char  , "%Y-%m")
mydata$survey_date <- as.Date(mydata$survey_date, format = "%d/%m/%Y")


# Filter the data until 2022 Dec---------
mydata <- mydata%>%filter(date_char <= "2022-12-01") #149096
mydata <- as.data.frame(mydata)


#================================================
#           Regression on Outliers               #
#================================================#


# Before removing outliers we study the relationshio between gas inflation and inflation expectations


nyf_full<- feols(Q8v2part2 ~ C4_1 | userid + survey_date, data = mydata) # This includes outliers

etable(nyf_full,  tex = FALSE)



#================================================
#   Cleaning for Outliers (Gas and Inf)          #
#================================================#


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

nyf_variables <-  c("Q8v2part2", "Q9_mean", "C4_1")
lapply(mydata[nyf_variables], calculate_min_max, x = 0.05, y = 0.95)


# Trimming the data at top and bottom 5 percent-------

data_nyf_cleaned <- mydata # Copy the original dataset


trim_limits <- lapply(data_nyf_cleaned[nyf_variables], function(var) {
  list(
    lower = quantile(var, 0.05, na.rm = TRUE),
    upper = quantile(var, 0.95, na.rm = TRUE)
  )
}) # We trim here at top and bottom 5 percent


for (var in nyf_variables) {
  lower_limit <- trim_limits[[var]]$lower
  upper_limit <- trim_limits[[var]]$upper
  
  data_nyf_cleaned <- data_nyf_cleaned %>%
    filter(!!sym(var) >= lower_limit & !!sym(var) <= upper_limit)
}



# Verify the trimming
trimmed_stats <- lapply(data_nyf_cleaned[nyf_variables], calculate_min_max, x = 0.0, y = 1)
print(trimmed_stats)




# Load Actual Gasoline data----------
actual_gas_inf <-   read_csv("~/Desktop/Project 1/1_Clean/A_Input/data/Gasoline/CUSR0000SETB01.csv")
colnames(actual_gas_inf)[2] <- "actual_gas_inf"


# Merge Data for Actual Gasoline dollars and Inflation with gasoline expectations-------

data_nyf_cleaned <- merge(data_nyf_cleaned, actual_gas_inf, by.x = "date_char", by.y = "DATE", all.x  = TRUE)


data_nyf_cleaned <- data_nyf_cleaned%>% dplyr::select(c("date_char", "userid", "survey_date","Q8v2part2", "C4_1", "actual_gas_inf"))



#=============================================================
#  Cleaned Regressions New York Fed SCE    5-95 trimming      #
#=============================================================#

# We estimate individual and individual Time FE (Here we use Survey_date time fixed effects as its more tight)

reg_ny_1 <- feols(Q8v2part2 ~ C4_1| userid , data = data_nyf_cleaned)
reg_ny_2 <- feols(Q8v2part2 ~ C4_1| userid + survey_date, data = data_nyf_cleaned)

etable(reg_ny_1,reg_ny_2,tex= FALSE)




#=============================================================================
#  Cleaned Actual gasoline Regressions New York Fed SCE    5-95 trimming      #
#=============================================================================#

# We estimate individual and individual Time FE (Here we use Survey_date time fixed effects as its more tight)

reg_ny_actual  <- feols(Q8v2part2 ~ actual_gas_inf| userid, data = data_nyf_cleaned)

etable(reg_ny_actual,tex= FALSE)



