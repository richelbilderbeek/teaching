# Exercise 4 (Pill)
# A drug company is producing a pill,
# with on average 12 mg of active substance.
mean <- 12
# The amount of active substance is normally distributed with
# mean 12 mg and standard deviation 0.5 mg,
# if the production is without problems.
sd <- 0.5

xs <- seq(12 - 4, 12 + 4, by = 0.01)
ys_dnorm <- dnorm(xs, mean = mean, sd = sd)
plot(xs, ys_dnorm) # Beautiful normal curve
ys_pnorm <- pnorm(xs, mean = mean, sd = sd)
plot(xs, ys_pnorm)

# > Sometimes there is a problem with the production
# > and the amount of active substance will be too high or too low,
# > in which case the pill has to be discarded.
# > What should the upper and lower critical values
# > (limits for when a pill is acceptable) be in order
# > not to discard more than 1/20 pills from a problem free production?

# This means that 1/40 pills = 2.5% have too little content
# 0.025 == pnorm(some_value, mean = mean, sd = sd)
# This is done by qnorm
lowest_amount <- qnorm(p = 1.0 / 40.0, mean = mean, sd = sd)
highest_amount <- qnorm(p = 1.0 / 40.0, mean = mean, sd = sd, lower.tail = FALSE)
# These should be symmetrical around the mean
testthat::expect_equal(mean - lowest_amount, highest_amount - mean)
testthat::expect_equal(11.02002, lowest_amount, tolerance = 0.000001)
testthat::expect_equal(12.97998, highest_amount, tolerance = 0.000001)

# This means that:
testthat::expect_equal(1.0 / 40.0, pnorm(lowest_amount, mean = mean, sd = sd))
testthat::expect_equal(1.0 / 40.0, pnorm(highest_amount, mean = mean, sd = sd, lower.tail = FALSE))

