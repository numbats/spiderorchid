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
#> # A tibble: 372 × 6
#>    scholar_id   authors                title publication_year journal_name DOI  
#>    <chr>        <chr>                  <chr>            <int> <chr>        <chr>
#>  1 vamErfkAAAAJ RJ Hyndman             An a…             1990 University … NA   
#>  2 vamErfkAAAAJ PJ Brockwell, RJ Hynd… Cont…             1991 Statistica … NA   
#>  3 vamErfkAAAAJ RJ Hyndman             The …             1991 Rob Hyndman  NA   
#>  4 vamErfkAAAAJ RJ Hyndman             Cont…             1992 University … NA   
#>  5 vamErfkAAAAJ PJ Brockwell, RJ Hynd… On c…             1992 Internation… NA   
#>  6 vamErfkAAAAJ RJ Hyndman             Yule…             1993 Journal of … NA   
#>  7 vamErfkAAAAJ RJ Hyndman             Appr…             1994 Journal of … NA   
#>  8 vamErfkAAAAJ R Hyndman, FC Klebane… Auto…             1994 Department … NA   
#>  9 vamErfkAAAAJ RJ Hyndman             High…             1995 Journal of … NA   
#> 10 vamErfkAAAAJ RJ Hyndman             The …             1995 Monash Univ… NA   
#> # ℹ 362 more rows
```
