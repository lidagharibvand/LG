#!/usr/bin/env python3
# ===========================================================================
# lab_sample_size.py
#
# Modern Biostatistics for the Health Sciences, Volume I
# Chapter 11, Section 11.6 -- Sample Size and Power in Software
#
# The Python counterpart of lab_sample_size.R. Python has no single function
# equivalent to R's power.t.test, so this file builds one, in about twenty
# lines, out of the noncentral t distribution in scipy.stats. Seeing the
# machinery is the point: power.t.test is not a lookup table, it is a root
# find on one probability statement.
#
# Run it:   python3 lab_sample_size.py
#
# Requires: numpy, scipy.  (pip install numpy scipy)
# ===========================================================================

import numpy as np
from scipy import optimize, stats

ALPHA = 0.05


# ---------------------------------------------------------------------------
# The one probability statement everything below rests on.
#
# Under the alternative hypothesis the t statistic does not follow a central
# t distribution; it follows a NONCENTRAL t with noncentrality parameter
#
#     ncp = sqrt(n / k) * delta / sd
#
# where k = 2 for two independent groups and k = 1 for a one-sample or paired
# design. Power is the probability that this noncentral variable lands beyond
# the critical value taken from the CENTRAL t distribution -- the critical
# value the test actually uses.
#
# This is exactly what R's power.t.test computes, which is why the two agree
# to thirteen significant figures.
# ---------------------------------------------------------------------------
def power_t(n, delta, sd, alpha=ALPHA, kind="two"):
    """Power of a two-sided t test. kind is 'two', 'one', or 'paired'."""
    k = 2 if kind == "two" else 1          # 'one' and 'paired' behave alike
    df = (n - 1) * k
    ncp = np.sqrt(n / k) * delta / sd
    crit = stats.t.ppf(1 - alpha / 2, df)  # central t: the decision threshold
    return stats.nct.sf(crit, df, ncp)     # noncentral t: the truth


def n_for_power(power, delta, sd, alpha=ALPHA, kind="two"):
    """Sample size (n per group, or number of pairs) for a target power."""
    f = lambda n: power_t(n, delta, sd, alpha, kind) - power
    return optimize.brentq(f, 2 + 1e-9, 1e7)


def rule(title):
    print("\n" + "=" * 70 + "\n" + title + "\n" + "=" * 70)


# ---------------------------------------------------------------------------
# 1. One-sample t test -- solving for n
# ---------------------------------------------------------------------------
rule("1. One-sample t test: solving for n")

n1 = n_for_power(0.80, delta=5, sd=25, kind="one")
print(f"  delta = 5, sd = 25, alpha = 0.05, power = 0.80")
print(f"  n = {n1:.4f}")
print(f"  Enroll: {int(np.ceil(n1))} participants")

# ---------------------------------------------------------------------------
# 2. One-sample t test -- solving for power at n = 180
# ---------------------------------------------------------------------------
rule("2. One-sample t test: solving for power at n = 180")

p2 = power_t(180, delta=5, sd=25, kind="one")
print(f"  n = 180, delta = 5, sd = 25, alpha = 0.05")
print(f"  power = {p2:.7f}")
print(f"  Power at n = 180: {p2:.4f}")

# ---------------------------------------------------------------------------
# 3. Two independent groups -- unequal variances
#
#    sd.ave is the root-mean-square of the two group standard deviations,
#    not their arithmetic average.
# ---------------------------------------------------------------------------
rule("3. Two-sample t test: unequal variances")

sd1, sd2 = 15.0, 18.0
sd_ave = np.sqrt((sd1**2 + sd2**2) / 2)
print(f"  sd1 = {sd1:g}, sd2 = {sd2:g}  ->  sd_ave = {sd_ave:.5f}")

n3 = n_for_power(0.80, delta=10, sd=sd_ave)
print(f"  n = {n3:.4f} per group")
print(f"  Enroll: {int(np.ceil(n3))} per group, {2 * int(np.ceil(n3))} total")

# ---------------------------------------------------------------------------
# 4. Two independent groups -- equal variances
# ---------------------------------------------------------------------------
rule("4. Two-sample t test: equal variances, sd = 17")

n4 = n_for_power(0.80, delta=10, sd=17)
print(f"  n = {n4:.4f} per group")
print(f"  Enroll: {int(np.ceil(n4))} per group, {2 * int(np.ceil(n4))} total")

# ---------------------------------------------------------------------------
# 5. Paired t test
# ---------------------------------------------------------------------------
rule("5. Paired t test")

rho, s1, s2 = 0.5, 40.0, 32.0
sd_paired = np.sqrt(s1**2 + s2**2 - 2 * rho * s1 * s2)
print(f"  sd1 = {s1:g}, sd2 = {s2:g}, rho = {rho:g}"
      f"  ->  sd_paired = {sd_paired:.5f}")

n5 = n_for_power(0.80, delta=20, sd=sd_paired, kind="paired")
print(f"  n = {n5:.4f} pairs")
print(f"  Enroll: {int(np.ceil(n5))} pairs")

# ---------------------------------------------------------------------------
# 6. Sensitivity to the assumed correlation
# ---------------------------------------------------------------------------
rule("6. Sensitivity of the paired design to rho")

print(f"  {'rho':>5}  {'sd_paired':>10}  {'n_exact':>9}  {'pairs':>6}")
for r in (0.0, 0.3, 0.5, 0.7, 0.9):
    sp = np.sqrt(s1**2 + s2**2 - 2 * r * s1 * s2)
    ne = n_for_power(0.80, delta=20, sd=sp, kind="paired")
    print(f"  {r:>5.1f}  {sp:>10.4f}  {ne:>9.4f}  {int(np.ceil(ne)):>6d}")

# ---------------------------------------------------------------------------
# 7. Agreement check against the R reference answers
#
#    These are the values lab_sample_size.R prints. If a future version of
#    scipy changes something, this block fails loudly rather than quietly
#    printing a different number.
# ---------------------------------------------------------------------------
rule("7. Agreement with the R reference (lab_sample_size.R)")

checks = [
    ("one-sample n",        n1,     198.15130, 1e-4),
    ("power at n = 180",    p2,       0.760805, 1e-6),
    ("sd_ave",              sd_ave,  16.568042, 1e-5),
    ("two-sample n (ave)",  n3,      44.071603, 1e-4),
    ("two-sample n (17)",   n4,      46.346736, 1e-4),
    ("sd_paired",           sd_paired, 36.660606, 1e-5),
    ("paired pairs",        n5,      28.352914, 1e-4),
]
ok = True
for label, got, want, tol in checks:
    good = abs(got - want) < tol
    ok &= good
    print(f"  {'OK ' if good else 'FAIL'}  {label:<20} {got:>12.6f}"
          f"   (R: {want:>12.6f})")
print("\n  All seven agree with R." if ok else "\n  MISMATCH -- investigate.")
