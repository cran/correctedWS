## ----setup, include=FALSE-----------------------------------------------------
knitr::opts_chunk$set(
  collapse = TRUE,
  comment = "#>",
  fig.width = 6,
  fig.height = 4
)
library(correctedWS)

## ----formula------------------------------------------------------------------
s2 <- c(2, 3)
nu <- c(10, 20)
w <- c(1, 2)

num <- sum(w * s2)
den <- sum(w^2 * s2^2 / (nu + 2))
num^2 / den - 2
cws(s2, nu, w)

## ----cws-examples-------------------------------------------------------------
cws(c(2, 3), c(10, 20))
cws(c(2, 3), c(10, 20), w = c(1, 2))
cws(c(1, 2, 3), c(5, 10, 15), w = c(1, 2, 3))

## ----weight-invariance--------------------------------------------------------
cws(c(2, 3), c(10, 20), w = c(1, 2))
cws(c(2, 3), c(10, 20), w = c(2, 4))

## ----cws2-examples------------------------------------------------------------
cws2(2, 3, 10, 20)
cws2(4, 9, 5, 8, w1 = 2, w2 = 3)

## ----comparison---------------------------------------------------------------
s2 <- c(1, 1)
nu <- c(1, 2)

cws(s2, nu)
ws_classical(s2, nu)

## ----t-test-example-----------------------------------------------------------
set.seed(20261103)
x <- rnorm(20, mean = 0, sd = 1)
y <- rnorm(12, mean = 0.4, sd = 2)

corrected <- corrected_t_test(x, y)
classical <- corrected_t_test(x, y, method = "classical")

corrected
classical

## ----base-t-test--------------------------------------------------------------
stats::t.test(x, y)

## ----simulation, results='asis'-----------------------------------------------
simulate_cell <- function(K, nu, nsim = 1000L) {
  draws <- matrix(rchisq(nsim * K, df = nu), nrow = nsim, ncol = K)
  s2 <- draws / nu
  estimates <- apply(
    s2, 1L,
    function(row) cws(row, nu = rep(nu, K))
  )
  target <- K * nu

  data.frame(
    K = K,
    nu = nu,
    target_df = target,
    mean_df = mean(estimates),
    bias = mean(estimates) - target,
    relative_bias = (mean(estimates) - target) / target,
    rmse = sqrt(mean((estimates - target)^2))
  )
}

set.seed(20261103)
simulation <- do.call(
  rbind,
  lapply(c(1, 3, 10), function(nu) {
    do.call(rbind, lapply(c(2, 10, 40), simulate_cell,
                          nu = nu, nsim = 1000L))
  })
)

simulation

