\name{cws2}
\alias{cws2}
\title{Corrected Welch-Satterthwaite Calculation for Two Components}
\description{Convenience wrapper for the corrected Welch-Satterthwaite calculation with two variance components.}
\usage{cws2(s2_1, s2_2, nu_1, nu_2, w1 = 1, w2 = 1)}
\arguments{
  \item{s2_1}{First estimated variance component.}
  \item{s2_2}{Second estimated variance component.}
  \item{nu_1}{Degrees of freedom for the first component.}
  \item{nu_2}{Degrees of freedom for the second component.}
  \item{w1}{Positive first-component weight.}
  \item{w2}{Positive second-component weight.}
}
\value{A single numeric corrected effective degrees of freedom.}
\examples{
cws2(2, 3, 10, 20)
cws2(4, 9, 5, 8, w1 = 2, w2 = 3)
}
