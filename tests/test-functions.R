library(correctedWS)

stopifnot(all.equal(cws2(2, 3, 10, 20), 31.673469387755105))
stopifnot(all.equal(cws(c(2, 3), c(10, 20), c(1, 2)),
                    30.49230769230769))
stopifnot(all.equal(cws(c(1, 2, 3), c(5, 10, 15), c(1, 2, 3)),
                    29.405745062836626))
stopifnot(all.equal(ws_classical(c(1, 1), c(1, 2)), 2.666666666666667))
stopifnot(is.na(cws(c(0, 0), c(1, 2))))

set.seed(1)
x <- rnorm(20)
y <- rnorm(25, mean = 0.2)
corrected <- corrected_t_test(x, y)
classical <- corrected_t_test(x, y, method = "classical")
reference <- stats::t.test(x, y)
stopifnot(inherits(corrected, "htest"))
stopifnot(all.equal(unname(classical$statistic),
                    unname(reference$statistic)))
stopifnot(all.equal(unname(classical$p.value),
                    unname(reference$p.value)))
