
<!-- README.md is generated from README.Rmd. Please edit that file -->

# spiderorchid <img src="man/figures/spiderorchid-hex.png" align="right" width = 150 />

<!-- badges: start -->

<!-- badges: end -->

**Download and wrangle publication data for Monash EBS academic staff**

## Overview

The `spiderorchid` R package provides tools to retrieve research
publications from Google Scholar, ORCID and PURE, or from DOIs, along
with CRAN package download statistics. It is tailored for academic
researchers in the EBS department who wish to consolidate and analyze
their research outputs, while also monitoring their contributions to
CRAN.

It also provides journal ranking information from various sources,
including the Monash Business School, the Australian Business Deans’
Council, CORE, SCImago and ERA2010.

The main functions included are:

- `fetch_scholar`: Retrieves publication details from Google Scholar
  given IDs.
- `fetch_orcid`: Retrieves publication details from ORCID given IDs.
- `fetch_doi`: Retrieves publication details given DOIS.
- `fetch_pure`: Retrieves publication details from PURE for specific
  years.
- `fetch_cran`: Searches for CRAN packages by an author’s name and
  returns relevant package information such as the number of downloads
  and last update date.
- `journal_ranking`: Return journal ranking information from the Monash
  Business School, the Australian Business Deans’ Council and other
  lists.

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

## Staff IDs

`staff_ids.csv`

This dataset contains mappings between researchers’ names and their
respective ORCID and Google Scholar IDs. It is useful for linking and
identifying academic profiles across different platforms.

``` r
staff_ids
#> # A tibble: 57 × 4
#>   first_name last_name orcid_id            scholar_id  
#>   <chr>      <chr>     <chr>               <chr>       
#> 1 Akanksha   Negi      0000-0003-2531-9408 Gcz8Ng0AAAAJ
#> 2 Alyssa     Hu        0000-0002-9013-8374 IIDTKgsAAAAJ
#> 3 Andrew     Matthews  <NA>                <NA>        
#> 4 Ann        Maharaj   0000-0002-5513-962X BZ07eocAAAAJ
#> 5 Athanasios Pantelous 0000-0001-5738-1471 ZMaiiQwAAAAJ
#> # ℹ 52 more rows
```

## Google scholar publications

Given a vector of Google Scholar IDs, the `fetch_scholar()` function
retrieves publication details and returns them in the form of a data
frame, with one row per publication.

``` r
staff_ids |>
  filter(last_name %in% c("Negi", "Lydeamore")) |>
  pull(scholar_id) |>
  fetch_scholar()
#> # A tibble: 58 × 7
#>   scholar_id   authors                            title            year journal details citations
#>   <chr>        <chr>                              <chr>           <int> <chr>   <chr>       <dbl>
#> 1 Gcz8Ng0AAAAJ A Negi, D Roy                      The cooling ef…  2015 IFPRI … 1439           16
#> 2 Gcz8Ng0AAAAJ R Chandra, PK Joshi, A Negi, D Roy Dynamics of pu…  2017 IFPRI … 179-220        10
#> 3 Gcz8Ng0AAAAJ P Birthal, A Negi, PK Joshi        Understanding …  2019 Journa… 9 (3),…        38
#> 4 Gcz8Ng0AAAAJ A Negi, JM Wooldridge              Revisiting reg…  2021 Econom… 40 (5)…       131
#> 5 Gcz8Ng0AAAAJ C Cox, A Negi, D Negi              Risk-Sharing w…  2023 Availa… 4555847         0
#> # ℹ 53 more rows
```

## ORCID publications

Given a vector of ORCID IDs, the `fetch_orcid()` function retrieves
publication details and returns them in the form of a data frame, with
one row per publication.

``` r
staff_ids |>
  filter(last_name %in% c("Negi", "Lydeamore")) |>
  pull(orcid_id) |>
  fetch_orcid()
#> # A tibble: 17 × 9
#>   orcid_id            authors                         year title journal volume issue doi   page 
#>   <chr>               <chr>                          <int> <chr> <chr>   <chr>  <chr> <chr> <chr>
#> 1 0000-0001-6515-827X Michael Lydeamore; Nigel Bean…  2016 Choi… Bullet… 78     2     10.1… 293-…
#> 2 0000-0001-6515-827X Thiripura Vino; Gurmeet R. Si…  2017 Indi… PeerJ   5      2017… 10.7… e3958
#> 3 0000-0001-6515-827X M. J. Lydeamore; P. T. Campbe…  2018 Calc… Epidem… 146    9     10.1… 1194…
#> 4 0000-0001-6515-827X M.J. Lydeamore; P.T. Campbell…  2019 A bi… Mathem… 309    2019… 10.1… 163-…
#> 5 0000-0001-6515-827X Will Cuningham; Jodie McVerno…  2019 High… Austra… 43     2     10.1… 149-…
#> # ℹ 12 more rows
```

## DOI publications

Given a vector of DOIs, the `fetch_doi()` function retrieves publication
details and returns them in the form of a data frame, with one row per
DOI.

``` r
c(
  "10.1016/j.ijforecast.2023.10.003",
  "10.1080/10618600.2020.1807353"
) |>
  fetch_doi()
#> # A tibble: 2 × 8
#>   doi                              authors                  year title journal volume issue page 
#>   <chr>                            <chr>                   <int> <chr> <chr>   <chr>  <chr> <chr>
#> 1 10.1016/j.ijforecast.2023.10.003 Daniele Girolimetto; G…  2024 Cros… Intern… 40     3     1134…
#> 2 10.1080/10618600.2020.1807353    Sevvandi Kandanaarachc…  2020 Dime… Journa… 30     1     204-…
```

## PURE publications

Given a vector of years, the `fetch_pure()` function retrieves
publication details from the PURE system for academic staff in the
Department of Econometrics & Business Statistics, Monash University.

``` r
fetch_pure(2024)
```

    #> # A tibble: 95 × 8
    #>   pure_id    year authors                                 title       journal subtype bib   doi  
    #>   <chr>     <int> <chr>                                   <chr>       <chr>   <chr>   <chr> <chr>
    #> 1 580119537  2024 Negi, A & Wooldridge, JM                Doubly rob… Econom… Article Negi… 10.1…
    #> 2 578896645  2024 Negi, A                                 Doubly wei… Journa… Article Negi… 10.1…
    #> 3 577211348  2024 Nibbering, D                            A high-dim… Journa… Article Nibb… 10.1…
    #> 4 576146015  2024 Rostami-Tabar, B & Hyndman, RJ          Hierarchic… Journa… Article Rost… 10.1…
    #> 5 574756920  2024 Fang, X, Zhou, J, Pantelous, AA & Lu, W A machine … Expert… Article Fang… 10.1…
    #> # ℹ 90 more rows

The `fetch_pure()` function requires an API key to access the PURE
system. The API key is stored in the environment variable
`PURE_API_KEY`. This function is restricted to Monash IP addresses; so
either use it on campus or invoke the VPN before using it off campus. It
will return publications in the specified years, coauthored by members
of the Department of Econometrics & Business Statistics, Monash
University.

The function is run periodically, and the data stored as `ebs_pure`.
Currently, the stored data includes publications from January 2018 to
May 2025.

``` r
ebs_pure
#> # A tibble: 665 × 8
#>   pure_id    year authors                                 title       journal subtype bib   doi  
#>   <chr>     <int> <chr>                                   <chr>       <chr>   <chr>   <chr> <chr>
#> 1 580119537  2024 Negi, A & Wooldridge, JM                Doubly rob… Econom… Article Negi… 10.1…
#> 2 578896645  2024 Negi, A                                 Doubly wei… Journa… Article Negi… 10.1…
#> 3 577211348  2024 Nibbering, D                            A high-dim… Journa… Article Nibb… 10.1…
#> 4 576146015  2024 Rostami-Tabar, B & Hyndman, RJ          Hierarchic… Journa… Article Rost… 10.1…
#> 5 574756920  2024 Fang, X, Zhou, J, Pantelous, AA & Lu, W A machine … Expert… Article Fang… 10.1…
#> # ℹ 660 more rows
```

## CRAN packages

This function retrieves information about CRAN packages authored by
specified individuals. It returns a data frame containing the package
name, number of downloads, the authors, and the last update date.

``` r
c(
  "Michael Lydeamore",
  "Di Cook",
  "Dianne Cook"
) |>
  fetch_cran()
#> # A tibble: 48 × 11
#>   package   date       title description version authors url   cran_url github_url first_download
#>   <chr>     <date>     <chr> <chr>       <chr>   <chr>   <chr> <chr>    <chr>      <date>        
#> 1 blockstr… 2026-02-01 "Sam… "Sample da… 1.0.0   "Micha… http… https:/… https://g… 2026-02-01    
#> 2 cardinalR 2025-12-18 "Col… "A collect… 1.0.6   "Jayan… http… https:/… <NA>       2024-04-16    
#> 3 condensr  2023-08-30 "Aca… "Helps aut… 1.0.0   "Micha… http… https:/… <NA>       2023-08-30    
#> 4 Hospital… 2024-12-22 "Bui… "Set of to… 0.9.4   "Pasca… http… https:/… <NA>       2023-02-27    
#> 5 mapycusm… 2026-02-06 "Foc… "Focus-glu… 1.0.7   "Alex … http… https:/… <NA>       2025-12-20    
#> # ℹ 43 more rows
#> # ℹ 1 more variable: downloads <dbl>
```

## Journal rankings

This function retrieves journal ranking information for a list of
journals. The rankings are from the Monash Business School (default),
the Australian Business Deans’ Council, the Computing Research and
Education Association of Australasia, SCImago or ERA2010. It returns a
data frame containing journal names, and their rankings. Fuzzy matching
is used, but it works best if you use the correct journal name. Multiple
matches can be returned if the journal name is ambiguous.

``` r
c(
  "Annals of Statistics",
  "Journal of the American Statistical Association",
  "Journal of Computational and Graphical Statistics",
  "International Journal of Forecasting"
) |>
  journal_ranking()
#> # A tibble: 4 × 2
#>   title                                             rank    
#>   <chr>                                             <fct>   
#> 1 Annals of Statistics                              Group 1+
#> 2 Journal of the American Statistical Association   Group 1+
#> 3 Journal of Computational and Graphical Statistics Group 1 
#> 4 International Journal of Forecasting              Group 2
journal_ranking("Forecasting")
#> # A tibble: 3 × 2
#>   title                                       rank   
#>   <chr>                                       <fct>  
#> 1 Journal of Forecasting                      Group 2
#> 2 International Journal of Forecasting        Group 2
#> 3 Technological Forecasting and Social Change Group 2
```

There is a [shiny app](https://ebsmonash.shinyapps.io/Journal_Rankings/)
that allows you to explore the journal rankings interactively.
