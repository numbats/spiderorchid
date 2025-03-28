#' Fetch article information given a DOI
#'
#' @description
#' Retrieves publications for a given list of DOIs using the CrossRef API.
#'
#' @param doi A character vector of DOIs.
#'
#' @return A tibble containing the article information.
#' @examples
#' \dontrun{
#' fetch_doi("10.1016/j.ijforecast.2023.10.010")
#' }
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
      article <- rcrossref::cr_works(doi = id)
      article <- article$data[
        colnames(article$data) %in%
          c(
            "title",
            "author",
            "issued",
            "container.title",
            "volume",
            "issue"
          )
      ]
      if (suppressWarnings(!is.null(article$author[[1]]$given))) {
        article$authors <- paste(
          article$author[[1]]$given,
          article$author[[1]]$family,
          collapse = "; "
        )
      } else {
        article$authors <- NA
      }
      cn <- colnames(article)
      if ("container.title" %in% cn) {
        colnames(article)[
          colnames(article) == "container.title"
        ] <- "journal_name"
      }
      if ("issued" %in% cn) {
        colnames(article)[colnames(article) == "issued"] <- "publication_year"
        article$publication_year <- as.numeric(
          substr(article$publication_year, 1, 4)
        )
      }
      article$DOI = id
      article$author <- NULL
      all_pubs[[id]] <- article
      saveRDS(all_pubs[[id]], dest_file)
    }
  }

  output <- dplyr::bind_rows(all_pubs)
  # Order columns
  col_order <- intersect(
    c(
      "DOI",
      "authors",
      "publication_year",
      "title",
      "journal_name",
      "volume",
      "issue"
    ),
    colnames(output)
  )
  output |>
    dplyr::select(col_order, dplyr::everything()) |>
    tibble::as_tibble()
}
