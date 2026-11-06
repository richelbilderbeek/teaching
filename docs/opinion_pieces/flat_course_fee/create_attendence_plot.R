get_data <- function() {
  readr::read_csv(file = "attendance_rates.csv", show_col_types = FALSE)
}

get_tidy_data <- function() {
  t <- get_data() |>
    tidyr::pivot_longer(cols = starts_with("n_"), names_to = "type", values_to = "n")
  t$type <- stringr::str_remove(t$type, "n_")
  t
}

create_amounts_plot <- function() {
  ggplot2::ggplot(
    get_tidy_data(),
    ggplot2::aes(x = date, y = n, color = type)
  ) + ggplot2::geom_point() +
  ggplot2::scale_y_continuous("Amount")
}

get_percentages <- function() {
  t <- get_data()
  t$percentage <- t$n_participants / t$n_registrations
  t

}

create_percentages_plot <- function() {
  ggplot2::ggplot(
    get_percentages(),
    ggplot2::aes(x = date, y = percentage)
  ) + ggplot2::geom_point() +
    ggplot2::scale_y_continuous("Attendance", labels = scales::percent)
}


p1 <- create_amounts_plot()
p2 <- create_percentages_plot()

library(patchwork)
p1 / p2
ggplot2::ggsave("attendance.png", width = 7, height = 7)

