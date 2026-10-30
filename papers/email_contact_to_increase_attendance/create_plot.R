library(tidyverse)
t <- read_csv("data.csv")
t$f <- t$n_participants / t$n_registrations
ggplot(t, aes(x = strategy, y = f)) +
  geom_boxplot() +
  geom_point(color = "blue") +
  scale_y_continuous("Participation rate", limits = c(0, NA), labels = scales::percent)
ggsave("participation_rates.svg")
