# Unit tests for fetch_cran
test_that("fetch_cran returns a dataframe for valid authors", {
  cran_authors <- c("Lydeamore", "Hyndman")
  result <- fetch_cran(cran_authors)
  expect_s3_class(result, "tbl_df")
  expect_true(all(c("package", "downloads", "authors", "date") %in% colnames(result)))
  years <- format(as.Date(result$date), "%Y")
  expect_true(all(!is.na(years)))
  expect_gt(nrow(result), 0)
})

test_that("fetch_cran returns empty dataframe for unknown authors", {
  result <- fetch_cran("Harvey Spector")
  expect_s3_class(result, "tbl_df")
  expect_equal(nrow(result), 0)
})

test_that("fetch_cran returns distinct rows", {
  result <- fetch_cran(c("Lydeamore", "Michael Lydeamore"))
  expect_s3_class(result, "tbl_df")
  expect_true(nrow(result) == nrow(dplyr::distinct(result)))
})

test_that("fetch_cran returns an empty dataframe if no authors are provided", {
  result <- fetch_cran(character(0))
  expect_s3_class(result, "tbl_df")
  expect_equal(nrow(result), 0)
})
