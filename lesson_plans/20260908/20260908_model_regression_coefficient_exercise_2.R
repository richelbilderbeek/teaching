# Exercises (regularization)
# https://nbisweden.github.io/workshop-mlbiostatistics/docs/SM4LS-book/SM4LS-lm/lm-coeff-exercises.html
#
# 255 - 15 - 15 = 225 minutes in.
#
# > Exercise 2 (Trout)
# > When the behavior of a group of trout is studied,
# > some fish are observed to become dominant and others to become subordinate.
# > Dominant fish have freedom of movement whereas
# > subordinate fish tend to congregate in the periphery of the waterway
# > to avoid crossing the path of the dominant fish.
# > Data on energy expenditure and ration of blood obtained were collected

# What is ration??? I feel it is something good, like 'the caloric
# value free-floating in all blood'

# > as part of a laboratory experiment for 20 trout.
# > Energy and ration is measured in calories per kilo-calorie per trout per day.

# Use the below code to load the data to R and use linear regression models to answer:
#
# a) is there a relationship between ration obtained and energy expenditure
# b) is the relationship between ration obtained and energy expenditure different for each type of fish?

get_data <- function() {
  # From https://github.com/NBISweden/workshop-mlbiostatistics/blob/master/SM4LS-lm/data/lm/trout.csv
  t <- readr::read_csv("https://raw.githubusercontent.com/NBISweden/workshop-mlbiostatistics/refs/heads/master/SM4LS-lm/data/lm/trout.csv", show_col_types = FALSE)
  t$Group <- factor(t$Group, labels = c("Dominant", "Subordinate"))
  t
}


names(get_data())
fitted_model_all <- lm(Ration ~ Energy, data = get_data())
fitted_model_dom <- lm(Ration ~ Energy, data = get_data() |> dplyr::filter(Group == "Dominant"))
fitted_model_sub <- lm(Ration ~ Energy, data = get_data() |> dplyr::filter(Group == "Subordinate"))
fitted_model_per_group <- lm(Ration ~ Energy + Group, data = get_data())
summary(fitted_model_all)
summary(fitted_model_dom)
summary(fitted_model_sub)
summary(fitted_model_per_group)

# I skip, as I have no idea what ration is...
