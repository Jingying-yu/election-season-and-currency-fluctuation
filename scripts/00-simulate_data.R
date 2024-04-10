#### Preamble ####
# Purpose: Simulates data for the entire paper to gather thoughts and avoid missteps
# Author: Sandy Yu
# Date: 2 April 2024
# Contact: jingying.yu@mail.utoronto.ca
# License: MIT
# Pre-requisites: N/A


#### Workspace setup ####
library(tidyverse)
library(lubridate)

#### Simulate data ####

# Set seed for reproducibility
set.seed(21)

# Generate the sequence of dates from 1970-01-01 to 2024-01-01
dates <- seq(from = as.Date("1970-01-01"), to = as.Date("2024-01-01"), by = "day")

# Initialize the inauguration_period column with zeros
inauguration_period <- rep(0, length(dates))

# Set inauguration_period to 1 for each inauguration week every four years
for(year in seq(1970, 2024, by = 4)) {
  inauguration_start <- as.Date(paste(year, "-01-17", sep = ""))
  inauguration_end <- inauguration_start + 6
  inauguration_period[dates >= inauguration_start & dates <= inauguration_end] <- 1
}

# Generate random exchange_rate values with normal distribution
# Make sure the values are clipped to the range [0.80, 1.55]
exchange_rate <- rnorm(length(dates), mean = 1, sd = 0.1)
exchange_rate <- pmin(1.55, pmax(0.80, exchange_rate))

# Create the data frame
simulated_data <- data.frame(
  date = dates,
  exchange_rate = exchange_rate,
  inauguration_period = inauguration_period
)



