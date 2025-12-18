# Find rankings of journals on the ABDC, ERA2010, CORE, SCImago or Monash lists.

Data sets used are:

- [monash](https://numbats.github.io/spiderorchid/reference/monash.md):
  :

  Monash Business School

- [abdc](https://numbats.github.io/spiderorchid/reference/abdc.md): :

  Australian Business Deans' Council

- [era2010](https://numbats.github.io/spiderorchid/reference/era2010.md):
  :

  ERA 2010

- [core](https://numbats.github.io/spiderorchid/reference/core.md): :

  CORE

- [scimago](https://numbats.github.io/spiderorchid/reference/scimago.md):
  :

  SCImago

## Usage

``` r
journal_ranking(
  title,
  source = c("monash", "abdc", "era2010", "core", "scimago"),
  fuzzy = TRUE,
  only_best = length(title) > 1,
  ...
)
```

## Arguments

- title:

  A character vector containing (partial) journal names.

- source:

  A character string indicating which ranking data base to use. Default
  `"monash"`.

- fuzzy:

  Should fuzzy matching be used. If `FALSE`, partial exact matching is
  used. Otherwise, full fuzzy matching is used.

- only_best:

  If `TRUE`, only the best matching journal is returned.

- ...:

  Other arguments are passed to `agrepl` (if `fuzzy` is `TRUE`), or
  `grepl` otherwise.

## Value

A data frame containing the journal title, rank and source for each
matching journal.

## Author

Rob J Hyndman

## Examples

``` r
# Return ranking for individual journals or conferences
journal_ranking("Annals of Statistics")
#> # A tibble: 1 × 2
#>   title                rank    
#>   <chr>                <fct>   
#> 1 Annals of Statistics Group 1+
journal_ranking("Annals of Statistics", "abdc")
#> # A tibble: 1 × 2
#>   title                rank 
#>   <chr>                <ord>
#> 1 Annals of Statistics A*   
journal_ranking("International Conference on Machine Learning")
#> # A tibble: 1 × 2
#>   title                                        rank   
#>   <chr>                                        <fct>  
#> 1 International Conference on Machine Learning Group 1
journal_ranking("International Conference on Machine Learning", "core")
#> # A tibble: 3 × 2
#>   title                                                         rank 
#>   <chr>                                                         <ord>
#> 1 International Conference on Machine Learning                  A*   
#> 2 International Conference on Machine Learning and Applications C    
#> 3 International Conference on Machine Learning and Cybernetics  NA   
journal_ranking("R Journal", "scimago", only_best = TRUE)
#> # A tibble: 1 × 2
#>   title     rank 
#>   <chr>     <chr>
#> 1 R Journal Q1   
```
