#' Fetch publications from ORCID
#'
#' @description
#' Retrieves publications for given ORCID IDs, and returns them as a tibble.
#'
#' @details
#' Before this function can be used, you need to authenticate with the ORCID API.
#' Follow the instructions at <https://github.com/ropensci-archive/rorcid/blob/master/README-not.md#authentication>.
#' We have found that the second option (a 2-legged OAuth) is necessary. Then store the token obtained
#' from `orcid_auth()` in your `.Renviron` file by running `usethis::edit_r_environ()`.
#' It should be of the form `ORCID_TOKEN=<your token>`.
#'
#' @param orcid_ids A character vector of ORCID IDs.
#'
#' @return A tibble containing all publications for the specified ORCID IDs.
#'
#' @examples
#' \dontrun{
#' fetch_orcid(c("0000-0003-2531-9408", "0000-0001-5738-1471"))
#' }
#'
#' @rdname get_publications
#' @export

fetch_orcid <- function(orcid_ids) {
  orcid_ids <- as.vector(orcid_ids)
  if (length(orcid_ids) == 0) {
    return(tibble::tibble(
      orcid_id = character(0),
      authors = character(0),
      title = character(0),
      publication_year = integer(0),
      journal_name = character(0),
      DOI = character(0)
    ))
  }
  all_pubs <- list()
  dest_folder <- tempdir()

  for (orcid_id in orcid_ids) {
    # If we've already fetched this ORCID ID, just read it from file
    dest_file <- paste0(dest_folder, "/", orcid_id, ".rds")
    if (file.exists(dest_file)) {
      all_pubs[[orcid_id]] <- readRDS(dest_file)
    } else {
      # Read it from ORCID
      pubs <- tryCatch(
        rorcid::orcid_works(orcid_id),
        error = function(e) {
          if (inherits(e, "http_404")) {
            stop(sprintf("Invalid ORCID ID: %s", orcid_id))
          } else {
            print(e)
          }
        }
      )
      if (!is.null(pubs[[1]]$works) && nrow(pubs[[1]]$works) > 0) {
        ids <- pubs[[1]]$works$`external-ids.external-id`
        dois <- purrr::map_chr(ids, function(x) {
          if (length(x) == 0L) {
            return(NA)
          }
          doi <- dplyr::filter(x, `external-id-type` == "doi") |>
            dplyr::pull(`external-id-value`)
          if (length(doi) == 0L) {
            return(NA)
          } else {
            return(doi[1])
          }
        })
        all_pubs[[orcid_id]] <- fetch_doi(stats::na.omit(unique(dois))) |>
          dplyr::mutate(orcid_id = orcid_id)
        saveRDS(all_pubs[[orcid_id]], dest_file)
      } else {
        saveRDS(NULL, dest_file)
      }
    }
  }

  output <- dplyr::bind_rows(all_pubs)
  col_order <- intersect(
    c(
      "orcid_id",
      "authors",
      "publication_year",
      "title",
      "journal_name",
      "volume",
      "issue",
      "DOI"
    ),
    colnames(output)
  )
  output |>
    dplyr::select(col_order, dplyr::everything()) |>
    dplyr::arrange(orcid_id, publication_year, title, authors) |>
    tibble::as_tibble()
}
