## ---- include = FALSE---------------------------------------------------------
knitr::opts_chunk$set(
  collapse = TRUE,
  comment = "#>"
)

## ----setup--------------------------------------------------------------------
if (!require(devtools)) install.packages("devtools")
devtools::install_github("tuomaseerola/onsetsync")

library(onsetsync)
library(httr)
library(dplyr)
library(ggplot2)

CSS_Song2_Onset <- get_OSF_csv('8a347') # Onsets
knitr::kable(head(CSS_Song2_Onset[,1:8,]),format = "simple")

