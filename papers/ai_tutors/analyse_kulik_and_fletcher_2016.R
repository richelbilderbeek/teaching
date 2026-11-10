t <- readr::read_csv("kulik_and_fletcher_2016_table_2.csv")

ggplot2::ggplot(
  t, ggplot2::aes(x = ES)
) + ggplot2::geom_histogram(binwidth = 0.1) +
  ggplot2::scale_x_continuous(minor_breaks = seq(-1.0, 4.0, by = 0.1)) +
  ggplot2::labs(
    title = "Effect sizes",
    caption = "From Kulik and Fletcher 2016, table 2"
  )
ggplot2::ggsave("analyse_kulik_and_fletcher_2016_table_2.svg")
