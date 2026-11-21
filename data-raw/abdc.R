library(readxl)
library(here)
library(dplyr)

# data downloaded from https://abdc.edu.au/abdc-journal-quality-list/
abdc <- here("data-raw", "ABDC-JQL-2025-v1-260326.xlsx") |>
  read_xlsx(skip = 7, .name_repair = janitor::make_clean_names) |>
  rename(
    title = journal_title,
    field_of_research = fo_r,
    rank = x2025_rating
  ) |>
  mutate(
    rank = factor(rank, levels = c("A*", "A", "B", "C"), ordered = TRUE),
    field_of_research = as.character(field_of_research)
  ) |>
  arrange(rank, title)

# save into rcademy
usethis::use_data(abdc, overwrite = TRUE)

# Remind to keep the Shiny app's "About the rankings" tab in step with the data
cli::cli_alert_warning(
  "Update the {.val Last updated} date (and any year in the text) on the {.strong ABDC} card in {.file shinyapp/app.R}."
)
