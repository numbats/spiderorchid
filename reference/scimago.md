# SCImago Journal Rank for all journals indexed by Scopus

This data was taken from https://www.scimagojr.com/journalrank.php

## Usage

``` r
data(scimago)
```

## Format

An object of class `tbl_df` (inherits from `tbl`, `data.frame`) with
31136 rows and 27 columns.

## Source

SCImago, (n.d.). SJR — SCImago Journal & Country Rank. Retrieved
2021-11-28, from <https://www.scimagojr.com/journalrank.php>

## Value

A tibble with 31136 rows and 27 variables:

- year:

  Year of SCImago Journal Ranking calculation.

- rank:

  Rank of the journal among all journals.

- sourceid:

  Database ID of the journal.

- title:

  Jounal's title.

- type:

  Type: "journal", "book series", "trade journal", or "conference and
  proceedings"

- issn:

  ISSN journal identifier.

- sjr:

  SCImago Journal Rank indicator. It expresses the average number of
  weighted citations received in the selected year by the documents
  published in the selected journal in the three previous years, –i.e.
  weighted citations received in year X to documents published in the
  journal in years X-1, X-2 and X-3. See [detailed description of
  SJR](https://www.scimagojr.com/SCImagoJournalRank.pdf) (PDF).

- sjr_best_quartile:

  Highest quartile of the journal among all categories it belongs to.

- h_index:

  Hirsch index of the journal. The h index expresses the journal's
  number of articles (h) that have received at least h citations. It
  quantifies both journal scientific productivity and scientific impact
  and it is also applicable to scientists, countries, etc. ([see H-index
  wikipedia definition](http://en.wikipedia.org/wiki/Hirsch_number)).

- total_docs_year:

  Total number of published documents within a specific year. All types
  of documents are considered, including citable and non citable
  documents.

- total_docs_3years:

  Published documents in the three previous years (selected year
  documents are excluded), i.e.when the year X is selected, then X-1,
  X-2 and X-3 published documents are retrieved. All types of documents
  are considered, including citable and non citable documents.

- total_refs:

  Total number of citations received by a journal to the documents
  published within a specific year.

- total_cites_3years:

  Number of citations received in the seleted year by a journal to the
  documents published in the three previous years, –i.e. citations
  received in year X to documents published in years X-1, X-2 and X-3.
  All types of documents are considered.

- citable_docs_3years:

  Number of citable documents published by a journal in the three
  previous years (selected year documents are excluded). Exclusively
  articles, reviews and conference papers are considered..

- cites_doc_2years:

  Average citations per document in a 2 year period. It is computed
  considering the number of citations received by a journal in the
  current year to the documents published in the two previous years,
  –i.e. citations received in year X to documents published in years X-1
  and X-2. Comparable to Journal Impact Factor.

- ref_doc:

  Average number of references per document in the selected year..

- country:

  Country of the publisher.

- publisher:

  Publisher of the journal.

- categories:

  Categories the jounal belongs to.

- highest_category:

  Category in which the journal ranks highest by percentile.

- highest_rank:

  Rank of journal in `highest_category`.

- highest_percentile:

  Highest percentile of journal in any category.

## Author

Rob Hyndman
