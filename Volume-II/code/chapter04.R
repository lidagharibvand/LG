## ==========================================================================
## Modern Biostatistics with R and AI, Volume II
## Chapter 4  The Normal Distribution and the Central Limit Theorem
##
## Every code block the chapter prints, in the order it appears, labelled
## with its Using R box number or listing number so the script and the book
## can be read side by side.
##
## Run from the top of Volume-II, where datasets/ lives:
##   Rscript code/chapter04.R
##
## ==========================================================================

halo <- read.csv("datasets/halo.csv")
names(halo) <- tolower(names(halo))


## --------------------------------------------------------------------------
## Using R 4.1  The 68-95-99.7 rule checked against HALO peak heart rate
## --------------------------------------------------------------------------

m <- mean(halo$max_hr); s <- sd(halo$max_hr)
c(m, s)                              # 161.36 and 13.74
m + c(-1, 1) * s                     # 147.6 to 175.1 beats/min
mean(abs(halo$max_hr - m) <= s)      # 0.683, against the rule 0.68
mean(abs(halo$max_hr - m) <= 2 * s)  # 0.957, against the rule 0.95


## --------------------------------------------------------------------------
## Using R 4.2  Standard normal areas and percentiles with pnorm() and qnorm()
## --------------------------------------------------------------------------

z <- (100 - 141.4) / 34.1
round(z, 2)                          # -1.21
pnorm(-1.21)                         # 0.1131 below 100 mg/dL
mean(halo$ldl0 < 100)                # 0.1100, observed
qnorm(0.99)                          # 2.3263, the top 1%
141.4 + qnorm(0.99) * 34.1           # 220.7 mg/dL


## --------------------------------------------------------------------------
## Using R 4.3  Non-standard normal calculations on the original scale
## --------------------------------------------------------------------------

pnorm(120, 82.5, 16.4, lower.tail = FALSE)   # 0.0111 above 120 kg
mean(halo$weight0 > 120)                     # 0.0170, the observed share
qnorm(0.90, 4.7, 1.5)                        # 6.62 hours per week
pnorm(7, 4.7, 1.5) - pnorm(3, 4.7, 1.5)      # 0.8089 between 3 and 7
qnorm(c(0.025, 0.975), 64.8, 8.0)            # ages 49.1 to 80.5
pnorm(175.5, 141.4, 34.1) - pnorm(107.3, 141.4, 34.1)   # 0.6827


## --------------------------------------------------------------------------
## Using R 4.4  The standard error and how it shrinks with sample size
## --------------------------------------------------------------------------

halo$sbp0[halo$sbp0 > 300] <- NA   # the planted 1,350
s <- sd(halo$sbp0, na.rm = TRUE)
s                                    # 16.56 mmHg
s / sqrt(c(9, 36, 144))              # 5.52, 2.76, 1.38 mmHg


## --------------------------------------------------------------------------
## Using R 4.5  The Central Limit Theorem by resampling HALO triglycerides
## --------------------------------------------------------------------------

set.seed(42)
mm <- replicate(3000, mean(sample(halo$tg, 30)))
c(mean(mm), sd(mm))                  # 171.72 and 17.17
sd(halo$tg) / sqrt(30)               # 17.06, the formula
mean(mm > 200)                       # 0.0593


## --------------------------------------------------------------------------
## Using R 4.6  Three normality checks: histogram, Q-Q plot, Shapiro-Wilk
## --------------------------------------------------------------------------

hist(halo$tg, breaks = 30)
qqnorm(halo$tg); qqline(halo$tg)
shapiro.test(halo$tg)
shapiro.test(halo$max_hr)


## --------------------------------------------------------------------------
## Listing 4.1  Log and square-root transformations of skewed HALO variables
## --------------------------------------------------------------------------

halo <- read.csv("datasets/halo.csv")
names(halo) <- tolower(names(halo))
library(psych)   # for skew()
tg <- halo$tg
# Shape on the original scale and on the log scale
round(c(raw = skew(tg), log = skew(log(tg))), 2)
shapiro.test(log(tg))
# Back-transform the mean of the logs: the geometric mean
m <- mean(log(tg))
round(c(mean_log = m, geo_mean = exp(m),
        median = median(tg), mean = mean(tg)), 2)
# A 95% interval on the log scale, then back to mg/dL
se <- sd(log(tg)) / sqrt(length(tg))
round(exp(m + c(-1.96, 1.96) * se), 1)
# Glucose: the log helps much less
g <- halo$glucose
round(c(raw = skew(g), log = skew(log(g))), 2)
round(tapply(g, halo$diabetes, skew), 2)
# A count with zeros: the square root instead of the log
sum(halo$visits == 0)
round(c(raw = skew(halo$visits),
        sqrt = skew(sqrt(halo$visits))), 2)


## --------------------------------------------------------------------------
## Using R 4.7  Reading a transformation: geometric mean, logs, counts with zeros
## --------------------------------------------------------------------------

c(mean(halo$tg), median(halo$tg))
exp(mean(log(halo$tg)))
shapiro.test(log(halo$tg))
sum(halo$visits == 0)
hist(log(halo$tg), breaks = 30)
hist(halo$visits, breaks = 0:35)


## --------------------------------------------------------------------------
## Listing 4.2  Visualizing the Central Limit Theorem with one line of resampling
## --------------------------------------------------------------------------

set.seed(42)
# Right-skewed population: the 2,000 HALO triglyceride values
pop <- halo$tg
# Sampling distribution at three different sample sizes
means_n5   <- replicate(3000, mean(sample(pop, size = 5)))
means_n30  <- replicate(3000, mean(sample(pop, size = 30)))
means_n100 <- replicate(3000, mean(sample(pop, size = 100)))
par(mfrow = c(2, 2))
hist(pop, breaks = 50, col = "firebrick",
     main = "Population (tg, skewed)", xlab = "tg (mg/dL)")
hist(means_n5, breaks = 30, col = "steelblue",
     main = "Sample means, n = 5", xlab = expression(bar(x)))
hist(means_n30, breaks = 30, col = "steelblue",
     main = "Sample means, n = 30", xlab = expression(bar(x)))
hist(means_n100, breaks = 30, col = "steelblue",
     main = "Sample means, n = 100", xlab = expression(bar(x)))
par(mfrow = c(1, 1))
# Compare the spread of the means with sigma / sqrt(n)
round(c(mean(pop), mean(means_n30)), 1)
round(c(sd(means_n30), sd(pop) / sqrt(30)), 2)


## --------------------------------------------------------------------------
## Listing 4.3  Generating a normal reference population with rnorm()
## --------------------------------------------------------------------------

set.seed(4)                       # without this, the numbers change every run
# 2,000 values from the model fitted to total cholesterol
sim <- rnorm(2000, mean = 223.4, sd = 41.3)
round(c(mean(sim), sd(sim)), 2)
# Does the model reproduce the right tail of the real data?
mean(sim >= 300)
mean(halo$total_chol >= 300)
# The model's own tail, with no simulation noise
1 - pnorm(300, 223.4, 41.3)


## --------------------------------------------------------------------------
## Using R 4.8  pnorm() and qnorm() as inverses: two round-trip checks
## --------------------------------------------------------------------------

pnorm(2) + pnorm(2, lower.tail = FALSE)      # 1, the two tails must add to 1
qnorm(pnorm(1.88))                           # 1.88, the round trip

