#' get_cran_packages
#'
#' @description
#' This function searches for CRAN packages by a given author's first and last name.
#'
#' @param first_name A character vector representing the authors' first names.
#' @param last_name A character vector representing the authors' last names.
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
#' get_cran_packages("Michael", "Lydeamore")
#' }
#'
#' @name find_cran_packages
#' @export

find_cran_packages <- function(first_name, last_name) {
  author_name <- paste(first_name, last_name)

  
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




# cran_all_pubs
#
# @description
# This function combines the cran publications for all authors.
#
# @param authors A list of names of different authors.
# @return A combined dataframe of CRAN package downloads for all authors.
# @examples
# \dontrun{
# cran_authors <- tibble::tibble(
#   first_name = c("Michael", "Rob"),
#   last_name = c("Lydeamore", "Hyndman")
# )
# }
# \dontrun{cran_all_pubs(cran_authors)}
#
# @name cran_all_pubs
# @export

cran_all_pubs <- function(authors) {
  if (nrow(authors) == 0) {
    return(tibble::tibble(name = character(), downloads = numeric(), authors = character(), last_update_date = character()))
  }

  combined_df <- purrr::map_dfr(1:nrow(authors), function(i) {
    find_cran_packages(authors$first_name[i], authors$last_name[i])
  })

  combined_df <- combined_df |>
    dplyr::distinct()

  return(tibble::as_tibble(combined_df))
}
