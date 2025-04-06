test_that("fetch_orcid returns a valid data frame", {
  # ORCID IDs for Rob Hyndman and Michael Lydeamore
  orcid_ids <- c("0000-0002-2140-5352", "0000-0001-6515-827X")
  result <- fetch_orcid(orcid_ids)
  expect_s3_class(result, "data.frame")
  expect_true(all(c("title", "doi", "authors", "publication_year", "journal_name", "orcid_id") %in% colnames(result)))
  expect_false(any(is.na(result$publication_year)))
  expect_true(nrow(result) > 0)
})

test_that("fetch_orcid handles empty input", {
  orcid_ids <- character(0)
  result <- fetch_orcid(orcid_ids)
  expect_s3_class(result, "data.frame")
  expect_equal(nrow(result), 0)
})

test_that("fetch_orcid works even when certain columns don't exist", {
  result <- fetch_orcid("0000-0001-9379-0010")
  expect_true(nrow(result) > 0)
  expect_true(all(c("title", "doi", "authors", "publication_year", "journal_name", "orcid_id") %in% colnames(result)))
})

test_that("fetch_orcid returns empty data frame for ORCID with no works", {
  orcid_ids <- c("0009-0008-4231-8291")
  result <- fetch_orcid(orcid_ids)
  expect_s3_class(result, "data.frame")
  expect_equal(nrow(result), 0)
})

test_that("fetch_orcid returns empty data frame for invalid ORCID IDs", {
  orcid_ids <- c("0000-0000-0000-0000")
  expect_error(fetch_orcid(orcid_ids), "Invalid ORCID ID")
})
