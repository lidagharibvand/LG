## ============================================================================
## Modern Biostatistics with R & AI, Volume II
## R Quickstart: Getting Ready to Analyze Health Data
##
## Every listing of this part of the book, in the order the book prints it (Q.1 to Q.39),
## then the code panels of the exercises. The listings share one R session, as they do in the
## book: an object made by one listing is used by later ones, so run them in order.
##
## How to run: open your RStudio project (the folder that holds the datasets folder), open this
## script, and run it line by line with Ctrl+Enter (Cmd+Return on a Mac), or all at once with
## Source. From a terminal in that folder:  Rscript Volume-II/code/quickstart.R
##
## Data: datasets/halo.csv (simulated: HALO is not real trial data).
## Packages: none. The printed figures are drawn by figures_quickstart.R.
## Lines that start with # are comments. A few panels of the book are shown here as comments,
## with a note, because they open RStudio windows, show an error on purpose, or are templates.
## Companion repository: github.com/lidagharibvand/LG
## ============================================================================

options(width = 80)
if (!interactive()) pdf(NULL)   # in a batch run, quick plots go nowhere instead of to a file

## ---- Listing Q.1 Your first command: add two numbers. --------------------------
2 + 3

## ---- Listing Q.2 Subtraction, multiplication, and division. --------------------
128 - 82
4 * 2.5
90 / 60

## ---- Listing Q.3 A first function: the square root of 16. ----------------------
sqrt(16)

## ---- Listing Q.4 A short script with comments. ---------------------------------
# Pulse pressure for a reading of 128/82 mmHg
128 - 82

# Mean arterial pressure: diastolic plus one third of the pulse pressure
82 + (128 - 82) / 3

## ---- Listing Q.5 A capital letter where R expects a small one. -----------------
# A capital S: R has no function called Sqrt
# try() prints the error and lets the script go on
try(Sqrt(16), outFile = stdout())

## ---- Listing Q.6 List the files in the datasets folder. ------------------------
list.files("datasets")

## ---- Listing Q.7 Read the HALO file and store it under the name halo. ----------
halo <- read.csv("datasets/halo.csv")

## ---- Listing Q.8 Count the rows and columns of HALO. ---------------------------
dim(halo)

## ---- Listing Q.9 The most common error: a file R cannot find. ------------------
# The folder name is missing, so R looks in the project folder
# try() prints the error and lets the script go on
try(read.csv("halo.csv"), outFile = stdout())

## ---- Listing Q.10 Your first R script, saved as first_script.R. ----------------
# first_script.R
# Read the HALO trial data and check its size
# Written by: your name, on today's date

halo <- read.csv("datasets/halo.csv")
dim(halo)

## ---- Listing Q.11 The number of rows and the number of columns. ----------------
nrow(halo)
ncol(halo)

## ---- Listing Q.12 The names of the 38 variables. -------------------------------
names(halo)

## ---- Listing Q.13 Change every variable name to lowercase. ---------------------
# Change variable names to lower case
names(halo) <- tolower(names(halo))
names(halo)

## ---- Listing Q.14 The numbers from 1 to 5. -------------------------------------
1:5

## ---- Listing Q.15 The first five rows and first five columns of HALO. ----------
halo[1:5, 1:5]

## ---- Listing Q.16 Five rows and three columns chosen by name. ------------------
halo[1:5, c("id", "age", "sbp0")]

## ---- Listing Q.17 Store a slice of HALO under its own name and print it. -------
# Save the slice under its own name, then print it
small <- halo[1:5, c("id", "age", "sbp0")]
small

## ---- Listing Q.18 The first six rows of HALO. ----------------------------------
head(halo)

## ---- Code shown in Section Q.5.7 -----------------------------------------------
## View() opens a spreadsheet view in RStudio; run it yourself in the Console.
# View(halo)

## ---- Listing Q.19 The first six values of age, and a misspelled column name. ----
head(halo$age)

# A capital A: HALO has no column called Age
head(halo$Age)

## ---- Listing Q.20 The structure of HALO: the type of every variable. -----------
str(halo)

## ---- Listing Q.21 The type of age, of body mass index, and of chest pain type. ----
class(halo$age)
class(halo$bmi)
class(halo$angina)

## ---- Listing Q.22 A category stored as a code and a category stored as text. ----
# Sex: 1 = women, 0 = men
head(halo$female)

# Chest pain type, stored as text
head(halo$angina)

## ---- Listing Q.23 The mean total cholesterol. ----------------------------------
mean(halo$total_chol)

## ---- Listing Q.24 The median total cholesterol. --------------------------------
median(halo$total_chol)

## ---- Listing Q.25 The smallest and largest total cholesterol. ------------------
min(halo$total_chol)
max(halo$total_chol)

## ---- Listing Q.26 A six-number summary of total cholesterol. -------------------
summary(halo$total_chol)

## ---- Listing Q.27 A six-number summary of age. ---------------------------------
summary(halo$age)

## ---- Listing Q.28 The mean of a variable with missing values. ------------------
mean(halo$ldl12)

## ---- Listing Q.29 The same mean, leaving out the missing values. ---------------
mean(halo$ldl12, na.rm = TRUE)

## ---- Listing Q.30 Store the mean under a name, then print it. ------------------
# Save the mean under a name; R prints nothing
avg_chol <- mean(halo$total_chol)

# Type the name to see what is stored
avg_chol

## ---- Listing Q.31 Round the stored mean to one decimal place. ------------------
round(avg_chol, 1)

## ---- Listing Q.32 Count the participants in each chest pain category. ----------
table(halo$angina)

## ---- Listing Q.33 Count the participants in each arm of the trial. -------------
table(halo$trt)

## ---- Listing Q.34 A bar chart of chest pain type. ------------------------------
barplot(table(halo$angina))

## ---- Listing Q.35 A histogram of total cholesterol. ----------------------------
hist(halo$total_chol)

## ---- Listing Q.36 The same histogram with a title and axis labels. -------------
hist(halo$total_chol,
     main = "Total cholesterol at enrollment",
     xlab = "Total cholesterol (mg/dL)",
     ylab = "Number of participants")

## ---- Listing Q.37 A first complete script: read, check, count, average, and draw. ----
# halo_first_look.R
# A first look at the HALO trial data

# Read the data, make the names lowercase, and check the size
halo <- read.csv("datasets/halo.csv")
names(halo) <- tolower(names(halo))
dim(halo)

# Count chest pain types and average total cholesterol
table(halo$angina)
mean(halo$total_chol)

# Draw the counts as a bar chart
barplot(table(halo$angina),
        main = "Chest pain type at enrollment",
        xlab = "Chest pain type",
        ylab = "Number of participants")

## ---- Code shown in Section Q.9.3 -----------------------------------------------
## Opens the help page in RStudio; run it yourself in the Console.
# ?mean
# help(mean)

## ---- Listing Q.38 A name typed with a capital letter. --------------------------
# A capital H: the data frame is called halo, not Halo
# try() prints the error and lets the script go on
try(mean(Halo$age), outFile = stdout())

## ---- Listing Q.39 A function name typed with a capital letter. -----------------
# A capital M: the function is mean(), not Mean()
# try() prints the error and lets the script go on
try(Mean(halo$age), outFile = stdout())

## ---- Code shown in Section Q.9.4 -----------------------------------------------
## An example of an error (Section Q.9.4): run it in the Console to see the message.
# mean(halo$age


## ============================================================================
## The code panels of the exercises. Each one reads the data again, so it can be run on its own.
## ============================================================================

## ---- Quickstart Practice, code panel 1 -----------------------------------------
halo <- read.csv("datasets/halo.csv")
names(halo) <- tolower(names(halo))   # lowercase names (Section Q.5.3)
table(halo$site)

## ---- Quickstart Practice, code panel 2 -----------------------------------------
halo <- read.csv("datasets/halo.csv")
names(halo) <- tolower(names(halo))   # lowercase names (Section Q.5.3)
mean(halo$hdl)

## ---- Quickstart Practice, code panel 3 -----------------------------------------
halo <- read.csv("datasets/halo.csv")
names(halo) <- tolower(names(halo))   # lowercase names (Section Q.5.3)
summary(halo$sbp0)

## ---- Quickstart Practice, code panel 4 -----------------------------------------
halo <- read.csv("datasets/halo.csv")
names(halo) <- tolower(names(halo))   # lowercase names (Section Q.5.3)
class(halo$female)
table(halo$female)

## ---- Quickstart Practice, code panel 5 -----------------------------------------
halo <- read.csv("datasets/halo.csv")
names(halo) <- tolower(names(halo))   # lowercase names (Section Q.5.3)
# Count the participants in each chest pain category
table(halo$Angina)
