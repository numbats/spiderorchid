#' Fetch packages from CRAN
#'
#' @description
#' This function searches for CRAN packages by author names.
#'
#' @param author_name A character vector containing the authors' names.
#'
#' @return A data frame returning package name, number of downloads,author names and last update date of the package.
#'
#' @importFrom pkgsearch ps
#' @importFrom tibble tibble
#' @importFrom dplyr bind_rows filter
#' @importFrom stringr str_detect
#'
#' @examples
#' \dontrun{
#' fetch_cran("Michael Lydeamore")
#' }
#'
#' @export

fetch_cran <- function(author_name) {
 
  combined_df <- purrr::map_dfr(1:nrow(authors), function(i) {
    find_cran_packages(authors$first_name[i], authors$last_name[i])
  })

  results <- pkgsearch::ps(author_name, size = 200)

  num_packages <- length(results$package)

  if (num_packages == 0) {
    return(
      tibble::tibble(
        name = character(0),
        downloads = numeric(0),
        authors = character(0),
        last_update_date = character(0)
      )
    )
  }

  package_frame <- lapply(1:num_packages, function(i) {
    tibble(
      name = results$package[i],
      downloads = results$package_data[[i]]$downloads,
      authors = results$package_data[[i]]$Author,
      last_update_date = results$package_data[[i]]$date
    )
  }) |>
    dplyr::bind_rows() |>
    dplyr::filter(stringr::str_detect(authors, author_name))

  unique(package_frame)
}
