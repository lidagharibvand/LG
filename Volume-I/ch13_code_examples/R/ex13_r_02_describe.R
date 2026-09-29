# ex13_r_02_describe.R
# Descriptive statistics and a boxplot of the change in systolic BP by arm.
# Section 13.5.2.

library(tidyverse)
trial <- read_csv("data/processed/trial_hypertension.csv")

# Counts, means, SDs, and medians by arm
trial %>%
  group_by(arm) %>%
  summarize(
    n            = n(),
    mean_age     = mean(age, na.rm = TRUE),
    sd_age       = sd(age, na.rm = TRUE),
    pct_female   = mean(sex == "F") * 100,
    baseline_sbp = mean(sbp_baseline, na.rm = TRUE),
    sbp_change   = mean(sbp_12wk - sbp_baseline, na.rm = TRUE)
  )

# Quick visual: change in SBP, by arm
trial %>%
  mutate(sbp_change = sbp_12wk - sbp_baseline) %>%
  ggplot(aes(x = arm, y = sbp_change)) +
  geom_boxplot() +
  labs(x = "Arm", y = "Change in systolic BP (mmHg)")
