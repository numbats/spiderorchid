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
#' @param years A numeric vector of publication years. All publications between
#' the minimum year and the maximum year are returned.
#' @return A data frame containing the data fetched from the PURE API covering
#' the specified publication years.
#' @seealso \code{\link{ebs_pure}}
#' @export

fetch_pure <- function(years) {
  # If we've already fetched this in the current session, just read it from file
  dest_folder <- tempdir()
  dest_file <- paste0(dest_folder, "/pure", paste(range(years),collapse="_"), ".rds")
  if (file.exists(dest_file)) {
    return(readRDS(dest_file))
  }

  # Check if the API key is set
  if (Sys.getenv("PURE_API_KEY") == "") {
    stop("Please set the PURE_API_KEY environment variable.")
  }

  # Prepare JSON payload
  payload <- list(
      faculty_list = list("Faculty of Business & Economics"),
      department_list = list("Econometrics & Business Statistics"),
      year_start = min(years),
      year_end = max(years)
  )

  # Make the API call
  response <- httr::POST(
    url = "https://zxtx3szp38.execute-api.ap-southeast-2.amazonaws.com/prod/predict/org-map/external",
    config = httr::add_headers(
      "x-api-key" = Sys.getenv("PURE_API_KEY"),
      "Content-Type" = "application/json"
    ),
    body =jsonlite::toJSON(payload, auto_unbox = TRUE),
    encode = "raw"
  )

  # Check if the request was successful
  if (httr::http_error(response)) {
    stop(
      sprintf(
        "API request failed [%s]: %s",
        httr::status_code(response),
        httr::http_status(response)$message
      )
    )
  }

  # Parse JSON response to R object
  result <- httr::content(response, "text")
  result <- jsonlite::fromJSON(result)
  result <- clean_pure_json(result[[2]])
  saveRDS(result, dest_file)
  return(result)
}


# Clean PURE json file and return a tibble
clean_pure_json <- function(json_data) {
  ebs <- dplyr::as_tibble(json_data) |>
    dplyr::select(
      pure_id = output_id,
      year = output_year,
      subtype = output_subtype,
      title = output_title,
      journal = journal_title,
      bib = output_bibliographic_text_harvard
    ) |>
    dplyr::mutate(
      pure_id = as.character(pure_id),
      doi = stringr::str_extract(bib, "doi.org/[0-9a-zA-Z._\\(\\)\\/\\-]*$") |>
        stringr::str_remove("doi.org/") |> stringr::str_trim(),
      authors = stringr::str_extract(bib, "^(.*?)(?=\\d)") |> stringr::str_trim()
    ) |>
    dplyr::select(pure_id, year, authors, title, journal, subtype, bib, doi)

  # Add known missing DOIs
  ebs |>
    dplyr::mutate(
      doi = dplyr::if_else(pure_id == "617686492", "10.1016/j.jeconom.2022.08.006", doi)
    )
}

utils::globalVariables(c(
  "output_id",
  "output_year",
  "output_subtype",
  "output_title",
  "journal_title",
  "output_bibliographic_text_harvard",
  "pure_id",
  "bib",
  "year",
  "subtype"
))
