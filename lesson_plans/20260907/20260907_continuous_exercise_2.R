# Exercise 2 (Exercise in standardization/transformation)
# If X ~ N(3, 4), compute the probabilities
mean <- 3.0
variance <- 4.0
sd <- sqrt(variance)

xs <- seq(-10, 10, by = 0.01)
ys_dnorm <- dnorm(xs, mean = mean, sd = sd)
plot(xs, ys_dnorm) # Beautiful normal curve
ys_pnorm <- pnorm(xs, mean = mean, sd = sd)
plot(xs, ys_pnorm)

# 2a. P(X < 5)
# Estimate: Around 80%
mass_under_five <- pnorm(5, mean = mean, sd = sd)
testthat::expect_equal(mass_under_five, 0.8413447, tolerance = 0.000001)

# 2b. P(3 < X < 5)
# Estimate: 35%
#   - Below 5 is around 85%
#   - Below 3 (the mean) is 50%
mass_under_3 <- pnorm(3.0, mean = mean, sd = sd)
mass_between_3_and_5 <- mass_under_five - mass_under_3
testthat::expect_equal(mass_between_3_and_5, 0.3413447, tolerance = 0.0000001)

# 2c. P(X > 7)
# Estimate: 20%
mass_above_7 <- pnorm(7.0, mean = mean, sd = sd, lower.tail = FALSE)
testthat::expect_equal(mass_above_7, 0.02275013, tolerance = 0.0000001)

