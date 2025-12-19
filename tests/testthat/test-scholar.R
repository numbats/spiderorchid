# Unit tests for fetch_scholar

test_that("fetch_scholar returns publications for Scholar ID", {
  result <- fetch_scholar("vamErfkAAAAJ")
  expect_s3_class(result, "tbl_df")
  required_cols <- c("title", "authors", "year", "journal")
  expect_true(all(required_cols %in% colnames(result)))
  expect_true(all(!is.null(result$title)))
  expect_gt(nrow(result), 0)
})

test_that("fetch_scholar returns empty dataframe for empty Scholar ID", {
  result <- fetch_scholar(character(0))
  expect_s3_class(result, "tbl_df")
  expect_equal(nrow(result), 0)
})

test_that("fetch_scholar with incorrect Scholar ID", {
  result <- fetch_scholar("TEST")
  expect_s3_class(result, "tbl_df")
  expect_equal(nrow(result), 0)
})
