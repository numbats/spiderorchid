# Tests for fetch_doi

test_that("fetch_doi returns a valid data frame", {
  # DOIs for two articles
  dois <- c("10.1016/j.ijforecast.2023.10.003", "10.1080/10618600.2020.1807353")
  result <- fetch_doi(dois)
  expect_s3_class(result, "data.frame")
  expect_true(all(
    c("title", "doi", "authors", "year", "journal") %in% colnames(result)
  ))
  expect_false(any(is.na(result$year)))
  expect_true(nrow(result) > 0)
})

test_that("fetch_doi returns NAs for unresolvable DOIs", {
  dois <- c("10.1007/978-3-642-00464-3-35", "10.1080/10618600.2020.1807353")
  result <- fetch_doi(dois)
  expect_equal(result$doi, dois)
  expect_true(is.na(result$title[1]))
  expect_false(is.na(result$title[2]))
})
