# Annual Report 2024

``` r
library(spiderorchid)
library(dplyr)
#> 
#> Attaching package: 'dplyr'
#> The following objects are masked from 'package:stats':
#> 
#>     filter, lag
#> The following objects are masked from 'package:base':
#> 
#>     intersect, setdiff, setequal, union
```

## Total output for 2024

``` r
# Grab output from ORCID where possible
orcid <- staff_ids |>
  pull(orcid_id) |>
  na.omit() |>
  fetch_orcid() |>
  filter(publication_year == 2024)
# Otherwise grab output from Scholar
scholar <- staff_ids |>
  filter(is.na(orcid_id)) |>
  pull(scholar_id) |>
  na.omit() |>
  fetch_scholar() |>
  filter(publication_year == 2024)
```
