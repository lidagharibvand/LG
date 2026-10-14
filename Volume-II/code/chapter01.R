## ============================================================================
## Modern Biostatistics with R & AI, Volume II
## Chapter 1: Working with Health Data in R
##
## Every listing of this part of the book, in the order the book prints it (1.1 to 1.54),
## then the code panels of the exercises. The listings share one R session, as they do in the
## book: an object made by one listing is used by later ones, so run them in order.
##
## How to run: open your RStudio project (the folder that holds the datasets folder), open this
## script, and run it line by line with Ctrl+Enter (Cmd+Return on a Mac), or all at once with
## Source. From a terminal in that folder:  Rscript Volume-II/code/chapter01.R
##
## Data: datasets/halo.csv (simulated: HALO is not real trial data).
## Packages: dplyr. The printed figures are drawn by figures_ch01.R.
## Lines that start with # are comments. A few panels of the book are shown here as comments,
## with a note, because they open RStudio windows, show an error on purpose, or are templates.
## Companion repository: github.com/lidagharibvand/LG
## ============================================================================

options(width = 80)
if (!interactive()) pdf(NULL)   # in a batch run, quick plots go nowhere instead of to a file

## ---- Listing 1.1 Read HALO and list the different values of one column. --------
# Read the HALO file (Section Q.4)
halo <- read.csv("datasets/halo.csv")
names(halo) <- tolower(names(halo))   # lowercase names (Section Q.5)

# The different values that occur in the site column
unique(halo$site)

## ---- Listing 1.2 Count the different participant identifiers. ------------------
# Every identifier in the file, each one listed once
ids <- unique(halo$id)

# How many different identifiers there are
length(ids)

## ---- Listing 1.3 The codes used for the number of narrowed vessels, in order. ----
# The codes used for the number of narrowed vessels
vessel_codes <- unique(halo$vessels)
vessel_codes

# The same codes, put in order
sort(vessel_codes)

## ---- Listing 1.4 How many different values a count and a measurement take. -----
# How many different values does the count of other conditions take?
comorb_values <- unique(halo$comorb)
length(comorb_values)

# And body mass index?
bmi_values <- unique(halo$bmi)
length(bmi_values)

## ---- Listing 1.5 The frequency table of a count variable. ----------------------
# A count variable: how many participants have 0, 1, 2, ... other conditions
table(halo$comorb)

## ---- Listing 1.6 A bar chart of a nominal variable: the right match. -----------
# A qualitative variable: one bar for each clinic
barplot(table(halo$site), main = "Participants at each clinic",
        xlab = "Clinic", ylab = "Participants")

## ---- Listing 1.7 A histogram of a continuous variable: the right match. --------
# A continuous measurement: a histogram groups the values into intervals
hist(halo$bmi, main = "Body mass index at enrollment",
     xlab = "Body mass index (kg/m2)", ylab = "Participants")

## ---- Listing 1.8 A bar chart of a continuous variable: the wrong match. --------
# The wrong graph: a bar for every different value of body mass index
barplot(table(halo$bmi), main = "One bar for each value of BMI",
        xlab = "Body mass index (kg/m2)", ylab = "Participants")

## ---- Listing 1.9 Six-number summaries of age, body mass index, and baseline systolic pressure. ----
# Summaries of three baseline measurements at once
summary(halo[, c("age", "bmi", "sbp0")])

## ---- Listing 1.10 A histogram of age as the file was read. ---------------------
# A histogram of age, as the file was read
hist(halo$age, main = "Age at enrollment", xlab = "Age (years)")

## ---- Listing 1.11 Six ages, and the answer to “is this age above 65?” for each. ----
# The ages of the first six participants
first_ages <- halo$age[1:6]
first_ages

# Is each of these six ages above 65?
first_ages > 65

## ---- Listing 1.12 Count the participants recorded as older than 120, and those enrolled at North. ----
# How many participants are recorded as older than 120 years?
sum(halo$age > 120)

# How many participants were enrolled at the North clinic?
sum(halo$site == "North")

## ---- Listing 1.13 The row number of the impossible age, and the identifier in that row. ----
# Which row holds the age above 120?
which(halo$age > 120)

# Show the identifier and the age in that row
halo[halo$age > 120, c("id", "age")]

## ---- Listing 1.14 The range of baseline systolic pressure and of LDL cholesterol at three later visits. ----
# Smallest and largest value of pressure and LDL cholesterol
range(halo$sbp0)
range(halo$ldl6, na.rm = TRUE)
range(halo$ldl12, na.rm = TRUE)
range(halo$ldl18, na.rm = TRUE)

## ---- Listing 1.15 The categories of clinic, sex, and education, with their counts. ----
# Every value of three category columns, with its count
table(halo$site)
table(halo$female)
table(halo$education)

## ---- Listing 1.16 Mean and median age, with and without the impossible value. ----
# Mean age with every value, then without the impossible one
mean(halo$age)
mean(halo$age[halo$age <= 120])

# The median, the same two ways
median(halo$age)
median(halo$age[halo$age <= 120])

## ---- Listing 1.17 Set the impossible age to missing, then check the column. ----
# Set the impossible age to missing (NA)
halo$age[halo$age > 120] <- NA

# Check: the largest age now, and the count of NA
summary(halo$age)

# Check: is any age above 120 left?
which(halo$age > 120)

## ---- Listing 1.18 The screening block: six planted values set to missing. ------
# Planted impossible values, set to missing (Section 1.4)
halo$age[halo$age > 120]    <- NA
halo$bmi[halo$bmi <= 0]     <- NA
halo$sbp0[halo$sbp0 > 300]  <- NA
halo$ldl6[halo$ldl6 <= 0]   <- NA
halo$ldl12[halo$ldl12 <= 0] <- NA
halo$ldl18[halo$ldl18 <= 0] <- NA

## ---- Listing 1.19 Check the other screened columns. ----------------------------
# Check four of the other screened columns
summary(halo[, c("bmi", "sbp0", "ldl6", "ldl12")])

# and the smallest LDL value left at 18 months
min(halo$ldl18, na.rm = TRUE)

## ---- Listing 1.20 The highest triglyceride value, with the participant’s other measurements. ----
# The highest triglyceride value, and the participant who has it
max(halo$tg)
halo[halo$tg > 900, c("id", "tg", "hdl", "bmi", "glucose")]

## ---- Listing 1.21 Count the identifiers that repeat an earlier one. ------------
# How many identifiers repeat one that appeared earlier?
sum(duplicated(halo$id))

## ---- Listing 1.22 Which of ten LDL values at 12 months are missing, and how many are missing in all. ----
# LDL cholesterol at 12 months for the first ten participants
halo$ldl12[1:10]

# Which of these ten values are missing?
is.na(halo$ldl12[1:10])

# How many of all 2,000 values are missing?
sum(is.na(halo$ldl12))

## ---- Listing 1.23 The number of missing values in each of the 38 columns. ------
# Count the NAs in every column of the data frame
colSums(is.na(halo))

## ---- Listing 1.24 A table of a comparison, without and with the missing values counted. ----
# Participants with LDL of 160 mg/dL or more at 18 months
table(halo$ldl18 >= 160)

# The same table, with the missing values counted
table(halo$ldl18 >= 160, useNA = "ifany")

## ---- Listing 1.25 Missing LDL at 18 months by trial arm. -----------------------
# Missing LDL at 18 months, by trial arm (trt: 0 = placebo, 1 = drug)
table(halo$trt, is.na(halo$ldl18))

## ---- Listing 1.26 Complete cases for two analyses. -----------------------------
# Participants with LDL at both baseline and 12 months
both <- complete.cases(halo[, c("ldl0", "ldl12")])
sum(both)

# Participants with LDL at all three later visits
later <- complete.cases(halo[, c("ldl6", "ldl12", "ldl18")])
sum(later)

## ---- Listing 1.27 Rows with no missing value in any column. --------------------
# Rows with no missing value in any of the 38 columns
no_gaps <- complete.cases(halo)
sum(no_gaps)

## ---- Code shown in Section 1.5.7 -----------------------------------------------
## A template: replace the placeholders with your own names before running it.
# # Exclude missing cases
# halo <- halo[!is.na(halo$XX), ]

## ---- Listing 1.28 The participants with an LDL value at 12 months, in a new data frame. ----
# Keep the participants with an LDL value at 12 months, under a new name
halo_ldl12 <- halo[!is.na(halo$ldl12), ]
nrow(halo_ldl12)

# halo itself still holds everyone
nrow(halo)

## ---- Listing 1.29 A labeled factor for sex, checked against its codes. ---------
# A labeled copy of female (codebook: 0 = men, 1 = women)
halo$sex <- factor(halo$female, levels = c(0, 1),
                   labels = c("Men", "Women"))

# The first six values of the new column
head(halo$sex)

# Check the new column against the codes it came from
table(halo$female, halo$sex)

## ---- Listing 1.30 Labeled factors for trial arm and outcome, each checked. -----
# Labeled copies of the trial arm and of the outcome
halo$arm <- factor(halo$trt, levels = c(0, 1),
                   labels = c("Placebo", "Drug"))
halo$event <- factor(halo$chd, levels = c(0, 1),
                     labels = c("No CHD event", "CHD event"))

# Check each one against its codes
table(halo$trt, halo$arm)
table(halo$chd, halo$event)

## ---- Listing 1.31 Chest pain type in clinical order. ---------------------------
# Chest pain type with its categories in clinical order
pain_order <- c("None", "Non-anginal", "Atypical", "Typical")
halo$angina_f <- factor(halo$angina, levels = pain_order)

# The text column, then the factor
table(halo$angina)
table(halo$angina_f)

## ---- Listing 1.32 The change in LDL cholesterol from baseline to 12 months. ----
# Change in LDL from baseline to 12 months (later minus earlier)
halo$ldl_change <- halo$ldl12 - halo$ldl0
summary(halo$ldl_change)

## ---- Listing 1.33 A yes-or-no column for obesity. ------------------------------
# A yes-or-no column: body mass index of 30 or more
halo$obese <- ifelse(halo$bmi >= 30, "Yes", "No")
table(halo$obese, useNA = "ifany")

## ---- Listing 1.34 Age groups, with a check of the boundary at 65. --------------
# Age groups: 40 to 54, 55 to 64, 65 to 74, 75 to 84
halo$age_group <- cut(halo$age, breaks = c(40, 55, 65, 75, 85),
                      right = FALSE)
table(halo$age_group, useNA = "ifany")

# Check a boundary: where did the participants aged 65 go?
table(halo$age_group[halo$age == 65])

## ---- Code shown in Section 1.7.1 -----------------------------------------------
## Run this once in the Console, not in a script (Section 1.7.1).
# # Run once on each computer (not every session)
# install.packages("dplyr")

## ---- Listing 1.35 Load dplyr for this session. ---------------------------------
# Load dplyr for this session (once per session, near the top of the script)
library(dplyr)

## ---- Listing 1.36 Keep four columns. -------------------------------------------
# Keep four columns (dplyr was loaded in Listing 1.35)
small <- select(halo, id, arm, age, ldl0)
head(small)

## ---- Listing 1.37 The participants aged 80 or older. ---------------------------
# Keep the participants aged 80 or older
oldest <- filter(halo, age >= 80)
nrow(oldest)

## ---- Listing 1.38 Pulse pressure at baseline, added with mutate(). -------------
# Add pulse pressure (systolic minus diastolic), in mmHg
halo <- mutate(halo, pulse_pressure = sbp0 - dbp0)
summary(halo$pulse_pressure)

## ---- Listing 1.39 The four-column table sorted by baseline LDL. ----------------
# Sort the four-column table by baseline LDL, lowest first
sorted <- arrange(small, ldl0)
head(sorted, 3)

## ---- Listing 1.40 The mean LDL at 12 months for the whole trial. ---------------
# One summary row for the whole trial
summarize(halo, mean_ldl12 = mean(ldl12, na.rm = TRUE))

## ---- Listing 1.41 Mean LDL at 12 months and the number of participants, by trial arm. ----
# The same summary for each trial arm, with the number of rows
by_arm <- group_by(halo, arm)
summarize(by_arm, n = n(), mean_ldl12 = mean(ldl12, na.rm = TRUE))

## ---- Listing 1.42 Listing 1.41 again, as two steps joined by the pipe. ---------
# Listing 1.41 again, written with the pipe
halo %>%
  group_by(arm) %>%
  summarize(n = n(), mean_ldl12 = mean(ldl12, na.rm = TRUE))

## ---- Listing 1.43 Three steps: the mean change in LDL among women, by trial arm. ----
# Mean change in LDL among the women, by trial arm
halo %>%
  filter(sex == "Women") %>%
  group_by(arm) %>%
  summarize(n = n(), mean_change = mean(ldl_change, na.rm = TRUE))

## ---- Listing 1.44 The rows of Listing 1.37 again, with base R. -----------------
# Base R: the same rows as Listing 1.37, with subset()
oldest_b <- subset(halo, age >= 80)
nrow(oldest_b)

## ---- Listing 1.45 Make the output folder. --------------------------------------
# Make a folder for results (quietly, if it already exists)
dir.create("output", showWarnings = FALSE)

## ---- Listing 1.46 Save the screened, labeled data in the output folder. --------
# Save the screened, labeled data under a new name
write.csv(halo, "output/halo_clean.csv", row.names = FALSE)

# Check that the file is there
list.files("output")

## ---- Listing 1.47 The software record, trimmed to the version of R and the packages attached. ----
# The record of R and the packages behind these results
sessionInfo()

## ---- Listing 1.48 A real error message: a table of chest pain type by clinic. ----
# try() prints the error message and lets the script go on
try(table(halo$angina, halo$Site), outFile = stdout())

## ---- Listing 1.49 An AI draft of a screening line, tested on a value you know is there. ----
# A fresh copy of the file to test the draft on
test <- read.csv("datasets/halo.csv")
names(test) <- tolower(names(test))   # lowercase names (Section Q.5)

# The assistant's draft of the BMI screening line
test$bmi[test$bmi < 0] <- NA

# The check: is any body mass index still recorded as 0?
sum(test$bmi == 0, na.rm = TRUE)

## ---- Code shown in Section 1.9.4 -----------------------------------------------
# make a chart

# Histogram of total_chol in the data frame halo, with base R hist(),
# the title "Total cholesterol at baseline", and the x-axis label
# "Total cholesterol (mg/dL)"

## ---- Code shown in Section 1.9.4 -----------------------------------------------
# Read datasets/halo.csv into a data frame called halo
halo <- read.csv("datasets/halo.csv")
names(halo) <- tolower(names(halo))   # lowercase names (Section Q.5)

# Count the participants in each category of angina
table(halo$angina)

# Bar chart of these counts with base R barplot() and a title
barplot(table(halo$angina), main = "Chest pain type at enrollment")

## ---- Listing 1.50 One script from the raw trial file to analysis-ready data. ----
# 01_prepare.R  From halo.csv to analysis-ready data
# Input:  datasets/halo.csv (2,000 participants, 38 columns)
# Output: output/halo_ready.csv
# Rules:  Chapter 1, Sections 1.4 to 1.6

# 1. Read the raw file and check it
halo <- read.csv("datasets/halo.csv")
names(halo) <- tolower(names(halo))   # lowercase names (Section Q.5)
dim(halo)
sum(duplicated(halo$id))
sum(is.na(halo))

# 2. Planted impossible values, set to missing (Section 1.4)
halo$age[halo$age > 120]    <- NA
halo$bmi[halo$bmi <= 0]     <- NA
halo$sbp0[halo$sbp0 > 300]  <- NA
halo$ldl6[halo$ldl6 <= 0]   <- NA
halo$ldl12[halo$ldl12 <= 0] <- NA
halo$ldl18[halo$ldl18 <= 0] <- NA
sum(is.na(halo))

# 3. Readable labels for the coded variables (Section 1.6)
halo$sex <- factor(halo$female, levels = c(0, 1),
                   labels = c("Men", "Women"))
halo$arm <- factor(halo$trt, levels = c(0, 1),
                   labels = c("Placebo", "Drug"))
halo$event <- factor(halo$chd, levels = c(0, 1),
                     labels = c("No CHD event", "CHD event"))

# 4. A derived variable (Section 1.6)
halo$ldl_change <- halo$ldl12 - halo$ldl0

# 5. Check the result and save it under a new name
dim(halo)
table(halo$female, halo$sex)
sum(is.na(halo$ldl_change))
dir.create("output", showWarnings = FALSE)
write.csv(halo, "output/halo_ready.csv", row.names = FALSE)

## ---- Listing 1.51 A file cut short by a template, the calls it loses, and a control total. ----
# The laboratory sent 2,000 rows; the template kept 1,500
received <- read.csv("datasets/halo.csv")
names(received) <- tolower(names(received))   # lowercase names (Section Q.5)
template <- received[1:1500, ]

# Participants with baseline LDL of 190 mg/dL or more, in each
sum(received$ldl0 >= 190)
sum(template$ldl0 >= 190)

# The control total: does the row count match what was sent?
nrow(template) == 2000

## ---- Listing 1.52 The reports of Analysts A and C. -----------------------------
# The file as the three analysts received it
raw <- read.csv("datasets/halo.csv")
names(raw) <- tolower(names(raw))   # lowercase names (Section Q.5)

# Analyst A: every row and every value, as read
mean(raw$age)
mean(raw$sbp0)

# Analyst C: the two impossible values set to missing, on a copy
c_file <- raw
c_file$age[c_file$age > 120] <- NA
c_file$sbp0[c_file$sbp0 > 300] <- NA
mean(c_file$age, na.rm = TRUE)
mean(c_file$sbp0, na.rm = TRUE)

## ---- Listing 1.53 The report of Analyst B, and what it kept. -------------------
# Analyst B: only the rows with no missing value anywhere
b_rows <- complete.cases(raw)
sum(b_rows)
mean(raw$age[b_rows])
mean(raw$sbp0[b_rows])

# The two impossible values are still in Analyst B's rows
max(raw$age[b_rows])
max(raw$sbp0[b_rows])

## ---- Listing 1.54 Which code means women? A check from outside the file. -------
# Which code is women? Mean HDL (mg/dL) for code 1, then code 0
mean(raw$hdl[raw$female == 1])
mean(raw$hdl[raw$female == 0])


## ============================================================================
## The code panels of the exercises. Each one reads the data again, so it can be run on its own.
## ============================================================================

## ---- Exercises for Section 1.1, code panel 1 -----------------------------------
halo <- read.csv("datasets/halo.csv")
names(halo) <- tolower(names(halo))   # lowercase names (Section Q.5)
edu <- unique(halo$education)
edu
sort(edu)
length(edu)

## ---- Exercises for Section 1.1, code panel 2 -----------------------------------
halo <- read.csv("datasets/halo.csv")
names(halo) <- tolower(names(halo))   # lowercase names (Section Q.5)
sites <- unique(halo$Site)
sites
length(sites)

## ---- Exercises for Section 1.2, code panel 1 -----------------------------------
halo <- read.csv("datasets/halo.csv")
names(halo) <- tolower(names(halo))   # lowercase names (Section Q.5)
table(halo$vessels)

## ---- Exercises for Section 1.2, code panel 2 -----------------------------------
halo <- read.csv("datasets/halo.csv")
names(halo) <- tolower(names(halo))   # lowercase names (Section Q.5)
class(halo$education)
class(halo$vessels)
class(halo$female)

## ---- Exercises for Section 1.2, code panel 3 -----------------------------------
halo <- read.csv("datasets/halo.csv")
names(halo) <- tolower(names(halo))   # lowercase names (Section Q.5)
ages <- unique(halo$age)
length(ages)
sort(ages)

## ---- Exercises for Section 1.3, code panel 1 -----------------------------------
halo <- read.csv("datasets/halo.csv")
names(halo) <- tolower(names(halo))   # lowercase names (Section Q.5)
which(halo$bmi <= 0)
halo[halo$bmi <= 0, c("id", "bmi", "weight0")]

## ---- Exercises for Section 1.3, code panel 2 -----------------------------------
halo <- read.csv("datasets/halo.csv")
names(halo) <- tolower(names(halo))   # lowercase names (Section Q.5)
sum(halo$ldl12 <= 0)
sum(halo$ldl12 <= 0, na.rm = TRUE)

## ---- Exercises for Section 1.4, code panel 1 -----------------------------------
halo <- read.csv("datasets/halo.csv")
names(halo) <- tolower(names(halo))   # lowercase names (Section Q.5)
halo$age[halo$age > 120] == NA
max(halo$age)

## ---- Exercises for Section 1.4, code panel 2 -----------------------------------
ages <- c(64, 999, 71)
mean(ages)
ages[ages > 120] <- NA
mean(ages, na.rm = TRUE)

## ---- Exercises for Section 1.5, code panel 1 -----------------------------------
halo <- read.csv("datasets/halo.csv")
names(halo) <- tolower(names(halo))   # lowercase names (Section Q.5)
colSums(is.na(halo[, c("sbp0", "sbp6", "sbp12", "sbp18")]))

## ---- Exercises for Section 1.5, code panel 2 -----------------------------------
halo <- read.csv("datasets/halo.csv")
names(halo) <- tolower(names(halo))   # lowercase names (Section Q.5)
table(halo$sbp18 >= 140)
table(halo$sbp18 >= 140, useNA = "ifany")

## ---- Exercises for Section 1.6, code panel 1 -----------------------------------
halo <- read.csv("datasets/halo.csv")
names(halo) <- tolower(names(halo))   # lowercase names (Section Q.5)
halo$sex <- factor(halo$female, levels = c(0, 1),
                   labels = c("Women", "Men"))
table(halo$sex)
mean(halo$hdl[halo$sex == "Women"])
mean(halo$hdl[halo$sex == "Men"])

## ---- Exercises for Section 1.6, code panel 2 -----------------------------------
halo <- read.csv("datasets/halo.csv")
names(halo) <- tolower(names(halo))   # lowercase names (Section Q.5)
pain <- factor(halo$angina,
               levels = c("None", "Non anginal", "Atypical", "Typical"))
table(pain, useNA = "ifany")

## ---- Exercises for Section 1.7, code panel 1 -----------------------------------
halo <- read.csv("datasets/halo.csv")
names(halo) <- tolower(names(halo))   # lowercase names (Section Q.5)
library(dplyr)
halo$arm <- factor(halo$trt, levels = c(0, 1),
                   labels = c("Placebo", "Drug"))
halo %>%
  group_by(arm) %>%
  summarize(n = n(), mean_sbp12 = mean(sbp12))

## ---- Exercises for Section 1.7, code panel 2 -----------------------------------
halo <- read.csv("datasets/halo.csv")
names(halo) <- tolower(names(halo))   # lowercase names (Section Q.5)
library(dplyr)
# try() prints the error message and lets the script go on
try(filter(halo, site = "South"), outFile = stdout())

## ---- Exercises for Section 1.8, code panel 1 -----------------------------------
halo <- read.csv("datasets/halo.csv")
names(halo) <- tolower(names(halo))   # lowercase names (Section Q.5)
dir.create("output", showWarnings = FALSE)
write.csv(halo[1:3, c("id", "age")], "output/three.csv")
back <- read.csv("output/three.csv")
back

## ---- Exercises for Section 1.8, code panel 2 -----------------------------------
# try() prints the error message and lets the script go on
try(read.csv("datasets/halo_clean.csv"), outFile = stdout())

## ---- Exercises for Section 1.9, code panel 1 -----------------------------------
halo <- read.csv("datasets/halo.csv")
names(halo) <- tolower(names(halo))   # lowercase names (Section Q.5)
# try() prints the error message and lets the script go on
try(factor(halo$female, levels = c(0, 1),
           labels = c("Men", "Women", "Unknown")), outFile = stdout())

## ---- Exercises for Section 1.9, code panel 2 -----------------------------------
halo <- read.csv("datasets/halo.csv")
names(halo) <- tolower(names(halo))   # lowercase names (Section Q.5)
table(halo$Angina)
table(halo$angina)

## ---- Exercises for Section 1.10, code panel 1 ----------------------------------
halo <- read.csv("datasets/halo.csv")
names(halo) <- tolower(names(halo))   # lowercase names (Section Q.5)
# The change score made BEFORE the screening
halo$ldl_change <- halo$ldl12 - halo$ldl0
halo$ldl12[halo$ldl12 <= 0] <- NA

min(halo$ldl_change, na.rm = TRUE)
sum(is.na(halo$ldl_change))

## ---- Exercises for Section 1.10, code panel 2 ----------------------------------
halo <- read.csv("datasets/halo.csv")
names(halo) <- tolower(names(halo))   # lowercase names (Section Q.5)
halo$sex <- factor(halo$female, levels = c(0, 1),
                   labels = c("Men", "Women"))
class(halo$sex)
dir.create("output", showWarnings = FALSE)
write.csv(halo, "output/halo_sex.csv", row.names = FALSE)
back <- read.csv("output/halo_sex.csv")
class(back$sex)
table(back$sex)

## ---- Lab: Frequency Tables and Charts, code panel 1 ----------------------------
halo <- read.csv("datasets/halo.csv")
names(halo) <- tolower(names(halo))   # lowercase names (Section Q.5)
# Education in order of schooling (factor levels, Section 1.6)
edu_order <- c("Less than high school", "High school",
               "Some college", "Bachelor's or higher")
education_f <- factor(halo$education, levels = edu_order)
pie(table(education_f), main = "Highest education at enrollment")

## ---- Lab: Frequency Tables and Charts, code panel 2 ----------------------------
halo <- read.csv("datasets/halo.csv")
names(halo) <- tolower(names(halo))   # lowercase names (Section Q.5)
statin_use <- factor(halo$statins, levels = c(0, 1),
                     labels = c("No", "Yes"))
counts <- table(statin_use)
bars <- barplot(counts, ylim = c(0, 1400),
                main = "Statin use at enrollment",
                xlab = "Taking a statin", ylab = "Participants")
text(bars, counts, labels = counts, pos = 3)
