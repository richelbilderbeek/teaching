# Exercises (regularization)
# https://nbisweden.github.io/workshop-mlbiostatistics/docs/SM4LS-book/SM4LS-lm/lm-lasso-exercises.html#load-data-reformat-data
#
# 210 minutes in.



# load libraries
library(tidyverse)
library(glmnet)
library(caret)
library(splitTools)

# > import raw data
# > input_diabetes <- read_csv("data/data-diabetes.csv")

get_data <- function() {
  read_csv("https://raw.githubusercontent.com/NBISweden/workshop-mlbiostatistics/refs/heads/master/SM4LS-lm/data/data-diabetes.csv", show_col_types = FALSE)
}

# preview data
glimpse(get_data())

# Aha, this exercise has no question.
# I glimpsed over it. Done!

