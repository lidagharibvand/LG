# ===========================================================================
# lab_sample_size.R
#
# Modern Biostatistics for the Health Sciences, Volume I
# Chapter 11, Section 11.6 -- Sample Size and Power in Software
#
# Five sample-size and power calculations for t-test designs, in base R.
# This is the reference implementation: the SAS, SPSS, Excel, and Python
# versions in this folder are written to reproduce these five answers.
#
# Run it:   Rscript lab_sample_size.R
#
# Requires: base R only (power.t.test ships with the stats package).
# ===========================================================================

rule <- function(title) {
  cat("\n", strrep("=", 70), "\n", title, "\n", strrep("=", 70), "\n", sep = "")
}

# ---------------------------------------------------------------------------
# 1. One-sample t test -- how many participants?
#
#    We want to detect a 5-unit shift from the null value. Past work puts the
#    standard deviation at 25. Two-sided alpha = 0.05, power = 0.80.
# ---------------------------------------------------------------------------
rule("1. One-sample t test: solving for n")

a <- power.t.test(power = 0.80, delta = 5, sd = 25, type = "one.sample")
print(a)
cat("Enroll:", ceiling(a$n), "participants\n")

# ---------------------------------------------------------------------------
# 2. One-sample t test -- what power does the budget buy?
#
#    Same design, but funding caps recruitment at 180. Solve for power
#    instead of n by supplying n and leaving power empty.
# ---------------------------------------------------------------------------
rule("2. One-sample t test: solving for power at n = 180")

b <- power.t.test(n = 180, delta = 5, sd = 25, type = "one.sample")
print(b)
cat(sprintf("Power at n = 180: %.4f\n", b$power))

# ---------------------------------------------------------------------------
# 3. Two independent groups -- unequal variances
#
#    The two groups are not expected to vary equally: sd1 = 15, sd2 = 18.
#    power.t.test takes a single sd, so we supply the root-mean-square of
#    the two, which is the standard deviation that gives the difference
#    between two equally sized group means the same variance it would have
#    under the unequal-variance model.
#
#        sd.ave = sqrt((sd1^2 + sd2^2) / 2)
#
#    Note this is a root-mean-square, NOT the average of 15 and 18 (16.5).
# ---------------------------------------------------------------------------
rule("3. Two-sample t test: unequal variances")

sd1 <- 15
sd2 <- 18
sd.ave <- sqrt((sd1^2 + sd2^2) / 2)
cat(sprintf("sd1 = %g, sd2 = %g  ->  sd.ave = %.5f\n", sd1, sd2, sd.ave))

cc <- power.t.test(delta = 10, sd = sd.ave, power = 0.80)
print(cc)
cat("Enroll:", ceiling(cc$n), "per group,", 2 * ceiling(cc$n), "total\n")

# ---------------------------------------------------------------------------
# 4. Two independent groups -- equal variances
#
#    The same comparison under a single pooled sd of 17, which is what you
#    would assume if the pilot data gave no reason to expect the groups to
#    differ in spread. Compare the answer with example 3.
# ---------------------------------------------------------------------------
rule("4. Two-sample t test: equal variances, sd = 17")

d <- power.t.test(delta = 10, sd = 17, power = 0.80)
print(d)
cat("Enroll:", ceiling(d$n), "per group,", 2 * ceiling(d$n), "total\n")

# ---------------------------------------------------------------------------
# 5. Paired t test
#
#    Two measurements on the same person are correlated, and the paired test
#    works on the differences. The standard deviation of the difference is
#
#        sd.paired = sqrt(sd1^2 + sd2^2 - 2 * rho * sd1 * sd2)
#
#    which shrinks as rho rises. That shrinkage is the whole advantage of
#    pairing, and it is why the correlation has to be assumed explicitly.
# ---------------------------------------------------------------------------
rule("5. Paired t test")

rho <- 0.5
sd1 <- 40
sd2 <- 32
sd.paired <- sqrt(sd1^2 + sd2^2 - 2 * rho * sd1 * sd2)
cat(sprintf("sd1 = %g, sd2 = %g, rho = %g  ->  sd.paired = %.5f\n",
            sd1, sd2, rho, sd.paired))

e <- power.t.test(delta = 20, sd = sd.paired, power = 0.80, type = "paired")
print(e)
cat("Enroll:", ceiling(e$n), "pairs\n")

# ---------------------------------------------------------------------------
# 6. How much does the assumed correlation matter?
#
#    rho is almost never known. This sweep shows what it costs to be wrong:
#    assuming 0.7 when the truth is 0.3 leaves the study less than half the
#    size it needed. When rho is uncertain, plan on the low end.
# ---------------------------------------------------------------------------
rule("6. Sensitivity of the paired design to rho")

sweep <- data.frame(rho = c(0.0, 0.3, 0.5, 0.7, 0.9))
sweep$sd.paired <- sqrt(sd1^2 + sd2^2 - 2 * sweep$rho * sd1 * sd2)
sweep$n.exact <- sapply(sweep$sd.paired, function(s)
  power.t.test(delta = 20, sd = s, power = 0.80, type = "paired")$n)
sweep$pairs <- ceiling(sweep$n.exact)
print(sweep, row.names = FALSE, digits = 5)

cat("\n")
cat(strrep("-", 70), "\n")
cat("The five answers this folder's SAS, SPSS, Excel, and Python versions\n")
cat("are written to reproduce:\n")
cat(sprintf("  1. one-sample n            %4d\n", ceiling(a$n)))
cat(sprintf("  2. power at n = 180        %.4f\n", b$power))
cat(sprintf("  3. two-sample, sd.ave      %4d per group\n", ceiling(cc$n)))
cat(sprintf("  4. two-sample, sd = 17     %4d per group\n", ceiling(d$n)))
cat(sprintf("  5. paired, rho = 0.5       %4d pairs\n", ceiling(e$n)))
cat(strrep("-", 70), "\n")
