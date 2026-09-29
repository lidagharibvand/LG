# ex13_r_04_chisq.R
# Chi-square test for a binary outcome, with an effect size.
# Section 13.5.4.

library(tidyverse)
trial <- read_csv("data/processed/trial_hypertension.csv")

# Cross-tabulation
tab <- table(arm = trial$arm, target = trial$bp_target_met)
tab

# Chi-square test of association
chisq.test(tab)

# Effect size: relative risk and risk difference
library(epitools)
riskratio(tab)$measure
