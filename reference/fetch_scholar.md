# Fetch publications from Google Scholar

Retrieves publications for given Google Scholar IDs, and returns them as
a tibble. This function retrieves publications for a given Google
Scholar ID and formats them into a structured tibble.

## Usage

``` r
fetch_scholar(scholar_id)
```

## Arguments

- scholar_id:

  A character vector of Google Scholar IDs.

## Value

A tibble containing all publications for the specified Google Scholar
IDs.

## Examples

``` r
fetch_scholar("vamErfkAAAAJ")
#> Warning: Coercing LHS to a list
#> Error in dplyr::arrange(dplyr::select(output, dplyr::all_of(col_order),     dplyr::everything()), scholar_id, year, title, authors): ℹ In argument: `..3 = title`.
#> Caused by error:
#> ! `..3` must be a vector, not a function.
```
