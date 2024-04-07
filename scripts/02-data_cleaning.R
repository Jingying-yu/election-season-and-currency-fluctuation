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

# Separate the exchange rate into 2 files, one containing the rate not contain inauguration week 
# Where the date of the inauguration is the 4th day, that is inauguration date +-3 days is the inauguration week
# The other file containing ONLY exchange rates during inauguration week.



# Define a function to get the exchange rates around each inauguration date and add change_party column
#get_date_range <- function(inauguration_date, change_party, cleaned_exchange_rate) {
#  date_range <- seq(inauguration_date - 3, inauguration_date + 3, by = "days")
#  rates <- cleaned_exchange_rate %>% filter(date %in% date_range)
#  rates$change_party <- change_party
#  return(rates)
#}

# Apply the function to each row in the inauguration dataframe
#list_of_df <- mapply(get_date_range, 
#                     cleaned_inauguration$inauguration_date, 
#                     cleaned_inauguration$change_party, 
#                     MoreArgs = list(cleaned_exchange_rate = cleaned_exchange_rate),
#                     SIMPLIFY = FALSE)

# Combine the list of dataframes into one
#inaug_exchange_rate <- bind_rows(list_of_df)

# Remove the gathered exchange rates from the original exchange rate dataframe
#exchange_rate_remaining <- cleaned_exchange_rate %>%
#  anti_join(inaug_exchange_rate, by = "date")


#### Save data ####
# write_csv(cleaned_exchange_rate, "data/analysis_data/cleaned_exchange_rate.csv")
write_parquet(cleaned_exchange_rate, "data/analysis_data/cleaned_exchange_rate.parquet")

# write_csv(cleaned_inauguration, "data/analysis_data/cleaned_inauguration.csv")
write_parquet(cleaned_inauguration, "data/analysis_data/cleaned_inauguration.parquet")

write_parquet(exchange_inaug, "data/analysis_data/exchange_inaug.parquet")


#write_csv(inaug_exchange_rate, "data/analysis_data/inaug_exchange_rate.csv")
#write_parquet(inaug_exchange_rate, "data/analysis_data/inaug_exchange_rate.parquet")

#write_csv(exchange_rate_remaining, "data/analysis_data/exchange_rate_remaining.csv")
#write_parquet(exchange_rate_remaining, "data/analysis_data/exchange_rate_remaining.parquet")
