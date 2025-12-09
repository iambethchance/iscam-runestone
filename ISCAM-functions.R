# ISCAM R Functions for Runestone Sage Cells
# Simplified versions of key functions from the ISCAM package

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
}

# Dotplot function
iscamdotplot <- function(x, ...) {
  stripchart(x, method = "stack", pch = 19, ...)
}

# Test message
cat("ISCAM functions loaded successfully from GitHub!\n")
cat("Available functions: iscamsummary(), iscamdotplot()\n")
