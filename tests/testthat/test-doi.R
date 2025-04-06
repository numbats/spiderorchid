# Tests for fetch_doi

test_that("fetch_doi returns a valid data frame", {
  # DOIs for two articles
  dois <- c("10.1016/j.ijforecast.2023.10.003", "10.1080/10618600.2020.1807353")
  result <- fetch_doi(dois)
  expect_s3_class(result, "data.frame")
  expect_true(all(c("title", "doi", "authors", "publication_year", "journal_name") %in% colnames(result)))
  expect_false(any(is.na(result$publication_year)))
  expect_true(nrow(result) > 0)
})
