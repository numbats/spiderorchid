# Fetch publications from PURE

To download data from PURE, it is necessary to have access to the API
via Simon Angus and the Astro team <https://astro.monash.edu/>. The API
key is stored in the environment variable `PURE_API_KEY`. You can add it
to your environment using `edit_r_environ()`. This is end-point
restricted to Monash IP addresses. So either use it on campus or invoke
the VPN before using it off campus.

## Usage

``` r
fetch_pure(years)
```

## Arguments

- years:

  A numeric vector of publication years. All publications between the
  minimum year and the maximum year are returned.

## Value

A data frame containing the data fetched from the PURE API covering the
specified publication years.

## Details

Publications up to 2024 are available in the
[`ebs_pure`](https://numbats.github.io/spiderorchid/reference/ebs_pure.md)
dataset.

## See also

[`ebs_pure`](https://numbats.github.io/spiderorchid/reference/ebs_pure.md)
