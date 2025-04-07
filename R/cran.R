#' Fetch packages from CRAN
#'
#' @description
#' This function searches for CRAN packages by author names. Note that some authors
#' may use different name variations on CRAN (e.g., "Di Cook" and "Dianne Cook"),
#' so it may be necessary to call the function
#' with several variations.
#'
#' @param author_names A character vector containing the authors' names in the form used on CRAN.
#' @param package_names A character vector of package names. Ignored if `author_names` is provided.
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
  author_names = NULL,
  package_names = NULL,
  downloads_from = "2000-01-01",
  downloads_to = Sys.Date()
) {
    pkgmeta::get_meta(
      cran_author = author_names,
      cran_packages = package_names,
      include_downloads = TRUE,
      start = downloads_from,
      end = downloads_to
    )
}
