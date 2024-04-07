#### Preamble ####
# Purpose: Test for any errors or missteps in the data cleaning process
# Author: Sandy Yu
# Date: 2 April 2024
# Contact: jingying.yu@mail.utoronto.ca
# License: MIT
# Pre-requisites: cleaned data and created parquets for each dataset


#### Workspace setup ####
library(tidyverse)
library(arrow)
library(dplyr)
library(lubridate)
library(readr)

#### Load data ####
cleaned_exchange_rate <- read_parquet("data/analysis_data/cleaned_exchange_rate.parquet")
cleaned_inauguration <- read_parquet("data/analysis_data/cleaned_inauguration.parquet")
exchange_inaug <- read_parquet("data/analysis_data/exchange_inaug.parquet")

#### Test data ####

# Test for consistency in value assignment for inauguration_period and change_party columns in exchange_inaug
# Define a function to get the exchange rates around each inauguration date and add change_party column
get_date_range <- function(inauguration_date, change_party, cleaned_exchange_rate) {
  date_range <- seq(inauguration_date - 3, inauguration_date + 3, by = "days")
  rates <- cleaned_exchange_rate %>% filter(date %in% date_range)
  rates$change_party <- change_party
  return(rates)
}

# Apply the function to each row in the inauguration dataframe
list_of_df <- mapply(get_date_range, 
                     cleaned_inauguration$inauguration_date, 
                     cleaned_inauguration$change_party, 
                     MoreArgs = list(cleaned_exchange_rate = cleaned_exchange_rate),
                     SIMPLIFY = FALSE)

# Combine the list of dataframes into one
inaug_exchange_rate <- bind_rows(list_of_df)

# Remove the gathered exchange rates from the original exchange rate dataframe
exchange_rate_remaining <- cleaned_exchange_rate %>%
  anti_join(inaug_exchange_rate, by = "date")

test_inaug <- exchange_inaug |> filter(exchange_inaug$inauguration_period == 1)
nrow(test_inaug) == nrow(inaug_exchange_rate)

test_non_inaug <- exchange_inaug |> filter(exchange_inaug$inauguration_period == 0)
nrow(test_non_inaug) == nrow(exchange_rate_remaining)



# Test for class of each column for all datasets
class(cleaned_inauguration$president) == "character"
class(cleaned_inauguration$party) == "character"
class(cleaned_inauguration$inauguration_date) == "Date"
class(cleaned_inauguration$change_party) == "integer"

class(cleaned_exchange_rate$date) == "Date"
class(cleaned_exchange_rate$exchange_rate) == "numeric"

class(exchange_inaug$date) == "Date"
class(exchange_inaug$exchange_rate) == "numeric"
class(exchange_inaug$change_party) == "numeric"
class(exchange_inaug$inauguration_period) == "numeric"



# Test for any missing values in the datasets
all(complete.cases(cleaned_inauguration)) == TRUE
all(complete.cases(cleaned_exchange_rate)) == TRUE
all(complete.cases(exchange_inaug)) == TRUE

