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
iscambinomtest <- function(
  observed,
  n,
  hypothesized = NULL,
  alternative,
  conf.level = NULL
) {
  old <- par(mar = c(3.5, 3, 2, 1), pin = c(4.5, 2.5))
  on.exit(par(old), add = TRUE)

  if (observed < 1) {
    observed <- round(n * observed)
  }
  pvalue <- NULL
  if (!is.null(hypothesized)) {
    minx <- max(
      0,
      n * hypothesized - 4 * sqrt(hypothesized * (1 - hypothesized) * n)
    )
    maxx <- min(
      n,
      n * hypothesized + 4 * sqrt(hypothesized * (1 - hypothesized) * n)
    )
    maxx <- max(observed + 1, maxx)
    myy <- max(dbinom(floor(n * hypothesized), n, hypothesized)) * .9
    x <- 0:n
    plot(
      x,
      dbinom(x, size = n, prob = hypothesized),
      xlab = "",
      ylab = " ",
      type = "h",
      xlim = c(minx, maxx),
      panel.first = grid(),
      lwd = 2
    )
    newtitle <- substitute(
      paste("Binomial (", n == x1, ", ", pi == x2, ")", ),
      list(x1 = n, x2 = hypothesized)
    )
    title(newtitle)
    mtext(side = 1, line = 2.2, "Number of Successes")
    mtext(side = 2, line = 2, "Probability")

    if (alternative == "less") {
      pvalue <- pbinom(observed, size = n, prob = hypothesized, TRUE)
      lines(
        0:observed,
        dbinom(0:observed, size = n, prob = hypothesized),
        col = "red",
        type = "h",
        lwd = 2
      )
      text(
        minx,
        myy,
        labels = paste("p-value:", signif(pvalue, 4)),
        pos = 4,
        col = "red"
      )
    } else if (alternative == "greater") {
      value <- observed - 1
      pvalue <- pbinom(value, size = n, prob = hypothesized, FALSE)
      lines(
        observed:n,
        dbinom(observed:n, size = n, prob = hypothesized),
        col = "red",
        type = "h",
        lwd = 2
      )
      text(
        maxx,
        myy,
        labels = paste("p-value:", signif(pvalue, 4)),
        pos = 2,
        col = "red"
      )
    } else {
      pvalue <- 0
      firstvalue <- dbinom(observed, size = n, prob = hypothesized)
      for (y in 0:n) {
        newvalue <- dbinom(y, size = n, prob = hypothesized)
        if (newvalue <= firstvalue + .00001) {
          pvalue <- pvalue + newvalue
          lines(y, newvalue, col = "red", type = "h", lwd = 2)
        }
      }
      text(
        minx,
        myy,
        labels = paste("two-sided p-value:\n", signif(pvalue, 4)),
        pos = 4,
        col = "red"
      )
    }
    pvalue <- signif(pvalue, 5)
    abline(h = 0, col = "gray")
    abline(v = 0, col = "gray")
  }
  cat("\n", "Exact Binomial Test\n", sep = "", "\n")
  statistic <- signif(observed / n, 4)
  cat(paste(
    "Data: observed successes = ",
    observed,
    ", sample size = ",
    n,
    ", sample proportion = ",
    statistic,
    "\n\n",
    sep = ""
  ))

  if (!is.null(hypothesized)) {
    cat(paste("Null hypothesis       : pi =", hypothesized, sep = " "), "\n")
    altname <- switch(alternative, less = "<", greater = ">", two.sided = "<>")
    cat(
      paste("Alternative hypothesis: pi", altname, hypothesized, sep = " "),
      "\n"
    )
    cat(paste("p-value:", pvalue, sep = " "), "\n")
  }
  p.L <- function(x, alpha) {
    if (x == 0) {
      0
    } else {
      qbeta(alpha, x, n - x + 1)
    }
  }
  p.U <- function(x, alpha) {
    if (x == n) {
      1
    } else {
      qbeta(1 - alpha, x + 1, n - x)
    }
  }
  CINT <- 0
  multconflevel <- 0
  lower1 <- NULL
  upper1 <- NULL
  if (!is.null(conf.level)) {
    for (k in 1:length(conf.level)) {
      if (conf.level[k] > 1) {
        conf.level[k] <- conf.level[k] / 100
      }
      alpha <- (1 - conf.level[k]) / 2
      CINT <- c(
        signif(p.L(observed, alpha), 5),
        ",",
        signif(p.U(observed, alpha), 5)
      )
      multconflevel <- 100 * conf.level[k]
      cat(multconflevel, "% Confidence interval for pi: (", CINT, ") \n")
      lower1[k] <- as.numeric(CINT[1])
      upper1[k] <- as.numeric(CINT[3])
    }
  }
  old2 <- par(mar = c(4, 2, 1.5, .5), mfrow = c(3, 1))
  on.exit(par(old2), add = TRUE)
  if (length(conf.level) > 1) {
    old3 <- par(mar = c(4, 2, 1.5, .4), mfrow = c(length(conf.level), 1))
    on.exit(par(old3), add = TRUE)
  }

  if (is.null(hypothesized)) {
    statistic <- observed / n
    # lower=lower1[1]; upper=upper1[1]
    SDphat <- sqrt(statistic * (1 - statistic) / n)
    min <- statistic - 4 * SDphat
    max <- statistic + 4 * SDphat
    CIseq <- seq(min, max, .01)
    minx <- as.integer(max(0, min * n))
    maxx <- as.integer(min(n, max * n))

    if (length(conf.level) == 1) {
      myxlab <- substitute(
        paste("Binomial (", n == x1, ", ", pi == x2, ")", ),
        list(x1 = n, x2 = signif(lower1[1], 4))
      )
      plot(
        seq(minx, maxx),
        dbinom(seq(minx, maxx), size = n, prob = lower1[1]),
        xlab = "  ",
        ylab = " ",
        type = "h",
        xlim = c(minx, maxx)
      )
      mtext("Number of successes", side = 1, line = 1.75, adj = .5, cex = .75)
      title(myxlab)
      lines(
        observed:n,
        dbinom(observed:n, size = n, prob = lower1[1]),
        col = "red",
        type = "h"
      )

      myxlab <- substitute(
        paste("Binomial (", n == x1, ", ", pi == x2, ")", ),
        list(x1 = n, x2 = signif(upper1[1], 4))
      )
      plot(
        seq(minx, maxx),
        dbinom(seq(minx, maxx), size = n, prob = upper1[1]),
        xlab = " ",
        ylab = " ",
        type = "h",
        xlim = c(minx, maxx)
      )
      lines(
        0:observed,
        dbinom(0:observed, size = n, prob = upper1[1]),
        col = "red",
        type = "h"
      )

      mtext("Number of successes", side = 1, line = 1.75, adj = .5, cex = .75)
      title(myxlab)
    } # end only one interval

    for (k in 1:length(conf.level)) {
      plot(
        c(min, statistic, max),
        c(1, 1, 1),
        pch = c(".", "^", "."),
        ylab = " ",
        xlab = "process probability",
        ylim = c(1, 1)
      )
      abline(v = statistic, col = "gray")
      text(min, 1, labels = paste(conf.level[k] * 100, "% CI:"))
      text(statistic, .9, labels = signif(statistic, 4))
      text(lower1[k], 1, labels = signif(lower1[k], 4), pos = 3)
      text(upper1[k], 1, labels = signif(upper1[k], 4), pos = 3)
      points(c(lower1[k], upper1[k]), c(1, 1), pch = c("[", "]"))
      lines(c(lower1[k], upper1[k]), c(1, 1))
    } # end intervals loop
  } # end no hypothesized

  par(mfrow = c(1, 1))
  return(invisible(list("pvalue" = pvalue, "lower" = lower1, "upper" = upper1)))
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
