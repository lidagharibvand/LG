# age_standardization.R
#
# Direct and indirect age standardization, Chapter 4, Section 4.5. A crude rate
# compares two populations only when they have the same age structure, which
# they almost never do. Standardization is how the comparison is made fair.
#
# Companion to Modern Biostatistics for the Health Sciences, Volume I.

# Direct: apply the study population's age-specific rates to a standard
# population, and report the rate that standard population would have had.
direct_standardize <- function(cases, population, standard, per = 100000) {
  rates <- cases / population
  weights <- standard / sum(standard)
  sum(rates * weights) * per
}

# Indirect: apply a standard population's age-specific rates to the study
# population, and compare what was observed with what would have been expected.
indirect_standardize <- function(cases, population, standard_rates) {
  observed <- sum(cases)
  expected <- sum(population * standard_rates)
  c(observed = observed, expected = expected, smr = observed / expected)
}

# A worked example. Two counties with the same crude rate and very different
# age structures.
age_group  <- c("0-19", "20-44", "45-64", "65+")
cases_a    <- c(  2,  18,  62, 140)
pop_a      <- c(20000, 30000, 18000, 9000)
cases_b    <- c(  3,  30,  45,  70)
pop_b      <- c(28000, 44000, 12000, 4500)
standard   <- c(25000, 38000, 21000, 11000)   # the reference age structure

crude_a <- sum(cases_a) / sum(pop_a) * 100000
crude_b <- sum(cases_b) / sum(pop_b) * 100000

cat(sprintf("Crude rate, county A        %8.1f per 100,000\n", crude_a))
cat(sprintf("Crude rate, county B        %8.1f per 100,000\n", crude_b))
cat(sprintf("Age-standardized, county A  %8.1f per 100,000\n",
            direct_standardize(cases_a, pop_a, standard)))
cat(sprintf("Age-standardized, county B  %8.1f per 100,000\n",
            direct_standardize(cases_b, pop_b, standard)))

# Indirect, using county A's rates as the standard.
smr <- indirect_standardize(cases_b, pop_b, cases_a / pop_a)
cat(sprintf("\nCounty B against county A's rates: observed %d, expected %.1f, SMR %.2f\n",
            smr[["observed"]], smr[["expected"]], smr[["smr"]]))
