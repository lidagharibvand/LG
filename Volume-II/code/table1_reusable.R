## table1_reusable.R: the tools for a reusable Table 1 (Listing 2.24 of Volume II, Section 2.11.1)
## Load them with source("table1_reusable.R"); then follow Listing 2.25 or the template of Section 2.11.1.
## Companion repository: github.com/lidagharibvand/LG

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
