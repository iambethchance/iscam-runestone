# ISCAM R Functions for Runestone Sage Cells
# Essential functions from the ISCAM package for use in browser-based R cells
# Source: https://github.com/ISCAM4/ISCAM

# ============================================================================
# SUMMARY STATISTICS
# ============================================================================

# Summary function for grouped data
iscamsummary <- function(variable, by = NULL, data = NULL) {
  if (!is.null(data)) {
    variable <- data[[deparse(substitute(variable))]]
    if (!is.null(by)) {
      by <- data[[deparse(substitute(by))]]
    }
  }
  
  if (is.null(by)) {
    # Single variable summary
    result <- list(
      n = length(variable),
      mean = mean(variable, na.rm = TRUE),
      sd = sd(variable, na.rm = TRUE),
      min = min(variable, na.rm = TRUE),
      Q1 = quantile(variable, 0.25, na.rm = TRUE),
      median = median(variable, na.rm = TRUE),
      Q3 = quantile(variable, 0.75, na.rm = TRUE),
      max = max(variable, na.rm = TRUE)
    )
    print(data.frame(result))
  } else {
    # Grouped summary
    cat("\nSummary Statistics by Group:\n\n")
    groups <- unique(by)
    for (g in groups) {
      cat(paste0("Group: ", g, "\n"))
      subset_data <- variable[by == g]
      result <- data.frame(
        n = length(subset_data),
        mean = mean(subset_data, na.rm = TRUE),
        sd = sd(subset_data, na.rm = TRUE),
        min = min(subset_data, na.rm = TRUE),
        median = median(subset_data, na.rm = TRUE),
        max = max(subset_data, na.rm = TRUE)
      )
      print(result)
      cat("\n")
    }
  }
  invisible(NULL)
}

# ============================================================================
# PLOTTING FUNCTIONS
# ============================================================================

# Dotplot function
iscamdotplot <- function(x, by = NULL, data = NULL, main = "", xlab = "", ylab = "") {
  if (!is.null(data)) {
    x <- data[[deparse(substitute(x))]]
    if (!is.null(by)) {
      by <- data[[deparse(substitute(by))]]
    }
  }
  
  if (is.null(by)) {
    stripchart(x, method = "stack", pch = 19, main = main, xlab = xlab)
  } else {
    stripchart(x ~ by, method = "stack", pch = 19, main = main, xlab = xlab, ylab = ylab)
  }
  invisible(NULL)
}

# Boxplot function
iscamboxplot <- function(x, by = NULL, data = NULL, main = "", xlab = "", ylab = "") {
  if (!is.null(data)) {
    x <- data[[deparse(substitute(x))]]
    if (!is.null(by)) {
      by <- data[[deparse(substitute(by))]]
    }
  }
  
  if (is.null(by)) {
    boxplot(x, main = main, xlab = xlab, horizontal = TRUE)
  } else {
    boxplot(x ~ by, main = main, xlab = xlab, ylab = ylab, horizontal = TRUE)
  }
  invisible(NULL)
}

# ============================================================================
# BINOMIAL FUNCTIONS
# ============================================================================

# Binomial probability with graph (from ISCAM4/ISCAM package)
iscambinomprob <- function(k, n, prob, lower.tail, verbose = TRUE) {
  if (prob < 0 || prob > 1) {
    stop("Error: `prob` (probability) must be a numeric value between 0 and 1.")
  }
  
  old <- par(mar = c(4, 3, 2, 2), pin = c(5, 3))
  on.exit(par(old), add = TRUE)
  thisx <- 0:n
  minx <- max(0, n * prob - 4 * sqrt(prob * (1 - prob) * n))
  maxx <- min(n, n * prob + 4 * sqrt(prob * (1 - prob) * n))
  maxx <- max(k + 1, maxx)
  myy <- dbinom(floor(n * prob), n, prob)
  plot(
    thisx,
    dbinom(thisx, size = n, prob),
    xlab = " ",
    ylab = " ",
    type = "h",
    xlim = c(minx, maxx),
    panel.first = grid(),
    lwd = 2
  )
  abline(h = 0, col = "gray")

  if (lower.tail) {
    this.prob <- pbinom(k, n, prob)
    showprob <- format(this.prob, digits = 4)
    lines(0:k, dbinom(0:k, size = n, prob), col = "red", type = "h", lwd = 2)
    text(
      minx,
      myy * .8,
      labels = bquote(atop(P(X <= .(k)), "=" ~ .(showprob))),
      pos = 4,
      col = "red"
    )
    if (verbose) {
      cat("Probability", k, "and below =", this.prob, "\n")
    }
  } else {
    this.prob <- 1 - pbinom(k - 1, n, prob)
    showprob <- format(this.prob, digits = 4)
    lines(k:n, dbinom(k:n, size = n, prob), col = "red", type = "h", lwd = 2)
    text(
      (maxx + n * prob) * 9 / 16,
      myy,
      labels = bquote(atop(P(X >= .(k)), "=" ~ .(showprob))),
      pos = 1,
      col = "red"
    )
    if (verbose) {
      cat("Probability", k, "and above =", this.prob, "\n")
    }
  }
  newtitle <- substitute(
    paste("Binomial (", n == x1, ", ", pi == x2, ")", ),
    list(x1 = n, x2 = prob)
  )
  title(newtitle)
  mtext(side = 1, line = 2, "Number of Successes")
  mtext(side = 2, line = 2, "Probability")

  return(this.prob)
}

# Binomial test
iscambinomtest <- function(observed, n, hypothesized = 0.5, alternative = "two.sided", conf.level = 0.95) {
  result <- binom.test(observed, n, hypothesized, alternative, conf.level)
  
  cat("\nOne Sample Binomial Test\n")
  cat("=========================\n")
  cat(paste0("Observed: ", observed, " out of ", n, "\n"))
  cat(paste0("Sample proportion: ", round(observed/n, 4), "\n"))
  cat(paste0("Hypothesized: ", hypothesized, "\n"))
  cat(paste0("Alternative: ", alternative, "\n"))
  cat(paste0("p-value: ", round(result$p.value, 4), "\n"))
  cat(paste0(conf.level*100, "% Confidence Interval: (", 
             round(result$conf.int[1], 4), ", ", 
             round(result$conf.int[2], 4), ")\n"))
  
  invisible(result)
}

# ============================================================================
# TWO PROPORTION Z-TEST
# ============================================================================

iscamtwopropztest <- function(x1, n1, x2, n2, hypothesized = 0, 
                                alternative = "two.sided", conf.level = 0.95) {
  # Allow proportions or counts
  if (x1 <= 1) x1 <- round(x1 * n1)
  if (x2 <= 1) x2 <- round(x2 * n2)
  
  p1 <- x1/n1
  p2 <- x2/n2
  phat <- (x1 + x2)/(n1 + n2)
  
  se <- sqrt(phat * (1 - phat) * (1/n1 + 1/n2))
  z <- (p1 - p2 - hypothesized) / se
  
  if (alternative == "two.sided") {
    pval <- 2 * pnorm(-abs(z))
  } else if (alternative == "greater") {
    pval <- pnorm(z, lower.tail = FALSE)
  } else {
    pval <- pnorm(z)
  }
  
  # CI
  se_ci <- sqrt(p1 * (1 - p1) / n1 + p2 * (1 - p2) / n2)
  z_crit <- qnorm(1 - (1 - conf.level)/2)
  ci_lower <- (p1 - p2) - z_crit * se_ci
  ci_upper <- (p1 - p2) + z_crit * se_ci
  
  cat("\nTwo Proportion Z-Test\n")
  cat("=====================\n")
  cat(paste0("Group 1: ", x1, " out of ", n1, " (", round(p1, 4), ")\n"))
  cat(paste0("Group 2: ", x2, " out of ", n2, " (", round(p2, 4), ")\n"))
  cat(paste0("Difference: ", round(p1 - p2, 4), "\n"))
  cat(paste0("Z-statistic: ", round(z, 4), "\n"))
  cat(paste0("p-value: ", round(pval, 4), "\n"))
  cat(paste0(conf.level*100, "% CI: (", round(ci_lower, 4), ", ", round(ci_upper, 4), ")\n"))
  
  invisible(list(z = z, pvalue = pval, ci = c(ci_lower, ci_upper)))
}

# ============================================================================
# HYPERGEOMETRIC FUNCTIONS
# ============================================================================

iscamhyperprob <- function(k, total, succ, n, lower.tail = TRUE) {
  if (lower.tail) {
    result <- phyper(k, succ, total - succ, n)
  } else {
    result <- phyper(k - 1, succ, total - succ, n, lower.tail = FALSE)
  }
  cat(paste0("P = ", round(result, 4), "\n"))
  invisible(result)
}

# ============================================================================
# STARTUP MESSAGE
# ============================================================================

cat("ISCAM functions loaded successfully from GitHub!\n")
cat("Available functions:\n")
cat("  - iscamsummary()\n")
cat("  - iscamdotplot()\n")
cat("  - iscamboxplot()\n")
cat("  - iscambinomprob()\n")
cat("  - iscambinomtest()\n")
cat("  - iscamtwopropztest()\n")
cat("  - iscamhyperprob()\n")
