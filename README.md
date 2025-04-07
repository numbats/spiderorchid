
<!-- README.md is generated from README.Rmd. Please edit that file -->

# spiderorchid <img src="man/figures/spiderorchid-hex.png" align="right" width = 150 />

<!-- badges: start -->
<!-- badges: end -->

**Download and wrangle publication data for Monash EBS academic staff**

## Overview

The `spiderorchid` R package provides tools to retrieve research
publications from Google Scholar and ORCID, or from DOIs, along with
CRAN package download statistics. It is tailored for academic
researchers in the EBS department who wish to consolidate and analyze
their research outputs, while also monitoring their contributions to
CRAN.

The main functions included are:

- `fetch_scholar`: Retrieves publications from Google Scholar given IDs.
- `fetch_orchid`: Retrieves publications from ORCID given IDs.
- `fetch_doi`: Retrieves publications from CrossRef given DOIS.
- `fetch_cran`: Searches for CRAN packages by an author’s name and
  returns relevant package information such as the number of downloads
  and last update date.

The package caches results within each R session. So if you fetch the
same data multiple times, it will only download it once.

## Installation

``` r
# Install the packages needed
pak::pak(c("robjhyndman/pkgmeta", "numbats/spiderorchid"))
```

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

## Dataset

`staff_ids.csv`

This dataset contains mappings between researchers’ names and their
respective ORCID and Google Scholar IDs. It is useful for linking and
identifying academic profiles across different platforms.

``` r
staff_ids
#> # A tibble: 57 × 4
#>    first_name last_name orcid_id            scholar_id  
#>    <chr>      <chr>     <chr>               <chr>       
#>  1 Akanksha   Negi      0000-0003-2531-9408 Gcz8Ng0AAAAJ
#>  2 Alan       Powell    <NA>                <NA>        
#>  3 Andrew     Matthews  <NA>                <NA>        
#>  4 Ann        Maharaj   0000-0002-5513-962X BZ07eocAAAAJ
#>  5 Athanasios Pantelous 0000-0001-5738-1471 ZMaiiQwAAAAJ
#>  6 Benjamin   Wong      0000-0002-1665-6165 Nneg6GAAAAAJ
#>  7 Bin        Peng      0000-0003-4231-4713 5d3ZOm4AAAAJ
#>  8 Bonsoo     Koo       0000-0002-7247-9773 OmK08lAAAAAJ
#>  9 Brett      Inder     <NA>                Wx6eeWgAAAAJ
#> 10 Catherine  Forbes    0000-0003-3830-5865 jm73LccAAAAJ
#> # ℹ 47 more rows
```

## Google scholar publications

``` r
staff_ids |>
  filter(last_name %in% c("Negi", "Lydeamore")) |>
  pull(scholar_id) |>
  fetch_scholar()
#> # A tibble: 49 × 6
#>    scholar_id   authors                title publication_year journal_name DOI  
#>    <chr>        <chr>                  <chr>            <int> <chr>        <chr>
#>  1 Gcz8Ng0AAAAJ A Negi, D Roy          The …             2015 IFPRI Discu… <NA> 
#>  2 Gcz8Ng0AAAAJ R Chandra, PK Joshi, … Dyna…             2017 IFPRI book … <NA> 
#>  3 Gcz8Ng0AAAAJ P Birthal, A Negi, PK… Unde…             2019 Journal of … <NA> 
#>  4 Gcz8Ng0AAAAJ A Negi                 Robu…             2020 Michigan St… <NA> 
#>  5 Gcz8Ng0AAAAJ A Negi, JM Wooldridge  Revi…             2021 Econometric… <NA> 
#>  6 Gcz8Ng0AAAAJ C Cox, A Negi, D Negi  Risk…             2023 Available a… <NA> 
#>  7 Gcz8Ng0AAAAJ G Rathnayake, A Negi,… Diff…             2024 arXiv prepr… <NA> 
#>  8 Gcz8Ng0AAAAJ A Negi, W Jeffrey M    Doub…             2024 Econometric… <NA> 
#>  9 Gcz8Ng0AAAAJ A Negi                 Doub…             2024 Journal of … <NA> 
#> 10 Gcz8Ng0AAAAJ A Negi, JM Wooldridge  Robu…             2024 Journal of … <NA> 
#> # ℹ 39 more rows
```

## ORCID publications

The `fetch_orcid()` function requires authentication on ORCID. If you
have not previously authenticated, it will prompt you to do so when
first run. If you just follow the prompts, you will be authenticated,
but only for downloading your own papers. If you want to download papers
from other ORCID IDs, you will need to authenticate with a 2-legged
OAuth. Follow the instructions at
<https://info.orcid.org/register-a-client-application-production-member-api/>.
To avoid having to do this in each session, store the token obtained
from `orcid_auth()` in your `.Renviron` file by running
`usethis::edit_r_environ()`. It should be of the form .

``` r
staff_ids |>
  filter(last_name %in% c("Negi", "Lydeamore")) |>
  pull(orcid_id) |>
  fetch_orcid()
#> # A tibble: 15 × 8
#>    orcid_id       authors publication_year title journal_name volume issue DOI  
#>    <chr>          <chr>              <dbl> <chr> <chr>        <chr>  <chr> <chr>
#>  1 0000-0001-651… Michae…             2016 Choi… Bulletin of… 78     2     10.1…
#>  2 0000-0001-651… Thirip…             2017 Indi… PeerJ        5      <NA>  10.7…
#>  3 0000-0001-651… M. J. …             2018 Calc… Epidemiolog… 146    9     10.1…
#>  4 0000-0001-651… M.J. L…             2019 A bi… Mathematica… 309    <NA>  10.1…
#>  5 0000-0001-651… Will C…             2019 High… Australian … 43     2     10.1…
#>  6 0000-0001-651… MICHAE…             2019 MECH… Bulletin of… 101    1     10.1…
#>  7 0000-0001-651… James …             2020 Brin… Journal of … 76     3     10.1…
#>  8 0000-0001-651… Michae…             2020 Esti… PLOS Comput… 16     10    10.1…
#>  9 0000-0001-651… <NA>                2021 Popu… The Lancet … 17     <NA>  10.1…
#> 10 0000-0001-651… Camero…             2021 Risk… Journal of … 18     174   10.1…
#> 11 0000-0001-651… James …             2021 Unde… Nature Comm… 12     1     10.1…
#> 12 0000-0001-651… M. J. …             2022 Burd… Antimicrobi… 11     1     10.1…
#> 13 0000-0001-651… Camero…             2022 COVI… Science Adv… 8      14    10.1…
#> 14 0000-0003-253… Pratap…             2019 Unde… Journal of … 9      3     10.1…
#> 15 0000-0003-253… Akanks…             2020 Revi… Econometric… 40     5     10.1…
```

## DOI publications

``` r
fetch_doi(c("10.1016/j.ijforecast.2023.10.003", "10.1080/10618600.2020.1807353"))
#> # A tibble: 2 × 7
#>   DOI                   authors publication_year title journal_name volume issue
#>   <chr>                 <chr>              <dbl> <chr> <chr>        <chr>  <chr>
#> 1 10.1016/j.ijforecast… Daniel…             2024 Cros… Internation… 40     3    
#> 2 10.1080/10618600.202… Sevvan…             2020 Dime… Journal of … 30     1
```

## CRAN packages

This function retrieves information about CRAN packages authored by a
specified individual. It returns a data frame containing the package
name, number of downloads, the authors, and the last update date.

``` r
fetch_cran(c(
  "Michael Lydeamore",
  "Di Cook",
  "Dianne Cook"
))
#> # A tibble: 40 × 11
#>    package         date       title   description version authors url   cran_url
#>    <chr>           <date>     <chr>   <chr>       <chr>   <chr>   <chr> <chr>   
#>  1 cardinalR       2024-04-16 "Colle… "A collect… 0.1.1   "Jayan… http… https:/…
#>  2 condensr        2023-08-30 "Acade… "Helps aut… 1.0.0   "Micha… http… https:/…
#>  3 HospitalNetwork 2024-12-22 "Build… "Set of to… 0.9.4   "Pasca… http… https:/…
#>  4 quollr          2024-03-05 "Visua… "To constr… 0.1.1   "Jayan… http… https:/…
#>  5 brolgar         2024-05-10 "Brows… "Provides … 1.0.1   "Nicho… http… https:/…
#>  6 eechidna        2021-02-25 "Explo… "Data from… 1.4.1   "Jerem… http… https:/…
#>  7 fabletools      2024-09-17 "Core … "Provides … 0.5.0   "Mitch… http… https:/…
#>  8 feasts          2024-09-25 "Featu… "Provides … 0.4.1   "Mitch… http… https:/…
#>  9 geozoo          2016-05-07 "Zoo o… "Geometric… 0.5.1   "Barre… http… https:/…
#> 10 GGally          2024-02-13 "Exten… "\nThe R p… 2.2.1   "Barre… http… https:/…
#> # ℹ 30 more rows
#> # ℹ 3 more variables: github_url <chr>, first_download <date>, downloads <dbl>
```
