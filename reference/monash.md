# Monash Business School Journal Quality List

This is a dataset that contains the list of quality journal rankings
from the Monash Business School. In most cases, it follows ABDC with A\*
equal to Group 1 and A equal to Group 2. The "Group 1+" category
contains a small set of the highest rank journals. The data set is
updated from time to time when journals not on the ABDC list are
classified. See
<https://www.intranet.monash/business/research-services/research-standards>
for the latest information.

## Usage

``` r
data(monash)
```

## Format

An object of class `tbl_df` (inherits from `tbl`, `data.frame`) with
4617 rows and 2 columns.

## Source

Monash Business School

## Value

A data frame with 4617 observations on the following 2 variables:

- `title`: :

  Title of the journal

- `rank`: :

  In order of best to lowest rank: Group 1+, Group 1, Group 2

## Examples

``` r
library(dplyr)
library(stringr)
monash |>
  filter(str_detect(title, "Statist")) |>
  arrange(rank)
#> # A tibble: 35 × 2
#>    title                                              rank    
#>    <chr>                                              <fct>   
#>  1 Annals of Statistics                               Group 1+
#>  2 Journal of the American Statistical Association    Group 1+
#>  3 Journal of the Royal Statistical Society, Series B Group 1+
#>  4 Review of Economics and Statistics                 Group 1+
#>  5 Journal of Business & Economic Statistics          Group 1 
#>  6 Journal of Computational and Graphical Statistics  Group 1 
#>  7 The Review of Economics and Statistics             Group 1 
#>  8 Journal of Business and Economic Statistics        Group 1 
#>  9 Annals of Applied Statistics                       Group 2 
#> 10 Annals of the Institute of Statistical Mathematics Group 2 
#> # ℹ 25 more rows
```
