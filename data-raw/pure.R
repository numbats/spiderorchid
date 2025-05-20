library(dplyr)

# Read downloaded json data from PURE
#ebs_pure <- jsonlite::fromJSON(here::here("data-raw/ebs.json"))[[2]] |>
#  spiderorchid:::clean_pure_json()

# Update existing ebs_pure data
new_ebs_pure <- fetch_pure(2025)
ebs_pure <- ebs_pure |>
  filter(year < 2025) |>
  bind_rows(new_ebs_pure)

# Check missing DOIs
ebs_pure |>
  filter(is.na(doi))

# Check missing authors
ebs_pure |>
  filter(is.na(authors))

# Save result
usethis::use_data(ebs_pure, overwrite = TRUE)
