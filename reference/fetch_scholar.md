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
#> # A tibble: 372 × 7
#>    scholar_id   authors                    title  year journal details citations
#>    <chr>        <chr>                      <chr> <int> <chr>   <chr>       <dbl>
#>  1 vamErfkAAAAJ RJ Hyndman                 An a…  1990 Univer… NA              5
#>  2 vamErfkAAAAJ PJ Brockwell, RJ Hyndman,… Cont…  1991 Statis… 401-410        36
#>  3 vamErfkAAAAJ RJ Hyndman                 The …  1991 Rob Hy… NA              4
#>  4 vamErfkAAAAJ RJ Hyndman                 Cont…  1992 Univer… NA              8
#>  5 vamErfkAAAAJ PJ Brockwell, RJ Hyndman   On c…  1992 Intern… 8 (2),…        58
#>  6 vamErfkAAAAJ RJ Hyndman                 Yule…  1993 Journa… 14 (3)…        38
#>  7 vamErfkAAAAJ RJ Hyndman                 Appr…  1994 Journa… 31 (4)…         2
#>  8 vamErfkAAAAJ R Hyndman, FC Klebaner, S… Auto…  1994 Depart… NA              0
#>  9 vamErfkAAAAJ RJ Hyndman                 High…  1995 Journa… 14 (5)…       124
#> 10 vamErfkAAAAJ RJ Hyndman                 The …  1995 Monash… 1-2           117
#> # ℹ 362 more rows
```
