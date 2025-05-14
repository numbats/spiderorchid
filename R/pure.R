#' Fetch publications from PURE
#'
#' To download data from PURE, it is necessary to have access to the
#' API via Simon Angus and the Astro team \url{https://astro.monash.edu/}.
#' The API key is stored in the environment variable `PURE_API_KEY`.
#' You can add it to your environment using \code{\link[usethis]{edit_r_environ}()}.
#' This is end-point restricted to Monash IP addresses. So either use it on campus
#' or invoke the VPN before using it off campus.
#'
#' Publications up to 2024 are available in the \code{\link{ebs_pure}} dataset.
#'
#' @param years A numeric vector of publication years.
#' @return A data frame containing the data fetched from the PURE API covering
#' the specified publication years.
#' @seealso \code{\link{ebs_pure}}
#' @export

fetch_pure <- function(years = 2025:2026) {
  # Check if the API key is set
  if (Sys.getenv("PURE_API_KEY") == "") {
    stop("Please set the PURE_API_KEY environment variable.")
  }

  # Define the API endpoint
  url <- "https://6wlo3eknv3.execute-api.ap-southeast-2.amazonaws.com/qat/predict/org-map/external"

  # Set the headers
  headers <- c(
    "x-api-key" = Sys.getenv("PURE_API_KEY"),
    "Content-Type" = "application/json"
  )
  data <- list(
    faculty_list = "Faculty of Business & Economics",
    department_list = "Econometrics & Business Statistics",
    year_start = 2018,
    year_end = 2025
  )

  # Make the GET request
  response <- httr::GET(url, httr::add_headers(.headers = headers))

  # Check for errors
  if (httr::http_error(response)) {
    stop("Failed to fetch data from PURE API.")
  }

  # Parse the response
  data <- httr::content(response, as = "parsed", type = "application/json")

  return(data)
}

# curl --location 'https://6wlo3eknv3.execute-api.ap-southeast-2.amazonaws.com/qat/predict/org-map/external' \
# --header 'x-api-key: ?????' \
# --header 'Content-Type: application/json' \
# --data '{
#     "faculty_list":["Faculty of Business & Economics"],
#     "department_list": ["Econometrics & Business Statistics"],
#     "year_start": 2018,
#     "year_end": 2025
# }'

# Clean PURE json file and return a tibble
clean_pure_json <- function(json_data) {
  ebs <- as_tibble(json_data) |>
    select(
      pure_id = output_id,
      year = output_year,
      subtype = output_subtype,
      title = output_title,
      journal = journal_title,
      bib = output_bibliographic_text_harvard
    ) |>
    mutate(
      pure_id = as.character(pure_id),
      doi = str_extract(bib, "doi.org/[0-9a-zA-Z._\\(\\)\\/\\-]*$") |>
        str_remove("doi.org/") |> str_trim(),
      authors = str_extract(bib, "^(.*?)(?=\\d)") |> str_trim()
    ) |>
    select(pure_id, year, authors, title, journal, subtype, bib, doi)

  # Add known missing DOIs
  ebs |>
    mutate(
      doi = if_else(pure_id == "617686492", "10.1016/j.jeconom.2022.08.006", doi)
    )
}
