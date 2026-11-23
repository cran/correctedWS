# correctedWS

`correctedWS` is a proposed standalone R package for the corrected
Welch-Satterthwaite effective degrees of freedom estimator.

The package makes the corrected estimator the default for its own
`corrected_t_test()` unequal-variance two-sample test. The classical
Welch-Satterthwaite calculation remains available explicitly through
`method = "classical"` or `ws_classical()`.

```r
source("R/cws.R")
source("R/corrected_t_test.R")

cws(c(2, 3), c(10, 20))
corrected_t_test(x, y)
corrected_t_test(x, y, method = "classical")
```

This is a package proposal, not a modification of base R's
`stats::t.test()`. Existing base-R behavior is intentionally left unchanged.
See `../../cran-comments.md` for the proposed CRAN submission route.
