#Exercise 10 (Chance of meeting boss)
# Your boss comes in to the office three days per week.
# You do also come in to work three days per week.
# If you both choose which days to come in to work at random,
# what is the probability that a particular week
# you are in the office at the same time 0, 1, 2 or 3 days, respectively?
#
# USE A SIMULATION
#
#' Simulate the days of the week I or the boss is present
set.seed(42)

simulate_presence <- function() {
  sample(c(rep(TRUE, 3), rep(FALSE, 2)), 5, replace = FALSE)
}
testthat::expect_equal(3, sum(simulate_presence()))

#' Get the number of days we are at the same time
simulate_n_days_both <- function() {
  presence_me <- simulate_presence()
  presence_boss <- simulate_presence()
  n_days_both <- sum(presence_me == TRUE & presence_boss == TRUE & presence_me == presence_boss)
  testthat::expect_true(n_days_both >= 1 && n_days_both <= 3)
  n_days_both
}

# Get a frequency table
t <- table(replicate(n = 1000, simulate_n_days_both()))
testthat::expect_equal(names(t), as.character(seq(1, 3)))
expected <- c(321, 591, 88)
testthat::expect_equal(as.numeric(t), expected)
# as.numeric(t) / 1000
#
# Unsure how to use the geometric distribution here, I am not convinced
