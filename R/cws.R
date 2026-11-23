#' Corrected Welch-Satterthwaite effective degrees of freedom
#'
#' @param s2 Numeric vector of estimated variance components.
#' @param nu Numeric vector of component degrees of freedom.
#' @param w Numeric vector of positive weights. Defaults to equal weights.
#' @return A single corrected effective degrees of freedom, or `NA_real_`
#'   when the denominator is zero.
#' @examples
#' cws(c(2, 3), c(10, 20))
#' cws(c(2, 3), c(10, 20), c(1, 2))
#' @export
cws <- function(s2, nu, w = rep(1, length(s2))) {
  .validate_components(s2, nu, w)

  den <- sum(w^2 * s2^2 / (nu + 2))
  if (den <= 0) {
    return(NA_real_)
  }

  sum(w * s2)^2 / den - 2
}

#' Corrected Welch-Satterthwaite calculation for two components
#'
#' @param s2_1,s2_2 Estimated variance components.
#' @param nu_1,nu_2 Component degrees of freedom.
#' @param w1,w2 Positive component weights. Defaults to one.
#' @return A single corrected effective degrees of freedom.
#' @examples
#' cws2(2, 3, 10, 20)
#' cws2(4, 9, 5, 8, w1 = 2, w2 = 3)
#' @export
cws2 <- function(s2_1, s2_2, nu_1, nu_2, w1 = 1, w2 = 1) {
  cws(c(s2_1, s2_2), c(nu_1, nu_2), c(w1, w2))
}

#' Classical Welch-Satterthwaite effective degrees of freedom
#'
#' This is retained as an explicit comparison method. Unlike [cws()], it
#' uses `nu` rather than `nu + 2` in the denominator and does not subtract 2.
#'
#' @param s2 Numeric vector of estimated variance components.
#' @param nu Numeric vector of component degrees of freedom.
#' @param w Numeric vector of positive weights. Defaults to equal weights.
#' @return A single classical Welch-Satterthwaite effective degrees of freedom,
#'   or `NA_real_` when the denominator is zero.
#' @examples
#' ws_classical(c(1, 1), c(1, 2))
#' @export
ws_classical <- function(s2, nu, w = rep(1, length(s2))) {
  .validate_components(s2, nu, w)

  den <- sum(w^2 * s2^2 / nu)
  if (den <= 0) {
    return(NA_real_)
  }

  sum(w * s2)^2 / den
}

.validate_components <- function(s2, nu, w) {
  if (!is.numeric(s2) || !is.numeric(nu) || !is.numeric(w)) {
    stop("s2, nu, and w must be numeric.", call. = FALSE)
  }
  if (length(s2) < 1L || length(nu) != length(s2) ||
      length(w) != length(s2)) {
    stop("s2, nu, and w must have the same positive length.", call. = FALSE)
  }
  if (any(!is.finite(c(s2, nu, w)))) {
    stop("s2, nu, and w must contain only finite values.", call. = FALSE)
  }
  if (any(s2 < 0)) {
    stop("all s2 values must be non-negative.", call. = FALSE)
  }
  if (any(nu <= 0)) {
    stop("all nu values must be positive.", call. = FALSE)
  }
  if (any(w <= 0)) {
    stop("all w values must be positive.", call. = FALSE)
  }
  invisible(NULL)
}
