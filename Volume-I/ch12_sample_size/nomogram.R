# Original power nomograms for Volume I, Chapter 10.
#
# A nomogram is a graphical solution of an equation: three parallel scales
# positioned so that a straightedge laid across any two reads the third.
# These are drawn from the power equation itself rather than copied from a
# published chart, so they are original figures.
#
# For a two-sided test at level alpha, with k = 2 for the independent-samples
# case (n is per group) and k = 1 for the paired case (n is the number of
# pairs), the normal approximation to the sample size is
#
#     n = k (z_{alpha/2} + z_power)^2 / d^2 .
#
# Taking logs and writing u = -log d and w = log(z_{alpha/2} + z_power),
#
#     log n = log k + 2u + 2w ,
#
# so if the left scale is drawn at u, the right scale at w, and the middle
# scale at m = (u + w)/2 -- which is exactly where a straightedge from u to w
# crosses the halfway line -- then
#
#     m = (log n - log k) / 4 .
#
# All three scales therefore share one linear vertical axis, and the
# straightedge property holds exactly.

ALPHA <- 0.05
ZA    <- qnorm(1 - ALPHA / 2)

u_of_d  <- function(d)  -log(d)
w_of_p  <- function(pw)  log(ZA + qnorm(pw))
m_of_n  <- function(n, k) (log(n) - log(k)) / 4

draw <- function(file, k, n_ticks, heading, footnote) {
  png(file, width = 1640, height = 1500, res = 200, bg = "white")
  on.exit(dev.off())
  par(mar = c(2.8, 0.6, 2.2, 0.6))

  d_lab  <- c(0.20, 0.25, 0.30, 0.35, 0.40, 0.45, 0.50, 0.55, 0.60, 0.65,
              0.70, 0.75, 0.80, 0.90, 1.00, 1.10, 1.20)
  pw_lab <- c(0.20, 0.30, 0.40, 0.50, 0.60, 0.65, 0.70, 0.75, 0.80, 0.85,
              0.90, 0.95, 0.99)

  u <- u_of_d(d_lab)
  w <- w_of_p(pw_lab)
  m <- m_of_n(n_ticks, k)

  yl <- range(c(u, w, m))
  yl <- yl + c(-0.045, 0.155) * diff(yl)

  plot(NA, xlim = c(-0.30, 1.30), ylim = yl, axes = FALSE, xlab = "",
       ylab = "")

  spine <- function(x, v, labs, side, digits) {
    lines(c(x, x), range(v), lwd = 2.2, col = "#1f4e79")
    for (i in seq_along(v)) {
      segments(x, v[i], x + side * 0.030, v[i], lwd = 1.4, col = "#1f4e79")
      text(x + side * 0.046, v[i],
           formatC(labs[i], format = "f", digits = digits),
           adj = if (side > 0) 0 else 1, cex = 0.82, col = "#1f2937")
    }
  }
  spine(0.0, u, d_lab,   -1, 2)
  spine(0.5, m, n_ticks, +1, 0)
  spine(1.0, w, pw_lab,  +1, 2)

  top <- yl[2] - 0.035 * diff(yl)
  text(0.0, top, "standardized\ndifference d", cex = 0.92, font = 2,
       col = "#1f4e79")
  text(0.5, top, if (k == 2) "n per group" else "number\nof pairs",
       cex = 0.92, font = 2, col = "#1f4e79")
  text(1.0, top, "power", cex = 0.92, font = 2, col = "#1f4e79")

  # the worked example the caption describes: d = 0.80 at 80% power
  segments(0, u_of_d(0.80), 1, w_of_p(0.80), lty = 2, lwd = 1.7,
           col = "#b85c22")
  points(0.5, m_of_n(k * (ZA + qnorm(0.80))^2 / 0.80^2, k), pch = 19,
         cex = 0.8, col = "#b85c22")

  mtext(heading, side = 3, line = 0.7, cex = 0.86, font = 2, col = "#1f4e79")
  mtext(footnote, side = 1, line = 1.5, cex = 0.66, col = "#595959")
}

draw("fig_nomogram_two_sample.png", k = 2,
     n_ticks = c(3, 4, 5, 6, 8, 10, 12, 15, 20, 25, 35, 50, 70, 100, 140,
                 200, 300, 400),
     heading = "Two independent groups, two-sided test at alpha = 0.05",
     footnote = paste("Lay a straightedge across any two scales to read the",
                      "third. Dashed line: d = 0.80 at 80% power reads about",
                      "25 per group; power.t.test gives 26."))

draw("fig_nomogram_paired.png", k = 1,
     n_ticks = c(2, 3, 4, 5, 6, 8, 10, 13, 17, 22, 30, 40, 55, 75, 100,
                 140, 200),
     heading = "Paired differences, two-sided test at alpha = 0.05",
     footnote = paste("Here d is the mean difference divided by the SD of the",
                      "differences and n is the number of pairs. Dashed line:",
                      "d = 0.80 at 80% power reads about 12 pairs;",
                      "power.t.test gives 15."))

# --- how far the graphical answer sits from the exact one -------------------
cat("\nnormal-approximation vs exact t-based n\n")
for (d in c(0.30, 0.50, 0.80, 1.00)) {
  appr <- 2 * (ZA + qnorm(0.80))^2 / d^2
  exact <- power.t.test(delta = d, sd = 1, power = 0.80)$n
  cat(sprintf("  d = %.2f : nomogram %6.1f   power.t.test %6.1f   (+%.1f)\n",
              d, appr, exact, exact - appr))
}
for (d in c(0.50, 0.80, 1.00)) {
  appr <- (ZA + qnorm(0.80))^2 / d^2
  exact <- power.t.test(delta = d, sd = 1, power = 0.80, type = "paired")$n
  cat(sprintf("  paired d = %.2f : nomogram %6.1f   power.t.test %6.1f\n",
              d, appr, exact))
}
