# ===========================================================================
# Biostatistics with R and AI -- Volume II
# Chapter 1: Exploring Data with Tables and Graphs
#
# Every R listing in Chapter 1, in the order it appears, ready to run.
#
# Before you start:
#   * put heart.csv in your working directory, or edit the path in Part 3
#   * run Part 2 once per machine, then comment it out
#
# Check your position with getwd() at any time.
# ===========================================================================


# ---------------------------------------------------------------------------
# PART 1  --  The rules of the road (Sections 1.3.3 and 1.3.4)
# ---------------------------------------------------------------------------

# Listing 1.1  Using comments to document an R script
install.packages("readr")        # install the package only once
library(readr)                   # load the package every session
heart <- read_csv("heart.csv")   # read in the companion heart.csv file

# Listing 1.2  Asking R for help
?summary       # open the help page for summary()
?mean          # open the help page for mean()
??regression   # search all installed help for the word "regression"


# ---------------------------------------------------------------------------
# PART 2  --  Packages (Section 1.5)   [run once per machine]
# ---------------------------------------------------------------------------

# Listing 1.5  Installing and loading the core packages used in this chapter
install.packages("tidyverse")   # broad collection of data tools
install.packages("haven")       # for reading SPSS, Stata, SAS files
install.packages("readr")       # for reading CSV files
install.packages("ggplot2")     # for advanced graphics

library(tidyverse)
library(haven)
library(readr)
library(ggplot2)


# ---------------------------------------------------------------------------
# PART 3  --  Three ways to import data (Section 1.7)
# ---------------------------------------------------------------------------

# Listing 1.3  Method 1 -- importing by full file path
#   Left commented because the path is a placeholder: edit it to your own
#   and uncomment if you want to run this method.
library(readr)
# heart <- read_csv("/path/to/your/data/heart.csv")

# Listing 1.4  Method 2 -- discovering the current working directory
getwd()
# [1] "/Users/LG/Documents/R Workdirectory Default"

# Listing 1.6  Importing heart.csv
#   setwd() is commented for the same reason. If heart.csv is already in
#   your working directory, the read_csv() line below is all you need.
# setwd("C:/Users/admin/Documents/biostat/data/")
heart <- read_csv("heart.csv")

# Quick look at the data
head(heart)
dim(heart)      # expect 303 rows and 14 columns


# ---------------------------------------------------------------------------
# PART 4  --  Exploring qualitative variables (Section 1.8)
# ---------------------------------------------------------------------------

# Listing 1.7  Building a frequency table
# Frequencies for chest pain type
counts <- table(heart$cp)
counts

# Output:
#   0    1    2    3
# 143   50   87   23

# Listing 1.8  A simple base R bar chart
barplot(counts,
        main = "Frequencies of Chest Pain Type",
        xlab = "cp",
        col  = "steelblue")

# Listing 1.9  Pie chart of a categorical variable
pie(counts,
    main = "Chest Pain Type Distribution",
    col  = rainbow(length(counts)))


# ---------------------------------------------------------------------------
# PART 5  --  Exploring quantitative variables (Section 1.9)
# ---------------------------------------------------------------------------

# Listing 1.10  Histogram of a continuous variable
hist(heart$age,
     main   = "Histogram for Age",
     xlab   = "Age (years)",
     col    = "steelblue",
     border = "black")

# Listing 1.11  Single boxplot
boxplot(heart$chol,
        main = "Boxplot for Cholesterol",
        ylab = "Serum cholesterol (mg/dL)",
        col  = "steelblue")

# Listing 1.12  Stratified boxplot
boxplot(heart$age ~ heart$target,
        main = "Age by Heart Disease Status",
        ylab = "Age (years)",
        xlab = "target (0 = disease, 1 = no disease)",
        col  = c("steelblue", "firebrick"))


# ---------------------------------------------------------------------------
# PART 6  --  Outliers (Section 1.10)
# ---------------------------------------------------------------------------

# The arithmetic the boxplot is doing, for serum cholesterol:
#   IQR         = 275 - 211 = 64 mg/dL
#   Lower fence = 211 - 1.5 * 64 = 115 mg/dL
#   Upper fence = 275 + 1.5 * 64 = 371 mg/dL

# Listing 1.13  Flagging candidate outliers programmatically
q     <- quantile(heart$chol, c(0.25, 0.75), na.rm = TRUE)
iqr   <- q[2] - q[1]
lower <- q[1] - 1.5 * iqr
upper <- q[2] + 1.5 * iqr

outliers <- heart[heart$chol < lower | heart$chol > upper, ]
nrow(outliers)        # how many candidate outliers?
head(outliers[, c("age", "sex", "chol", "target")])


# ---------------------------------------------------------------------------
# PART 7  --  Esquisse, the drag-and-drop chart builder (Section 1.11)
# ---------------------------------------------------------------------------

# Listing 1.14  Installing, loading, and launching esquisse
# 1. Install (once) and load
install.packages("esquisse")
install.packages("plotly")
library(esquisse)
library(plotly)

# 2. Make sure the dataset is in memory
library(readr)
heart <- read_csv("heart.csv")

# 3. Launch the drag-and-drop builder
esquisse::esquisser(heart)


# ---------------------------------------------------------------------------
# PART 8  --  The Quickstart, for reference (Section 1.1.5)
# ---------------------------------------------------------------------------
# The five lines the chapter opens with, and the Copilot prompts that
# produce them.

# Load the readr package and read heart.csv from the working directory
# into a data frame called heart
library(readr)
heart <- read_csv("heart.csv")

# Count how many patients fall into each level of chest pain type (cp)
counts <- table(heart$cp)
counts

# Make a bar chart of counts with a blue fill and the title
# "Chest Pain Type Distribution"
barplot(counts,
        main = "Chest Pain Type Distribution",
        col  = "steelblue")

# ===========================================================================
# End of Chapter 1
# ===========================================================================
