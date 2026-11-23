\name{ws_classical}
\alias{ws_classical}
\title{Classical Welch-Satterthwaite Effective Degrees of Freedom}
\description{Calculates the classical Welch-Satterthwaite effective degrees of freedom for explicit comparison with the corrected estimator.}
\usage{ws_classical(s2, nu, w = rep(1, length(s2)))}
\arguments{
  \item{s2}{Numeric vector of estimated variance components.}
  \item{nu}{Numeric vector of component degrees of freedom.}
  \item{w}{Numeric vector of positive weights.}
}
\value{A single numeric classical Welch-Satterthwaite effective degrees of freedom.}
\examples{
ws_classical(c(1, 1), c(1, 2))
}
