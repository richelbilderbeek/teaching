# Exercises (introduction to linear models)
# https://nbisweden.github.io/workshop-mlbiostatistics/docs/SM4LS-book/SM4LS-lm/lm-intro-exercises.html


# > Exercise 1 (Fitting linear model)
# > Going back to the diabetes data,
# > fit linear regression models using vector-matrix notations
# > to model BMI based on age [years] and waist [m] measurements.
# > In particular, define design matrix X,
# > vector of observations Y
# > and vector of parameters beta
# > and use beta_hat = ((X^T * X) ^ -1) * (X ^ T) * Y
# > to find beta values estimates.
# >
# > Check your calculations by fitting the model using lm() function.
# >
# > The below code can get you started.
#
# ```r
# inch2m <- 2.54/100
# pound2kg <- 0.45
# data_diabetes <- diabetes %>%
#   mutate(height  = height * inch2m, height = round(height, 2)) %>%
#   mutate(waist = waist * inch2m) %>%
#   mutate(weight = weight * pound2kg, weight = round(weight, 2)) %>%
#   mutate(BMI = weight / height^2, BMI = round(BMI, 2)) %>%
#   mutate(obese= cut(BMI, breaks = c(0, 29.9, 100), labels = c("No", "Yes"))) %>%
#   mutate(diabetic = ifelse(glyhb > 7, "Yes", "No"), diabetic = factor(diabetic, levels = c("No", "Yes"))) %>%
#   na.omit()
# ```
#
# Problems: no indications of the libraries used.
# Problems: no easy link to the code behind the pages.
# Luckily I know the pattern:
#
# https://nbisweden.github.io/workshop-mlbiostatistics
# -> https://github.com/NBISweden/workshop-mlbiostatistics
#
# Ah, I found it:
#
# https://github.com/NBISweden/workshop-mlbiostatistics/blob/master/SM4LS-lm/lm-reg-cls.qmd#L95
#
# It is chosen to be **not** shown
#
# WOW! The data is at
#
# https://github.com/NBISweden/workshop-mlbiostatistics/blob/master/SM4LS-lm/data/data-diabetes.csv
#
# Here I write code that works:


get_diabetes_data <- function() {
  library(tidyverse)
  input_diabetes <- readr::read_csv("https://raw.githubusercontent.com/NBISweden/workshop-mlbiostatistics/refs/heads/master/SM4LS-lm/data/data-diabetes.csv", show_col_types = FALSE)

  # clean data
  inch2cm <- 2.54
  pound2kg <- 0.45
  input_diabetes %>%
    mutate(height  = height * inch2cm / 100, height = round(height, 2)) %>%
    mutate(waist = waist * inch2cm) %>%
    mutate(weight = weight * pound2kg, weight = round(weight, 2)) %>%
    mutate(BMI = weight / height^2, BMI = round(BMI, 2)) %>%
    mutate(obese = cut(BMI, breaks = c(0, 29.9, 100), labels = c("No", "Yes"))) %>%
    mutate(diabetic = ifelse(glyhb > 7, "Yes", "No"), diabetic = factor(diabetic, levels = c("No", "Yes"))) %>%
    mutate(location = factor(location)) %>%
    mutate(frame = factor(frame)) %>%
    mutate(gender = factor(gender))

}

#
# Hence, I spent 20 minutes to get the data.
#
# Back to the question:
#
# > Going back to the diabetes data,
# > fit linear regression models using vector-matrix notations
# > to model BMI based on age [years] and waist [m] measurements.
get_data <- function() {
  # names(get_diabetes_data())
  get_diabetes_data() |> dplyr::select(BMI, age, waist) |> tidyr::drop_na()
}
testthat::expect_all_true(stringr::str_detect(names(get_data()), "BMI|age|waist"))
# Removed NAs, unsure why this was kept in
testthat::expect_true(all(is.na(get_data()) == FALSE))

# Hmm, it is a 3D model, hence this will fail:
#
# ggplot2::ggplot(
#   get_data(),
#   ggplot2::aes(x = age, y = waist, z = BMI)
# )
#
# Some googling and I find a way to plot in 3D
#
if ("I want" == "an interactive plot") {
  plotly::plot_ly(data = get_data(), x = ~age, y = ~waist, z = ~BMI, type = "scatter3d", mode = "markers")
}
if ("I want" == "an 3D plot") {
  remotes::install_github("AckerDWM/gg3D")
  theta <- 45
  phi <- 10

  ggplot2::ggplot(
    get_data() |> tidyr::drop_na(),
    ggplot2::aes(x = age, y = waist, z = BMI, color = BMI)
  ) +
    ggplot2::theme_void() +
    gg3D::axes_3D(theta = theta, phi = phi) +
    gg3D::stat_3D(theta = theta, phi = phi) +
    gg3D::labs_3D(
      theta = theta, phi = phi,
      labs = c("Age (years)", "Waist (cm)", "BMI")
    )
}

# 45 minutes in :-)


# > In particular, define design matrix X,
# > vector of observations Y
# > and vector of parameters beta
# > and use beta_hat = ((X^T * X) ^ -1) * (X ^ T) * Y
# > to find beta values estimates.
#
#
# > n <- length(plasma) # no. of observation
# > Y <- as.matrix(plasma, ncol=1)
# > X <- cbind(rep(1, length=n), weight)
# > X <- as.matrix(X)
#
# So, Y is the response variable, in our case BMI
#
# Good, I can calculate this:

#' Get Y, the vector of observations.
#' Observations are the response variables, in this case BMI
get_observations_vector <- function() {
  bmis <- get_data() |> dplyr::select(BMI) |> dplyr::pull()
  as.matrix(bmis, ncol = 1)
}
testthat::expect_equal(1, ncol(get_observations_vector()))
testthat::expect_equal(nrow(get_data()), nrow(get_observations_vector()))

# Checking https://en.wikipedia.org/wiki/Design_matrix I see that the
# design matrix will be three columns:
# - First column is all ones
# - Second column is the first independent variable, in this case, age
# - Third column is the second independent variable, in this case, waist

#' Get X, the design matrix
get_design_matrix <- function() {
  n_observations <- nrow(get_data())
  m <- matrix(NA, nrow = n_observations, ncol = 3)
  m[, 1] <- 1
  m[, 2] <- get_data() |> dplyr::select(age) |> dplyr::pull()
  m[, 3] <- get_data() |> dplyr::select(waist) |> dplyr::pull()
  m
}
testthat::expect_equal(3, ncol(get_design_matrix()))
testthat::expect_all_true(1 == get_design_matrix()[, 1])
testthat::expect_equal(nrow(get_data()), nrow(get_design_matrix()))

#
# > and vector of parameters beta
# > and use beta_hat = ((X^T * X) ^ -1) * (X ^ T) * Y
# > to find beta values estimates.

get_beta_values_estimates <- function() {
  x <- get_design_matrix()
  y <- get_observations_vector()
  # From examples:
  # > beta.hat <- solve(t(X)%*%X)%*%t(X)%*%Y
  # Converting this:
  beta_values_estimates <- solve(t(x) %*% x) %*% t(x) %*% y
  # Problem: only NAs.
  # Prediction: data has NAs
  # Experiment: removed NAs
  # Conclusion: yes, that was it
  beta_values_estimates
}
testthat::expect_equal(1, ncol(get_beta_values_estimates()))

# Why 3, for 2 independent variables?
# Aha, you get 2 beta value estimates for 1 independent variable,
# hence you expect n_independent_variables + 1
testthat::expect_equal(3, nrow(get_beta_values_estimates()))

# OK, I feel I did it! After 75 minutes

# >
# > Check your calculations by fitting the model using lm() function.
#
# I can search for vector-matrix notations
# and find
# https://nbisweden.github.io/workshop-mlbiostatistics/docs/SM4LS-book/SM4LS-lm/lm-intro.html#vector-matrix-notations
#
# ```r
# reg1 <- lm(plasma ~ weight)
# a <- reg1$coefficients[1]
# b <- reg1$coefficients[2]
# ```
#
# So, in this example, plasma is the dependent/response variable
# and weight is the independent variable. For me, that makes it:
fitted_model <- lm(data = get_data(), BMI ~ age + waist)
fitted_model

testthat::expect_equal(
  as.numeric(fitted_model$coefficients[1]),
  get_beta_values_estimates()[1, ]
)
testthat::expect_equal(
  as.numeric(fitted_model$coefficients[2]),
  get_beta_values_estimates()[2, ]
)
testthat::expect_equal(
  as.numeric(fitted_model$coefficients[3]),
  get_beta_values_estimates()[3, ]
)

# It seems I have checked my calculation :-)
# Back to the question...
# Ah, I am done.
# What have I done?
# I've been transforming data I guess ...
#
# Total time needed: 81 minutes

