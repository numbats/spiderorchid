#' Fetch publications from Google Scholar
#'
#' @description
#' Retrieves publications for given Google Scholar IDs,  and returns them as a tibble.

#' This function retrieves publications for a given Google Scholar ID and formats them into a structured tibble.
#'
#' @param scholar_id A character vector of Google Scholar IDs.
#'
#' @return A tibble containing all publications for the specified Google Scholar IDs.
#' @examples
#' fetch_scholar("vamErfkAAAAJ")
#' @export
fetch_scholar <- function(scholar_id) {
  if (length(scholar_id) == 0) {
    return(tibble::tibble(
      title = character(0),
      DOI = character(0),
      authors = character(0),
      publication_year = integer(0),
      journal_name = character(0)
    ))
  }

  all_pubs <- list()
  dest_folder <- tempdir()

  for (id in scholar_id) {
    # If we've already fetched this Scholar ID, just read it from file
    dest_file <- paste0(dest_folder, "/", id, ".rds")
    if (file.exists(dest_file)) {
      all_pubs[[id]] <- readRDS(dest_file)
    } else {
      publications <- scholar::get_publications(scholar_id)
      if (NROW(publications) == 0) {
        publications$doi <- character(0)
      } else {
        if (!"doi" %in% colnames(publications)) {
          publications$doi <- NA_character_
        }
        if (!"journal" %in% colnames(publications)) {
          publications$journal <- NA_character_
        }
        if (!"year" %in% colnames(publications)) {
          publications$year <- NA_integer_
        }
      }
      all_pubs[[id]] <- tibble::tibble(
        scholar_id = id,
        title = publications$title,
        DOI = publications$doi,
        authors = publications$author,
        publication_year = as.integer(publications$year),
        journal_name = publications$journal
      )
      saveRDS(all_pubs[[id]], dest_file)
    }
  }

  output <- dplyr::bind_rows(all_pubs)
  col_order <- intersect(
    c(
      "scholar_id",
      "authors",
      "title",
      "publication_year",
      "journal_name",
      "DOI"
    ),
    colnames(output)
  )
  output |>
    dplyr::select(col_order, dplyr::everything()) |>
    dplyr::arrange(scholar_id, publication_year, title, authors) |>
    tibble::as_tibble()
}
