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

# Binomial with normal approximation and continuity correction visualization
iscambinomnorm <- function(k, n, prob, direction) {
  withr::local_par(mar = c(5, 3, 1, 1))

  thisx <- 0:n
  phat <- thisx / n
  minx <- max(0, n * prob - 4 * sqrt(prob * (1 - prob) * n))
  maxx <- max(k + 1, min(n, n * prob + 4 * sqrt(prob * (1 - prob) * n)))
  myy <- max(dbinom(floor(n * prob), n, prob))
  plot(
    thisx,
    dbinom(thisx, size = n, prob),
    xlab = "",
    ylab = " ",
    type = "h",
    xlim = c(minx, maxx),
    panel.first = grid(),
    lwd = 2
  )
  abline(h = 0, col = "gray")
  mtext(side = 1, line = 3, "Number of Successes (Proportion)")
  mtext(side = 2, line = 2, "Probability (Density)")

  axis(
    side = 1,
    at = thisx,
    labels = signif(phat, 2),
    padj = 1.2,
    tick = FALSE,
    col.axis = "blue"
  )
  normmean <- n * prob
  normsd <- sqrt(n * prob * (1 - prob))
  normseq <- seq(0, n, .001)
  lines(normseq, dnorm(normseq, normmean, normsd), col = "grey")
  if (direction == "below") {
    probseq <- seq(0, k, .001)
    phatseq <- probseq / n
    withcorrect <- seq(0, k + .5, .001)
    this.prob <- pbinom(k, n, prob)
    normprob <- pnorm(k, normmean, normsd)
    normprob2 <- pnorm(k + .5, normmean, normsd)
    showprob <- format(this.prob, digits = 4)
    showprob2 <- format(normprob, digits = 4)
    showprob3 <- format(normprob2, digits = 4)
    polygon(
      c(withcorrect, k + .5, 0),
      c(dnorm(withcorrect, normmean, normsd), 0, 0),
      col = 6,
      border = 6
    )
    polygon(
      c(probseq, k, 0),
      c(dnorm(probseq, normmean, normsd), 0, 0),
      col = "light blue",
      border = "blue"
    )
    lines(0:k, dbinom(0:k, size = n, prob), col = "red", type = "h", lwd = 2)
    text(
      minx,
      myy * .9,
      labels = paste("P(X \u2264", k, ") \n =", showprob),
      col = "red",
      pos = 4
    )
  } else if (direction == "above") {
    this.prob <- 1 - pbinom(k - 1, n, prob)
    probseq <- seq(k, n, .001)
    withcorrect <- seq(k - .5, n, .001)
    normprob <- pnorm(k, normmean, normsd, lower.tail = FALSE)
    normprob2 <- pnorm(k - .5, normmean, normsd, lower.tail = FALSE)
    showprob <- format(this.prob, digits = 4)
    showprob2 <- format(normprob, digits = 4)
    showprob3 <- format(normprob2, digits = 4)
    polygon(
      c(k - .5, withcorrect, n),
      c(0, dnorm(withcorrect, normmean, normsd), 0),
      col = 6,
      border = 6
    )
    polygon(
      c(k, probseq, n),
      c(0, dnorm(probseq, normmean, normsd), 0),
      col = "light blue",
      border = "blue"
    )
    lines(k:n, dbinom(k:n, size = n, prob), col = "red", type = "h", lwd = 2)
    text(
      maxx,
      myy * .9,
      labels = paste0("P(X \u2265 ", k, ")\n = ", showprob),
      col = "red",
      pos = 2
    )
  } else if (direction == "two.sided") {
    if (k < normmean) {
      k1 <- k
      k2 <- floor(min(normmean - k + normmean, n))
      newvalue <- dbinom(k2, size = n, prob)
      if (newvalue <= dbinom(k1, size = n, prob) + .00001) {
        k2 <- k2
      } else {
        k2 <- k2 + 1
      }
    } else {
      k1 <- floor(min(normmean - (k - normmean), n))
      k2 <- k
      newvalue <- dbinom(k1, size = n, prob)
      if (newvalue <= dbinom(k, size = n, prob) + .00001) {
        k1 <- k1
      } else {
        k1 <- k1 - 1
      }
    }
    this.prob <- pbinom(k1, n, prob) +
      pbinom(k2 - 1, n, prob, lower.tail = FALSE)
    normprob <- pnorm(k1, normmean, normsd) +
      pnorm(k2, normmean, normsd, lower.tail = FALSE)
    normprob2 <- pnorm(k1 + .5, normmean, normsd) +
      pnorm(k2 - .5, normmean, normsd, lower.tail = FALSE)
    showprob <- format(this.prob, digits = 4)
    showprob2 <- format(normprob, digits = 4)
    showprob3 <- format(normprob2, digits = 4)
    probseq1 <- seq(0, k1, .001)
    probseq2 <- seq(k2, n, .001)
    withcorrect <- seq(0, k1 + .5, .001)
    withcorrect2 <- seq(k2 - .5, n, .001)
    polygon(
      c(withcorrect, k1 + .5, 0),
      c(dnorm(withcorrect, normmean, normsd), 0, 0),
      col = 6,
      border = 6
    )
    polygon(
      c(probseq1, k1, 0),
      c(dnorm(probseq1, normmean, normsd), 0, 0),
      col = "light blue",
      border = "blue"
    )
    polygon(
      c(k2 - .5, withcorrect2, n),
      c(0, dnorm(withcorrect2, normmean, normsd), 0),
      col = 6,
      border = 6
    )
    polygon(
      c(k2, probseq2, n),
      c(0, dnorm(probseq2, normmean, normsd), 0),
      col = "light blue",
      border = "blue"
    )
    lines(0:k1, dbinom(0:k1, size = n, prob), col = "red", type = "h")
    lines(k2:n, dbinom(k2:n, size = n, prob), col = "red", type = "h")
    text(
      minx,
      myy * .85,
      labels = paste(
        "P(X \u2264",
        k1,
        ") + P(X \u2265",
        k2,
        ") \n =",
        showprob
      ),
      col = "red",
      pos = 4
    )
  }
  newtitle <- substitute(
    paste(
      "Binomial (",
      n == x1,
      ", ",
      pi == x2,
      "), Normal(",
      mean == x3,
      ",  ",
      SD == x4,
      ")"
    ),
    list(x1 = n, x2 = prob, x3 = prob, x4 = signif(normsd / n, 4))
  )
  title(newtitle)
  full <- c(
    c(" binomial:", showprob),
    c("\n normal approx:", showprob2),
    c("\n normal approx with continuity:", showprob3)
  )
  cat(full, "\n")
}

# Binomial test
iscambinomtest <- function(
  observed,
  n,
  hypothesized = NULL,
  alternative,
  conf.level = NULL
) {
  # Check for missing required parameters (observed and n)
  if (missing(observed) || missing(n)) {
    cat("Please fill in the required parameters:\n")
    cat("  observed = number of successes\n")
    cat("  n = sample size\n")
    return(invisible(NULL))
  }
  
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
}

# ============================================================================
# NORMAL DISTRIBUTION FUNCTIONS
# ============================================================================

# Inverse Normal Calculation - finds quantiles from probabilities
iscaminvnorm <- function(prob1, mean = 0, sd = 1, direction, verbose = TRUE) {
  min_x <- mean - 4 * sd
  max_x <- mean + 4 * sd
  x_seq <- seq(min_x, max_x, length.out = 500)
  y_max <- dnorm(mean, mean, sd)
  
  plot(x_seq, dnorm(x_seq, mean, sd), type = "l", 
       xlab = "", ylab = "", main = paste0("Normal(mean = ", mean, ", SD = ", sd, ")"),
       panel.first = grid())
  abline(h = 0, col = "gray")
  
  if (direction == "below") {
    answer <- qnorm(prob1, mean, sd)
    prob_seq <- seq(min_x, answer, length.out = 100)
    polygon(c(min_x, prob_seq, answer), c(0, dnorm(prob_seq, mean, sd), 0), 
            col = "pink", border = "red")
    text(min_x, y_max * 0.8, labels = paste0("P(X <= ", round(answer, 4), ") = ", prob1),
         pos = 4, col = "red")
    if (verbose) cat("The observation with", prob1, "probability below is", round(answer, 4), "\n")
  } else if (direction == "above") {
    answer <- qnorm(prob1, mean, sd, lower.tail = FALSE)
    prob_seq <- seq(answer, max_x, length.out = 100)
    polygon(c(answer, prob_seq, max_x), c(0, dnorm(prob_seq, mean, sd), 0), 
            col = "pink", border = "red")
    text(max_x, y_max * 0.8, labels = paste0("P(X >= ", round(answer, 4), ") = ", prob1),
         pos = 2, col = "red")
    if (verbose) cat("The observation with", prob1, "probability above is", round(answer, 4), "\n")
  } else if (direction == "between") {
    answer1 <- qnorm((1 - prob1) / 2, mean, sd)
    answer2 <- qnorm(1 - (1 - prob1) / 2, mean, sd)
    prob_seq <- seq(answer1, answer2, length.out = 100)
    polygon(c(answer1, prob_seq, answer2), c(0, dnorm(prob_seq, mean, sd), 0), 
            col = "pink", border = "red")
    text(mean, y_max * 0.5, labels = prob1, col = "blue")
    text(answer1, dnorm(answer1, mean, sd), labels = round(answer1, 4), pos = 3, col = "red")
    text(answer2, dnorm(answer2, mean, sd), labels = round(answer2, 4), pos = 3, col = "red")
    if (verbose) cat("There is", prob1, "probability between", round(answer1, 4), "and", round(answer2, 4), "\n")
  } else if (direction == "outside") {
    answer1 <- qnorm(prob1 / 2, mean, sd)
    answer2 <- qnorm(1 - prob1 / 2, mean, sd)
    prob_seq1 <- seq(min_x, answer1, length.out = 100)
    prob_seq2 <- seq(answer2, max_x, length.out = 100)
    polygon(c(min_x, prob_seq1, answer1), c(0, dnorm(prob_seq1, mean, sd), 0), 
            col = "pink", border = "red")
    polygon(c(answer2, prob_seq2, max_x), c(0, dnorm(prob_seq2, mean, sd), 0), 
            col = "pink", border = "red")
    text(answer1, dnorm(answer2, mean, sd) * 0.5, labels = prob1/2, pos = 2, col = "blue")
    text(answer2, dnorm(answer2, mean, sd) * 0.5, labels = prob1/2, pos = 4, col = "blue")
    if (verbose) cat("There is", prob1, "probability outside", round(answer1, 4), "and", round(answer2, 4), "\n")
  }
}

# ============================================================================
# T-DISTRIBUTION FUNCTIONS
# ============================================================================

# Find t* critical value (inverse t) - simplified version for Sage cells
iscaminvt <- function(prob, df, direction) {
  old_par <- par(mar = c(4, 3, 2, 2))
  on.exit(par(old_par))
  
  min_val <- -4
  max_val <- 4
  ymax <- dt(0, df)
  thisx <- seq(min_val, max_val, .001)
  
  plot(
    thisx,
    dt(thisx, df),
    xlab = "",
    ylab = "density",
    type = "l",
    panel.first = grid()
  )
  title(paste("t (df =", df, ")"))
  mtext(side = 1, line = 2, "t-values")
  mtext(side = 2, line = 2, "density")
  
  abline(h = 0, col = "black")
  
  if (direction == "below") {
    answer <- signif(qt(prob, df, lower.tail = TRUE), 4)
    thisrange <- seq(min_val, answer, .001)
    polygon(c(thisrange, answer, 0), c(dt(thisrange, df), 0, 0), col = "pink")
    text(
      (min_val + answer) / 2,
      dt(answer, df) / 2,
      labels = prob,
      pos = 2,
      col = "blue"
    )
    text(
      answer,
      min(dt(answer, df), ymax * .85),
      labels = paste("T <=", answer),
      col = "red",
      pos = 3
    )
    cat("The observation with", prob, "probability below is", answer, "\n")
    invisible()
  } else if (direction == "above") {
    answer <- signif(qt(prob, df, lower.tail = FALSE), 4)
    thisrange <- seq(answer, max_val, .001)
    polygon(c(answer, thisrange, max_val), c(0, dt(thisrange, df), 0), col = "pink")
    text(
      (answer + max_val) / 2,
      (dt(answer, df) / 2),
      labels = prob,
      pos = 4,
      col = "blue"
    )
    text(
      answer,
      min(dt(answer, df), ymax * .85),
      labels = paste("T >=", answer),
      col = "red",
      pos = 3
    )
    cat("The observation with", prob, "probability above is", answer, "\n")
    invisible()
  } else if (direction == "between") {
    answer1 <- signif(qt((1 - prob) / 2, df, lower.tail = TRUE), 4)
    answer2 <- 0 + (0 - answer1)
    thisrange <- seq(answer1, answer2, .001)
    polygon(
      c(answer1, thisrange, answer2),
      c(0, dt(thisrange, df), 0),
      col = "pink"
    )
    text(0, (dt(.5, df) / 2), labels = prob, col = "blue")
    text(
      answer1,
      min(dt(answer1, df), ymax * .85),
      labels = paste("T =", answer1),
      col = "red",
      pos = 3
    )
    text(
      answer2,
      min(dt(answer2, df), ymax * .85),
      labels = paste("T =", answer2),
      col = "red",
      pos = 3
    )
    cat("There is", prob, "probability between", answer1, "and", answer2, "\n")
    invisible()
  } else if (direction == "outside") {
    answer1 <- signif(qt(prob / 2, df, lower.tail = TRUE), 4)
    answer2 <- 0 + (0 - answer1)
    thisrange1 <- seq(min_val, answer1, .001)
    thisrange2 <- seq(answer2, max_val, .001)
    polygon(
      c(min_val, thisrange1, answer1),
      c(0, dt(thisrange1, df), 0),
      col = "pink"
    )
    polygon(
      c(answer2, thisrange2, max_val),
      c(0, dt(thisrange2, df), 0),
      col = "pink"
    )
    text(
      answer1,
      dt(answer1, df) / 2,
      labels = prob / 2,
      col = "blue",
      pos = 2
    )
    text(
      answer2,
      dt(answer2, df) / 2,
      labels = prob / 2,
      col = "blue",
      pos = 4
    )
    text(
      answer1,
      min(dt(answer1, df), ymax * .85),
      labels = paste("T =", answer1),
      col = "red",
      pos = 3
    )
    text(
      answer2,
      min(dt(answer2, df), ymax * .85),
      labels = paste("T =", answer2),
      col = "red",
      pos = 3
    )
    cat("There is", prob, "probability outside", answer1, "and", answer2, "\n")
    invisible()
  }
}

# One Sample t-Test and Confidence Interval - with graphics
iscamonesamplet <- function(
  xbar,
  sd,
  n,
  hypothesized = 0,
  alternative = NULL,
  conf.level = NULL,
  verbose = TRUE
) {
  # Handle conf.level as percentage (95) or proportion (0.95)
  if (!is.null(conf.level) && any(conf.level > 1)) {
    conf.level <- conf.level / 100
  }
  
  if (verbose) {
    cat("\nOne Sample t test\n\n", sep = "")
  }
  statistic <- xbar
  df <- n - 1
  se <- sd / sqrt(n)
  tvalue <- NULL
  pvalue <- NULL
  
  if (verbose) {
    cat(paste(
      "mean = ",
      xbar,
      ", sd = ",
      sd,
      ",  sample size = ",
      n,
      "\n",
      sep = ""
    ))
  }
  
  if (!is.null(alternative)) {
    if (verbose) {
      cat(paste("Null hypothesis       : mu =", hypothesized, sep = " "), "\n")
      altname <- switch(
        alternative,
        less = "<",
        greater = ">",
        two.sided = "<>",
        not.equal = "<>"
      )
      cat(
        paste("Alternative hypothesis: mu", altname, hypothesized, sep = " "),
        "\n"
      )
    }

    tvalue <- (statistic - hypothesized) / se
    if (verbose) {
      cat("t-statistic:", signif(tvalue, 4), "\n")
    }
    
    min_t <- min(-4, tvalue - .001)
    diffmin <- min(
      hypothesized - 4 * se,
      hypothesized - abs(hypothesized - statistic) - .01
    )
    max_t <- max(4, tvalue + .001)
    diffmax <- max(
      hypothesized + 4 * se,
      hypothesized + abs(hypothesized - statistic) + .01
    )
    x <- seq(min_t, max_t, .001)
    diffx <- x * se + hypothesized
    
    old_par <- par(mar = c(4, 3, 2, 2))
    on.exit(par(old_par), add = TRUE)
    
    plot(
      diffx,
      dt(x, df),
      xlab = "Sample Means",
      ylab = " ",
      type = "l",
      ylim = c(0, dt(0, df)),
      panel.first = grid()
    )
    tseq <- c(
      hypothesized - 3 * se,
      hypothesized - 2 * se,
      hypothesized - se,
      hypothesized,
      hypothesized + se,
      hypothesized + 2 * se,
      hypothesized + 3 * se
    )
    mtext(side = 2, line = 2, "density")

    axis(
      side = 1,
      at = tseq,
      labels = c("t=-3", "t=-2", "t=-1", "t=0", "t=1", "t=2", "t=3"),
      padj = 1.2,
      tick = FALSE,
      col.axis = "blue"
    )
    abline(h = 0, col = "black")
    title(paste("t (df=", df, ")"))
    
    if (alternative == "less") {
      pvalue <- pt(tvalue, df)
      drawseq <- seq(diffmin, statistic, .001)
      polygon(
        c(drawseq, statistic, diffmin),
        c(dt((drawseq - hypothesized) / se, df), 0, 0),
        col = "red"
      )
      text(
        diffmin,
        dt(0, df) * .9,
        labels = paste("t-statistic:", signif(tvalue, 3)),
        pos = 4,
        col = "blue"
      )
      text(
        diffmin,
        dt(0, df) * .8,
        labels = paste("p-value:", signif(pvalue, 4)),
        pos = 4,
        col = "red"
      )
    } else if (alternative == "greater") {
      pvalue <- 1 - pt(tvalue, df)
      drawseq <- seq(statistic, diffmax, .001)
      polygon(
        c(statistic, drawseq, diffmax),
        c(0, dt((drawseq - hypothesized) / se, df), 0),
        col = "red"
      )
      text(
        diffmax,
        dt(0, df) * .9,
        labels = paste("t-statistic:", signif(tvalue, 3)),
        pos = 2,
        col = "blue"
      )
      text(
        diffmax,
        dt(0, df) * .8,
        labels = paste("p-value:", signif(pvalue, 4)),
        pos = 2,
        col = "red"
      )
    } else if (alternative == "two.sided" || alternative == "not.equal") {
      pvalue <- 2 * pt(-1 * abs(tvalue), df)
      drawseq1 <- seq(
        diffmin,
        hypothesized - abs(hypothesized - statistic),
        .001
      )
      drawseq2 <- seq(
        hypothesized + abs(hypothesized - statistic),
        diffmax,
        .001
      )
      polygon(
        c(diffmin, drawseq1, drawseq1[length(drawseq1)]),
        c(0, dt((drawseq1 - hypothesized) / se, df), 0),
        col = "red"
      )
      polygon(
        c(drawseq2[1], drawseq2, diffmax),
        c(0, dt((drawseq2 - hypothesized) / se, df), 0),
        col = "red"
      )
      text(
        diffmin,
        dt(0, df) * .9,
        labels = paste("t-statistic:", signif(tvalue, 4)),
        pos = 4,
        col = "blue"
      )
      text(
        diffmin,
        dt(0, df) * .8,
        labels = paste("two-sided p-value:", signif(pvalue, 4)),
        pos = 4,
        col = "red"
      )
    }
  } # end test

  lower <- NULL
  upper <- NULL
  if (!is.null(conf.level)) {
    for (k in 1:length(conf.level)) {
      criticalvalue <- qt((1 - conf.level[k]) / 2, df)
      lower[k] <- statistic + criticalvalue * se
      upper[k] <- statistic - criticalvalue * se
      multconflevel <- 100 * conf.level[k]
      if (verbose) {
        cat(
          multconflevel,
          "% Confidence interval for mu: (",
          signif(lower[k], 4),
          ", ",
          signif(upper[k], 4),
          ") \n"
        )
      }
    }
  }
  
  if (!is.null(alternative) && verbose) {
    cat("p-value:", pvalue, "\n")
  }
  
  invisible()
}

# One Proportion Z-Test and Confidence Interval
iscamonepropztest <- function(
  observed,
  n,
  hypothesized = NULL,
  alternative = "two.sided",
  conf.level = NULL
) {
  withr::local_par(mar = c(5, 3, 1, 1))

  if (observed < 1) {
    observed = round(n * observed)
  }
  myout = prop.test(observed, n, hypothesized, alternative, correct = FALSE)
  cat("\n", "One Proportion z test\n", sep = "", "\n")
  statistic = signif(observed / n, 4)
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
  zvalue = NULL
  pvalue = NULL
  if (!is.null(hypothesized)) {
    cat(paste("Null hypothesis       : pi =", hypothesized, sep = " "), "\n")
    altname = switch(
      alternative,
      less = "<",
      greater = ">",
      two.sided = "<>",
      not.equal = "<>"
    )
    cat(
      paste("Alternative hypothesis: pi", altname, hypothesized, sep = " "),
      "\n"
    )
    zvalue = (statistic - hypothesized) /
      sqrt(hypothesized * (1 - hypothesized) / n)
    cat("z-statistic:", signif(zvalue, 4), "\n")
    pvalue = signif(myout$p.value, 4)
    cat("p-value:", pvalue, "\n")
    SD = sqrt(hypothesized * (1 - hypothesized) / n)
    min = min(hypothesized - 4 * SD, hypothesized - abs(zvalue) * SD - .001)
    max = max(hypothesized + 4 * SD, hypothesized + abs(zvalue) * SD + .001)
    x = seq(min, max, .001)
    plot(
      x,
      dnorm(x, hypothesized, SD),
      xlab = "",
      ylab = "",
      type = "l",
      ylim = c(0, dnorm(hypothesized, hypothesized, SD)),
      panel.first = grid()
    )

    zseq = c(
      hypothesized - 3 * SD,
      hypothesized - 2 * SD,
      hypothesized - SD,
      hypothesized,
      hypothesized + SD,
      hypothesized + 2 * SD,
      hypothesized + 3 * SD
    )
    axis(
      side = 1,
      at = zseq,
      labels = c("z=-3", "z=-2", "z=-1", "z=0", "z=1", "z=2", "z=3"),
      padj = 1.2,
      tick = FALSE,
      col.axis = "blue"
    )
    abline(h = 0, col = "black")
    mtext(side = 1, line = 3, "\u2190 Sample Proportions \u2192")
    mtext(side = 2, line = 2, "Density")
    if (alternative == "less") {
      drawseq = seq(min, statistic, .001)
      polygon(
        c(drawseq, statistic, min),
        c(dnorm(drawseq, hypothesized, SD), 0, 0),
        col = "red"
      )
      text(
        min,
        max(dnorm(hypothesized, hypothesized, SD)) * .9,
        labels = paste("z-statistic:", signif(zvalue, 4)),
        pos = 4,
        col = "blue"
      )
      text(
        min,
        max(dnorm(hypothesized, hypothesized, SD)) * .8,
        labels = paste("p-value:", pvalue),
        pos = 4,
        col = "red"
      )
    } else if (alternative == "greater") {
      drawseq = seq(statistic, max, .001)
      polygon(
        c(statistic, drawseq, max),
        c(0, dnorm(drawseq, hypothesized, SD), 0),
        col = "red"
      )
      text(
        max,
        max(dnorm(hypothesized, hypothesized, SD)) * .9,
        labels = paste("z-statistic:", signif(zvalue, 4)),
        pos = 2,
        col = "blue"
      )
      text(
        max,
        max(dnorm(hypothesized, hypothesized, SD)) * .8,
        labels = paste("p-value:", pvalue),
        pos = 2,
        col = "red"
      )
    } else if (alternative == "two.sided" || alternative == "not.equal") {
      if (statistic < hypothesized) {
        drawseq1 = seq(min, statistic, .001)
        drawseq2 = seq(hypothesized + (hypothesized - statistic), max, .001)
      } else {
        drawseq1 = seq(min, hypothesized - (statistic - hypothesized), .001)
        drawseq2 = seq(statistic, max, .001)
      }
      polygon(
        c(min, drawseq1, drawseq1[length(drawseq1)]),
        c(0, dnorm(drawseq1, hypothesized, SD), 0),
        col = "red"
      )
      polygon(
        c(drawseq2[1], drawseq2, max),
        c(0, dnorm(drawseq2, hypothesized, SD), 0),
        col = "red"
      )
      text(
        min,
        max(dnorm(hypothesized, hypothesized, SD)) * .9,
        labels = paste("z-statistic:", signif(zvalue, 4)),
        pos = 4,
        col = "blue"
      )
      text(
        min,
        max(dnorm(hypothesized, hypothesized, SD)) * .8,
        labels = paste("two-sided p-value:", pvalue),
        pos = 4,
        col = "red"
      )
    }
  }
  withr::local_par(mfrow = c(3, 1))
  if (length(conf.level) > 1) {
    withr::local_par(mar = c(4, 2, 1.5, 4), mfrow = c(length(conf.level), 1))
  }
  lower = 0
  upper = 0
  if (!is.null(conf.level)) {
    for (k in 1:length(conf.level)) {
      if (conf.level[k] > 1) {
        conf.level[k] = conf.level[k] / 100
      }
      myout = prop.test(
        observed,
        n,
        p = statistic,
        alternative = "two.sided",
        conf.level[k],
        correct = FALSE
      )
      criticalvalue = qnorm((1 - conf.level[k]) / 2)
      lower[k] = statistic +
        criticalvalue * sqrt(statistic * (1 - statistic) / n)
      upper[k] = statistic -
        criticalvalue * sqrt(statistic * (1 - statistic) / n)
      multconflevel = 100 * conf.level[k]
      cat(
        multconflevel,
        "% Confidence interval for pi: (",
        lower[k],
        ", ",
        upper[k],
        ") \n"
      )
    }
    if (is.null(hypothesized)) {
      SDphat = sqrt(statistic * (1 - statistic) / n)
      min = statistic - 4 * SDphat
      max = statistic + 4 * SDphat
      CIseq = seq(min, max, .001)

      if (length(conf.level) == 1) {
        myxlab = substitute(
          paste("Normal (", mean == x1, ", ", SD == x2, ")", ),
          list(x1 = signif(lower[1], 4), x2 = signif(SDphat, 4))
        )
        plot(CIseq, dnorm(CIseq, lower[1], SDphat), type = "l", xlab = " ")
        mtext("sample proportions", side = 1, line = 1.75, adj = .5, cex = .75)
        topseq = seq(statistic, max, .001)
        polygon(
          c(statistic, topseq, max),
          c(0, dnorm(topseq, lower[1], SDphat), 0),
          col = "red"
        )
        title(myxlab)
        myxlab = substitute(
          paste("Normal (", mean == x1, ", ", SD == x2, ")", ),
          list(x1 = signif(upper[1], 4), x2 = signif(SDphat, 4))
        )
        plot(
          seq(min, max, .001),
          dnorm(seq(min, max, .001), upper[1], SDphat),
          type = "l",
          xlab = " "
        )
        mtext("sample proportions", side = 1, line = 1.75, adj = .5, cex = .75)
        bottomseq = seq(min, statistic, .001)
        polygon(
          c(min, bottomseq, statistic, statistic),
          c(
            0,
            dnorm(bottomseq, upper[1], SDphat),
            dnorm(statistic, upper[1], SDphat),
            0
          ),
          col = "red"
        )
        newtitle = substitute(
          paste("Normal (", mean == x1, ", ", SD == x2, ")", ),
          list(x1 = signif(upper[1], 4), x2 = signif(SDphat, 4))
        )
        title(newtitle)
      }
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
        text(min * 1.1, 1, labels = paste(conf.level[k] * 100, "% CI:"))
        text(statistic, .9, labels = signif(statistic, 4))
        text(lower[k], 1, labels = signif(lower[k], 4), pos = 3)
        text(upper[k], 1, labels = signif(upper[k], 4), pos = 3)
        points(c(lower[k], upper[k]), c(1, 1), pch = c("[", "]"))
        lines(c(lower[k], upper[k]), c(1, 1))
      }
    }
  }
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
}

# ==============================================================================
# HYPERGEOMETRIC FUNCTIONS
# ==============================================================================

iscamhyperprob <- function(k, total, succ, n, lower.tail = TRUE) {
  withr::local_par(mar = c(4, 4, 2, 1))

  if (k < 1 & k > 0) {
    k <- round((k * (total - n) * n + succ * n) / total)
  }

  fail <- total - succ
  thisx <- max(0, n - fail):min(n, succ)
  plot(
    thisx,
    dhyper(thisx, succ, fail, n),
    xlab = " ",
    ylab = " ",
    type = "h",
    panel.first = grid(),
    lwd = 2
  )
  abline(h = 0, col = "gray")
  mtext(side = 1, line = 2, "Number of Successes")
  mtext(side = 2, line = 2, "Probability")

  if (lower.tail) {
    this.prob <- phyper(k, succ, fail, n)
    showprob <- format(this.prob, digits = 4)
    lines(0:k, dhyper(0:k, succ, fail, n), col = "red", type = "h", lwd = 2)
    xtext <- max(2, k - .5)
    text(
      xtext,
      dhyper(k, succ, fail, n),
      labels = paste("P(X \u2264 ", k, ")\n = ", showprob),
      pos = 3,
      col = "red"
    )
    cat("Probability", k, "and below =", this.prob, "\n")
  }
  if (!lower.tail) {
    this.prob <- 1 - phyper(k - 1, succ, fail, n)
    showprob <- format(this.prob, digits = 4)
    lines(k:n, dhyper(k:n, succ, fail, n), col = "red", type = "h", lwd = 2)
    # text(k, dhyper(k, succ, fail, n), labels=showprob, pos=4, col="red")
    xtext <- min(k + .5, succ - 2)
    text(
      xtext,
      dhyper(k, succ, fail, n),
      labels = paste("P(X \u2265 ", k, ")\n = ", showprob),
      pos = 3,
      col = "red"
    )
    cat("Probability", k, "and above =", this.prob, "\n")
  }
  newtitle <- substitute(
    paste("Hypergeometric (", N == x1, ", ", M == x2, ",", n == x3, ")"),
    list(x1 = total, x2 = succ, x3 = n)
  )
  title(newtitle)
  return(this.prob)
}
