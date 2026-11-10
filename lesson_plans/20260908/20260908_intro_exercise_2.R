# Exercises (introduction to linear models)
# https://nbisweden.github.io/workshop-mlbiostatistics/docs/SM4LS-book/SM4LS-lm/lm-intro-exercises.html

# > Exercise 2 (Hypothesis testing)
# Your colleague Anna is interested in association between
# BMI and cholesterol, both total cholesterol (chol)
# and high density lipoprotein fraction (hdl).
# She has correctly fitted linear model using lm()
# function but her computer broke and she only has the below output:
# >
# >   # Coefficients:
# >   #               Estimate Std. Error t value Pr(>|t|)
# >   # (Intercept)  3.471e+01  2.940e+00  11.808  < 2e-16 ***
# >   # chol         1.965e-05  1.231e-02
# >   # hdl         -9.371e-02  3.220e-02
# >
# > Can you help Anna finding out whether chol and hdl
# > are significantly associated with BMI?
# > What are the t-value statistics and the corresponding p-values?
# > Calculate these values without fitting the model
# > and then fit the model to double check your calculations.

# First, let's get the data


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

get_data <- function() {
  # > Your colleague Anna is interested in association between
  # > BMI and cholesterol, both total cholesterol (chol)
  # > and high density lipoprotein fraction (hdl).
  # names(get_diabetes_data())
  get_diabetes_data() |> dplyr::select(BMI, chol, hdl) |> tidyr::drop_na()
}
testthat::expect_all_true(stringr::str_detect(names(get_data()), "BMI|chol|hdl"))
# Removed NAs, unsure why this was kept in
testthat::expect_true(all(is.na(get_data()) == FALSE))

# > Can you help Anna finding out whether chol and hdl
# > are significantly associated with BMI?
#
# Sure, just do a fit to get the beta
fitted_model <- lm(data = get_data(), BMI ~ chol + hdl)
coefficient_names <- names(fitted_model$coefficients)
chol_index <- which(coefficient_names == "chol")
hdl_index <- which(coefficient_names == "hdl")
estimated_beta_for_chol <- as.numeric(fitted_model$coefficients[chol_index])
estimated_beta_for_hdl <- as.numeric(fitted_model$coefficients[hdl_index])
testthat::expect_equal(estimated_beta_for_chol, 0.01954617)
options(digits = 8)
testthat::expect_equal(estimated_beta_for_hdl, -0.10040587)

# Now, to determine if it is significantly associated with BMI
#
# I have no idea why it was important to know that Anna's
# computer broke down ...?
#
# I do that more info is in the fitted model:

summary(fitted_model)

# Blimey, that already gives p values, no, t values,
# as well as the chance of a false positive:
#
# Estimate Std. Error t value  Pr(>|t|)
# (Intercept) 29.6112115  1.6663512 17.7701 < 2.2e-16 ***
#   chol         0.0195462  0.0072869  2.6824  0.007619 **
#   hdl         -0.1004059  0.0185859 -5.4023 1.143e-07 ***
tidy_fitted_model <- broom::tidy(fitted_model)
chol_index <- which(tidy_fitted_model$term == "chol")
hdl_index <- which(tidy_fitted_model$term == "hdl")
chol_t_value <- tidy_fitted_model$statistic[chol_index]
hdl_t_value <- tidy_fitted_model$statistic[hdl_index]
chol_p_value <- tidy_fitted_model$p.value[chol_index]
hdl_p_value <- tidy_fitted_model$p.value[hdl_index]

# As both p values are below 0.05, we can assume ...
# ... that there is, or is not a relation ...
# Well, we do see that the intercept has a value/slope of 29
# and is deemed super significant, hence, it is deemed
# super significant to deviate from being horizontal.
# Hence, both other values are significantly
# deviating from being horizontal
#
# My answer is wrong.
#
# I just learnt that using lm and getting those matrices
# myself is equivalent, now I cannot use lm in this case ..?
#
# Aha, 'pt' is getting the t distribution.
pt_with_df_1 <- function(q) { pt(q = q, df = 1) }
plot(pt_with_df_1)
pt_with_df_2 <- function(q) { pt(q = q, df = 2) }
plot(pt_with_df_2, add = TRUE)

# Aha, later in the answer, they do the exact same thing as me
# Maybe I need to use all data..?
fitted_model_on_all_data <- lm(data = get_diabetes_data(), BMI ~ chol + hdl)
summary(fitted_model_on_all_data)
fitted_model <- lm(data = get_data(), BMI ~ chol + hdl)
summary(fitted_model)
# I did not expect a difference, and there was none.
# My hypothesis is that the answers
# are generated from different data ...?
#
# I am going to run their code now ...
#
# I have trouble rendering these Quarto pages
#
# I am 135 minutes in.
# I am now 155 in (minus 20 mins reflection)
#
# I assume I did the right thing and will move on to the next
# exercise
