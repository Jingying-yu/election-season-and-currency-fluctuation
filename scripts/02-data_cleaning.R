#### Preamble ####
# Purpose: Cleans the raw data, keeping only variables we need to explore
# Author: Sandy Yu
# Date: 2 April 2024
# Contact: jingying.yu@mail.utoronto.ca
# License: MIT
# Pre-requisites: downloaded appropriate datasets and understood what variables needed keeping.


#### Workspace setup ####
library(tidyverse)
library(readr)
library(lubridate)
library(arrow)

#### Clean data ####
raw_exchange_rate <- read_csv("data/raw_data/raw_exchange_rate.csv")
raw_inauguration <- read_csv("data/raw_data/raw_inauguration.csv")

cleaned_exchange_rate <-
  raw_exchange_rate |>
  janitor::clean_names() |>
  filter(date >= "1969-01-20" & dexcaus != ".") |> 
  rename(exchange_rate = dexcaus) |> mutate(exchange_rate = as.numeric(exchange_rate)) |>
  tidyr::drop_na()


cleaned_inauguration <-
  raw_inauguration |>
  janitor::clean_names() |>
  filter(inauguration_date >= "1974-08-09") |>
  select(president, party, inauguration_date) |>
  mutate(change_party = as.integer(lag(party) != party & !is.na(lag(party)))) |>
  tidyr::drop_na()





# Convert date columns to Date type
cleaned_inauguration$inauguration_date <- as.Date(cleaned_inauguration$inauguration_date)
cleaned_exchange_rate$date <- as.Date(cleaned_exchange_rate$date)

exchange_inaug <- cleaned_exchange_rate
exchange_inaug$date <- as.Date(exchange_inaug$date)

# Initialize the new columns to 0
exchange_inaug$inauguration_period <- 0
exchange_inaug$change_party <- 0

# Loop through the inauguration dates
for(i in 1:nrow(cleaned_inauguration)) {
  # Define the date range for each inauguration date
  date_range <- seq(cleaned_inauguration$inauguration_date[i] - 3,
                    cleaned_inauguration$inauguration_date[i] + 3,
                    by = 'day')
  # Identify indices within the date range
  date_indices <- which(exchange_inaug$date %in% date_range)
  
  # Set inauguration_period to 1 for the date range
  exchange_inaug$inauguration_period[date_indices] <- 1
  
  # Set change_party to the value from inauguration_df if there's a party change
  if(cleaned_inauguration$change_party[i] == 1) {
    exchange_inaug$change_party[date_indices] <- 1
  }
}

#alternative approach, ABANDONED
#inaug_period_exchange <- exchange_inaug |> filter(inauguration_period == 1)
#for(i in 1:nrow(cleaned_inauguration)) {
  # Define the date range for each inauguration date
#  date_range <- seq(cleaned_inauguration$inauguration_date[i] - 3,
#                    cleaned_inauguration$inauguration_date[i] - 1,
#                    by = 'day')
#  date_indices <- which(inaug_period_exchange$date %in% date_range)
#  inaug_period_exchange$inauguration_period[date_indices] <- 0  
#}






#### Save data ####
write_csv(cleaned_exchange_rate, "data/analysis_data/cleaned_exchange_rate.csv")
write_parquet(cleaned_exchange_rate, "data/analysis_data/cleaned_exchange_rate.parquet")

write_csv(cleaned_inauguration, "data/analysis_data/cleaned_inauguration.csv")
write_parquet(cleaned_inauguration, "data/analysis_data/cleaned_inauguration.parquet")

write_csv(exchange_inaug, "data/analysis_data/exchange_inaug.csv")
write_parquet(exchange_inaug, "data/analysis_data/exchange_inaug.parquet")
