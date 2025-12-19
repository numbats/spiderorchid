# Fetch article information given a DOI

Retrieves publications for a given list of DOIs using the DOI API and
formats them into a structured tibble.

## Usage

``` r
fetch_doi(doi)
```

## Arguments

- doi:

  A character vector of DOIs.

## Value

A tibble containing the article information.

## Examples

``` r
fetch_doi("10.1016/j.ijforecast.2023.10.010")
#> # A tibble: 1 × 8
#>   doi                             authors  year title journal volume issue page 
#>   <chr>                           <chr>   <int> <chr> <chr>   <chr>  <chr> <chr>
#> 1 10.1016/j.ijforecast.2023.10.0… George…  2024 Fore… Intern… 40     2     430-…
```
