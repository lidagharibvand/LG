# measures_2x2.R
#
# The 2x2 table measures of Chapter 4, Section 4.3, computed from the counts
# in a single place so the arithmetic can be checked rather than trusted.
#
#            Outcome yes   Outcome no
#   Exposed       a             b
#   Unexposed     c             d
#
# Companion to Modern Biostatistics for the Health Sciences, Volume I.

measures_2x2 <- function(a, b, c, d, conf = 0.95) {
  n1 <- a + b          # exposed
  n0 <- c + d          # unexposed

  risk_exposed   <- a / n1
  risk_unexposed <- c / n0

  rr  <- risk_exposed / risk_unexposed
  or  <- (a / b) / (c / d)
  ard <- risk_exposed - risk_unexposed
  nnt <- 1 / abs(ard)

  # Confidence intervals on the log scale, which is where these are symmetric.
  z <- qnorm(1 - (1 - conf) / 2)
  se_log_rr <- sqrt(1 / a - 1 / n1 + 1 / c - 1 / n0)
  se_log_or <- sqrt(1 / a + 1 / b + 1 / c + 1 / d)
  se_ard    <- sqrt(risk_exposed * (1 - risk_exposed) / n1 +
                    risk_unexposed * (1 - risk_unexposed) / n0)

  out <- data.frame(
    measure = c("Risk, exposed", "Risk, unexposed", "Relative risk",
                "Odds ratio", "Risk difference", "Number needed to treat"),
    estimate = c(risk_exposed, risk_unexposed, rr, or, ard, nnt),
    lower = c(NA, NA, exp(log(rr) - z * se_log_rr),
              exp(log(or) - z * se_log_or), ard - z * se_ard, NA),
    upper = c(NA, NA, exp(log(rr) + z * se_log_rr),
              exp(log(or) + z * se_log_or), ard + z * se_ard, NA)
  )
  out
}

# The worked example of Section 4.3: 18 events among 120 exposed, 31 among 118
# unexposed. Both figures are printed in the chapter.
print(measures_2x2(a = 18, b = 120 - 18, c = 31, d = 118 - 31), digits = 4)
