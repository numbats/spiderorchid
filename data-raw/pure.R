library(dplyr)
library(stringr)

# Read downloaded json data from PURE
ebs_pure <- jsonlite::fromJSON(here::here("data-raw/ebs.json"))[[2]] |>
  spiderorchid:::clean_pure_json()
# Should be equivalent to the following
# ebs_pure <- fetch_pure(2018:2025)

# Check missing DOIs
ebs_pure |>
  filter(is.na(doi))

# Check missing authors
ebs_pure |>
  filter(is.na(authors))

# Save result
usethis::use_data(ebs_pure, overwrite = TRUE)
