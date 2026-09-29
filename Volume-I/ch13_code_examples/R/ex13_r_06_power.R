# ex13_r_06_power.R
# Sample-size calculation.
# Section 13.5.6. Note that pwr reports n PER GROUP, and that a required
# sample size is always rounded UP.

library(pwr)

# Two-sample t-test, medium effect, 80% power, two-tailed alpha 0.05
pwr.t.test(d = 0.5, sig.level = 0.05, power = 0.80, type = "two.sample")
# 63.77 per group, so 64 per group and 128 in total.

# What sample size is needed to detect a 5 mmHg difference (SD = 12)?
# Cohen's d = 5 / 12 = 0.4167
pwr.t.test(d = 5/12, sig.level = 0.05, power = 0.80, type = "two.sample")
# 91.39 per group, so 92 per group and 184 in total.
