\name{cws}
\alias{cws}
\title{Corrected Welch-Satterthwaite Effective Degrees of Freedom}
\description{Calculates corrected effective degrees of freedom for a weighted sum of independent variance components.}
\usage{cws(s2, nu, w = rep(1, length(s2)))}
\arguments{
  \item{s2}{Numeric vector of estimated variance components.}
  \item{nu}{Numeric vector of component degrees of freedom.}
  \item{w}{Numeric vector of positive weights.}
}
\value{A single numeric corrected effective degrees of freedom, or \code{NA_real_} when the denominator is zero.}
\examples{
cws(c(2, 3), c(10, 20))
cws(c(2, 3), c(10, 20), c(1, 2))
}
