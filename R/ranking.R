#' Find rankings of journals on the ABDC, ERA2010, CORE, SCImago or Monash lists.
#'
#' Data sets used are:
#'   \describe{
#'   \item{\cite{\link{monash}}: }{Monash Business School}
#'   \item{\cite{\link{abdc}}: }{Australian Business Deans' Council}
#'   \item{\cite{\link{era2010}}: }{ERA 2010}
#'   \item{\cite{\link{core}}: }{CORE}
#'   \item{\cite{\link{scimago}}: }{SCImago}
#'   }
#'
#' @param title A character vector containing (partial) journal names.
#' @param source A character string indicating which ranking data base to use. Default \code{"monash"}.
#' @param fuzzy Should fuzzy matching be used. If \code{FALSE}, partial exact matching is used.
#' Otherwise, full fuzzy matching is used.
#' @param only_best If \code{TRUE}, only the best matching journal is returned.
#' @param ... Other arguments are passed to \code{agrepl} (if \code{fuzzy} is \code{TRUE}), or \code{grepl} otherwise.
#' @return A data frame containing the journal title, rank and source for each matching journal.
#' @author Rob J Hyndman
#' @examples
#' # Return ranking for individual journals or conferences
#' journal_ranking("Annals of Statistics")
#' journal_ranking("Annals of Statistics", "abdc")
#' journal_ranking("International Conference on Machine Learning")
#' journal_ranking("International Conference on Machine Learning", "core")
#' journal_ranking("R Journal", "scimago", only_best = TRUE)
#' @export
journal_ranking <- function(
  title,
  source = c("monash", "abdc", "era2010", "core", "scimago"),
  fuzzy = TRUE,
  only_best = length(title) > 1,
  ...
) {
  source <- match.arg(source)
  jrankings <- switch(
    source,
    "monash" = monash,
    "abdc" = abdc,
    "era2010" = era2010,
    "core" = dplyr::bind_rows(
      core,
      core_journals
    ),
    "scimago" = scimago |> mutate(rank = sjr_best_quartile)
  )
  purrr::map_dfr(title, \(x) match_journal_title(jrankings, x, fuzzy, only_best, ...))
}

match_journal_title <- function(jrankings, title, fuzzy, only_best, ...) {
  jrankings <- jrankings |>
    dplyr::select(title, rank) |>
    dplyr::mutate(title = clean_journal_names(title)) |>
    dplyr::arrange(title)
  if (fuzzy) {
    idx <- agrepl(title, jrankings$title, ignore.case = TRUE, ...)
  } else {
    idx <- grepl(title, jrankings$title, ignore.case = TRUE, ...)
  }
  jrankings <- jrankings[idx, ]
  if (only_best & nrow(jrankings) > 1) {
    dist <- c(utils::adist(title, jrankings$title, ignore.case = TRUE, ...))
    jrankings <- jrankings |> mutate(dist = dist)
    jrankings <- jrankings[dist == min(dist), ]
  }
  jrankings |> select(title, rank)
}

clean_journal_names <- function(journals) {
  # Change "&" and "and",
  # Also omit anything in parentheses
  journals <- stringr::str_replace_all(journals, "&", "and")
  journals <- stringr::str_remove_all(journals, "\\([A-Za-z\\s]*\\)")
  stringr::str_trim(journals)
}
