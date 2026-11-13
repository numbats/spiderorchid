# Fetch publications from ORCID

Retrieves publications for given ORCID IDs, and returns them as a
tibble. Only publications with DOIs are returned. The function uses the
ORCID API to fetch the DOIs, and then uses the DOI API to fetch the
publication details for each DOI.

## Usage

``` r
fetch_orcid(orcid_ids)
```

## Arguments

- orcid_ids:

  A character vector of ORCID IDs.

## Value

A tibble containing all publications for the specified ORCID IDs.

## Details

Data are retrieved from the ORCID public API via the orcidtr package, so
no authentication is required.

## Examples

``` r
if (FALSE) { # \dontrun{
fetch_orcid(c("0000-0003-2531-9408", "0000-0001-5738-1471"))
} # }
```
