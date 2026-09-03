# Exercise 1 (The normal table) Let Z ~ N(0, 1)
# be a standard normal random variable, and compute;

# 1a. P(Z < 1.64)

plot(dnorm, from = -5.0, to = 5.0)
plot(pnorm, from = -5.0, to = 5.0)
# This is the mass below 1.64 stdev, I estimate 70%
mass_below_164 <- pnorm(
  q = 1.64, # vector of quantiles.
  mean = 0,
  sd = 1,
  lower.tail = TRUE
)
testthat::expect_equal(mass_below_164, 0.9494974, tolerance = 0.0000001)

# 1b. P(Z > -1.64)
# I estimate this to be the same: 0.9494974
mass_above_minus_164 <- pnorm(
  q = -1.64, # vector of quantiles.
  mean = 0,
  sd = 1,
  lower.tail = FALSE
)

testthat::expect_equal(mass_above_minus_164, 0.9494974, tolerance = 0.0000001)

# 1c. P(-1.96 < Z)
# This is equal to P(Z > -1.96),
# which I estimate at 0.97
mass_above_minus_196 <- pnorm(
  q = -1.96, # vector of quantiles.
  mean = 0,
  sd = 1,
  lower.tail = FALSE
)
testthat::expect_true(mass_above_minus_196 > mass_above_minus_164)
testthat::expect_equal(mass_above_minus_196, 0.9750021, tolerance = 0.0000001)

# 1d. P(Z < 2.36)
mass_below_236 <- pnorm(
  q = 2.36, # vector of quantiles.
  mean = 0,
  sd = 1,
  lower.tail = TRUE
)
testthat::expect_equal(mass_below_236, 0.9908625, tolerance = 0.0000001)

# 1e. An a such that P(Z < a) = 0.95
# Or: which x has 0.95 below it? This is around 1.64

#
#?qnorm
#
#  > qnorm gives the quantile function
#
# Ah, that is super useless ...
plot(qnorm, from = 0.0, to = 1.0)

a_with_95_percent_below_it <- qnorm(
  p = 0.95,
  mean = 0,
  sd = 1,
  lower.tail = TRUE
)
testthat::expect_equal(a_with_95_percent_below_it, 1.644854, tolerance = 0.000001)

# 1f. A b such that P(Z > b) = 0.975
# Hence, a a value of x above which 97.5% percent of the density is
# I estimate this at -1.96
b_with_97_5_percent_above_it <- qnorm(
  p = 0.975,
  mean = 0,
  sd = 1,
  lower.tail = FALSE
)
testthat::expect_equal(b_with_97_5_percent_above_it, -1.959964, tolerance = 0.000001)
b_with_97_5_percent_above_it
