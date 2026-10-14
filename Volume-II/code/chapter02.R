## ============================================================================
## Modern Biostatistics with R & AI, Volume II
## Chapter 2: Describing and Visualizing Health Data
##
## Every listing of this part of the book, in the order the book prints it (2.1 to 2.29),
## then the code panels of the exercises. The listings share one R session, as they do in the
## book: an object made by one listing is used by later ones, so run them in order.
##
## How to run: open your RStudio project (the folder that holds the datasets folder), open this
## script, and run it line by line with Ctrl+Enter (Cmd+Return on a Mac), or all at once with
## Source. From a terminal in that folder:  Rscript Volume-II/code/chapter02.R
##
## Data: datasets/halo.csv (simulated: HALO is not real trial data).
## Packages: dplyr, ggplot2. The printed figures are drawn by figures_ch02.R.
## Lines that start with # are comments. A few panels of the book are shown here as comments,
## with a note, because they open RStudio windows, show an error on purpose, or are templates.
## Companion repository: github.com/lidagharibvand/LG
## ============================================================================

options(width = 80)
if (!interactive()) pdf(NULL)   # in a batch run, quick plots go nowhere instead of to a file

# Listing 2.25 loads the reusable Table 1 tools with source("table1_reusable.R").
# Run this script from the project folder with table1_reusable.R beside it, or use the
# copy of the tools printed in Listing 2.24 (they are the same).

## ---- Listing 2.1 Read and screen halo.csv, then count, proportion, and percentage for chest pain type. ----
halo <- read.csv("datasets/halo.csv")
names(halo) <- tolower(names(halo))   # lowercase names (Section Q.5)

# Planted impossible values, set to missing before any summary (Section 1.4)
halo$age[halo$age > 120]    <- NA
halo$bmi[halo$bmi <= 0]     <- NA
halo$sbp0[halo$sbp0 > 300]  <- NA
halo$ldl6[halo$ldl6 <= 0]   <- NA
halo$ldl12[halo$ldl12 <= 0] <- NA
halo$ldl18[halo$ldl18 <= 0] <- NA
colSums(is.na(halo[, c("age", "bmi", "sbp0", "ldl0", "total_chol", "tg")]))

# Order the chest pain types for display; R would sort them alphabetically
halo$angina <- factor(halo$angina,
                      levels = c("None", "Non-anginal", "Atypical", "Typical"))

counts <- table(halo$angina)             # frequencies
counts
round(prop.table(counts), 3)             # proportions
round(100 * prop.table(counts), 1)       # percentages

## ---- Listing 2.2 Cumulative percentages for an ordered category, and a two-way table with row percentages. ----
# halo is the data frame from Listing 2.1
# An ordered category: cumulative percentages have a meaning
halo$education <- factor(halo$education,
                         levels = c("Less than high school", "High school",
                                    "Some college", "Bachelor's or higher"))
edu <- table(halo$education)
cbind(n          = edu,
      percent    = round(100 * prop.table(edu), 1),
      cumulative = round(100 * cumsum(prop.table(edu)), 1))

# Two variables at once: chest pain type by later coronary event
halo$chdlab <- factor(ifelse(halo$chd == 1, "CHD event", "No CHD event"),
                      levels = c("CHD event", "No CHD event"))
tab <- table(halo$angina, halo$chdlab)
addmargins(tab)

round(100 * prop.table(tab, margin = 1), 1)    # row percentages

## ---- Listing 2.3 The classes of Example 2.2 with cut(). ------------------------
hand <- read.csv("datasets/halo_hand.csv")
names(hand) <- tolower(names(hand))   # lowercase names (Section Q.5)
# Classes 10 mmHg wide. right = FALSE counts 140 in 140 to 149, not below it
classes <- cut(hand$sbp0, breaks = seq(90, 170, by = 10), right = FALSE)
table(classes)

## ---- Listing 2.4 A frequency distribution of age with classes, relative frequencies, and cumulative frequencies. ----
# Age in classes 10 years wide; halo is the data frame from Listing 2.1
age_class <- cut(halo$age, breaks = seq(40, 90, by = 10), right = FALSE)
freq <- table(age_class)

# Frequency, relative frequency, percentage, and the two cumulative columns
cbind(n            = freq,
      relative     = round(prop.table(freq), 3),
      percent      = round(100 * prop.table(freq), 1),
      cumulative   = cumsum(freq),
      cum_relative = round(cumsum(freq) / sum(freq), 3))

## ---- Listing 2.5 Bar charts of chest pain type: quick checks in base R, then ggplot2 for print. ----
library(ggplot2)

# Quick checks while you work: base R, one line each
barplot(counts, ylab = "Participants")       # counts is from Listing 2.1
pie(counts)                                  # the chart on Slide 1

# For print: the data, the mapping of variables, and a layer of bars
ggplot(halo, aes(x = angina)) +
  geom_bar(fill = "#1F4E79", width = 0.6) +
  labs(x = "Chest pain type at enrollment", y = "Number of participants")

# Bars from numbers you have already computed: geom_col()
pct <- as.data.frame(round(100 * prop.table(tab, margin = 1), 1))
names(pct) <- c("angina", "status", "percent")
ggplot(subset(pct, status == "CHD event"), aes(x = angina, y = percent)) +
  geom_col(fill = "#1F4E79", width = 0.6) +
  geom_text(aes(label = percent), vjust = -0.5) +
  labs(x = "Chest pain type at enrollment",
       y = "Participants with a coronary event (%)")

## ---- Listing 2.6 Coronary events by chest pain type, sorted, with cumulative percentages and a quick Pareto chart. ----
# Coronary events by chest pain type, largest first (tab is from Listing 2.2)
events <- sort(tab[, "CHD event"], decreasing = TRUE)
cbind(events, cumulative_pct = round(100 * cumsum(events) / sum(events), 1))

barplot(events, ylab = "Coronary events")    # a quick Pareto chart

## ---- Listing 2.7 The classes of Example 2.2 as a quick histogram. --------------
# The classes of Listing 2.3 drawn as a quick histogram
hist(hand$sbp0, breaks = seq(90, 170, by = 10), right = FALSE,
     xlab = "Systolic pressure (mmHg)", main = "")

## ---- Listing 2.8 Histograms and a density curve in ggplot2. --------------------
# Quick look in base R; halo is from Listing 2.1
hist(halo$total_chol, right = FALSE, xlab = "Total cholesterol (mg/dL)",
     main = "")

# For print: choose the bin width yourself and state it. closed = "left"
# keeps the convention of Example 2.2: a value of 200 is counted in 200 to 209
ggplot(halo, aes(x = total_chol)) +
  geom_histogram(binwidth = 10, boundary = 0, closed = "left",
                 fill = "#EAF3F8", color = "#1F4E79") +
  labs(x = "Total cholesterol (mg/dL)", y = "Number of participants")

# A density curve over a histogram: put the bars on the density scale
ggplot(halo, aes(x = tg)) +
  geom_histogram(aes(y = after_stat(density)), binwidth = 20, boundary = 0,
                 closed = "left", fill = "#EAF3F8", color = "#1F4E79") +
  geom_density(color = "#B85C22", linewidth = 0.8) +
  labs(x = "Triglycerides (mg/dL)", y = "Density")

## ---- Listing 2.9 A frequency polygon of age. -----------------------------------
# A frequency polygon of age. boundary = 39.5 puts the bins on the class
# boundaries of Listing 2.4, so each point sits on a class midpoint
ggplot(halo, aes(x = age)) +
  geom_freqpoly(binwidth = 10, boundary = 39.5, color = "#1F4E79") +
  labs(x = "Age (years)", y = "Number of participants")

## ---- Listing 2.10 The points of an ogive of age, and the ogive. ----------------
# An ogive: cumulative frequency at each upper class boundary (Listing 2.4)
ogive <- data.frame(boundary   = seq(39.5, 89.5, by = 10),
                    cumulative = c(0, cumsum(freq)))
ogive

ggplot(ogive, aes(x = boundary, y = cumulative)) +
  geom_line(color = "#1F4E79") +
  geom_point(color = "#1F4E79") +
  labs(x = "Age (years), upper class boundary",
       y = "Cumulative number of participants")

## ---- Listing 2.11 A dot plot of the 20 systolic pressures. ---------------------
# A dot plot of the 20 pressures: one dot per participant, stacked
ggplot(hand, aes(x = sbp0)) +
  geom_dotplot(binwidth = 2, fill = "#1F4E79", color = "#1F4E79") +
  scale_y_continuous(breaks = NULL) +
  labs(x = "Baseline systolic pressure (mmHg)", y = NULL)

## ---- Listing 2.12 A stem-and-leaf plot of the 20 systolic pressures. -----------
# A stem-and-leaf plot of the 20 pressures, printed in the Console.
# scale = 2 gives one stem for each ten; the default would use fewer
stem(hand$sbp0, scale = 2)

## ---- Listing 2.13 Mean, median, and mode for the 20 pressures, then for total cholesterol and triglycerides in all of HALO. ----
# Example 2.3: the 20 systolic pressures (hand is from Listing 2.3)
sum(hand$sbp0)
mean(hand$sbp0)
median(hand$sbp0)

# mode() in R reports what kind of object x is, not its most common value
mode(hand$sbp0)
stat_mode <- function(x) {
  counts <- table(x)
  as.numeric(names(counts)[counts == max(counts)])
}
stat_mode(hand$sbp0)

# All 2,000 participants: a symmetric variable and a skewed one
center <- function(x) {
  c(mean = mean(x), median = median(x),
    pct_below_mean = 100 * mean(x < mean(x)))
}
round(rbind(total_chol = center(halo$total_chol),
            tg         = center(halo$tg)), 2)

## ---- Listing 2.14 Deviations, variance, and standard deviation, by the definition and with var() and sd(). ----
# Example 2.4: ages of the six women in halo_hand.csv
age_w <- hand$age[hand$female == 1]
dev   <- age_w - mean(age_w)             # deviations from the mean
rbind(age = age_w, deviation = dev, squared = dev^2)
sum(dev)                                 # deviations always sum to zero
sum(dev^2) / (length(age_w) - 1)         # variance from the definition
c(variance = var(age_w), sd = sd(age_w))

# The 20 systolic pressures of the running example
c(range = diff(range(hand$sbp0)), variance = var(hand$sbp0),
  sd = sd(hand$sbp0))

# All of HALO: total cholesterol and triglycerides
spread <- function(x) {
  c(min = min(x), max = max(x), range = diff(range(x)),
    variance = var(x), sd = sd(x))
}
round(rbind(total_chol = spread(halo$total_chol),
            tg         = spread(halo$tg)), 2)

## ---- Listing 2.15 Percentiles with quantile() under two rules, and a percentile rank. ----
x <- sort(hand$sbp0)                     # the 20 values in order
quantile(x, probs = c(0.25, 0.50, 0.75, 0.90))    # R's default rule, type 7

# Another rule in common use gives other answers in a small sample
quantile(x, probs = c(0.25, 0.75), type = 2)

# All of HALO: selected percentiles of total cholesterol
quantile(halo$total_chol, probs = c(0.10, 0.25, 0.50, 0.75, 0.90))

# Percentile rank: the share of participants at or below 275 mg/dL
100 * mean(halo$total_chol <= 275)

## ---- Listing 2.16 z-scores, and a test of the 68-95-99.7 rule on two variables. ----
# Example 2.6: two measurements on two scales
chol  <- halo$total_chol
z_340 <- (340 - mean(chol)) / sd(chol)
z_150 <- (150 - mean(halo$sbp0, na.rm = TRUE)) / sd(halo$sbp0, na.rm = TRUE)
round(c(total_chol_340 = z_340, sbp0_150 = z_150), 2)

# Does the 68-95-99.7 rule describe these two variables?
share_within <- function(x) {
  z <- (x - mean(x)) / sd(x)
  100 * c(within_1_sd = mean(abs(z) <= 1), within_2_sd = mean(abs(z) <= 2),
          within_3_sd = mean(abs(z) <= 3))
}
round(rbind(total_chol = share_within(halo$total_chol),
            tg         = share_within(halo$tg)), 2)

## ---- Listing 2.17 Five-number summary, fences, and flagged values, for the hand example and for total cholesterol. ----
# Quartiles, fences, and the number of values beyond each fence
fences <- function(x) {
  q   <- quantile(x, c(0.25, 0.75), names = FALSE)
  iqr <- q[2] - q[1]
  c(Q1 = q[1], Q3 = q[2], IQR = iqr,
    lower = q[1] - 1.5 * iqr, upper = q[2] + 1.5 * iqr,
    n_below = sum(x < q[1] - 1.5 * iqr), n_above = sum(x > q[2] + 1.5 * iqr))
}

# Example 2.7: five-number summary (and mean) of the 20 pressures, then fences
summary(hand$sbp0)
fences(hand$sbp0)

# Total cholesterol in all of HALO
summary(halo$total_chol)
fences(halo$total_chol)

# Quick boxplot in base R, then the ggplot2 version. With one variable the
# vertical axis carries no information, so its numbers are switched off
boxplot(halo$total_chol, horizontal = TRUE)
ggplot(halo, aes(x = total_chol)) +
  geom_boxplot(fill = "#EAF3F8", color = "#1F4E79") +
  scale_y_continuous(breaks = NULL) +
  labs(x = "Total cholesterol (mg/dL)")

## ---- Listing 2.18 Two flagging rules on two variables, and what each would flag in data from a normal curve. ----
# Two rules for flagging unusual values, on two variables
flagged <- function(x) {
  z <- (x - mean(x)) / sd(x)
  f <- fences(x)                         # fences() is from Listing 2.17
  c(beyond_fences = unname(f["n_below"] + f["n_above"]),
    beyond_3_sd   = sum(abs(z) > 3),
    above_3_sd    = sum(z > 3))          # how many of those are high
}
rbind(total_chol = flagged(halo$total_chol), tg = flagged(halo$tg))

# What a normal curve would give among 2,000 values (Section 3.8).
# Its fences lie 2.698 standard deviations from the mean
round(2000 * c(beyond_fences = 2 * pnorm(-2.698), beyond_3_sd = 2 * pnorm(-3)),
      1)

# Triglycerides: where the fences fall on a skewed variable
fences(halo$tg)

## ---- Listing 2.19 One impossible systolic pressure: what the fences flag with it, and four summaries with and without it. ----
# The file as recorded, with the planted systolic pressure still in it
raw <- read.csv("datasets/halo.csv")
names(raw) <- tolower(names(raw))   # lowercase names (Section Q.5)
raw[788, c("id", "sbp0")]

# The fences flag the impossible value and twelve real ones alike
fence <- fences(raw$sbp0)                # fences() is from Listing 2.17
fence[c("lower", "upper")]
sort(raw$sbp0[raw$sbp0 > fence["upper"]])

# Four summaries with the value in place and with it set to missing
four <- function(x) {
  c(mean = mean(x, na.rm = TRUE), sd = sd(x, na.rm = TRUE),
    median = median(x, na.rm = TRUE), IQR = IQR(x, na.rm = TRUE))
}
round(rbind(as_recorded = four(raw$sbp0), screened = four(halo$sbp0)), 2)

## ---- Listing 2.20 Maximum heart rate by coronary event status: a grouped summary, boxplots, and density curves. ----
library(dplyr)

# Describe each group; chdlab was created in Listing 2.2
halo %>%
  group_by(chdlab) %>%
  summarize(n = n(), mean_hr = round(mean(max_hr), 1),
            sd_hr = round(sd(max_hr), 1), q1 = quantile(max_hr, 0.25),
            median_hr = median(max_hr), q3 = quantile(max_hr, 0.75)) %>%
  as.data.frame()

# How much do the groups overlap? Percentage of the event group below
# the median of the group without an event
event    <- halo$max_hr[halo$chd == 1]
no_event <- halo$max_hr[halo$chd == 0]
round(100 * mean(event < median(no_event)), 1)

boxplot(max_hr ~ chdlab, data = halo)    # quick check

# For print: side-by-side boxplots, then overlaid density curves
ggplot(halo, aes(x = chdlab, y = max_hr)) +
  geom_boxplot(fill = "#EAF3F8", color = "#1F4E79", width = 0.5) +
  labs(x = NULL, y = "Maximum heart rate (beats per minute)")

ggplot(halo, aes(x = max_hr, color = chdlab, fill = chdlab)) +
  geom_density(alpha = 0.25) +
  scale_color_manual(values = c("#1F4E79", "#B85C22")) +
  scale_fill_manual(values = c("#1F4E79", "#B85C22")) +
  labs(x = "Maximum heart rate (beats per minute)", y = "Density",
       color = NULL, fill = NULL)

## ---- Listing 2.21 Maximum heart rate against age: means by age group, then a scatterplot with a straight-line summary for each group. ----
# A numeric summary of the trend first: mean heart rate by age group
ages <- c("42 to 50", "51 to 60", "61 to 70", "71 to 82")
halo$age_group <- cut(halo$age, breaks = c(40, 50, 60, 70, 85), labels = ages)
halo %>%
  filter(!is.na(age)) %>%
  group_by(age_group) %>%
  summarize(n = n(), mean_max_hr = round(mean(max_hr), 1)) %>%
  as.data.frame()

plot(halo$age, halo$max_hr)              # quick check

# For print: semi-transparent points, one straight-line summary per group
ggplot(halo, aes(x = age, y = max_hr, color = chdlab)) +
  geom_point(alpha = 0.35, size = 1) +
  geom_smooth(method = "lm", se = FALSE) +
  scale_color_manual(values = c("#1F4E79", "#B85C22")) +
  labs(x = "Age (years)", y = "Maximum heart rate (beats per minute)",
       color = NULL)

## ---- Listing 2.22 Mean LDL cholesterol by trial arm at each visit: summarize, then draw a time series graph. ----
# One row per participant per visit; the LDL column holds the planted values
long <- read.csv("datasets/halo_long.csv")
names(long) <- tolower(names(long))   # lowercase names (Section Q.5)
long$ldl[long$ldl <= 0] <- NA            # Section 1.4
long$arm <- factor(long$trt, levels = c(0, 1), labels = c("Placebo", "Drug"))

# Summarize first, then plot the summary
ldl_means <- long %>%
  filter(!is.na(ldl)) %>%
  group_by(arm, month) %>%
  summarize(n = n(), mean_ldl = round(mean(ldl), 1), .groups = "drop") %>%
  as.data.frame()
ldl_means

ggplot(ldl_means, aes(x = month, y = mean_ldl, color = arm)) +
  geom_line() +
  geom_point() +
  scale_x_continuous(breaks = c(0, 6, 12, 18)) +
  scale_color_manual(values = c("#1F4E79", "#B85C22")) +
  labs(x = "Month of follow-up", y = "Mean LDL cholesterol (mg/dL)",
       color = NULL)

## ---- Listing 2.23 A baseline table by treatment arm, built from four small functions. ----
# Three ways to summarize a variable, chosen by its type and shape
mean_sd <- function(x) {
  sprintf("%.1f (%.1f)", mean(x, na.rm = TRUE), sd(x, na.rm = TRUE))
}

med_q <- function(x) {
  q <- quantile(x, c(0.25, 0.50, 0.75), na.rm = TRUE)
  q <- floor(q + 0.5)                    # a half rounds up: 148.5 becomes 149
  sprintf("%.0f (%.0f-%.0f)", q[2], q[1], q[3])
}

n_pct <- function(x) sprintf("%d (%.1f)", sum(x), 100 * mean(x))
by_level <- function(x) {
  n <- table(x)
  setNames(sprintf("%d (%.1f)", as.vector(n), 100 * as.vector(prop.table(n))),
           paste0("  ", names(n)))
}

# One column of the table: every row for the participants in d
describe <- function(d) {
  c("Participants, n"                      = nrow(d),
    "Age, years, mean (SD)"                = mean_sd(d$age),
    "Women, n (%)"                         = n_pct(d$female == 1),
    "BMI, kg/m2, mean (SD)"                = mean_sd(d$bmi),
    "Systolic pressure, mmHg, mean (SD)"   = mean_sd(d$sbp0),
    "LDL cholesterol, mg/dL, mean (SD)"    = mean_sd(d$ldl0),
    "HDL cholesterol, mg/dL, mean (SD)"    = mean_sd(d$hdl),
    "Triglycerides, mg/dL, median (Q1-Q3)" = med_q(d$tg),
    "Diabetes, n (%)"                      = n_pct(d$diabetes == 1),
    "Smoker, n (%)"                        = n_pct(d$smoking == 1),
    "Statin use, n (%)"                    = n_pct(d$statins == 1),
    "Chest pain type, n (%)"               = "",
    by_level(d$angina),
    "Race and ethnicity, n (%)"            = "",
    by_level(d$race_eth))
}

# One call per column: each arm (placebo first), then everyone
halo$arm <- factor(halo$trt, levels = c(0, 1), labels = c("Placebo", "Drug"))
table1 <- cbind(Placebo = describe(halo[halo$arm == "Placebo", ]),
                Drug    = describe(halo[halo$arm == "Drug", ]),
                All     = describe(halo))
noquote(table1)

# Values set to missing in Listing 2.1, by arm
sapply(split(halo[, c("age", "bmi", "sbp0")], halo$arm),
       function(d) colSums(is.na(d)))

## ---- Listing 2.24 The tools of a reusable Table 1 (saved as table1_reusable.R). ----
# ---- Reusable Table 1 ------------------------------------------------------
# Three ways to summarize a variable, chosen by its type and shape
half_up <- function(x, digits = 0) floor(x * 10^digits + 0.5) / 10^digits

mean_sd <- function(x, digits = 1) {
  sprintf("%.*f (%.*f)", digits, mean(x, na.rm = TRUE),
                         digits, sd(x, na.rm = TRUE))
}

med_q <- function(x, digits = 0) {
  q <- half_up(quantile(x, c(0.25, 0.50, 0.75), na.rm = TRUE), digits)
  sprintf("%.*f (%.*f-%.*f)", digits, q[2], digits, q[1], digits, q[3])
}

n_pct <- function(x) {                   # x is TRUE/FALSE; missing is left out
  sprintf("%d (%.1f)", sum(x, na.rm = TRUE), 100 * mean(x, na.rm = TRUE))
}

by_level <- function(x, levels) {        # same levels in every column
  n <- table(factor(x, levels = levels))
  setNames(sprintf("%d (%.1f)", as.vector(n), 100 * as.vector(prop.table(n))),
           paste0("  ", levels))
}

# What each type prints after the label
stat_text <- c(mean = "mean (SD)", median = "median (Q1-Q3)",
               yes  = "n (%)",     levels = "n (%)")

# One column of the table: every row in spec, for the participants in d
describe <- function(d, spec, all_data) {
  out <- c("Participants, n" = as.character(nrow(d)))
  for (i in seq_len(nrow(spec))) {
    x     <- d[[spec$var[i]]]
    label <- paste0(spec$label[i], ", ", stat_text[[spec$type[i]]])
    cell  <- switch(spec$type[i],
      mean   = mean_sd(x),
      median = med_q(x),
      yes    = n_pct(x == 1),
      levels = c("", by_level(x, levels(factor(all_data[[spec$var[i]]])))),
      stop("Unknown type for ", spec$var[i], ": ", spec$type[i]))
    names(cell)[1] <- label
    out <- c(out, cell)
  }
  out
}

# The whole table: one column per level of `by`, then everyone
make_table1 <- function(data, spec, by = NULL, total = "All") {
  spec <- setNames(as.data.frame(spec, stringsAsFactors = FALSE),
                   c("var", "label", "type"))
  absent <- setdiff(c(spec$var, by), names(data))
  if (length(absent) > 0)
    stop("Not in the data: ", paste(absent, collapse = ", "))
  groups <- if (is.null(by)) list() else split(data, data[[by]])
  if (!is.null(total)) groups[[total]] <- data
  noquote(sapply(groups, describe, spec = spec, all_data = data))
}

# Missing values in the chosen variables, by group
count_missing <- function(data, vars, by) {
  sapply(split(data[, vars, drop = FALSE], data[[by]]),
         function(d) colSums(is.na(d)))
}

## ---- Listing 2.25 Table 1 for HALO from the tools: the part that changes from table to table. ----
# ---- Table 1 for HALO: the only part that changes from table to table ------
halo$arm <- factor(halo$trt, levels = c(0, 1), labels = c("Placebo", "Drug"))

spec <- rbind(
  # variable     label                          type
  c("age",      "Age, years",                  "mean"),
  c("female",   "Women",                       "yes"),
  c("bmi",      "BMI, kg/m2",                  "mean"),
  c("sbp0",     "Systolic pressure, mmHg",     "mean"),
  c("ldl0",     "LDL cholesterol, mg/dL",      "mean"),
  c("hdl",      "HDL cholesterol, mg/dL",      "mean"),
  c("tg",       "Triglycerides, mg/dL",        "median"),
  c("diabetes", "Diabetes",                    "yes"),
  c("smoking",  "Smoker",                      "yes"),
  c("statins",  "Statin use",                  "yes"),
  c("angina",   "Chest pain type",             "levels"),
  c("race_eth", "Race and ethnicity",          "levels"))

table1 <- make_table1(halo, spec, by = "arm")
table1

# Values set to missing in Listing 2.1, by arm
count_missing(halo, c("age", "bmi", "sbp0"), by = "arm")

## ---- Listing 2.26 A second Table 1 from the same tools: by coronary event, with a different spec. ----
# The same tools, a different table: only `by` and the spec change.
# chdlab (event first) and the order of education are from Listing 2.2
spec_chd <- rbind(
  # variable     label                          type
  c("age",       "Age, years",                  "mean"),
  c("female",    "Women",                       "yes"),
  c("bmi",       "BMI, kg/m2",                  "mean"),
  c("sbp0",      "Systolic pressure, mmHg",     "mean"),
  c("ldl0",      "LDL cholesterol, mg/dL",      "mean"),
  c("glucose",   "Glucose, mg/dL",              "median"),
  c("diabetes",  "Diabetes",                    "yes"),
  c("smoking",   "Smoker",                      "yes"),
  c("education", "Education",                   "levels"),
  c("angina",    "Chest pain type",             "levels"))

make_table1(halo, spec_chd, by = "chdlab")
count_missing(halo, c("age", "bmi", "sbp0"), by = "chdlab")

## ---- Listing 2.27 A variable name with the wrong capitals: the error and its message. ----
# A spec row that still says BMI in capitals, as the file had it
spec_wrong <- spec
spec_wrong[3, 1] <- "BMI"
try(make_table1(halo, spec_wrong, by = "arm"), outFile = stdout())

## ---- Code shown in Section 2.11.1 ----------------------------------------------
## A template: replace the placeholders with your own names before running it.
# # Table 1 for your own data. Replace each placeholder (mydata, group, and
# # the names in spec) with your own; do not edit table1_reusable.R
# source("table1_reusable.R")                     # the tools, unchanged
#
# mydata <- read.csv("datasets/mydata.csv")       # your file
# names(mydata) <- tolower(names(mydata))         # lowercase names (Section Q.5)
#
# # Impossible values of your own variables, one line each (Section 1.4)
# mydata$weight[mydata$weight <= 0] <- NA
#
# # The grouping variable: labels, in the order of the columns
# mydata$group <- factor(mydata$group_code, levels = c(0, 1),
#                        labels = c("Control", "Treated"))
#
# # A yes/no answer stored as text becomes 1 = yes, 0 = no
# mydata$smoker <- ifelse(mydata$smoker_text == "Yes", 1, 0)
#
# # A category with more than two levels: the order of its rows
# mydata$stage <- factor(mydata$stage, levels = c("I", "II", "III", "IV"))
#
# spec <- rbind(
#   # variable       label, with its unit        type
#   c("your_var",    "Your measure, unit",       "mean"),     # symmetric
#   c("skewed_var",  "Skewed measure, unit",     "median"),   # skewed
#   c("smoker",      "Current smoker",           "yes"),      # 1 = yes
#   c("stage",       "Stage",                    "levels"))   # categories
#
# table1 <- make_table1(mydata, spec, by = "group")  # by = NULL: one column
# table1
# count_missing(mydata, c("weight", "your_var"), by = "group")
# write.csv(table1, "table1.csv")                 # to open in Word or Excel

## ---- Listing 2.28 One HDL value, 45 mg/dL, placed among men, among women, and among all participants. ----
# The same HDL value read against two reference groups
halo$sex <- factor(ifelse(halo$female == 1, "Women", "Men"),
                   levels = c("Men", "Women"))
halo %>%
  group_by(sex) %>%
  summarize(n = n(), mean_hdl = round(mean(hdl), 2),
            sd_hdl = round(sd(hdl), 2), median_hdl = median(hdl),
            z_of_45    = round((45 - mean(hdl)) / sd(hdl), 2),
            rank_of_45 = round(100 * mean(hdl <= 45), 1)) %>%
  as.data.frame()

# Ignoring sex gives a third answer
round(c(z_of_45    = (45 - mean(halo$hdl)) / sd(halo$hdl),
        rank_of_45 = 100 * mean(halo$hdl <= 45)), 2)

## ---- Listing 2.29 Slide 3: the values above the upper fence, and the mean and standard deviation with and without them. ----
# Slide 3: the 19 values above the upper fence, and what deleting them did
# halo is from Listing 2.1 and fences() from Listing 2.17
chol <- halo$total_chol
high <- chol > fences(chol)["upper"]
c(n_flagged = sum(high), lowest = min(chol[high]), highest = max(chol[high]))
round(rbind(all_2000   = c(mean = mean(chol), sd = sd(chol)),
            without_19 = c(mean = mean(chol[!high]), sd = sd(chol[!high]))), 2)
