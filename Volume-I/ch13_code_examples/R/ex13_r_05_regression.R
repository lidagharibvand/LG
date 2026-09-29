# ex13_r_05_regression.R
# Linear regression with adjustment.
# Section 13.5.5.

library(tidyverse)
trial <- read_csv("data/processed/trial_hypertension.csv")

# Adjust the treatment effect for baseline SBP, age, and sex
model <- lm(sbp_12wk ~ arm + sbp_baseline + age + sex, data = trial)
summary(model)

# Tidy output with confidence intervals
library(broom)
tidy(model, conf.int = TRUE)
