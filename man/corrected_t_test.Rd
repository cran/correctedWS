\name{corrected_t_test}
\alias{corrected_t_test}
\title{One- and Two-Sample t-Tests with Corrected Default Degrees of Freedom}
\description{Performs one-sample, paired, pooled two-sample, or unequal-variance two-sample t-tests. The corrected Welch-Satterthwaite calculation is the default for the unequal-variance two-sample case.}
\usage{
corrected_t_test(x, y = NULL, alternative = c("two.sided", "less", "greater"),
  mu = 0, paired = FALSE, var.equal = FALSE, conf.level = 0.95,
  method = c("corrected", "classical"))
}
\arguments{
  \item{x}{Numeric vector of observations.}
  \item{y}{Optional numeric vector for a two-sample or paired test.}
  \item{alternative}{Alternative hypothesis: \code{"two.sided"}, \code{"less"}, or \code{"greater"}.}
  \item{mu}{Null mean or null difference in means.}
  \item{paired}{Logical; perform a paired test when \code{TRUE}.}
  \item{var.equal}{Logical; use the pooled-variance test for an independent two-sample test.}
  \item{conf.level}{Confidence level for the interval.}
  \item{method}{\code{"corrected"} by default, or \code{"classical"} for the usual Welch-Satterthwaite calculation.}
}
\value{An object of class \code{"htest"}.}
\examples{
corrected_t_test(1:10, y = 2:11)
corrected_t_test(1:10, y = 2:11, method = "classical")
}
