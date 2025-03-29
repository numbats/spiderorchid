#' Fetch packages from CRAN
#'
#' @description
#' This function searches for CRAN packages by author names. Note that some authors
#' may use different name variations on CRAN (e.g., "Di Cook" and "Dianne Cook"),
#' so it may be necessary to call the function
#' with several variations.
#'
#' @param author_names A character vector containing the authors' names in the form used on CRAN.
#' @param downloads_from A date or character string in the format "YYYY-MM-DD" specifying the date
#' from which to start counting downloads. Default is "2000-01-01".
#' @param downloads_to A date or character string in the format "YYYY-MM-DD" specifying the last date
#' for counting downloads. Default is current date.
#'
#' @return A data frame returning meta data about a package including total downloads
#' between `downloads_from` and `downloads_to`.
#'
#' @importFrom tibble tibble
#' @importFrom dplyr bind_rows filter
#' @importFrom stringr str_detect
#'
#' @examples
#' cran2024 <- fetch_cran(
#'    author_names = c("Michael Lydeamore", "Di Cook", "Dianne Cook", "Hyndman"),
#'    downloads_from = "2024-01-01",
#'    downloads_to = "2024-12-31"
#' )
#' @export

fetch_cran <- function(
  author_names,
  downloads_from = "2000-01-01",
  downloads_to = Sys.Date()
) {
  purrr::map_dfr(author_names, fetch_cran_author, start = downloads_from, end = downloads_to) |>
    dplyr::distinct()
}

fetch_cran_author <- function(author_name, start, end) {
  # If we've already fetched this author/start/end combination, just read it from file
  dest_folder <- tempdir()
  dest_file <- paste0(dest_folder, "/", author_name, "_", start, "_", end, ".rds")
  if (file.exists(dest_file)) {
    return(readRDS(dest_file))
  } else {
    # Otherwise grab the data from CRAN and store it
    results <- try(
      pkgmeta::get_meta(
        cran_author = author_name,
        include_downloads = TRUE,
        start = start,
        end = end
      ),
      silent = TRUE
    )
    if (inherits(results, "try-error")) {
      results <- tibble::tibble(
        package = character(0),
        date = as.Date(numeric(0)),
        title = character(0),
        description = character(0),
        version = character(0),
        authors = character(0),
        url = character(0),
        cran_url = character(0),
        github_url = character(0),
        first_download = as.Date(numeric(0)),
        downloads = integer(0)
      )
    }
    saveRDS(results, file = dest_file)
    return(results)
  }
}
