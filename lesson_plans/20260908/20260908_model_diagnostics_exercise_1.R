# Exercises (model diagnostics)
# https://nbisweden.github.io/workshop-mlbiostatistics/docs/SM4LS-book/SM4LS-lm/lm-diagn-exercises.html
#
#
# > Exercise 1 (Brozek score) Researchers collected age, weight, height and 10 body circumference measurements for 252 men in an attempt to find an alternative way of calculate body fat as oppose to measuring someone weight and volume, the latter one by submerging in a water tank. Is it possible to predict body fat using easy-to-record measurements?
# >
# > Use lm() function and fit a linear method to model brozek, score estimate of percent body fat
# >
# > find R^2 and R^2_adjusted
# >  and
# > assess the diagnostics plots to check for model assumptions
# > delete observation #86 with the highest Cook’s distance and re-fit the model (model.clean)
# > look at the model summary. Are all variables associated with brozek score?
# > try improving the model fit by removing variables with the highest p-value first and re-fitting the model until all the variables are significantly associated with the response (p value less than 0.1); note down the
# > values while doing so
# > compare the output models for model.clean and final model
# > To access and preview the data:

get_data <- function() {
  data(fat, package = "faraway")
  t <- fat
  rm(fat, envir = globalenv())
  t
}

t <- get_data()
names(t)

# 180 minutes in

# > find R^2 and R^2_adjusted

fitted_model <- lm(t)
r_squared <- summary(fitted_model)$r.squared
r_squared_adj <- summary(fitted_model)$adj.r.squared
options(digits = 8)
testthat::expect_equal(r_squared, 0.99954835)
testthat::expect_equal(r_squared_adj, 0.99951553)

# > assess the diagnostics plots to check for model assumptions

par(mfrow = c(2,2))
plot(fitted_model)

# So what I see:
# - panel A: in the 'Residuals vs Fitted' (top-left): the residuals should be
#   horizontal, but there is a slight negative slope.
#   Outliers are 182, 33 and 169
# - Panel B: In the Q-Q-residuals (top-right:
#    - at the left, these are below the straight line with a slight slope
#    - at the right, these are above the straight line with a slight slope
# - In the 'Scale-Location' (bottom-left) I see a nearly flat red line
#   that is an upward parabola
# - In the 'Residuals vs Leverage' (bottom-right) I see tha the red
#   line goes slightly upward
#
# This means:
#
# - the model fits the data reasonably well
# - Heavy tail: from panel B: smaller residuals follow a normal distributions,
#   but bigger residuals happen more often than expected
#
# I see that panel C and D are unused and unexplained.

# > delete observation #86 with the highest Cook’s distance and re-fit the model (model.clean)

# No idea why 86 needs to be deleted. He/she is no outlier
# Easy:

get_data_without_86 <- function() {
  t <- get_data()
  index_86 <- which(row.names(t) == "86")
  t[-index_86, ]
}

t <- get_data_without_86()
testthat::expect_equal(0, length(which(row.names(t) == "86")))

fitted_model <- lm(t)
r_squared <- summary(fitted_model)$r.squared
r_squared_adj <- summary(fitted_model)$adj.r.squared
options(digits = 8)
testthat::expect_equal(r_squared, 0.99954707)
testthat::expect_equal(r_squared_adj, 0.99951403)
par(mfrow = c(2,2))
plot(fitted_model)

# I see no difference in the plot


# > look at the model summary. Are all variables associated with brozek score?

# When I do

summary(fitted_model)

# I see many independent variable that are not result in a significant slope.
# I assume that answers the question.

# > try improving the model fit by removing variables with
# > the highest p-value first and re-fitting the model
#
# NO! This must be lowest p values!
#
# > until all the variables are significantly associated with the
# > response (p value less than 0.1); note down the
# > values while doing so

#' Get the data with only those independent variables that have
#' a significant slope
get_useful_data <- function() {
  t <- get_data() # Don't care about 86 anymore
  fitted_model <- lm(t)
  x <- summary(fitted_model)
  p_values <- x$coefficients[, 4]
  useful_independent_variables <- names(p_values[p_values < 0.05])
  t[, names(t) %in% useful_independent_variables]
}

t <- get_useful_data()
fitted_model <- lm(t)
r_squared <- summary(fitted_model)$r.squared
r_squared_adj <- summary(fitted_model)$adj.r.squared
options(digits = 8)
testthat::expect_equal(r_squared, 0.98492672)
testthat::expect_equal(r_squared_adj, 0.98455758)
par(mfrow = c(2,2))
plot(fitted_model)

# The results seens fine enough still ...


# > compare the output models for model.clean and final model

# Sure! They look quite similar!

