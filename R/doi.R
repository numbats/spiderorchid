#' Fetch article information given a DOI
#'
#' @description
#' Retrieves publications for a given list of DOIs using the DOI API and formats
#' them into a structured tibble.
#'
#' @param doi A character vector of DOIs.
#'
#' @return A tibble containing the article information.
#' @examples
#' fetch_doi("10.1016/j.ijforecast.2023.10.010")
#' @export

fetch_doi <- function(doi) {
  all_pubs <- list()
  dest_folder <- tempdir()

  for (id in doi) {
    # If we've already fetched this DOI, just read it from file
    doi_clean <- gsub("/", "_", id)
    dest_file <- paste0(dest_folder, "/", doi_clean, ".rds")
    if (file.exists(dest_file)) {
      all_pubs[[id]] <- readRDS(dest_file)
    } else {
      # Fetch the article
      res <- httr::GET(
        paste0("dx.doi.org/", id),
        httr::accept("application/json")
      )
      a <- httr::content(res, as = "text", encoding = "UTF-8") |>
        jsonlite::fromJSON()
      all_pubs[[id]] <- data.frame(
        doi = id,
        authors = NA_character_,
        title = NA_character_,
        year = NA_integer_,
        journal = NA_character_,
        volume = NA_character_,
        issue = NA_character_,
        page = NA_character_
      )
      if (!is.null(a[["author"]])) {
        all_pubs[[id]]$authors = paste(
          a$author$given,
          a$author$family,
          collapse = "; "
        ) |>
          trimws(whitespace = "[\\h\\v]")
      }
      if (!is.null(a$published)) {
        all_pubs[[id]]$year = as.integer(a$published$`date-parts`[1,1])
      }
      if (!is.null(a$title)) {
        all_pubs[[id]]$title = a$title
      }
      if (!is.null(a$`container-title`) & !is.list(a$`container-title`)) {
        all_pubs[[id]]$journal = a$`container-title`
      }
      if (!is.null(a$volume)) {
        all_pubs[[id]]$volume = a$volume
      }
      if (!is.null(a$issue)) {
        all_pubs[[id]]$issue =  paste(unlist(a$issue), collapse="-")
      }
      if (!is.null(a$page)) {
        all_pubs[[id]]$page = a$page
      }
      saveRDS(all_pubs[[id]], dest_file)
    }
  }
  # Combine all data frames into one
  output <- dplyr::bind_rows(all_pubs)
  # Order columns
  col_order <- intersect(
    c(
      "doi",
      "authors",
      "year",
      "title",
      "journal",
      "volume",
      "issue"
    ),
    colnames(output)
  )
  output |>
    dplyr::select(dplyr::all_of(col_order), dplyr::everything()) |>
    tibble::as_tibble()
}
