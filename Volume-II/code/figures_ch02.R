## Modern Biostatistics with R & AI, Volume II. Companion repository: github.com/lidagharibvand/LG
## Chapter 2, Describing and Visualizing Health Data: Figures 2.1 to 2.16
## Run from the project folder (the one that holds datasets/):  Rscript Volume-II/code/figures_ch02.R
## PNG files are written to the folder figures/ at 300 dpi, 6.5 inches wide.

invisible(Sys.setlocale("LC_CTYPE", "C.UTF-8"))     # so that the minus sign (U+2212) prints on any system
suppressPackageStartupMessages({library(ggplot2); library(gridExtra); library(grid); library(patchwork)})
pdf(NULL)                                          # grid needs an open device; this one writes no file
out_dir <- "figures"
dir.create(out_dir, recursive = TRUE, showWarnings = FALSE)
fig <- function(name) file.path(out_dir, name)

navy <- "#1F4E79"; blue <- "#2E75B6"; rust <- "#B85C22"; gray <- "#595959"; pale <- "#EAF3F8"; cream <- "#FDF6F1"
th <- theme_minimal(base_size = 10) +
  theme(panel.grid.minor = element_blank(), panel.grid.major.x = element_blank(),
        plot.title = element_text(face = "bold", colour = navy, size = 10.5),
        plot.subtitle = element_text(colour = gray, size = 8.5),
        axis.title = element_text(colour = "#333333", size = 9),
        axis.text = element_text(colour = "#333333"))
minus <- function(x) sub("-", "−", x)

## ---------- data: read and screen exactly as Listing 2.1 does ----------
raw  <- read.csv("datasets/halo.csv")
names(raw) <- tolower(names(raw))   # lowercase names (Section Q.5)
halo <- raw
halo$age[halo$age > 120]   <- NA
halo$bmi[halo$bmi <= 0]    <- NA
halo$sbp0[halo$sbp0 > 300] <- NA
halo$angina <- factor(halo$angina, levels = c("None", "Non-anginal", "Atypical", "Typical"))
halo$chdlab <- factor(ifelse(halo$chd == 1, "CHD event", "No CHD event"), levels = c("CHD event", "No CHD event"))
hand <- read.csv("datasets/halo_hand.csv")
names(hand) <- tolower(names(hand))   # lowercase names (Section Q.5)

## ---------- Figure 2.1: bar chart beside pie chart ----------
ang <- as.data.frame(table(angina = halo$angina))
ang$pct <- 100 * ang$Freq / sum(ang$Freq)
p_bar <- ggplot(ang, aes(angina, Freq)) +
  geom_col(fill = navy, width = 0.6) +
  geom_text(aes(label = sprintf("%d\n(%.1f%%)", Freq, pct)), vjust = -0.25, size = 2.9, colour = "#222222",
            lineheight = 0.95) +
  scale_y_continuous(limits = c(0, 780), breaks = seq(0, 600, 200), expand = c(0, 0)) +
  labs(title = "Bar chart", subtitle = "Heights on one baseline: the order is plain",
       x = "Chest pain type at enrollment", y = "Number of participants") + th
shades <- c(None = navy, `Non-anginal` = blue, Atypical = "#9DC3E6", Typical = "#C9C9C9")
ang$mid <- cumsum(ang$Freq) - ang$Freq / 2
p_pie <- ggplot(ang, aes(x = 1, y = Freq, fill = angina)) +
  geom_col(width = 1, colour = "white", linewidth = 0.8, position = position_stack(reverse = TRUE)) +
  coord_polar(theta = "y") +
  geom_text(aes(x = 1.14, y = mid, label = angina, colour = angina), size = 2.55, fontface = "bold") +
  scale_fill_manual(values = shades, guide = "none") +
  scale_colour_manual(values = c(None = "white", `Non-anginal` = "white", Atypical = "#1A1A1A", Typical = "#1A1A1A"),
                      guide = "none") +
  labs(title = "Pie chart", subtitle = "The same counts as angles: which is second?") +
  theme_void(base_size = 10) +
  theme(plot.title = element_text(face = "bold", colour = navy, size = 10.5),
        plot.subtitle = element_text(colour = gray, size = 8.5))
ggsave(fig("fig2_1.png"), arrangeGrob(p_bar, p_pie, ncol = 2, widths = c(1.05, 1)), width = 6.5, height = 2.4,
       dpi = 300, bg = "white")

## ---------- Figure 2.2: coronary events by chest pain type ----------
tab <- table(halo$angina, halo$chdlab)
ev <- data.frame(angina = factor(rownames(tab), levels = levels(halo$angina)),
                 pct = round(100 * prop.table(tab, 1)[, "CHD event"], 1), n = as.vector(rowSums(tab)),
                 events = as.vector(tab[, "CHD event"]))
p <- ggplot(ev, aes(angina, pct)) +
  geom_col(fill = navy, width = 0.6) +
  geom_text(aes(label = sprintf("%.1f%%", pct)), vjust = -0.5, size = 3.1, colour = "#222222") +
  geom_text(aes(y = 2.2, label = sprintf("%d of %d", events, n)), size = 2.7, colour = "white") +
  scale_y_continuous(limits = c(0, 52), breaks = seq(0, 50, 10), expand = c(0, 0)) +
  labs(x = "Chest pain type at enrollment", y = "Participants with a\ncoronary event (%)") + th
ggsave(fig("fig2_2.png"), p, width = 6.5, height = 2.4, dpi = 300, bg = "white")

## ---------- Figure 2.3: a Pareto chart of coronary events by chest pain type ----------
evn <- sort(tab[, "CHD event"], decreasing = TRUE)
par_df <- data.frame(angina = factor(names(evn), levels = names(evn)), n = as.vector(evn))
par_df$pct <- 100 * par_df$n / sum(par_df$n)
par_df$cum <- cumsum(par_df$pct)
p <- ggplot(par_df, aes(angina, pct)) +
  geom_col(fill = navy, width = 0.62) +
  geom_text(aes(y = pct / 2, label = sprintf("%d events", n)), colour = "white", size = 2.8) +
  geom_line(aes(y = cum, group = 1), colour = rust, linewidth = 0.7) +
  geom_point(aes(y = cum), colour = rust, size = 2) +
  geom_text(aes(y = cum, label = sprintf("%.1f%%", cum)), colour = rust, size = 2.8, vjust = -0.9) +
  annotate("text", x = 1.55, y = 92, label = "cumulative percentage", colour = rust, size = 2.8, fontface = "italic") +
  scale_y_continuous(limits = c(0, 108), breaks = seq(0, 100, 20), expand = c(0, 0)) +
  labs(x = "Chest pain type at enrollment, largest number of events first",
       y = "Percentage of the\n434 coronary events") + th
ggsave(fig("fig2_3.png"), p, width = 6.5, height = 2.6, dpi = 300, bg = "white")

## ---------- Figure 2.4: one variable, three bin widths ----------
hist_bw <- function(bw, ttl, sub) ggplot(halo, aes(total_chol)) +
  geom_histogram(binwidth = bw, boundary = 0, closed = "left", fill = if (bw < 5) blue else pale,
                 colour = if (bw < 5) NA else navy, linewidth = 0.25) +
  labs(title = ttl, subtitle = sub, x = "Total cholesterol (mg/dL)", y = "Participants") + th
g <- arrangeGrob(hist_bw(2, "Bins 2 mg/dL wide", "Too narrow: noise looks like structure"),
                 hist_bw(10, "Bins 10 mg/dL wide", "One mound, a tail at each end"),
                 hist_bw(50, "Bins 50 mg/dL wide", "Too wide: the shape is gone"), ncol = 3)
ggsave(fig("fig2_4.png"), g, width = 6.5, height = 2.35, dpi = 300, bg = "white")

## ---------- Figure 2.5: four shapes (the uniform panel is simulated) ----------
shape <- function(v, bw, ttl, sub, xl) ggplot(data.frame(v = v), aes(v)) +
  geom_histogram(aes(y = after_stat(density)), binwidth = bw, boundary = 0, closed = "left", fill = pale,
                 colour = navy, linewidth = 0.2) +
  geom_density(colour = rust, linewidth = 0.7) +
  labs(title = ttl, subtitle = sub, x = xl, y = "Density") + th +
  theme(axis.text.y = element_blank())
set.seed(2)
unif <- runif(2000, min = 0, max = 60)                 # simulated: no numeric HALO variable is uniform
g <- arrangeGrob(shape(halo$total_chol, 10, "Close to symmetric (bell-shaped)", "Sides nearly mirror images",
                       "Total cholesterol (mg/dL)"),
                 shape(halo$tg, 25, "Right-skewed", "Tail to the right", "Triglycerides (mg/dL)"),
                 shape(halo$days, 100, "Left-skewed", "Tail to the left", "Days of follow-up"),
                 shape(unif, 5, "Uniform (simulated)", "Every class about equally full",
                       "Minute past the hour (2,000 simulated values)"), ncol = 2)
ggsave(fig("fig2_5.png"), g, width = 6.5, height = 3.7, dpi = 300, bg = "white")

## ---------- Figure 2.6: frequency polygon and ogive of age ----------
ag <- halo$age[!is.na(halo$age)]
fq <- as.vector(table(cut(ag, seq(40, 90, 10), right = FALSE)))
poly <- data.frame(mid = seq(34.5, 94.5, 10), f = c(0, fq, 0))
og <- data.frame(b = seq(39.5, 89.5, 10), cum = c(0, cumsum(fq)))
half <- length(ag) / 2
x_half <- approx(og$cum, og$b, xout = half)$y
cat("Figure 2.6: the ogive reaches half of", length(ag), "at age", round(x_half, 1), "\n")
p1 <- ggplot() +
  geom_histogram(data = data.frame(a = ag), aes(a), binwidth = 10, boundary = 39.5, fill = "#F3F7FA",
                 colour = "#C9D9E6", linewidth = 0.3) +
  geom_line(data = poly, aes(mid, f), colour = navy, linewidth = 0.7) +
  geom_point(data = poly, aes(mid, f), colour = navy, size = 1.8) +
  geom_text(data = poly[2:6, ], aes(mid, f, label = f, hjust = c(1.35, 1.35, 0.5, -0.35, -0.35),
                                    vjust = c(-0.2, -0.2, -0.9, -0.2, -0.2)), size = 2.7, colour = navy) +
  scale_x_continuous(breaks = seq(34.5, 94.5, 10)) +
  scale_y_continuous(limits = c(0, 1010), expand = c(0, 0)) +
  labs(title = "Frequency polygon", subtitle = "Frequencies at the class midpoints, closed at zero",
       x = "Age (years), class midpoint", y = "Participants") + th +
  theme(axis.text.x = element_text(size = 7.5))
p2 <- ggplot(og, aes(b, cum)) +
  annotate("segment", x = 39.5, xend = x_half, y = half, yend = half, colour = rust, linetype = "dashed",
           linewidth = 0.4) +
  annotate("segment", x = x_half, xend = x_half, y = 0, yend = half, colour = rust, linetype = "dashed",
           linewidth = 0.4) +
  annotate("text", x = x_half + 1.2, y = 260, label = sprintf("half reached\nnear %.0f years", x_half),
           hjust = 0, size = 2.7, colour = rust, lineheight = 0.9) +
  geom_line(colour = navy, linewidth = 0.7) + geom_point(colour = navy, size = 1.8) +
  geom_text(aes(label = format(cum, big.mark = ",")), hjust = 1.15, vjust = -0.5, size = 2.6, colour = navy) +
  scale_x_continuous(breaks = seq(39.5, 89.5, 10)) +
  scale_y_continuous(limits = c(0, 2150), breaks = seq(0, 2000, 500), labels = function(x) format(x, big.mark = ","),
                     expand = c(0, 0)) +
  labs(title = "Ogive", subtitle = "Cumulative frequency at upper boundaries",
       x = "Age (years), upper class boundary", y = "Cumulative participants") + th +
  theme(axis.text.x = element_text(size = 7.5))
ggsave(fig("fig2_6.png"), arrangeGrob(p1, p2, ncol = 2), width = 6.5, height = 2.7, dpi = 300, bg = "white")

## ---------- Figure 2.7: dot plot of the 20 pressures ----------
p <- ggplot(hand, aes(x = sbp0)) +
  geom_dotplot(binwidth = 2, fill = navy, colour = navy, dotsize = 0.9) +
  scale_y_continuous(NULL, breaks = NULL) +
  scale_x_continuous(breaks = seq(90, 170, 10), limits = c(88, 170)) +
  labs(x = "Baseline systolic pressure (mmHg), one dot per participant") + th +
  theme(panel.grid.major.y = element_blank())
ggsave(fig("fig2_7.png"), p, width = 6.5, height = 1.25, dpi = 300, bg = "white")

## ---------- Figure 2.8: mean and median on a symmetric and a skewed variable ----------
mm <- function(v, bw, ttl, xl, xmax, xlab) {
  m <- mean(v); md <- median(v)
  top <- max(hist(v, breaks = seq(0, max(v) + bw, bw), right = FALSE, plot = FALSE)$counts)
  ggplot(data.frame(v = v), aes(v)) +
    geom_histogram(binwidth = bw, boundary = 0, closed = "left", fill = pale, colour = navy, linewidth = 0.2) +
    geom_vline(xintercept = md, colour = navy, linewidth = 0.8, linetype = "dashed") +
    geom_vline(xintercept = m, colour = rust, linewidth = 0.8) +
    annotate("text", x = xlab, y = top * 0.98, hjust = 0, size = 2.9, colour = rust,
             label = sprintf("mean %.1f", m)) +
    annotate("text", x = xlab, y = top * 0.86, hjust = 0, size = 2.9, colour = navy,
             label = sprintf("median %.0f", md)) +
    coord_cartesian(xlim = c(min(v) - bw, xmax)) +
    labs(title = ttl, x = xl, y = "Participants") + th
}
g <- arrangeGrob(mm(halo$total_chol, 10, "Close to symmetric: the two agree", "Total cholesterol (mg/dL)", 400, 300),
                 mm(halo$tg, 20, "Right-skewed: the tail pulls the mean", "Triglycerides (mg/dL)", 940, 420), ncol = 2)
ggsave(fig("fig2_8.png"), g, width = 6.5, height = 2.5, dpi = 300, bg = "white")

## ---------- Figure 2.9: same mean, different spread ----------
clinic_a <- c(124, 126, 127, 128, 129, 130, 130, 131, 132, 133, 134, 136)
clinic_b <- c(104, 110, 116, 121, 125, 129, 131, 135, 139, 144, 150, 156)
cl <- data.frame(clinic = rep(c("Clinic A", "Clinic B"), each = 12), sbp = c(clinic_a, clinic_b))
cl$stack <- ave(cl$sbp, cl$clinic, cl$sbp, FUN = seq_along)
cl$y <- ifelse(cl$clinic == "Clinic A", 2, 1) + 0.16 * (cl$stack - 1)
sds <- c(sd(clinic_a), sd(clinic_b))
p <- ggplot(cl, aes(sbp, y)) +
  annotate("rect", xmin = 140, xmax = 160, ymin = 0.6, ymax = 2.75, fill = cream) +
  annotate("text", x = 150, y = 2.66, label = "140 mmHg or higher", size = 2.7, colour = rust) +
  geom_vline(xintercept = 130, colour = gray, linetype = "dashed", linewidth = 0.4) +
  annotate("label", x = 130, y = 2.66, label = "mean 130 in both", size = 2.7, colour = gray, fill = "white",
           label.size = 0) +
  geom_point(aes(colour = clinic), size = 2.6) +
  annotate("text", x = 101, y = 2.25, hjust = 0, size = 3, colour = navy, fontface = "bold",
           label = sprintf("Clinic A   SD %.1f mmHg", sds[1])) +
  annotate("text", x = 101, y = 1.25, hjust = 0, size = 3, colour = rust, fontface = "bold",
           label = sprintf("Clinic B   SD %.1f mmHg", sds[2])) +
  scale_colour_manual(values = c(navy, rust), guide = "none") +
  scale_y_continuous(NULL, breaks = NULL, limits = c(0.6, 2.75)) +
  scale_x_continuous(breaks = seq(100, 160, 10), limits = c(100, 160)) +
  labs(x = "Home systolic pressure (mmHg), one dot per patient") + th +
  theme(panel.grid.major.y = element_blank())
ggsave(fig("fig2_9.png"), p, width = 6.5, height = 2.3, dpi = 300, bg = "white")

## ---------- Figure 2.10: the 68-95-99.7 rule ----------
zz <- seq(-3.6, 3.6, length.out = 721)
nd <- data.frame(z = zz, d = dnorm(zz))
band <- function(k, fill) geom_area(data = nd[abs(nd$z) <= k, ], aes(z, d), fill = fill)
brace <- function(k, y, lab) list(
  annotate("segment", x = -k, xend = k, y = y, yend = y, colour = navy, linewidth = 0.4,
           arrow = arrow(ends = "both", length = unit(0.05, "inches"), type = "closed")),
  annotate("label", x = 0, y = y, label = lab, size = 2.9, colour = navy, fill = "white", label.size = 0,
           label.padding = unit(0.12, "lines")))
p <- ggplot(nd, aes(z, d)) +
  band(3, "#DCE9F3") + band(2, "#A9C8E3") + band(1, "#6FA3D0") +
  geom_line(colour = navy, linewidth = 0.6) +
  brace(1, 0.45, "about 68%") + brace(2, 0.50, "about 95%") + brace(3, 0.55, "about 99.7%") +
  scale_x_continuous(breaks = -3:3, labels = minus(as.character(-3:3))) +
  scale_y_continuous(NULL, breaks = NULL, limits = c(0, 0.58), expand = c(0, 0)) +
  labs(x = "z-score (standard deviations from the mean)") + th +
  theme(panel.grid.major.y = element_blank())
ggsave(fig("fig2_10.png"), p, width = 6.5, height = 2.3, dpi = 300, bg = "white")

## ---------- Figure 2.11: the 20 pressures, by hand ----------
x <- sort(hand$sbp0)
q <- quantile(x, c(0.25, 0.5, 0.75), names = FALSE)
iqr <- q[3] - q[1]; lo <- q[1] - 1.5 * iqr; hi <- q[3] + 1.5 * iqr
inside <- x[x >= lo & x <= hi]
dots <- data.frame(x = x, stack = ave(x, x, FUN = seq_along), out = x < lo | x > hi)
yb <- 1.0
lab <- function(xv, y, text, col = navy, ...) annotate("text", x = xv, y = y, label = text, size = 2.7, colour = col, ...)
p <- ggplot() +
  geom_vline(xintercept = c(lo, hi), colour = rust, linetype = "dashed", linewidth = 0.4) +
  annotate("label", x = lo, y = 2.6, label = sprintf("lower fence\n%.3f", lo), size = 2.7, colour = rust,
           fill = "white", label.size = 0, lineheight = 0.9) +
  annotate("label", x = hi, y = 2.6, label = sprintf("upper fence\n%.3f", hi), size = 2.7, colour = rust,
           fill = "white", label.size = 0, lineheight = 0.9) +
  geom_point(data = dots, aes(x, 1.75 + 0.17 * (stack - 1), colour = out), size = 2.2) +
  annotate("segment", x = min(inside), xend = q[1], y = yb, yend = yb, colour = navy, linewidth = 0.5) +
  annotate("segment", x = q[3], xend = max(inside), y = yb, yend = yb, colour = navy, linewidth = 0.5) +
  annotate("rect", xmin = q[1], xmax = q[3], ymin = yb - 0.22, ymax = yb + 0.22, fill = pale, colour = navy,
           linewidth = 0.5) +
  annotate("segment", x = q[2], xend = q[2], y = yb - 0.22, yend = yb + 0.22, colour = navy, linewidth = 0.9) +
  annotate("point", x = x[x < lo | x > hi], y = yb, colour = rust, size = 2.2) +
  lab(q[1] - 0.6, 0.55, sprintf("Q1\n%.1f", q[1]), hjust = 1, lineheight = 0.9) +
  lab(q[2], 0.55, sprintf("median\n%.1f", q[2]), lineheight = 0.9) +
  lab(q[3] + 0.6, 0.55, sprintf("Q3\n%.2f", q[3]), hjust = 0, lineheight = 0.9) +
  lab(min(inside), 1.38, "whisker ends at 117", gray) +
  lab(max(inside), 1.38, "whisker ends at 147", gray) +
  lab(92, 0.62, "92, 92\nflagged", rust, lineheight = 0.9) + lab(166, 0.62, "166\nflagged", rust, lineheight = 0.9) +
  lab(130, 2.3, "The 20 values, one dot each", gray, fontface = "italic") +
  scale_colour_manual(values = c(`FALSE` = navy, `TRUE` = rust), guide = "none") +
  scale_y_continuous(NULL, breaks = NULL, limits = c(0.35, 2.85)) +
  scale_x_continuous(breaks = seq(90, 170, 10), limits = c(87, 171)) +
  labs(x = "Baseline systolic pressure (mmHg)") + th + theme(panel.grid.major.y = element_blank())
ggsave(fig("fig2_11.png"), p, width = 6.5, height = 2.35, dpi = 300, bg = "white")

## ---------- Figure 2.12: histogram and boxplot of total cholesterol on one axis ----------
v <- halo$total_chol
q <- quantile(v, c(0.25, 0.5, 0.75), names = FALSE)
iqr <- q[3] - q[1]; lo <- q[1] - 1.5 * iqr; hi <- q[3] + 1.5 * iqr
xl <- c(80, 400)
top <- ggplot(halo, aes(total_chol)) +
  geom_histogram(binwidth = 10, boundary = 0, closed = "left", fill = pale, colour = navy, linewidth = 0.2) +
  geom_vline(xintercept = q, colour = navy, linewidth = c(0.4, 0.8, 0.4), linetype = c("dashed", "solid", "dashed")) +
  annotate("text", x = q[1] - 3, y = 236, label = "Q1\n195.75", hjust = 1, size = 2.7, colour = navy, lineheight = 0.9) +
  annotate("text", x = q[2] + 2.5, y = 236, label = "median\n222", hjust = 0, size = 2.7, colour = navy, lineheight = 0.9) +
  annotate("text", x = q[3] + 3, y = 236, label = "Q3\n250", hjust = 0, size = 2.7, colour = navy, lineheight = 0.9) +
  annotate("text", x = 300, y = 150, label = "Half of the 2,000 values\nlie between Q1 and Q3", size = 2.7,
           colour = gray, hjust = 0, lineheight = 0.95) +
  scale_x_continuous(limits = xl, breaks = seq(100, 400, 50)) +
  scale_y_continuous(limits = c(0, 255), expand = c(0, 0)) +
  labs(x = NULL, y = "Participants") + th + theme(axis.text.x = element_blank())
ins <- v[v >= lo & v <= hi]; outv <- v[v < lo | v > hi]
bot <- ggplot() +
  geom_vline(xintercept = c(lo, hi), colour = rust, linetype = "dashed", linewidth = 0.4) +
  annotate("segment", x = min(ins), xend = q[1], y = 1, yend = 1, colour = navy, linewidth = 0.5) +
  annotate("segment", x = q[3], xend = max(ins), y = 1, yend = 1, colour = navy, linewidth = 0.5) +
  annotate("rect", xmin = q[1], xmax = q[3], ymin = 0.72, ymax = 1.28, fill = pale, colour = navy, linewidth = 0.5) +
  annotate("segment", x = q[2], xend = q[2], y = 0.72, yend = 1.28, colour = navy, linewidth = 0.9) +
  geom_point(data = data.frame(x = outv), aes(x, 1), colour = rust, size = 1.3, alpha = 0.75,
             position = position_jitter(width = 0, height = 0.09, seed = 2)) +
  annotate("label", x = lo, y = 1.78, label = "lower fence 114.4", size = 2.7, colour = rust, fill = "white",
           label.size = 0) +
  annotate("label", x = hi, y = 1.78, label = "upper fence 331.4", size = 2.7, colour = rust, fill = "white",
           label.size = 0) +
  annotate("text", x = (q[1] + q[3]) / 2, y = 1.55, label = "box = IQR = 54.25", size = 2.7, colour = navy) +
  annotate("text", x = 96, y = 0.38, label = "9 flagged", size = 2.7, colour = rust) +
  annotate("text", x = 358, y = 0.38, label = "19 flagged", size = 2.7, colour = rust) +
  annotate("text", x = 152, y = 0.38, label = paste("whisker to", min(ins)), size = 2.7, colour = gray) +
  annotate("text", x = 295, y = 0.38, label = paste("whisker to", max(ins)), size = 2.7, colour = gray) +
  scale_x_continuous(limits = xl, breaks = seq(100, 400, 50)) +
  scale_y_continuous(NULL, breaks = NULL, limits = c(0.2, 1.95)) +
  labs(x = "Total cholesterol (mg/dL)") + th + theme(panel.grid.major.y = element_blank())
stopifnot(sum(v < lo) == 9, sum(v > hi) == 19)
cat("Figure 2.12 whiskers end at", min(ins), "and", max(ins), "\n")
ggsave(fig("fig2_12.png"), top / bot + plot_layout(heights = c(1.7, 1)), width = 6.5, height = 3.4, dpi = 300,
       bg = "white")

## ---------- Figure 2.13: maximum heart rate by coronary event status ----------
## The event group is listed first and drawn in navy; the second group is rust (book convention)
cols <- c(`CHD event` = navy, `No CHD event` = rust)
p1 <- ggplot(halo, aes(chdlab, max_hr, colour = chdlab)) +
  geom_boxplot(fill = "white", width = 0.5, outlier.size = 0.9, linewidth = 0.45) +
  scale_colour_manual(values = cols, guide = "none") +
  labs(title = "Side-by-side boxplots", subtitle = "The boxes overlap, and one sits lower",
       x = NULL, y = "Maximum heart rate (beats per minute)") + th
p2 <- ggplot(halo, aes(max_hr, colour = chdlab, fill = chdlab)) +
  geom_density(alpha = 0.22, linewidth = 0.6) +
  annotate("text", x = 136, y = 0.0262, label = "CHD event", colour = navy, size = 2.9, fontface = "bold") +
  annotate("text", x = 185, y = 0.0262, label = "No CHD event", colour = rust, size = 2.9, fontface = "bold") +
  scale_colour_manual(values = cols, guide = "none") + scale_fill_manual(values = cols, guide = "none") +
  labs(title = "Overlaid density curves", subtitle = "Same shape, shifted by about 7 beats per minute",
       x = "Maximum heart rate (beats per minute)", y = "Density") + th + theme(axis.text.y = element_blank())
ggsave(fig("fig2_13.png"), arrangeGrob(p1, p2, ncol = 2), width = 6.5, height = 2.9, dpi = 300, bg = "white")

## ---------- Figure 2.14: maximum heart rate against age ----------
hs <- halo[!is.na(halo$age), ]
p <- ggplot(hs, aes(age, max_hr, colour = chdlab)) +
  geom_point(alpha = 0.3, size = 0.9) +
  geom_smooth(method = "lm", formula = y ~ x, se = FALSE, linewidth = 0.9) +
  annotate("text", x = 83.4, y = 152.5, label = "No CHD event", colour = rust, size = 2.9, fontface = "bold",
           hjust = 0) +
  annotate("text", x = 83.4, y = 143.5, label = "CHD event", colour = navy, size = 2.9, fontface = "bold",
           hjust = 0) +
  scale_x_continuous(breaks = seq(40, 80, 10), limits = c(41, 91.5)) +
  scale_colour_manual(values = cols, guide = "none") +
  labs(x = "Age (years)", y = "Maximum heart rate (beats per minute)") + th +
  theme(panel.grid.major.x = element_line(colour = "#E5E5E5"))
ggsave(fig("fig2_14.png"), p, width = 6.5, height = 2.7, dpi = 300, bg = "white")

## ---------- Figure 2.15: a time series graph of mean LDL by arm ----------
long <- read.csv("datasets/halo_long.csv")
names(long) <- tolower(names(long))   # lowercase names (Section Q.5)
long$ldl[long$ldl <= 0] <- NA
long$arm <- factor(long$trt, levels = c(0, 1), labels = c("Placebo", "Drug"))     # placebo first: navy; drug: rust
lm_ <- aggregate(ldl ~ arm + month, long, mean)
p <- ggplot(lm_, aes(month, ldl, colour = arm)) + geom_line(linewidth = 0.7) + geom_point(size = 2) +
  annotate("text", x = 18.6, y = lm_$ldl[lm_$arm == "Placebo" & lm_$month == 18], label = "Placebo", colour = navy,
           size = 3, fontface = "bold", hjust = 0) +
  annotate("text", x = 18.6, y = lm_$ldl[lm_$arm == "Drug" & lm_$month == 18], label = "Drug", colour = rust,
           size = 3, fontface = "bold", hjust = 0) +
  scale_colour_manual(values = c(navy, rust), guide = "none") +
  scale_x_continuous(breaks = c(0, 6, 12, 18), limits = c(0, 21)) +
  scale_y_continuous(limits = c(100, 150), breaks = seq(100, 150, 10)) +
  labs(x = "Month of follow-up", y = "Mean LDL cholesterol (mg/dL)") + th +
  theme(panel.grid.major.x = element_line(colour = "#E5E5E5"))
ggsave(fig("fig2_15.png"), p, width = 6.5, height = 2.6, dpi = 300, bg = "white")

## ---------- Figure 2.16: choosing a graph (Section 1.2's map, then the question) ----------
box <- function(x, y, w, h, label, fill, col = "white", size = 2.8, face = "bold")
  list(annotate("rect", xmin = x - w/2, xmax = x + w/2, ymin = y - h/2, ymax = y + h/2,
                fill = fill, colour = navy, linewidth = 0.3),
       annotate("text", x = x, y = y, label = label, colour = col, size = size, fontface = face, lineheight = 0.95))
seg <- function(x, y, xend, yend) annotate("segment", x = x, y = y, xend = xend, yend = yend, colour = navy, linewidth = 0.4)
xs <- c(1.0, 3.0, 5.0, 7.0, 9.0); cw <- 1.86
types <- c("One categorical", "One numeric", "Categorical\nby categorical", "Numeric\nby categorical", "Numeric\nby numeric")
## each cell: the question (italic, above) and the graph with its section (blue box)
cells <- list(
  list(c("How many in each?", "Bar chart\n2.3"), c("Which few hold most?", "Pareto chart\n2.3.1"),
       c("One share of a whole?", "Pie chart (2 or 3\ncategories) 2.3")),
  list(c("What shape?", "Histogram;\nfrequency polygon\n2.4, 2.4.4"), c("How many below a value?", "Ogive\n2.4.4"),
       c("Every value, small n?", "Dot plot;\nstem-and-leaf 2.4.5"), c("Five numbers, flags?", "Boxplot\n2.8")),
  list(c("Does a share differ?", "Bars of\npercentages\nwithin groups 2.3")),
  list(c("Do distributions differ?", "Side-by-side\nboxplots; density\ncurves 2.9.1")),
  list(c("Do they move together?", "Scatterplot\n2.9.2"), c("Change over time?", "Time series\ngraph 2.9.3")))
p <- ggplot() + xlim(0, 10) + ylim(-0.75, 8.15) + theme_void() +
  box(5, 7.8, 7.6, 0.55, "Section 1.2: what type is each variable, and how many are there?", navy) +
  lapply(xs, function(x) seg(x, 7.52, x, 7.25)) +
  lapply(1:5, function(k) box(xs[k], 6.85, cw, 0.8, types[k], pale, navy, 2.7)) +
  annotate("label", x = 5, y = 6.15, label = "Then: what question must the graph answer?", size = 2.7, colour = navy,
           fontface = "italic", fill = "white", label.size = 0, label.padding = unit(0.12, "lines"))
for (k in 1:5) for (j in seq_along(cells[[k]])) {
  y <- 5.5 - (j - 1) * 1.42
  p <- p + annotate("text", x = xs[k], y = y, label = cells[[k]][[j]][1], size = 2.35, colour = gray,
                    fontface = "italic") +
    box(xs[k], y - 0.62, cw, 0.92, cells[[k]][[j]][2], blue, "white", 2.45)
}
p <- p + annotate("text", x = 5, y = -0.55, size = 2.7, colour = gray, fontface = "italic",
                  label = "The types and the question choose the graph. How the result looks never does.")
ggsave(fig("fig2_16.png"), p, width = 6.5, height = 4.4, dpi = 300, bg = "white")
