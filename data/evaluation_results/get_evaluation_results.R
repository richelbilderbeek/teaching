library(rvest)
library(xml2)

#' Collect URLs to evaluations from a teaching overview webpage
#'
#' Scrapes the provided webpage, extracts all anchor tags, filters for those
#' pointing to or describing an evaluation, and resolves relative paths to absolute URLs.
#'
#' @param url Character string with the webpage URL. Defaults to Richel Bilderbeek's teaching overview.
#'
#' @return A character vector of unique, absolute URLs to evaluations.
#' @export
collect_evaluation_urls <- function(url = "https://richelbilderbeek.github.io/teaching/teaching_overview/") {
  # 1. Read and parse the webpage HTML
  page <- rvest::read_html(url)

  # 2. Extract all anchor elements
  anchors <- rvest::html_elements(page, "a")

  # 3. Retrieve link targets and visible display text
  hrefs <- rvest::html_attr(anchors, "href")
  texts <- rvest::html_text2(anchors)

  # 4. Filter for links indicating an evaluation in text or href
  is_evaluation <- grepl("evaluat", texts, ignore.case = TRUE) |
                   grepl("evaluat", hrefs, ignore.case = TRUE)

  eval_hrefs <- hrefs[is_evaluation]

  # Clean out missing or empty links
  eval_hrefs <- eval_hrefs[!is.na(eval_hrefs) & nzchar(eval_hrefs)]

  # 5. Convert relative links to absolute URLs
  absolute_urls <- xml2::url_absolute(eval_hrefs, base = url)

  # Return deduplicated URLs
  unique(absolute_urls)
}

readr::write_lines(
  collect_evaluation_urls(),
  "evaluation_urls.txt"
)
