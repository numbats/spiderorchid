# ABDC Journal Quality List

This is a dataset that contains the quality list of rankings of the
Australian Business Deans Council (ABDC). You can read more about this
list [here](https://abdc.edu.au/abdc-journal-quality-list/).

## Usage

``` r
data(abdc)
```

## Format

An object of class `tbl_df` (inherits from `tbl`, `data.frame`) with
2680 rows and 7 columns.

## Source

<https://abdc.edu.au/abdc-journal-quality-list/>

## Value

A data frame with 2680 observations on the following 7 variables:

- `title`: :

  Title of the journal

- `publisher`: :

  Publishing house

- `issn`: :

  International Standard Serial Number

- `issn_online`: :

  ISSN Online - as ISSN, but for the online, rather than print version

- `year_inception`: :

  Year the journal started

- `field_of_research`: :

  Field of Research Code as provided by the Australian Bureau of
  Statistics

- `rank`: :

  In order of best to lowest rank: A\*, A, B, or C

## Examples

``` r
library(dplyr)
#> 
#> Attaching package: ‘dplyr’
#> The following objects are masked from ‘package:stats’:
#> 
#>     filter, lag
#> The following objects are masked from ‘package:base’:
#> 
#>     intersect, setdiff, setequal, union
abdc |>
  filter(field_of_research == "4905") |>
  arrange(rank)
#> # A tibble: 85 × 7
#>    title      publisher issn  issn_online year_inception field_of_research rank 
#>    <chr>      <chr>     <chr> <chr>       <chr>          <chr>             <ord>
#>  1 Annals of… Institut… 0091… 2168-894X   1973           4905              A*   
#>  2 Annals of… Institut… 0090… NA          1973           4905              A*   
#>  3 Biometrika Oxford U… 0006… 1464-3510   1901           4905              A*   
#>  4 Journal o… Taylor &… 1061… 1537-2715   1992           4905              A*   
#>  5 Journal o… Taylor &… 0162… 1537-274X   1888           4905              A*   
#>  6 Journal o… Wiley-Bl… NA    1467-9868   1934           4905              A*   
#>  7 Probabili… Springer… 0178… 1432-2064   1962           4905              A*   
#>  8 Advances … Applied … 0001… 1475-6064   1964           4905              A    
#>  9 Annals of… Institut… 1050… 2168-8737   1991           4905              A    
#> 10 Annals of… Institut… 1932… 1941-7330   2007           4905              A    
#> # ℹ 75 more rows
```
