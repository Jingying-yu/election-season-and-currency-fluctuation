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

cleaned_exchange_rate <- read_parquet("data/analysis_data/cleaned_exchange_rate.parquet")
cleaned_inauguration <- read_parquet("data/analysis_data/cleaned_inauguration.parquet")
exchange_rate_remaining <- read_parquet("data/analysis_data/exchange_rate_remaining.parquet")
inaug_exchange_rate <- read_parquet("data/analysis_data/inaug_exchange_rate.parquet")
#### Test data ####
# Test for class of each column for all datasets
class(cleaned_inauguration$president) == "character"
class(cleaned_inauguration$party) == "character"
class(cleaned_inauguration$inauguration_date) == "Date"
class(cleaned_inauguration$change_party) == "integer"

class(cleaned_exchange_rate$date) == "Date"
class(cleaned_exchange_rate$exchange_rate) == "numeric"

class(inaug_exchange_rate$date) == "Date"
class(inaug_exchange_rate$exchange_rate) == "numeric"
class(inaug_exchange_rate$change_party) == "integer"

class(exchange_rate_remaining$date) == "Date"
class(exchange_rate_remaining$exchange_rate) == "numeric"


# Test for any missing values in the datasets
all(complete.cases(cleaned_inauguration)) == TRUE
all(complete.cases(cleaned_exchange_rate)) == TRUE
all(complete.cases(inaug_exchange_rate)) == TRUE
all(complete.cases(exchange_rate_remaining)) == TRUE

