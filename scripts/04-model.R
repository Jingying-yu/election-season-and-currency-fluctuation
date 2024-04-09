#### Preamble ####
# Purpose: Models... [...UPDATE THIS...]
# Author: Rohan Alexander [...UPDATE THIS...]
# Date: 11 February 2023 [...UPDATE THIS...]
# Contact: rohan.alexander@utoronto.ca [...UPDATE THIS...]
# License: MIT
# Pre-requisites: [...UPDATE THIS...]
# Any other information needed? [...UPDATE THIS...]


#### Workspace setup ####
library(tidyverse)
library(rstanarm)
library(readr)
library(arrow)

#### Read data ####
#exchange_inaug <- read_parquet("data/analysis_data/exchange_inaug.parquet")
inaug_period_exchange <- read_csv("data/analysis_data/inaug_period_exchange.csv", show_col_types = FALSE)

### Model data ####
inaug_model <-
  stan_glm(
    formula = exchange_rate ~ inauguration_period + change_party,
    data = exchange_inaug,
    family = gaussian(),
    prior = normal(location = 0, scale = 2.5, autoscale = TRUE),
    prior_intercept = normal(location = 0, scale = 2.5, autoscale = TRUE),
    prior_aux = exponential(rate = 1, autoscale = TRUE),
   seed = 21
  )


# Attempt alternative RDD approach, ABANDONED
#inaug_period_model <-
#  stan_glm(
#    formula = exchange_rate ~ date + inauguration_period,
#    data = inaug_period_exchange,
#    family = gaussian(),
#    prior = normal(location = 0, scale = 2.5, autoscale = TRUE),
#    prior_intercept = normal(location = 0, scale = 2.5, autoscale = TRUE),
#    prior_aux = exponential(rate = 1, autoscale = TRUE),
#   seed = 21
#  )

#### Save model ####
saveRDS(
  inaug_model,
  file = "models/inaug_model.rds"
)


# alternative approach, ABANDONED
#saveRDS(
#  inaug_period_model,
#  file = "models/inaug_period_model.rds"
#)

