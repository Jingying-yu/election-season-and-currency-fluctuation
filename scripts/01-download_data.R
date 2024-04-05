#### Preamble ####
# Purpose: Downloads and saves the data from FRED and 
# Author: Sandy Yu
# Date: 2 April 2024
# Contact: jingying.yu@mail.utoronto.ca
# License: MIT
# Pre-requisites: Research on whether the sources are trustworthy and consider which datasets are necessary



#### Workspace setup ####
library(tidyverse)


#### Download data ####
raw_exchange_rate <- read_csv(
  file = "https://fred.stlouisfed.org/graph/fredgraph.csv?bgcolor=%23e1e9f0&chart_type=line&drp=0&fo=open%20sans&graph_bgcolor=%23ffffff&height=450&mode=fred&recession_bars=on&txtcolor=%23444444&ts=12&tts=12&width=1138&nt=0&thu=0&trc=0&show_legend=yes&show_axis_titles=yes&show_tooltip=yes&id=DEXCAUS&scale=left&cosd=1971-01-04&coed=2024-03-29&line_color=%234572a7&link_values=false&line_style=solid&mark_type=none&mw=3&lw=2&ost=-99999&oet=99999&mma=0&fml=a&fq=Daily&fam=avg&fgst=lin&fgsnd=2020-02-01&line_index=1&transformation=lin&vintage_date=2024-04-02&revision_date=2024-04-02&nd=1971-01-04",
  show_col_types = FALSE
)

raw_election_results <- read_csv(
  file = "",
  show_col_types = FALSE
)


#### Save data ####
write_csv(raw_exchange_rate, "inputs/data/raw_exchange_rate.csv") 

write_csv(raw_election_results, "inputs/data/raw_election_results.csv") 
