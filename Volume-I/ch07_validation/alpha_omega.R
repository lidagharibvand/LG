# alpha_omega.R
#
# Internal consistency for a scale, Chapter 7, Section 7.5. Cronbach's alpha is
# what most papers report; McDonald's omega is what most methodologists would
# rather they reported, because alpha assumes every item loads on the factor
# equally and that is rarely true.
#
# Alpha is computed here from its definition rather than from a package, so the
# arithmetic is visible. Omega needs a factor model: the psych package does it
# in one line, and that line is given at the end.
#
# Companion to Modern Biostatistics for the Health Sciences, Volume I.

cronbach_alpha <- function(items) {
  items <- as.matrix(items)
  items <- items[complete.cases(items), , drop = FALSE]
  k <- ncol(items)
  if (k < 2) stop("alpha needs at least two items")
  item_var  <- sum(apply(items, 2, var))
  total_var <- var(rowSums(items))
  (k / (k - 1)) * (1 - item_var / total_var)
}

# Reverse-worded items have to be turned round first, or they drag alpha down
# for a reason that has nothing to do with reliability.
reverse_score <- function(x, low = 1, high = 5) (low + high) - x

# Which items are they? Appendix G says survey300 has two, without naming them,
# and that is the realistic case: you are handed a dataset and have to work it
# out. An item worded the other way round correlates with the total near zero
# while the rest sit well above it, so the correlations name them for you.
survey <- read.csv("../datasets/survey300.csv")
items  <- survey[, grep("^q[0-9]+$", names(survey))]
items  <- items[complete.cases(items), , drop = FALSE]

item_total <- sapply(names(items), function(col)
  cor(items[[col]], rowSums(items)))

cat("Item-total correlations before any reversal:
")
for (col in names(item_total)) {
  cat(sprintf("  %-4s %+.3f%s
", col, item_total[[col]],
              if (item_total[[col]] < 0.3) "   <- worded the other way round" else ""))
}

reversed <- names(item_total)[item_total < 0.3]
for (col in reversed) items[[col]] <- reverse_score(items[[col]])
cat(sprintf("
Reversed: %s

", paste(reversed, collapse = ", ")))

cat(sprintf("Items: %d, complete responses: %d
",
            ncol(items), nrow(items)))
cat(sprintf("Cronbach's alpha: %.3f
", cronbach_alpha(items)))

# Alpha with each item dropped in turn. An item whose removal raises alpha is
# the one to look at, not to delete automatically.
for (col in names(items)) {
  cat(sprintf("  without %-4s  %.3f
", col,
              cronbach_alpha(items[, setdiff(names(items), col)])))
}

# McDonald's omega, when the psych package is available:
#   install.packages("psych")
#   psych::omega(items, nfactors = 1)$omega.tot
