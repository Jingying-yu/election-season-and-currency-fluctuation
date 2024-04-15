#### Preamble ####
# Purpose: create bayesian model based on cleaned data
# Author: Sandy Yu
# Date: 2 April 2024
# Contact: jingying.yu@mail.utoronto.ca
# License: MIT
# Pre-requisites: downloaded and cleaned data, understand what model to use



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





#### Save model ####
saveRDS(
  inaug_model,
  file = "models/inaug_model.rds"
)

