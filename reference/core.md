# CORE (Computing Research and Education) lists of conference and journal rankings

Two datasets are provided: `core` and `core_journals`, which contains
lists of conference and journal rankings respectively, according to the
CORE executive committee. The details of the CORE organisation, and its
procedure for ranking are provided below.

## Usage

``` r
core

core_journals
```

## Format

An object of class `tbl_df` (inherits from `tbl`, `data.frame`) with 982
rows and 2 columns.

An object of class `tbl_df` (inherits from `tbl`, `data.frame`) with 639
rows and 4 columns.

## Source

<https://www.core.edu.au/conference-portal>

## Value

`core` is a data frame with 982 observations and two variables:

- `title:`:

  Title of the conference

- `rank:`:

  Conferences are assigned to one of the following categories:

  - A\*: flagship conference, a leading venue in a discipline area

  - A: excellent conference, and highly respected in a discipline area

  - B: good conference, and well regarded in a discipline area

  - C: other ranked conference venues that meet minimum standards

`core_journals` is a data frame with 639 observations and 4 variables:

- `title:`:

  Title of the journal

- `field_of_research`: :

  Field of Research Code as provided by the Australian Bureau of
  Statistics

- `issn`: :

  International Standard Serial Number

- `rank`: :

  In order of best to lowest rank: A\*, A, B, or C

## Details

CORE is an association of university departments of computer science in
Australia and New Zealand. Prior to 2004 it was known as the Computer
Science Association, CSA.

The CORE Conference Ranking provides assessments of major conferences in
the computing disciplines. The rankings are managed by the CORE
Executive Committee, with periodic rounds for submission of requests for
addition or reranking of conferences. Decisions are made by academic
committees based on objective data requested as part of the submission
process. Conference rankings are determined by a mix of indicators,
including citation rates, paper submission and acceptance rates, and the
visibility and research track record of the key people hosting the
conference and managing its technical program. A more detailed statement
categorizing the ranks A\*, A, B, and C can be found
[here](http://bit.ly/core-rankings).

## Examples

``` r
core
#> # A tibble: 982 × 2
#>    title                                                                   rank 
#>    <chr>                                                                   <ord>
#>  1 ACM Conference on Applications, Technologies, Architectures, and Proto… A*   
#>  2 ACM Conference on Computer and Communications Security                  A*   
#>  3 ACM Conference on Economics and Computation                             A*   
#>  4 ACM Conference on Embedded Networked Sensor Systems                     A*   
#>  5 ACM International Conference on Knowledge Discovery and Data Mining     A*   
#>  6 ACM International Conference on Mobile Computing and Networking         A*   
#>  7 ACM International Conference on Research and Development in Informatio… A*   
#>  8 ACM International Conference on the Foundations of Software Engineerin… A*   
#>  9 ACM International Symposium on Computer Architecture                    A*   
#> 10 ACM Multimedia                                                          A*   
#> # ℹ 972 more rows
core_journals
#> # A tibble: 639 × 4
#>    title                                           field_of_research issn  rank 
#>    <chr>                                           <chr>             <chr> <ord>
#>  1 ACM Computing Surveys                           0803              0360… A*   
#>  2 ACM Transactions on Computer - Human Interacti… 0806              1073… A*   
#>  3 ACM Transactions on Computer Systems            0803              0734… A*   
#>  4 ACM Transactions on Database Systems            0804              0362… A*   
#>  5 ACM Transactions on Graphics                    0801              0730… A*   
#>  6 ACM Transactions on Mathematical Software       0802              0098… A*   
#>  7 ACM Transactions on Programming Languages and … 0803              0164… A*   
#>  8 ACM Transactions on Software Engineering and M… 0803              1049… A*   
#>  9 Algorithmica: an international journal in comp… 0802              0178… A*   
#> 10 Annual Review of Information Science and Techn… 0807              0066… A*   
#> # ℹ 629 more rows
```
