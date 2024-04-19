# Relationship between Election Season and Currency Fluctuation

## Overview

Fluctuation of exchange rate can be attributed to multiple different factors. This paper will focus on one particular aspect that contributes to the change in USD exchange rate: the expectation of the populous on the future of the United States, perceived through the results of the US Presidential Election. The paper will examine relationship between US presidential result announcement and USD exchange rate fluctuation.

Exchange Rate between CAD & USD gathered from [FRED](https://fred.stlouisfed.org/series/DEXCAUS) 

US Presidential Election Result data gathered from [United States Census Bureau](https://www.census.gov/content/dam/Census/library/visualizations/2021/comm/inauguration-day.pdf), cross checked with data from [Frank LaRose Ohio Secretary of State](https://www.ohiosos.gov/elections/election-results-and-data/historical-election-comparisons/presidents-of-the-united-states-of-america/) website to ensure accuracy.

## File Structure

The repo is structured as:

-   `data/raw_data` contains the raw data as obtained from FRED, United States Census Bureau and Frank LaRose Ohio Secretary of State.
-   `data/analysis_data` contains the cleaned dataset that was constructed.
-   `model` contains fitted models.
-   `other` contains relevant literature, details about LLM chat interactions, and sketches.
-   `paper` contains the files used to generate the paper, including the Quarto document and reference bibliography file, as well as the PDF of the paper.
-   `paper/datasheet` contains the datasheet for the final dataset used for analysis.
-   `scripts` contains the R scripts used to simulate, download and clean data.

## Statement on LLM usage

Aspects of the paper are written with the help of ChatGPT and the entire chat history is available in inputs/llms/usage.txt.
