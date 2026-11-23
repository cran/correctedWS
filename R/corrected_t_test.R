#' One- and two-sample t-tests with corrected default degrees of freedom
#'
#' @param x Numeric vector of observations.
#' @param y Optional numeric vector of observations for a two-sample test.
#' @param alternative Character string: `"two.sided"`, `"less"`, or
#'   `"greater"`.
#' @param mu Null mean, or null difference in means.
#' @param paired Logical; perform a paired test when `TRUE`.
#' @param var.equal Logical; use the pooled-variance test when `TRUE` for an
#'   independent two-sample test.
#' @param conf.level Confidence level for the interval.
#' @param method Degrees-of-freedom method: `"corrected"` by default, or
#'   `"classical"` for the usual Welch-Satterthwaite calculation.
#' @return An object of class `"htest"`, analogous to the result of
#'   [stats::t.test()].
#' @details
#' For an independent unequal-variance two-sample test, the two variance
#' components are `var(x) / length(x)` and `var(y) / length(y)`, with degrees
#' of freedom `length(x) - 1` and `length(y) - 1`. The corrected method then
#' applies [cws()] to those components. One-sample, paired, and pooled tests
#' have their usual degrees of freedom because they reduce to one variance
#' component or a pooled variance estimate.
#' @examples
#' corrected_t_test(1:10, y = 2:11)
#' corrected_t_test(1:10, y = 2:11, method = "classical")
#' @export
corrected_t_test <- function(x, y = NULL,
                             alternative = c("two.sided", "less", "greater"),
                             mu = 0, paired = FALSE, var.equal = FALSE,
                             conf.level = 0.95,
                             method = c("corrected", "classical")) {
  alternative <- match.arg(alternative)
  method <- match.arg(method)

  if (!is.numeric(x) || !is.null(y) && !is.numeric(y)) {
    stop("x and y must be numeric.", call. = FALSE)
  }
  if (length(mu) != 1L || !is.numeric(mu) || !is.finite(mu)) {
    stop("mu must be one finite numeric value.", call. = FALSE)
  }
  if (length(conf.level) != 1L || !is.numeric(conf.level) ||
      !is.finite(conf.level) || conf.level <= 0 || conf.level >= 1) {
    stop("conf.level must be a number strictly between 0 and 1.",
         call. = FALSE)
  }

  x_name <- deparse(substitute(x))
  y_name <- deparse(substitute(y))

  if (paired) {
    if (is.null(y)) {
      stop("y must be supplied for a paired test.", call. = FALSE)
    }
    if (length(x) != length(y)) {
      stop("x and y must have the same length for a paired test.",
           call. = FALSE)
    }
    keep <- is.finite(x) & is.finite(y)
    d <- x[keep] - y[keep]
    if (length(d) < 2L) {
      stop("not enough complete pairs.", call. = FALSE)
    }
    estimate_value <- mean(d)
    stderr <- sqrt(var(d) / length(d))
    df <- length(d) - 1
    estimate <- c("mean difference" = estimate_value)
    null_value <- c("mean difference" = mu)
    method_label <- if (method == "corrected") {
      "Corrected paired t-test"
    } else {
      "Classical paired t-test"
    }
    data_name <- paste(x_name, "and", y_name)
  } else if (is.null(y)) {
    x <- x[is.finite(x)]
    if (length(x) < 2L) {
      stop("not enough finite observations in x.", call. = FALSE)
    }
    estimate_value <- mean(x)
    stderr <- sqrt(var(x) / length(x))
    df <- length(x) - 1
    estimate <- c("mean of x" = estimate_value)
    null_value <- c("mean" = mu)
    method_label <- if (method == "corrected") {
      "Corrected one-sample t-test"
    } else {
      "Classical one-sample t-test"
    }
    data_name <- x_name
  } else {
    x <- x[is.finite(x)]
    y <- y[is.finite(y)]
    if (length(x) < 2L || length(y) < 2L) {
      stop("not enough finite observations in one or both groups.",
           call. = FALSE)
    }

    nx <- length(x)
    ny <- length(y)
    vx <- var(x)
    vy <- var(y)
    estimate_value <- mean(x) - mean(y)

    if (var.equal) {
      df <- nx + ny - 2
      pooled <- ((nx - 1) * vx + (ny - 1) * vy) / df
      stderr <- sqrt(pooled * (1 / nx + 1 / ny))
      method_label <- "Pooled two-sample t-test"
    } else {
      components <- c(vx / nx, vy / ny)
      component_df <- c(nx - 1, ny - 1)
      stderr <- sqrt(sum(components))
      df <- if (method == "corrected") {
        cws(components, component_df)
      } else {
        ws_classical(components, component_df)
      }
      method_label <- if (method == "corrected") {
        "Corrected Welch t-test"
      } else {
        "Classical Welch t-test"
      }
    }
    estimate <- c("mean of x" = mean(x), "mean of y" = mean(y))
    null_value <- c("difference in means" = mu)
    data_name <- paste(x_name, "and", y_name)
  }

  if (!is.finite(stderr) || stderr <= 0) {
    stop("data have essentially no variance.", call. = FALSE)
  }

  statistic_value <- (estimate_value - mu) / stderr
  statistic <- c(t = statistic_value)
  parameter <- c(df = df)

  p_value <- switch(
    alternative,
    two.sided = 2 * stats::pt(-abs(statistic_value), df = df),
    less = stats::pt(statistic_value, df = df),
    greater = stats::pt(statistic_value, df = df)
  )

  alpha <- 1 - conf.level
  critical <- if (alternative == "two.sided") {
    stats::qt(1 - alpha / 2, df = df)
  } else {
    stats::qt(1 - alpha, df = df)
  }
  conf_int <- switch(
    alternative,
    two.sided = c(estimate_value - critical * stderr,
                  estimate_value + critical * stderr),
    less = c(-Inf, estimate_value + critical * stderr),
    greater = c(estimate_value - critical * stderr, Inf)
  )
  attr(conf_int, "conf.level") <- conf.level

  result <- list(
    statistic = statistic,
    parameter = parameter,
    p.value = p_value,
    conf.int = conf_int,
    estimate = estimate,
    null.value = null_value,
    alternative = alternative,
    method = method_label,
    data.name = data_name,
    stderr = stderr
  )
  class(result) <- "htest"
  result
}
