# Title     : TODO
# Objective : TODO
# Created by: AdhamAlHossary
# Created on: 16/11/2020

# Code from: https://towardsdatascience.com/a-census-based-deprivation-index-using-r-7aa738da697c

library(tidycensus)
library(tidyverse)
library(psych)

#-- for plotting maps
library(tigris)
options(tigris_class = "sf",
        tigris_use_cache = TRUE)

#-- source script
source("R/ndi.R")

#census_api_key("ba70dd04efd7319ff425a2b12322b80116d6534a")
#
#-- index function

#ndi_county()

ndi()