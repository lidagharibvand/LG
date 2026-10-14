## Modern Biostatistics with R & AI, Volume II. Companion repository: github.com/lidagharibvand/LG
## R Quickstart, Getting Ready to Analyze Health Data: Figures Q.1 to Q.4
## Run from the project folder (the one that holds datasets/):  Rscript Volume-II/code/figures_quickstart.R
## PNG files are written to the folder figures/ at 300 dpi, 6.5 inches wide.
## Figures Q.1 and Q.2 are diagrams drawn in ggplot2. Figures Q.3 and Q.4 are base R graphs, drawn with
## png() on purpose: they are exactly what the student sees in the Plots pane after Listings Q.34 to Q.37.

suppressPackageStartupMessages(library(ggplot2))
out_dir <- "figures"
dir.create(out_dir, recursive = TRUE, showWarnings = FALSE)
fig <- function(name) file.path(out_dir, name)

navy <- "#1F4E79"; blue <- "#2E75B6"; rust <- "#B85C22"; gray <- "#595959"; pale <- "#EAF3F8"; cream <- "#FDF6F1"

rect <- function(x0, x1, y0, y1, fill = "white", col = navy, lw = 0.3)
  annotate("rect", xmin = x0, xmax = x1, ymin = y0, ymax = y1, fill = fill, colour = col, linewidth = lw)
txt <- function(x, y, label, size = 3, col = "#222222", face = "plain", hjust = 0.5, family = "", lh = 0.95)
  annotate("text", x = x, y = y, label = label, size = size, colour = col, fontface = face, hjust = hjust,
           family = family, lineheight = lh)

## ---------- Figure Q.1: the four panes of RStudio ----------
code_l <- c("# first_script.R", "# Read the HALO trial data", "halo <- read.csv(\"datasets/halo.csv\")",
            "dim(halo)")
cons_l <- c("> 2 + 3", "[1] 5", "> dim(halo)", "[1] 2000   38", "> ")
p1 <- ggplot() + xlim(0, 10) + ylim(0, 7.2) + theme_void() +
  rect(0.1, 5.35, 3.75, 7.0, pale) + rect(0.1, 5.35, 0.2, 3.6, "white") +
  rect(5.5, 9.9, 3.75, 7.0, "white") + rect(5.5, 9.9, 0.2, 3.6, pale) +
  rect(0.1, 5.35, 6.5, 7.0, navy) + rect(0.1, 5.35, 3.1, 3.6, navy) +
  rect(5.5, 9.9, 6.5, 7.0, navy) + rect(5.5, 9.9, 3.1, 3.6, navy) +
  txt(0.3, 6.75, "1  Script (Source): you write here", 3.3, "white", "bold", 0) +
  txt(0.3, 3.35, "2  Console: R runs the code here", 3.3, "white", "bold", 0) +
  txt(5.7, 6.75, "3  Environment: what R holds", 3.3, "white", "bold", 0) +
  txt(5.7, 3.35, "4  Files, Plots, Help", 3.3, "white", "bold", 0) +
  txt(0.3, 6.15 - 0.36 * (0:3), code_l, 2.75, "#1F2937", hjust = 0, family = "mono") +
  txt(0.3, 4.25, "Type code here and save it as a file. Run the line\nunder the cursor with Ctrl+Enter (Cmd+Return on a Mac).",
      2.7, gray, "italic", 0) +
  txt(0.3, 2.78 - 0.36 * (0:4), cons_l, 2.75, "#1F2937", hjust = 0, family = "mono") +
  txt(0.3, 0.72, "Results and error messages appear here. A line typed\nhere runs once and is not saved.", 2.7, gray, "italic", 0) +
  txt(5.7, 6.1, "halo     2000 obs. of 38 variables", 2.75, "#1F2937", hjust = 0, family = "mono") +
  txt(5.7, 5.1, "Every object you create is listed here.\nClick a data frame to see it as a table.", 2.7, gray, "italic", 0) +
  txt(5.7, 2.7, "datasets      first_script.R", 2.75, "#1F2937", hjust = 0, family = "mono") +
  txt(5.7, 1.55, "Files: the folders of your project.\nPlots: the graphs you draw.\nHelp: the page that opens for ?mean.",
      2.7, gray, "italic", 0)
ggsave(fig("figQ_1.png"), p1, width = 6.5, height = 3.4, dpi = 300, bg = "white")

## ---------- Figure Q.2: the project folder ----------
row <- function(y, x, label, note, col = "#1F2937", face = "plain")
  list(txt(x, y, label, 2.9, col, face, 0, family = "mono"), txt(6.1, y, note, 2.65, gray, "italic", 0))
p2 <- ggplot() + xlim(0, 10) + ylim(0.2, 6.3) + theme_void() +
  rect(0.15, 9.85, 0.35, 6.15, pale) +
  txt(0.45, 5.75, "halo-project/", 3.3, navy, "bold", 0, family = "mono") +
  txt(6.1, 5.75, "the project folder: R starts looking here", 2.75, navy, "bold", 0) +
  annotate("segment", x = 0.75, xend = 0.75, y = 5.45, yend = 0.95, colour = navy, linewidth = 0.35) +
  annotate("segment", x = 0.75, xend = 1.05, y = c(5.0, 3.85, 2.3, 1.0), yend = c(5.0, 3.85, 2.3, 1.0),
           colour = navy, linewidth = 0.35) +
  row(5.0, 1.15, "datasets/", "Section Q.3: the data, never edited", navy, "bold") +
  row(4.45, 1.75, "halo.csv", "downloaded from the companion repository") +
  annotate("segment", x = 1.45, xend = 1.45, y = 4.75, yend = 4.45, colour = navy, linewidth = 0.3) +
  annotate("segment", x = 1.45, xend = 1.65, y = 4.45, yend = 4.45, colour = navy, linewidth = 0.3) +
  row(3.85, 1.15, "scripts/", "Section Q.9: your R scripts", navy, "bold") +
  row(3.3, 1.75, "first_script.R", "Section Q.4") +
  row(2.85, 1.75, "halo_first_look.R", "Section Q.8") +
  annotate("segment", x = 1.45, xend = 1.45, y = 3.6, yend = 2.85, colour = navy, linewidth = 0.3) +
  annotate("segment", x = 1.45, xend = 1.65, y = c(3.3, 2.85), yend = c(3.3, 2.85), colour = navy, linewidth = 0.3) +
  row(2.3, 1.15, "output/", "Section Q.9: graphs and tables you save", navy, "bold") +
  row(1.75, 1.75, "cholesterol_histogram.png", "exported from the Plots pane") +
  annotate("segment", x = 1.45, xend = 1.45, y = 2.05, yend = 1.75, colour = navy, linewidth = 0.3) +
  annotate("segment", x = 1.45, xend = 1.65, y = 1.75, yend = 1.75, colour = navy, linewidth = 0.3) +
  row(1.0, 1.15, "halo-project.Rproj", "made by RStudio; opens the project") +
  txt(0.45, 0.55, "In code, a file is named from the project folder down:  \"datasets/halo.csv\"", 2.75, rust, "bold", 0)
ggsave(fig("figQ_2.png"), p2, width = 6.5, height = 2.9, dpi = 300, bg = "white")

## ---------- Figures Q.3 and Q.4: base R graphs, as they appear in the Plots pane ----------
halo <- read.csv("datasets/halo.csv")
names(halo) <- tolower(names(halo))   # lowercase names (Section Q.5)

# Figure Q.3: Listing Q.34, barplot(table(halo$angina)) with no labels
png(fig("figQ_3.png"), width = 6.5, height = 3.6, units = "in", res = 300, pointsize = 12)
barplot(table(halo$angina))
invisible(dev.off())

# Figure Q.4: Listing Q.35 (left) and Listing Q.36 (right)
png(fig("figQ_4.png"), width = 6.5, height = 3.2, units = "in", res = 300, pointsize = 9)
par(mfrow = c(1, 2))
hist(halo$total_chol)
hist(halo$total_chol,
     main = "Total cholesterol at enrollment",
     xlab = "Total cholesterol (mg/dL)",
     ylab = "Number of participants")
invisible(dev.off())
