# Exercises (regularization)
# https://nbisweden.github.io/workshop-mlbiostatistics/docs/SM4LS-book/SM4LS-lm/lm-coeff-exercises.html
#
# 270 - 15 - 15 = 240 minutes in.
#
# > Exercise 3 (Lowering blood pressure)
#
# > A clinical trial has been carried out to compare three drug treatments
# > which are intended to lower blood pressure in hypertensive patients.
# > The data contains initial values fo systolic blood pressure (bp) in mmHg
# > for each patient and the reduction achieved during the course of the trial.
# > For each patient, allocation to treatment (drug) was carried out
# > randomly and conditions such as the length of the treatment
# > and dose of the drug were standardized as far as possible.

get_data <- function() {
  # From https://github.com/NBISweden/workshop-mlbiostatistics/blob/master/SM4LS-lm/data/lm/bloodrug.csv
  t <- readr::read_csv("https://raw.githubusercontent.com/NBISweden/workshop-mlbiostatistics/refs/heads/master/SM4LS-lm/data/lm/bloodrug.csv", show_col_types = FALSE)
  t$drug <- factor(t$drug)
  t
}
names(get_data())
ggplot2::ggplot(get_data(), ggplot2::aes(x = drug, y = redn)) + ggplot2::geom_boxplot()

# > Use linear regression to answer questions:
#
# > a. is there an association between the reduction in blood pressure and initial blood pressure

fitted_model <- lm(redn ~ initial, data = get_data())
summary(fitted_model)

# Answer: yes, the chance the slop was sloped by chance is 0.00312, hence
# it is significantly sloped


# > b. is reduction in blood pressure different across the treatment (in three drug groups)?

fitted_model <- lm(redn ~ drug, data = get_data())
summary(fitted_model)

# Answer: no, neither works


# > c. is reduction in blood pressure different across the treatment when accounting for initial blood pressure?

fitted_model <- lm(redn ~ initial + drug, data = get_data())
summary(fitted_model)

# Answer: yes, drug 2 works

# > d. is reduction in blood pressure changing differently under different treatment?
# Hint: here we have three categories which can be seen as expanding
# the model with two categories by an additional one:
# one category will be treated as baseline

fitted_model <- lm(redn ~ initial * drug, data = get_data())
summary(fitted_model)

# Answer: no, interaction slopes are flat

# Huh? There is no answer?

# Total time: (6 * 45) + 15 - 15 - 15 = 255 minutes

