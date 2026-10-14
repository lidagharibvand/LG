# Modern Biostatistics with R & AI, Volume II: companion repository

Lida Gharibvand, PhD

This repository holds every dataset and every R listing of *Modern Biostatistics with R & AI, Volume II:
An Interactive Guide to Data Analysis*. It is free to use for learning and teaching.

## What is here

| Folder | What it holds |
|---|---|
| `datasets/` | The HALO data files. `halo.csv` is the main file used throughout the book. The other HALO files (long format, hand-work subset, ward, clinic, EHR, survey, vitals) are used in later chapters. Each comes as `.csv`, `.xlsx`, `.sav` (SPSS), and `.xpt` (SAS transport). |
| `Volume-II/code/` | One script per part of the book. `quickstart.R` holds every listing of the R Quickstart, `chapter01.R` every listing of Chapter 1, `chapter02.R` every listing of Chapter 2, in the order the book prints them, followed by the code panels of the exercises. `figures_quickstart.R`, `figures_ch01.R`, and `figures_ch02.R` draw the printed figures. `table1_reusable.R` holds the reusable Table 1 tools of Section 2.11.1. |

HALO (Heart And Lipid Outcomes) is a **simulated** randomized trial of 2,000 participants run by the fictional
HALO health system. No participant, clinic, or drug in it exists, and nothing in it is evidence about a real
treatment.

## How to use it

1. Click the green **Code** button and choose **Download ZIP**, or download single files from the `datasets` folder
   (you do not need a GitHub account).
2. Put the `datasets` folder inside your RStudio project folder (R Quickstart, Section Q.3).
3. Every script reads the data with

   ```r
   halo <- read.csv("datasets/halo.csv")
   names(halo) <- tolower(names(halo))   # lowercase names (Section Q.5)
   ```

   so run the scripts from the project folder, the one that holds `datasets`.
4. Open a script and run it line by line with Ctrl+Enter (Cmd+Return on a Mac), or all at once with Source.
   The listings of a chapter share one R session, so run them in order.

Packages: Chapter 1 uses `dplyr`; Chapter 2 uses `dplyr` and `ggplot2`; the figure scripts also use `gridExtra`
and `patchwork`. Install a package once with `install.packages("dplyr")`.

Some scripts save files into a folder called `output` in your project, as the book shows; the figure scripts
write PNG files into a folder called `figures`.
