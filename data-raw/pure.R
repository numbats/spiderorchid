library(dplyr)

# Read downloaded json data from PURE
#ebs_pure <- jsonlite::fromJSON(here::here("data-raw/ebs.json"))[[2]] |>
#  spiderorchid:::clean_pure_json()

# Refresh ebs_pure data
ebs_pure <- fetch_pure(2018:as.numeric(format(Sys.Date(), "%Y")))

# Check missing DOIs
ebs_pure |>
  filter(is.na(doi))

# Check missing authors
ebs_pure |>
  filter(is.na(authors))

# Save result
usethis::use_data(ebs_pure, overwrite = TRUE)
