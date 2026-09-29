# ex13_r_03_ttest.R
# Welch's two-sample t-test on the change score.
# Section 13.5.3.

library(tidyverse)
trial <- read_csv("data/processed/trial_hypertension.csv")

trial <- trial %>% mutate(sbp_change = sbp_12wk - sbp_baseline)

t_result <- t.test(sbp_change ~ arm, data = trial)
t_result

cat(sprintf(
  "Mean difference (app - usual care): %.2f mmHg, 95%% CI [%.2f, %.2f], p = %.4f\n",
  t_result$estimate[1] - t_result$estimate[2],
  t_result$conf.int[1], t_result$conf.int[2], t_result$p.value))
