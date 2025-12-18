# spiderorchid ![](reference/figures/spiderorchid-hex.png)

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
#>    first_name last_name orcid_id            scholar_id  
#>    <chr>      <chr>     <chr>               <chr>       
#>  1 Akanksha   Negi      0000-0003-2531-9408 Gcz8Ng0AAAAJ
#>  2 Alyssa     Hu        0000-0002-9013-8374 IIDTKgsAAAAJ
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

Given a vector of Google Scholar IDs, the
[`fetch_scholar()`](https://numbats.github.io/spiderorchid/reference/fetch_scholar.md)
function retrieves publication details and returns them in the form of a
data frame, with one row per publication.

``` r
staff_ids |>
  filter(last_name %in% c("Negi", "Lydeamore")) |>
  pull(scholar_id) |>
  fetch_scholar()
#> # A tibble: 50 × 6
#>    scholar_id   authors                title publication_year journal_name DOI  
#>    <chr>        <chr>                  <chr>            <int> <chr>        <chr>
#>  1 Gcz8Ng0AAAAJ A Negi, D Roy          The …             2015 IFPRI Discu… <NA> 
#>  2 Gcz8Ng0AAAAJ R Chandra, PK Joshi, … Dyna…             2017 IFPRI book … <NA> 
#>  3 Gcz8Ng0AAAAJ P Birthal, A Negi, PK… Unde…             2019 Journal of … <NA> 
#>  4 Gcz8Ng0AAAAJ A Negi, JM Wooldridge  Revi…             2021 Econometric… <NA> 
#>  5 Gcz8Ng0AAAAJ C Cox, A Negi, D Negi  Risk…             2023 Available a… <NA> 
#>  6 Gcz8Ng0AAAAJ G Rathnayake, A Negi,… Diff…             2024 arXiv prepr… <NA> 
#>  7 Gcz8Ng0AAAAJ A Negi, W Jeffrey M    Doub…             2024 Econometric… <NA> 
#>  8 Gcz8Ng0AAAAJ A Negi                 Doub…             2024 Journal of … <NA> 
#>  9 Gcz8Ng0AAAAJ A Negi, DS Negi        Diff…             2025 Journal of … <NA> 
#> 10 Gcz8Ng0AAAAJ A Negi, D Nibbering    Iden…             2025 arXiv prepr… <NA> 
#> # ℹ 40 more rows
```

## ORCID publications

Given a vector of ORCID IDs, the
[`fetch_orcid()`](https://numbats.github.io/spiderorchid/reference/fetch_orcid.md)
function retrieves publication details and returns them in the form of a
data frame, with one row per publication.

``` r
staff_ids |>
  filter(last_name %in% c("Negi", "Lydeamore")) |>
  pull(orcid_id) |>
  fetch_orcid()
#> # A tibble: 17 × 9
#>    orcid_id authors publication_year title journal_name volume issue doi   page 
#>    <chr>    <chr>              <int> <chr> <chr>        <chr>  <chr> <chr> <chr>
#>  1 0000-00… "Micha…             2016 Choi… Bulletin of… 78     2     10.1… 293-…
#>  2 0000-00… "Thiri…             2017 Indi… PeerJ        5      <NA>  10.7… e3958
#>  3 0000-00… "M. J.…             2018 Calc… Epidemiolog… 146    9     10.1… 1194…
#>  4 0000-00… "M.J. …             2019 A bi… Mathematica… 309    <NA>  10.1… 163-…
#>  5 0000-00… "Will …             2019 High… Australian … 43     2     10.1… 149-…
#>  6 0000-00… "MICHA…             2019 MECH… Bulletin of… 101    1     10.1… 174-…
#>  7 0000-00… "James…             2020 Brin… Journal of … 76     3     10.1… 547-…
#>  8 0000-00… "Micha…             2020 Esti… PLOS Comput… 16     10    10.1… e100…
#>  9 0000-00… "  "                2021 Popu… The Lancet … 17     <NA>  10.1… 1002…
#> 10 0000-00… "Camer…             2021 Risk… Journal of … 18     174   10.1… 2020…
#> 11 0000-00… "James…             2021 Unde… Nature Comm… 12     1     10.1… <NA> 
#> 12 0000-00… "M. J.…             2022 Burd… Antimicrobi… 11     1     10.1… <NA> 
#> 13 0000-00… "Camer…             2022 COVI… Science Adv… 8      14    10.1… <NA> 
#> 14 0000-00… "Prata…             2019 Unde… Journal of … 9      3     10.1… 255-…
#> 15 0000-00… "Akank…             2020 Revi… Econometric… 40     5     10.1… 504-…
#> 16 0000-00… "Akank…             2024 Robu… Journal of … 43     2     10.1… 454-…
#> 17 0000-00… "Akank…             2025 Diff… Journal of … 40     4     10.1… 411-…
```

The
[`fetch_orcid()`](https://numbats.github.io/spiderorchid/reference/fetch_orcid.md)
function requires authentication on ORCID. If you have not previously
authenticated, it will prompt you to do so when first run. If you just
follow the prompts, you will be authenticated, but only for downloading
your own papers. If you want to download papers from other ORCID IDs,
you will need to authenticate with a 2-legged OAuth. Follow the
instructions at
<https://info.orcid.org/register-a-client-application-production-member-api/>.
To avoid having to do this in each session, store the token obtained
from `orcid_auth()` in your `.Renviron` file by running
`usethis::edit_r_environ()`. It should be of the form
`ORCID_TOKEN=<your token>`.

## DOI publications

Given a vector of DOIs, the
[`fetch_doi()`](https://numbats.github.io/spiderorchid/reference/fetch_doi.md)
function retrieves publication details and returns them in the form of a
data frame, with one row per DOI.

``` r
c(
  "10.1016/j.ijforecast.2023.10.003",
  "10.1080/10618600.2020.1807353"
) |>
  fetch_doi()
#> # A tibble: 2 × 8
#>   doi             authors publication_year title journal_name volume issue page 
#>   <chr>           <chr>              <int> <chr> <chr>        <chr>  <chr> <chr>
#> 1 10.1016/j.ijfo… Daniel…             2024 Cros… Internation… 40     3     1134…
#> 2 10.1080/106186… Sevvan…             2020 Dime… Journal of … 30     1     204-…
```

## PURE publications

Given a vector of years, the
[`fetch_pure()`](https://numbats.github.io/spiderorchid/reference/fetch_pure.md)
function retrieves publication details from the PURE system for academic
staff in the Department of Econometrics & Business Statistics, Monash
University.

``` r
fetch_pure(2024)
```

``` R
#> # A tibble: 83 × 8
#>    pure_id    year authors                     title journal subtype bib   doi  
#>    <chr>     <int> <chr>                       <chr> <chr>   <chr>   <chr> <chr>
#>  1 580119537  2024 Negi, A & Wooldridge, JM    Doub… Econom… Article Negi… 10.1…
#>  2 578896645  2024 Negi, A                     Doub… Journa… Article Negi… 10.1…
#>  3 577211348  2024 Nibbering, D                A hi… Journa… Article Nibb… 10.1…
#>  4 576146015  2024 Rostami-Tabar, B & Hyndman… Hier… Journa… Article Rost… 10.1…
#>  5 574756920  2024 Fang, X, Zhou, J, Pantelou… A ma… Expert… Article Fang… 10.1…
#>  6 571851299  2024 Kim, HY & McLaren, KR       Inte… Resear… Article Kim,… 10.1…
#>  7 571257919  2024 Gao, J, Peng, B, Wu, WB & … Time… Journa… Article Gao,… 10.1…
#>  8 571257838  2024 Yan, Y, Gao, J & Peng, B    Asym… Econom… Article Yan,… 10.1…
#>  9 565992428  2024 Athanasopoulos, G, Hyndman… Fore… Intern… Article Atha… 10.1…
#> 10 564353599  2024 Wang, G, Zhou, J, Pantelou… A de… Comput… Article Wang… 10.1…
#> # ℹ 73 more rows
```

The
[`fetch_pure()`](https://numbats.github.io/spiderorchid/reference/fetch_pure.md)
function requires an API key to access the PURE system. The API key is
stored in the environment variable `PURE_API_KEY`. This function is
restricted to Monash IP addresses; so either use it on campus or invoke
the VPN before using it off campus. It will return publications in the
specified years, coauthored by members of the Department of Econometrics
& Business Statistics, Monash University.

The function is run periodically, and the data stored as `ebs_pure`.
Currently, the stored data includes publications from January 2018 to
May 2025.

``` r
ebs_pure
#> # A tibble: 613 × 8
#>    pure_id    year authors                     title journal subtype bib   doi  
#>    <chr>     <int> <chr>                       <chr> <chr>   <chr>   <chr> <chr>
#>  1 580119537  2024 Negi, A & Wooldridge, JM    Doub… Econom… Article Negi… 10.1…
#>  2 578896645  2024 Negi, A                     Doub… Journa… Article Negi… 10.1…
#>  3 577211348  2024 Nibbering, D                A hi… Journa… Article Nibb… 10.1…
#>  4 576146015  2024 Rostami-Tabar, B & Hyndman… Hier… Journa… Article Rost… 10.1…
#>  5 574756920  2024 Fang, X, Zhou, J, Pantelou… A ma… Expert… Article Fang… 10.1…
#>  6 574375066  2023 Pullin, JM, Gurrin, LC & V… Stat… The R … Article Pull… 10.3…
#>  7 571851299  2024 Kim, HY & McLaren, KR       Inte… Resear… Article Kim,… 10.1…
#>  8 571257919  2024 Gao, J, Peng, B, Wu, WB & … Time… Journa… Article Gao,… 10.1…
#>  9 571257838  2024 Yan, Y, Gao, J & Peng, B    Asym… Econom… Article Yan,… 10.1…
#> 10 567405205  2023 Zhou, J, Jiang, G, Pantelo… Onli… IEEE T… Article Zhou… 10.1…
#> # ℹ 603 more rows
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
#> # A tibble: 43 × 11
#>    package         date       title   description version authors url   cran_url
#>    <chr>           <date>     <chr>   <chr>       <chr>   <chr>   <chr> <chr>   
#>  1 cardinalR       2025-12-18 "Colle… "A collect… 1.0.6   "Jayan… http… https:/…
#>  2 condensr        2023-08-30 "Acade… "Helps aut… 1.0.0   "Micha… http… https:/…
#>  3 HospitalNetwork 2024-12-22 "Build… "Set of to… 0.9.4   "Pasca… http… https:/…
#>  4 quollr          2025-12-18 "Visua… "To constr… 1.0.6   "Jayan… http… https:/…
#>  5 brolgar         2025-09-03 "Brows… "Provides … 1.0.2   "Nicho… http… https:/…
#>  6 eechidna        2021-02-25 "Explo… "Data from… 1.4.1   "Jerem… http… https:/…
#>  7 fabletools      2025-09-01 "Core … "Provides … 0.5.1   "Mitch… http… https:/…
#>  8 feasts          2025-08-27 "Featu… "Provides … 0.4.2   "Mitch… http… https:/…
#>  9 geozoo          2016-05-07 "Zoo o… "Geometric… 0.5.1   "Barre… http… https:/…
#> 10 GGally          2025-08-23 "Exten… "The R pac… 2.4.0   "Barre… http… https:/…
#> # ℹ 33 more rows
#> # ℹ 3 more variables: github_url <chr>, first_download <date>, downloads <dbl>
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
#> 1 International Journal of Forecasting        Group 2
#> 2 Journal of Forecasting                      Group 2
#> 3 Technological Forecasting and Social Change Group 2
```

There is a [shiny app](https://ebsmonash.shinyapps.io/Journal_Rankings/)
that allows you to explore the journal rankings interactively.
