# sample_size.R  Section 12.6 of Modern Biostatistics, Volume I.

# ---- One-sample test for a mean -------------------------------------

# Solve for the sample size that gives 80% power
power.t.test(power = 0.8, delta = 5, sd = 25, type = 'one.sample')

# Turn the question round: what power does n = 180 buy?
power.t.test(n = 180, delta = 5, sd = 25, type = 'one.sample')

# ---- Two independent samples ----------------------------------------

# Unequal variances: combine them with a root-mean-square
sd1    <- 15
sd2    <- 18
sd.ave <- sqrt((sd1 ^ 2 + sd2 ^ 2) / 2)
power.t.test(delta = 10, sd = sd.ave, power = 0.8)

# Equal variances, for comparison
power.t.test(delta = 10, sd = 17, power = 0.8)

# ---- Paired design ---------------------------------------------------

# sd here is the SD of the WITHIN-PAIR DIFFERENCES, which depends on
# how strongly the two measurements correlate
rho       <- 0.5
sd1       <- 40
sd2       <- 32
sd.paired <- sqrt(sd1 ^ 2 + sd2 ^ 2 - 2 * rho * sd1 * sd2)
power.t.test(delta = 20, sd = sd.paired, power = 0.8, type = 'paired')
