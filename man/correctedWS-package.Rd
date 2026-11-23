\name{correctedWS-package}
\alias{correctedWS-package}
\docType{package}
\title{Corrected Welch-Satterthwaite Degrees of Freedom}
\description{Corrected Welch-Satterthwaite effective degrees of freedom for weighted sums of independent variance components, with corrected-default t-test utilities.}
\details{The package implements the corrected estimator described in von Davier (2026): the denominator uses \code{nu + 2} and the result subtracts 2. The classical calculation remains available through \code{ws_classical()} and \code{method = "classical"}.}
\seealso{\code{\link{cws}}, \code{\link{corrected_t_test}}}
