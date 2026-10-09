# Exercise 11 (Rare disease)
# A rare disease affects 3 in 100000 in a large population.
n_total <- 100000
n_affected <- 3
n_not_affected <- n_total- n_affected
p_affected <- n_affected / n_total
p_not_affected <- 1.0 - p_affected
n_picked <- 10000
# If 10000 people are randomly selected from the population,
# what is the probability
# that no one in the sample is affected?
my_estimate <- p_not_affected ^ 10000
# Use hypergeometric distribution again:

none <- 0

p_none_of_3_affected <- dhyper(
  x = none, # vector of quantiles representing the number of white balls drawn without replacement from an urn which contains both black and white balls.
  m = n_affected, # the number of white balls in the urn.
  n = n_not_affected, # the number of black balls in the urn
  k = n_picked # the number of balls drawn from the urn
)
testthat::expect_equal(p_none_of_3_affected, 0.7289976, tolerance = 0.0000001)
testthat::expect_equal(my_estimate, p_none_of_3_affected, tolerance = 0.02)

# that at least two in the sample are affected?
# Need phyper
p_at_least_2_affected <- phyper(
  q = 2 -  1, # vector of quantiles representing the number of white balls drawn without replacement from an urn which contains both black and white balls.
  m = n_affected, # the number of white balls in the urn.
  n = n_not_affected, # the number of black balls in the urn
  k = n_picked, # the number of balls drawn from the urn
  lower.tail = FALSE
)
testthat::expect_equal(p_at_least_2_affected, 0.02799784, tolerance = 0.0000001)

# HUH? Why is this a Poisson distribution?
# Aha: at
#
# https://nbisweden.github.io/workshop-mlbiostatistics/docs/SM4LS-book/SM4LS-probability/prob_02discrv.html#poisson
#
# I read:
#
# > It is commonly used for rare events.
#
# Still, I assume my answers are correct...?
# I will use these as estimates then :-)
my_estimate <- p_none_of_3_affected # Calculated from hypergeometric distribution

expect_to_be_affected <- p_affected * n_picked

p_none_of_3_affected <- dpois(
  x = none, # vector of quantiles representing the number of white balls drawn without replacement from an urn which contains both black and white balls.
  lambda = expect_to_be_affected # vector of (non-negative) means.
)
testthat::expect_equal(p_none_of_3_affected, 0.7408182, tolerance = 0.0000001)
testthat::expect_equal(my_estimate, p_none_of_3_affected, tolerance = 0.3)

# > that at least two in the sample are affected?
my_estimate <- p_at_least_2_affected # my earlier estimate

p_at_least_2_affected <- ppois(
  q = 2 -  1, # vector of quantiles representing the number of white balls drawn without replacement from an urn which contains both black and white balls.
  lambda = expect_to_be_affected, # vector of (non-negative) means.
  lower.tail = FALSE
)

testthat::expect_equal(p_at_least_2_affected, 0.03693631, tolerance = 0.0000001)
testthat::expect_equal(my_estimate, p_at_least_2_affected, tolerance = 0.01)
