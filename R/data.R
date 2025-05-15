#' staff_ids
#'
#' @description
#' This dataset contains the mappings between researcher names and their respective ORCID
#' and Google Scholar IDs. It is useful for identifying and linking academic profiles across
#' different platforms.
#'
#' @format A data frame with 4 variables:
#' \describe{
#'  \item{first_name}{\code{character}. The first name of the individual.}
#'  \item{last_name}{\code{character}. The last name of the individual.}
#'  \item{orcid_id}{\code{character}. The ORCID identifier.}
#'  \item{scholar_id}{\code{character}. The Google Scholar user ID.}
#' }
#' @source \url{https://www.monash.edu/business/ebs/our-people/staff-directory}
"staff_ids"

#' ebs_pure
#'
#' @description
#' This dataset contains publications between 2018 and May 2025 downloaded from PURE.
#' Additional data can be updated using the \code{\link{fetch_pure}()} function.
#'
#' @format A data frame with 7 variables:
#' \describe{
#' \item{pure_id}{\code{character}. The unique identifier for the publication in PURE.}
#' \item{year}{\code{integer}. The year of publication.}
#' \item{authors}{\code{character}. The authors of the publication.}
#' \item{title}{\code{character}. The title of the publication.}
#' \item{journal}{\code{character}. The journal where the publication appeared.}
#' \item{subtype}{\code{character}. The subtype of the publication.}
#' \item{bib}{\code{character}. A bibliographic citation in the Harvard format.}
#' \item{doi}{\code{character}. The DOI of the publication where available.}
#' }
#' @source \url{https://research.monash.edu/en/organisations/econometrics-business-statistics/publications/}
"ebs_pure"
