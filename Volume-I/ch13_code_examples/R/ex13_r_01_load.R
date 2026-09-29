# ex13_r_01_load.R
# Reading the trial dataset and inspecting its structure.
# Section 13.5.1 of Modern Biostatistics for the Health Sciences, Volume I.

library(tidyverse)

trial <- read_csv("data/processed/trial_hypertension.csv")

# Quick structural overview
glimpse(trial)      # variable names and types
summary(trial)      # numerical summary by column
head(trial, 10)     # first 10 rows
