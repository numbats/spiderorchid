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
  arrange(rank) |>
  select(title, rank)
#> # A tibble: 85 × 2
#>    title                                                                   rank 
#>    <chr>                                                                   <ord>
#>  1 Annals of Probability                                                   A*   
#>  2 Annals of Statistics                                                    A*   
#>  3 Biometrika                                                              A*   
#>  4 Journal of Computational and Graphical Statistics                       A*   
#>  5 Journal of the American Statistical Association                         A*   
#>  6 Journal of the Royal Statistical Society, Series B (Statistical Method… A*   
#>  7 Probability Theory and Related Fields                                   A*   
#>  8 Advances in Applied Probability                                         A    
#>  9 Annals of Applied Probability                                           A    
#> 10 Annals of Applied Statistics                                            A    
#> # ℹ 75 more rows
```
