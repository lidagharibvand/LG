## Modern Biostatistics with R & AI, Volume II. Companion repository: github.com/lidagharibvand/LG
## Chapter 1, Working with Health Data in R: Figures 1.1 to 1.5
## Run from the project folder (the one that holds datasets/):  Rscript Volume-II/code/figures_ch01.R
## PNG files are written to the folder figures/ at 300 dpi, 6.5 inches wide.
## The listings of Chapter 1 use base R graphs only; the printed figures are redrawn in ggplot2.

out_dir <- "figures"
dir.create(out_dir, showWarnings = FALSE)
suppressPackageStartupMessages(library(ggplot2))
# The minus sign in a label needs a UTF-8 session
if (!l10n_info()[["UTF-8"]]) invisible(suppressWarnings(Sys.setlocale("LC_CTYPE", "C.UTF-8")))
dir.create(out_dir, showWarnings = FALSE)

navy <- "#1F4E79"; blue <- "#2E75B6"; rust <- "#B85C22"; gray <- "#595959"; pale <- "#EAF3F8"; cream <- "#FDF6F1"
th <- theme_minimal(base_size = 10) +
  theme(panel.grid.minor = element_blank(), panel.grid.major.x = element_blank(),
        plot.title = element_text(face = "bold", colour = navy, size = 10.5),
        plot.subtitle = element_text(colour = gray, size = 8.5),
        axis.title = element_text(colour = "#333333", size = 9),
        axis.text = element_text(colour = "#333333"))

rect <- function(x0, x1, y0, y1, fill = "white", col = navy, lw = 0.3)
  annotate("rect", xmin = x0, xmax = x1, ymin = y0, ymax = y1, fill = fill, colour = col, linewidth = lw)
txt <- function(x, y, label, size = 3, col = "#222222", face = "plain", hjust = 0.5, family = "", lh = 0.95)
  annotate("text", x = x, y = y, label = label, size = size, colour = col, fontface = face, hjust = hjust,
           family = family, lineheight = lh)
arrow_seg <- function(x, y, xend, yend, col = navy)
  annotate("segment", x = x, y = y, xend = xend, yend = yend, colour = col, linewidth = 0.45,
           arrow = arrow(length = unit(0.06, "inches"), type = "closed"))

halo <- read.csv("datasets/halo.csv")
names(halo) <- tolower(names(halo))   # lowercase names (Section Q.5)

## ---------- Figure 1.1: HALO at a glance (valid LDL values after the screening of Section 1.4) ----------
scr <- halo
scr$ldl6[scr$ldl6 <= 0] <- NA
scr$ldl12[scr$ldl12 <= 0] <- NA
scr$ldl18[scr$ldl18 <= 0] <- NA
nvis <- sapply(scr[, c("ldl0", "ldl6", "ldl12", "ldl18")], function(x) tapply(!is.na(x), scr$trt, sum))
fmt <- function(n) format(n, big.mark = ",")
vx <- c(3.6, 5.5, 7.4, 9.3)
p1 <- ggplot() + xlim(0, 12.2) + ylim(0.8, 6.6) + theme_void() +
  rect(0.05, 2.45, 2.55, 4.05, navy) +
  txt(1.25, 3.5, "2,000 participants", 2.75, "white", "bold") + txt(1.25, 3.05, "randomized", 2.7, "white") +
  arrow_seg(2.45, 3.6, 2.85, 4.75) + arrow_seg(2.45, 3.0, 2.85, 1.85) +
  txt(6.45, 6.35, "LDL cholesterol and systolic pressure measured at four visits", 3.0, navy, "bold") +
  txt(vx, 5.85, c("Baseline", "Month 6", "Month 12", "Month 18"), 2.9, gray, "bold") +
  txt(2.1, 4.95, "Placebo", 3.0, navy, "bold", 1) + txt(2.1, 1.65, "Drug", 3.0, rust, "bold", 1) +
  txt(2.1, 5.35, "trt = 0", 2.5, gray, hjust = 1, family = "mono") +
  txt(2.1, 1.25, "trt = 1", 2.5, gray, hjust = 1, family = "mono")
for (k in 1:4) {
  p1 <- p1 + rect(vx[k] - 0.75, vx[k] + 0.75, 4.25, 5.25, pale, navy) +
    txt(vx[k], 4.75, fmt(nvis["0", k]), 3.3, navy, "bold") +
    rect(vx[k] - 0.75, vx[k] + 0.75, 1.35, 2.35, cream, rust) +
    txt(vx[k], 1.85, fmt(nvis["1", k]), 3.3, rust, "bold")
  if (k < 4) p1 <- p1 + arrow_seg(vx[k] + 0.75, 4.75, vx[k + 1] - 0.75, 4.75) +
      arrow_seg(vx[k] + 0.75, 1.85, vx[k + 1] - 0.75, 1.85, rust)
}
p1 <- p1 + txt(6.45, 3.3, "Number of participants with a valid LDL value at each visit", 2.8, gray, "italic") +
  rect(10.3, 12.15, 1.35, 5.25, "white", navy) +
  txt(11.225, 4.65, "Follow-up", 2.9, navy, "bold") + txt(11.225, 4.2, "for a first", 2.6) +
  txt(11.225, 3.87, "coronary event", 2.6) + txt(11.225, 3.5, "(up to 4.5 years)", 2.4, gray) +
  txt(11.225, 2.55, paste0(sum(halo$chd), " events"), 3.0, navy, "bold") + txt(11.225, 2.15, "in 2,000", 2.6, gray)
ggsave(file.path(out_dir, "fig1_1.png"), p1, width = 6.5, height = 2.5, dpi = 300, bg = "white")

## ---------- Figure 1.4: the histogram of age as read (Listing 1.10, redrawn for print) ----------
p2 <- ggplot(halo, aes(x = age)) +
  geom_histogram(breaks = seq(0, 850, by = 50), fill = blue, colour = "white", linewidth = 0.3) +
  annotate("segment", x = 822, xend = 822, y = 260, yend = 30, colour = rust, linewidth = 0.45,
           arrow = arrow(length = unit(0.06, "inches"), type = "closed")) +
  annotate("text", x = 815, y = 330, hjust = 1, size = 2.9, colour = rust, lineheight = 0.95,
           label = "One participant recorded as 820 years old.\nThe bar is too short to see.") +
  annotate("text", x = 140, y = 1280, hjust = 0, size = 2.9, colour = navy, lineheight = 0.95,
           label = "The other 1,999 participants, aged 42 to 82,\nare squeezed into two bars") +
  scale_x_continuous(breaks = seq(0, 800, by = 100), expand = expansion(mult = c(0.01, 0.02))) +
  scale_y_continuous(expand = expansion(mult = c(0, 0.05))) +
  labs(title = "Age at enrollment, as the file was read",
       subtitle = "The axis runs to 850 years because one value lies there",
       x = "Age (years)", y = "Number of participants") + th
ggsave(file.path(out_dir, "fig1_4.png"), p2, width = 6.5, height = 2.2, dpi = 300, bg = "white")

## ---------- Figure 1.5: what to do with a value that looks wrong ----------
box <- function(x, y, w, h, label, fill, col = "white", size = 2.9, face = "bold")
  list(annotate("rect", xmin = x - w / 2, xmax = x + w / 2, ymin = y - h / 2, ymax = y + h / 2,
                fill = fill, colour = navy, linewidth = 0.3),
       annotate("text", x = x, y = y, label = label, colour = col, size = size, fontface = face, lineheight = 0.95))
seg <- function(x, y, xend, yend) annotate("segment", x = x, y = y, xend = xend, yend = yend, colour = navy, linewidth = 0.4)
lab <- function(x, y, label) annotate("label", x = x, y = y, label = label, size = 2.7, colour = navy,
                                      fontface = "italic", fill = "white", label.size = 0, label.padding = unit(0.12, "lines"))
p3 <- ggplot() + xlim(0, 10) + ylim(0.1, 8.1) + theme_void() +
  seg(5, 7.45, 5, 7.05) + seg(5, 6.25, 2.6, 5.45) + seg(5, 6.25, 7.4, 5.45) +
  seg(7.4, 4.55, 7.4, 4.15) + seg(7.4, 3.35, 6.1, 2.6) + seg(7.4, 3.35, 8.75, 2.6) + seg(2.6, 4.55, 2.6, 2.6) +
  box(5, 7.75, 4.6, 0.6, "A value looks wrong", navy) +
  box(5, 6.65, 6.2, 0.8, "1.  Could it be a real measurement?\n(codebook range, clinical knowledge)", pale, navy) +
  lab(3.55, 5.9, "Yes") + lab(6.45, 5.9, "No") +
  box(2.6, 5.0, 3.6, 0.9, "Unusual but possible\n(triglycerides 923 mg/dL)", pale, navy, 2.8) +
  box(7.4, 5.0, 3.6, 0.9, "Impossible\n(age 820, systolic pressure 1,350)", pale, navy, 2.8) +
  box(7.4, 3.75, 4.6, 0.8, "2.  Does a source record give the true value?", pale, navy, 2.8) +
  lab(6.55, 3.0, "Yes") + lab(8.3, 3.0, "No") +
  box(2.6, 1.95, 3.6, 1.3, "Keep it.\nCheck the record if you can.\nReport it with the results.", blue, "white", 2.8) +
  box(6.1, 1.95, 2.45, 1.3, "Correct it from\nthe source.\nLog old and new value.", blue, "white", 2.7) +
  box(8.75, 1.95, 2.35, 1.3, "Set it to\nmissing (NA).\nDo not guess.", rust, "white", 2.7) +
  annotate("text", x = 5, y = 0.6, size = 2.8, colour = gray, fontface = "italic", lineheight = 1.05,
           label = "On every branch: delete no rows, leave the raw file unchanged, and write the decision in the cleaning log.")
ggsave(file.path(out_dir, "fig1_5.png"), p3, width = 6.5, height = 3.0, dpi = 300, bg = "white")

## ---------- Figure 1.2: which table and which graph fit which type of data (Section 1.2) ----------
rowbox <- function(y, q, a, sec) list(
  annotate("rect", xmin = 0.2, xmax = 3.7, ymin = y - 0.38, ymax = y + 0.38, fill = pale, colour = navy, linewidth = 0.3),
  annotate("text", x = 1.95, y = y, label = q, size = 2.85, colour = navy, fontface = "bold", lineheight = 0.95),
  annotate("segment", x = 3.75, y = y, xend = 4.25, yend = y, colour = navy, linewidth = 0.45,
           arrow = arrow(length = unit(0.06, "inches"), type = "closed")),
  annotate("rect", xmin = 4.3, xmax = 9.8, ymin = y - 0.38, ymax = y + 0.38, fill = "white", colour = navy, linewidth = 0.3),
  annotate("text", x = 4.45, y = y + if (grepl("\n", a)) 0.15 else 0.09, label = a, size = 2.75, colour = "#222222", hjust = 0, lineheight = 0.9),
  annotate("text", x = 4.45, y = y - if (grepl("\n", a)) 0.25 else 0.22, label = sec, size = 2.45, colour = rust, hjust = 0, fontface = "italic"))
p4 <- ggplot() + xlim(0, 10) + ylim(0.35, 6.45) + theme_void() +
  annotate("rect", xmin = 0.2, xmax = 9.8, ymin = 5.75, ymax = 6.4, fill = navy, colour = navy) +
  annotate("text", x = 5, y = 6.075, colour = "white", size = 2.95, fontface = "bold", lineheight = 0.95,
           label = "Ask first: is each variable qualitative or quantitative (Table 1.2),\nand how many variables does the question involve?") +
  rowbox(5.2, "One qualitative variable", "Frequency table. Bar chart, pie chart, Pareto chart", "Sections 2.2 and 2.3") +
  rowbox(4.25, "One quantitative variable", "Frequency distribution with classes. Histogram,\nfrequency polygon, ogive, dot plot, stem-and-leaf, boxplot", "Sections 2.2, 2.4, and 2.8") +
  rowbox(3.3, "One quantitative variable\nmeasured over time", "Time series graph", "Section 2.9") +
  rowbox(2.35, "One quantitative variable\nacross groups", "Side-by-side boxplots", "Sections 2.8 and 2.9") +
  rowbox(1.4, "Two quantitative variables", "Scatterplot", "Section 2.9") +
  annotate("text", x = 5, y = 0.62, size = 2.7, colour = gray, fontface = "italic",
           label = "The questions are about the type of data, never about what the graph will show. Section 2.10 brings the choices together.")
ggsave(file.path(out_dir, "fig1_2.png"), p4, width = 6.5, height = 3.6, dpi = 300, bg = "white")

## ---------- Figure 1.3: the base R graphs of Listings 1.6 to 1.8, as the Plots pane shows them ----------
png(file.path(out_dir, "fig1_3.png"), width = 6.5, height = 2.6, units = "in", res = 300, pointsize = 8)
par(mfrow = c(1, 3), mar = c(4.2, 4.2, 2.6, 0.6), mgp = c(2.4, 0.7, 0))
barplot(table(halo$site), main = "Participants at each clinic",
        xlab = "Clinic", ylab = "Participants")
hist(halo$bmi, main = "Body mass index at enrollment",
     xlab = "Body mass index (kg/m2)", ylab = "Participants")
barplot(table(halo$bmi), main = "One bar for each value of BMI",
        xlab = "Body mass index (kg/m2)", ylab = "Participants")
invisible(dev.off())
