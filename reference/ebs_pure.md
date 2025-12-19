# Monash EBS PURE publications data

This dataset contains publications between 2018 and May 2025 downloaded
from PURE. Additional data can be updated using the
[`fetch_pure()`](https://numbats.github.io/spiderorchid/reference/fetch_pure.md)
function.

## Usage

``` r
ebs_pure
```

## Format

A data frame with 7 variables:

- pure_id:

  `character`. The unique identifier for the publication in PURE.

- year:

  `integer`. The year of publication.

- authors:

  `character`. The authors of the publication.

- title:

  `character`. The title of the publication.

- journal:

  `character`. The journal where the publication appeared.

- subtype:

  `character`. The subtype of the publication.

- bib:

  `character`. A bibliographic citation in the Harvard format.

- doi:

  `character`. The DOI of the publication where available.

## Source

<https://research.monash.edu/en/organisations/econometrics-business-statistics/publications/>
