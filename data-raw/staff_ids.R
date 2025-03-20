# Reading the data
staff_ids <- readr::read_csv("data-raw/staff_ids.csv") |>
  dplyr::rename(scholar_id = gsuser_id)
# Document the data
usethis::use_data(staff_ids, overwrite = TRUE)
