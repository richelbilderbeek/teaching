# Exercise 3 (Hemoglobin)
# The hemoglobin (Hb) value in a male population is normally distributed
# with mean 188 g/L and standard deviation 14 g/L.
mean <- 188
sd <- 14

xs <- seq(150, 200, by = 0.01)
ys_dnorm <- dnorm(xs, mean = mean, sd = sd)
plot(xs, ys_dnorm) # Beautiful normal curve
ys_pnorm <- pnorm(xs, mean = mean, sd = sd)
plot(xs, ys_pnorm)

# > Men with Hb below 158 g/L are considered anemic.
# > What is the probability of a random man being anemic?
#
# Estimate: 10%
p_anemic <- pnorm(158, mean = mean, sd = sd)
testthat::expect_equal(0.01606229, p_anemic)

# When randomly selecting 10 men from the population,
# what is the probability that none of them are anemic?
#
# We can easily calculate this:
p_not_anemic <- 1.0 - p_anemic
p_none_anemic <- p_not_anemic ^ 10
testthat::expect_equal(p_none_anemic, 0.8505034, tolerance = 0.0000001)
