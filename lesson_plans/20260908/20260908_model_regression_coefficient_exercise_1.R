# Exercises (regularization)
# https://nbisweden.github.io/workshop-mlbiostatistics/docs/SM4LS-book/SM4LS-lm/lm-coeff-exercises.html
#
# 255 - 15 - 15 = 225 minutes in.

# > Exercise 1 (Height-weight-gender)
# >
# > repeat fitting the models with a) gender,
# > b) weight and gender and
# > c) interaction between weight and gender

get_data <- function() {
  # From https://github.com/NBISweden/workshop-mlbiostatistics/blob/master/SM4LS-lm/data/lm/heights_weights_genders.csv
  readr::read_csv("https://raw.githubusercontent.com/NBISweden/workshop-mlbiostatistics/refs/heads/master/SM4LS-lm/data/lm/heights_weights_genders.csv", show_col_types = FALSE)
}


t <- get_data()
# Aha, we need to predict the height
fitted_model_on_gender <- lm(data = get_data(), Height ~ Gender)
fitted_model_on_weight_and_gender <- lm(data = get_data(), Height ~ Weight + Gender)
fitted_model_on_weight_and_gender_and_interaction <- lm(data = get_data(), Height ~ Weight * Gender)


# > given the model with the interaction term,
# > what is expected height of a man and a women given a weight of 120 lbs?
# >   can you use predict() function to check your calculations?
# >
to_predict <- data.frame(Weight = 120, Gender = c("Male", "Female"))

male_height_1 <- predict(fitted_model_on_gender, to_predict)[1]
female_height_1 <- predict(fitted_model_on_gender, to_predict)[2]

male_height_2 <- predict(fitted_model_on_weight_and_gender, to_predict)[1]
female_height_2 <- predict(fitted_model_on_weight_and_gender, to_predict)[2]

male_height_3 <- predict(fitted_model_on_weight_and_gender_and_interaction, to_predict)[1]
female_height_3 <- predict(fitted_model_on_weight_and_gender_and_interaction, to_predict)[2]
