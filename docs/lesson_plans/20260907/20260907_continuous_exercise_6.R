# > Exercise 6 (Amount of active substance)
# > The amount of active substance in a pill is
# > stated by the manufacturer to be normally
# > distributed with mean 12 mg and standard deviation 0.5 mg.
mean <- 12
sd <- 0.5
# > You take a sample of five pills and measure
# > the amount of active substance to;
# > 13.0, 12.3, 12.6, 12.5, 12.7 mg.
measurements <- c(13.0, 12.3, 12.6, 12.5, 12.7)
n_measurements <- length(measurements)
testthat::expect_equal(5, n_measurements)
#
# > [Note: a-c were already computed in the descriptive
# > statistics session.]
#
# Uhhh, sure, where is that...? Let's ignore :-)
#
# > 6.a. Compute the sample mean
sample_mean <- mean(measurements)
testthat::expect_equal(sample_mean, 12.62)

#
# 6.b. Compute the sample variance
#
# WRONG variance <- sd * sd
# WRONG sample_variance <- variance / n_measurements
# WRONG testthat::expect_equal(sample_variance, 0.05)
sample_variance <- var(measurements)
testthat::expect_equal(sample_variance, 0.067)

# > 6.c. Compute the sample standard deviation
# WRONG sample_sd <- sqrt(sample_variance)
sample_sd <- sd(measurements)
testthat::expect_true(sample_sd < sd)
# WRONG testthat::expect_equal(sample_sd, 0.2236068)
testthat::expect_equal(sample_sd, 0.2588436, tolerance = 0.0000001)

# > 6.d. compute the standard error of mean, SEM
#
# SEM = sample_sd / sqrt(n_samples)
# WRONG sem <- sample_sd / sqrt(n_measurements)
#
# In the answer I read:
#
# > Note, here the known standard deviation, sd = 0.5 is used.
#
# No idea what SEM does, nor why I should pick the regular sd
#
sem <- sd / sqrt(n_measurements)
# WRONG testthat::expect_equal(0.1157584, sem, tolerance = 0.000001)
# ????? ANSWER IS 0.2236068, NO IDEA HOW THIS IS CALCULATED
testthat::expect_equal(0.2236068, sem, tolerance = 0.000001)

# > 6.e. If the manufacturers claim is correct,
# > what is the probability to see a sample mean
# > as high as in (a) or higher?
xs <- seq(mean - (3.0 * sd), mean + (3.0 * sd), by = 0.01)
ys_dnorm <- dnorm(xs, mean = mean, sd = sd)
plot(xs, ys_dnorm) # Beautiful normal curve
ys_pnorm <- pnorm(xs, mean = mean, sd = sd)
plot(xs, ys_pnorm)
# 12.62 is sample mean, around 20% is above it
# WRONG: p_above_12_62 <- pnorm(sample_mean, mean = mean, sd = sd, lower.tail = FALSE)
p_above_12_62 <- pnorm(sample_mean, mean = mean, sd = sem, lower.tail = FALSE)
testthat::expect_equal(p_above_12_62, 0.00277946)

