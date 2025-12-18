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

This function requires authentication on ORCID. If you have not
previously authenticated, it will prompt you to do so when first run. If
you just follow the prompts, you will be authenticated, but only for
downloading your own papers. If you want to download papers from other
ORCID IDs, you will need to authenticate with a 2-legged OAuth. Follow
the instructions at
<https://info.orcid.org/register-a-client-application-production-member-api/>.
To avoid having to do this in each session, store the token obtained
from `orcid_auth()` in your `.Renviron` file by running
`usethis::edit_r_environ()`. It should be of the form
`ORCID_TOKEN=<your token>`.

## Examples

``` r
if (FALSE) { # \dontrun{
fetch_orcid(c("0000-0003-2531-9408", "0000-0001-5738-1471"))
} # }
```
