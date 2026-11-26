# Exercise 5 (Exercise in distribution of sample mean)
# The total cholesterol in population (mg/dL) is normally distributed with
# mean = 202 and sd = 40
mean <- 202
sd <- 40

xs <- seq(mean - (3.0 * sd), mean + (3.0 * sd), by = 0.01)
ys_dnorm <- dnorm(xs, mean = mean, sd = sd)
plot(xs, ys_dnorm) # Beautiful normal curve
ys_pnorm <- pnorm(xs, mean = mean, sd = sd)
plot(xs, ys_pnorm)


# > 5a. How is the sample mean of a sample of 4 persons distributed?
#
# Well, we know that, from
variance <- sd * sd
# X ~ N(mean, variance) -> N(202, 1600)
# a sample of n has:
# X ~ N(mean, variance / n) -> N(202, 400)
n_people <- 4
variance_of_sample <- variance / n_people
sd_of_sample <- sqrt(variance_of_sample)
testthat::expect_equal(sd_of_sample, sd / sqrt(n_people))
testthat::expect_equal(sd_of_sample, 20)

# > 5b. What is the probability to see a sample mean of 260 mg/dL or higher?
sd <- sd_of_sample # OVERWRITE
xs <- seq(mean - (3.0 * sd), mean + (3.0 * sd), by = 0.01)
ys_dnorm <- dnorm(xs, mean = mean, sd = sd)
plot(xs, ys_dnorm) # Beautiful normal curve
ys_pnorm <- pnorm(xs, mean = mean, sd = sd)
plot(xs, ys_pnorm)
# This is when the mass above 260
# Estimate: 1%
p_mass_above_260 <- pnorm(260, mean = mean, sd = sd, lower.tail = FALSE)
testthat::expect_equal(p_mass_above_260, 0.001865813)

# > 5c. Is there reason to believe that the four persons with mean 260 mg/dL
# > were sampled from another population with higher population mean?
#
# The chance is around 0.18%, or 1 in 536. It is quite low
