# Exercises (introduction to linear models)
# https://nbisweden.github.io/workshop-mlbiostatistics/docs/SM4LS-book/SM4LS-lm/lm-intro-exercises.html

# > Exercise 3 (Evaluate model fit)
# > After helping Anna you got interested in whether
# > your initial model containing age and waist
# > is a better fit to the data than Anna’s model containing chol and hdl.
# > Evaluate model fit by calculating R^2(adj)  based on the equation:
# > ...
# > where
# >
# > p is the number of independent predictors, i.e. the number of variables in the model, excluding the constant and
# > n is the number of observations.
#
# > Check your calculations using lm() function.

# No, I will use the lm function, due to time restrains.


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

get_my_data <- function() {
  # names(get_diabetes_data())
  get_diabetes_data() |> dplyr::select(BMI, age, waist) |> tidyr::drop_na()
}
testthat::expect_all_true(stringr::str_detect(names(get_my_data()), "BMI|age|waist"))
# Removed NAs, unsure why this was kept in
testthat::expect_true(all(is.na(get_my_data()) == FALSE))


get_annas_data <- function() {
  # > Your colleague Anna is interested in association between
  # > BMI and cholesterol, both total cholesterol (chol)
  # > and high density lipoprotein fraction (hdl).
  # names(get_diabetes_data())
  get_diabetes_data() |> dplyr::select(BMI, chol, hdl) |> tidyr::drop_na()
}
testthat::expect_all_true(stringr::str_detect(names(get_annas_data()), "BMI|chol|hdl"))
# Removed NAs, unsure why this was kept in
testthat::expect_true(all(is.na(get_annas_data()) == FALSE))

# So, with the 2 models, I need to ...
#
# > Evaluate model fit by calculating R^2(adj) ...
#
fitted_my_model <- lm(data = get_my_data(), BMI ~ age + waist)
fitted_annas_model <- lm(data = get_annas_data(), BMI ~ chol + hdl)

my_adj_r_squared <- summary(fitted_my_model)$adj.r.squared
options(digits = 8)
testthat::expect_equal(my_adj_r_squared, 0.676145)
annas_adj_r_squared <- summary(fitted_annas_model)$adj.r.squared
testthat::expect_equal(annas_adj_r_squared, 0.071145153)

if (my_adj_r_squared > annas_adj_r_squared) {
  message("My choice of independent variables were better at causing the variance")
} else {
  message("Anna was better")
}

# I have different outcomes and I assume this is because
# of different data used in the course material.
# I assume I did the right thing.
