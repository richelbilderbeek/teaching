#!/bin/env Rscript

# Minimal amount of measurements to be put in
min_n_measurements <- 4

#' Get the descriptions of the courses
get_descriptions <- function() {
  readr::read_csv("description.csv", show_col_types = FALSE)
}

testthat::expect_true(tibble::is_tibble(get_descriptions()))

#' Check all counts files exists
check_all_counts_files_exist <- function() {
  descriptions <- get_descriptions()
  for (date in descriptions$date) {
    filename <- paste0(date, "_counts.csv")
    if (!file.exists(filename)) {
      stop("File with name '", filename, "' does not exist")
    }
  }
}
check_all_counts_files_exist()

#' Check that all files have descriptions
check_all_count_have_a_description <- function() {
  descriptions <- get_descriptions()
  count_filenames <- list.files(pattern = "_counts")
  for (count_filename in count_filenames) {
    count_filename_date <- stringr::str_sub(count_filename, 1, 8)
    if (!count_filename_date %in% descriptions$date) {
      stop(
        paste0(
          "File '",
          count_filename,
          "' does not have a description. ",
          "Please add it to 'descriptions.csv'."
        )
      )
    }
  }
}
check_all_count_have_a_description()

#' Check that all files have the same col_names
check_dataset <- function() {
  descriptions <- get_descriptions()
  first_filename <- paste0(descriptions$date[1], "_counts.csv")
  testthat::expect_true(file.exists(first_filename))
  col_names <- names(readr::read_csv(first_filename, show_col_types = FALSE))
  for (date in descriptions$date) {
    filename <- paste0(date, "_counts.csv")
    testthat::expect_true(file.exists(filename))
    these_col_names <- names(readr::read_csv(paste0(date, "_counts.csv"), show_col_types = FALSE))
    testthat::expect_equal(col_names, these_col_names)
  }
}
check_dataset()

str_to_date <- function(s) {
  testthat::expect_equal(8, stringr::str_length(s))
  paste0(
    stringr::str_sub(s, 1, 4),
    "-",
    stringr::str_sub(s, 5, 6),
    "-",
    stringr::str_sub(s, 7, 8)
  )
}
testthat::expect_equal(str_to_date("12345679"), "1234-56-79")

get_f_time <- function(t, begin, end) {
  d_all <- difftime(end, begin, units = "mins")
  d_t <- difftime(t, begin, units = "mins")
  as.double(d_t) / as.double(d_all)
}

t <- readr::parse_time("9:00")
begin <- readr::parse_time("9:00")
end <- readr::parse_time("16:00")
testthat::expect_equal(0.0, get_f_time(t, begin, end))

is_lunch <- function(t) {
  testthat::expect_equal(class(t), class(readr::parse_time("12:00")))
  t >= readr::parse_time("12:00") & t < readr::parse_time("13:00")
}

testthat::expect_false(is_lunch(readr::parse_time("11:59")))
testthat::expect_true(is_lunch(readr::parse_time("12:00")))
testthat::expect_false(is_lunch(readr::parse_time("13:00")))

# Put all counts in one big table
get_counts_table <- function() {
  descriptions <- get_descriptions()
  tables <- list()
  for (i in seq_along(descriptions$date)) {
    date <- descriptions$date[i]

    t_start <- descriptions$t_start[i]
    t_end <- descriptions$t_end[i]
    filename <- paste0(date, "_counts.csv")
    testthat::expect_true(file.exists(filename))
    t <- readr::read_csv(filename, show_col_types = FALSE)
    if (nrow(t) < min_n_measurements) next
    t$f_time <- get_f_time(t$time, t_start, t_end)
    t$date <- as.Date(str_to_date(date))
    t$description <- descriptions$description[i]
    t$n_total <- t$n_cam_on + t$n_cam_off
    t$n_max <- max(t$n_total)
    t$f_total <- t$n_total / t$n_max
    t$f_on <- t$n_cam_on / t$n_max
    t$f_off <- t$n_cam_off / t$n_max
    t$most_have_cam_on <- mean(t$f_on) > 0.5
    t$t_start <- t_start
    t$t_end <- t_end
    tables[[i]] <- t
  }
  counts <- dplyr::bind_rows(tables)
  counts <- counts[counts$f_time >= 0.0 & counts$f_time <= 1.0, ]
  counts <- counts[!is_lunch(counts$time), ]
  counts$session <- "morning"
  counts$session[counts$f_time > 0.5] <- "afternoon"
  counts
}

testthat::expect_true(tibble::is_tibble(get_counts_table()))
t <-  get_counts_table()
names(t)
ggplot2::ggplot(data = t, ggplot2::aes(x = f_time)) +
  ggplot2::geom_histogram() +
  ggplot2::labs(
    caption = "All data"
  )



t_strict <- t |>
  dplyr::filter(t_start == readr::parse_time("9:00")) |>
  dplyr::filter(t_end == readr::parse_time("16:00"))

ggplot2::ggplot(
  t_strict,
  ggplot2::aes(x = time)) +
  ggplot2::geom_histogram(binwidth = 60 * 15) +
  ggplot2::scale_x_time("Time of the day") +
  ggplot2::scale_y_continuous("Number of observations") +
  ggplot2::labs(
    caption = "All data from exactly 9:00-16:00, bin width is 15 minutes"
  )
ggplot2::ggsave("n_observations_per_time.png", width = 7, height = 4)


# Plot all in one, color by lesson
counts <- t_strict

ggplot2::ggplot(counts, ggplot2::aes(x = time, y = f_total)) +
  ggplot2::geom_point() +
  ggplot2::geom_smooth(color = "black") +
  ggplot2::geom_line(
    data = counts,
    mapping = ggplot2::aes(x = time, y = f_total, color = description),
    inherit.aes = FALSE
  ) +
  ggplot2::geom_point(
    mapping = ggplot2::aes(x = time, y = f_total, color = description)
  ) +
  ggplot2::labs(
    title = "Fraction of learners present in time under lesson time",
    subtitle = "Per course",
    caption = paste0(
      "f_total = n_learners / max(learners_of_that_day)",
      "min_n_measurements: ", min_n_measurements,
      "\nTrendline is Loess smoothing of all data. ",
      "Some dips can be explained by breaks"
    )
  ) + ggplot2::theme(legend.position = "none")

ggplot2::ggsave("f_learners_per_f_time_per_course.png", width = 7, height = 4)



# Plot all in one, color by percentage using the camera
ggplot2::ggplot(counts, ggplot2::aes(x = time, y = f_total)) +
  ggplot2::geom_point() +
  ggplot2::geom_smooth(color = "black") +
  ggplot2::geom_point(
    data = counts,
    mapping = ggplot2::aes(x = time, y = f_total, color = f_on),
    inherit.aes = FALSE
  ) +
  ggplot2::labs(
    title = "Fraction of learners present in time under lesson time",
    subtitle = "For the fraction of learners that have the camera on",
    caption = paste0(
      "f_total = n_learners / max(learners_of_that_day)",
      "min_n_measurements: ", min_n_measurements,
      "\nTrendline is Loess smoothing of all data. ",
      "Some dips can be explained by breaks"
    )
  )

ggplot2::ggsave("f_learners_per_f_time_per_f_on.png", width = 7, height = 4)

# Determine if half has camera on
ggplot2::ggplot(counts, ggplot2::aes(x = time, y = f_total, color = most_have_cam_on)) +
  ggplot2::geom_point() +
  ggplot2::geom_smooth() +
  ggplot2::labs(
    title = "Fraction of learners present in time under lesson time",
    subtitle = "For if half of the learners have camera on",
    caption = paste0(
      "f_total = n_learners / max(learners_of_that_day)",
      "min_n_measurements: ", min_n_measurements,
      "\nTrendline is Loess smoothing of all data. ",
      "Some dips can be explained by breaks"
    )
  ) + ggplot2::scale_fill_continuous(guide = ggplot2::guide_legend()) +
    ggplot2::theme(legend.position = "bottom")

ggplot2::ggsave("f_learners_per_f_time_per_most_on.png", width = 7, height = 4)

#
# Assume 2 sessions, do split up
#

# Plot all in one, color by lesson
ggplot2::ggplot(counts, ggplot2::aes(x = time, y = f_total, fill = session)) +
  ggplot2::geom_point() +
  ggplot2::geom_smooth(color = "black") +
  ggplot2::geom_line(
    data = counts,
    mapping = ggplot2::aes(x = time, y = f_total, color = description),
    inherit.aes = FALSE
  ) +
  ggplot2::geom_point(
    mapping = ggplot2::aes(x = time, y = f_total, color = description)
  ) +
  ggplot2::labs(
    title = "Fraction of learners present in time under lesson time",
    subtitle = "Per course",
    caption = paste0(
      "f_total = n_learners / max(learners_of_that_day)",
      "min_n_measurements: ", min_n_measurements,
      "\nTrendline is Loess smoothing of all data. ",
      "Some dips can be explained by breaks"
    )
  )  + ggplot2::theme(legend.position = "none")

ggplot2::ggsave("f_learners_per_f_time_per_course_per_session.png", width = 7, height = 4)



# Plot all in one, color by percentage using the camera
ggplot2::ggplot(counts, ggplot2::aes(x = time, y = f_total, fill = session)) +
  ggplot2::geom_point() +
  ggplot2::geom_smooth(color = "black") +
  ggplot2::geom_point(
    data = counts,
    mapping = ggplot2::aes(x = time, y = f_total, color = f_on),
    inherit.aes = FALSE
  ) +
  ggplot2::labs(
    title = "Fraction of learners present in time under lesson time",
    subtitle = "For the fraction of learners that have the camera on",
    caption = paste0(
      "f_total = n_learners / max(learners_of_that_day)",
      "min_n_measurements: ", min_n_measurements,
      "\nTrendline is Loess smoothing of all data. ",
      "Some dips can be explained by breaks"
    )
  )

ggplot2::ggsave("f_learners_per_f_time_per_f_on_per_session.png", width = 7, height = 4)

# Determine if half has camera on
ggplot2::ggplot(counts, ggplot2::aes(x = time, y = f_total, color = most_have_cam_on, ... = session)) +
  ggplot2::geom_smooth() +
  ggplot2::geom_point() +
  ggplot2::labs(
    title = "Fraction of learners present in time under lesson time",
    subtitle = "For if half of the learners have camera on",
    caption = paste0(
      "f_total = n_learners / max(learners_of_that_day)",
      "min_n_measurements: ", min_n_measurements,
      "\nTrendline is Loess smoothing of all data. ",
      "Some dips can be explained by breaks"
    )
  ) +
  ggplot2::theme(legend.position = "bottom")

ggplot2::ggsave("f_learners_per_f_time_per_most_on_per_session.png", width = 7, height = 4)


names(counts)
counts_on <- counts |> dplyr::select(f_time, f_total, most_have_cam_on) |> dplyr::filter(most_have_cam_on == TRUE) |> dplyr::select(f_time, f_total)
counts_off <- counts |> dplyr::select(f_time, f_total, most_have_cam_on) |> dplyr::filter(most_have_cam_on == FALSE) |> dplyr::select(f_time, f_total)
m_on <- mgcv::gam(
  f_total ~  s(f_time),
  data = counts_on,
  method = "REML"
)
m_off <- mgcv::gam(
  f_total ~  s(f_time),
  data = counts_off,
  method = "REML"
)

names(t)
t_interpolation_on <- expand.grid(f_time = seq(0.0, 1.0, length = 1000))
t_interpolation_off <- expand.grid(f_time = seq(0.0, 1.0, length = 1000))

t_interpolation_on$f_total <- predict(m_on, newdata = t_interpolation_on)
t_interpolation_off$f_total <- predict(m_off, newdata = t_interpolation_off)
ggplot2::ggplot(t_interpolation_on, ggplot2::aes(x = f_time, y = f_total)) +
  ggplot2::geom_line()
ggplot2::ggplot(t_interpolation_off, ggplot2::aes(x = f_time, y = f_total)) +
  ggplot2::geom_line()



t_interpolation_diff <- t_interpolation_off
t_interpolation_diff$f_total <- t_interpolation_on$f_total - t_interpolation_diff$f_total
ggplot2::ggplot(t_interpolation_diff, ggplot2::aes(x = f_time, y = f_total)) +
  ggplot2::geom_line()


t_interpolation_on$type <- "On"
t_interpolation_off$type <- "Off"
t_interpolation_diff$type <- "Difference"

t_interpolation_on$time <- hms::hms(seq(readr::parse_time("9:00"), readr::parse_time("16:00"), length.out = nrow(t_interpolation_on)))
t_interpolation_off$time <- hms::hms(seq(readr::parse_time("9:00"), readr::parse_time("16:00"), length.out = nrow(t_interpolation_off)))
t_interpolation_diff$time <- hms::hms(seq(readr::parse_time("9:00"), readr::parse_time("16:00"), length.out = nrow(t_interpolation_diff)))


t <- dplyr::bind_rows(
  t_interpolation_on,
  t_interpolation_off,
  t_interpolation_diff
)

ggplot2::ggplot(
  t, ggplot2::aes(x = time, y = f_total, color = type)) +
  ggplot2::geom_line(size = 2) +
  ggplot2::labs(
  title = "Difference"
)


ggplot2::ggsave("f_diff_learners_per_f_time.png", width = 7, height = 4)
