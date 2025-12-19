# Promotion applications

This document was developed during *ozunconf19* and *numbat hackathon
2020*, to provide tools and ideas that will help gather the information
required to apply for *academic promotion*. It was updated by Rob
Hyndman in December 2025 to work with the `spiderorchid` package.

Typically, an application for academic promotion will require you to
provide evidence of your performance in Research, Teaching, Engagement
and (for senior appointments) Leadership. The rest of this document
summarises what sort of things you could include in each of these
sections.

## Research

For research, you will need a list of publications, the number of
citations, and the ranking of the journals in which you have published

You can obtain a list of your publication from various sources, such as
PURE, Google Scholar or ORCID. Normally you would only need to use one
of these.

``` r
library(spiderorchid)
library(dplyr)
```

``` r
mypubs_scholar <- fetch_scholar("miNl6rMAAAAJ")
mypubs_orcid <- fetch_orcid("0000-0001-6515-827X")
```

Each of these functions will return a tibble, with one row per
publication and the columns providing information such as title,
authors, year of publication, etc. The different sources provide some
different information, and it is often useful to combine them. We will
combine the publications from Google Scholar and ORCID in the following
examples.

``` r
mypubs_orcid
```

    ## # A tibble: 13 × 9
    ##    orcid_id            authors       year title journal volume issue doi   page 
    ##    <chr>               <chr>        <int> <chr> <chr>   <chr>  <chr> <chr> <chr>
    ##  1 0000-0001-6515-827X "Michael Ly…  2016 Choi… Bullet… 78     2     10.1… 293-…
    ##  2 0000-0001-6515-827X "Thiripura …  2017 Indi… PeerJ   5      2017… 10.7… e3958
    ##  3 0000-0001-6515-827X "M. J. Lyde…  2018 Calc… Epidem… 146    9     10.1… 1194…
    ##  4 0000-0001-6515-827X "M.J. Lydea…  2019 A bi… Mathem… 309    2019… 10.1… 163-…
    ##  5 0000-0001-6515-827X "Will Cunin…  2019 High… Austra… 43     2     10.1… 149-…
    ##  6 0000-0001-6515-827X "MICHAEL J.…  2019 MECH… Bullet… 101    1     10.1… 174-…
    ##  7 0000-0001-6515-827X "James H Mc…  2020 Brin… Journa… 76     3     10.1… 547-…
    ##  8 0000-0001-6515-827X "Michael J.…  2020 Esti… PLOS C… 16     10    10.1… e100…
    ##  9 0000-0001-6515-827X ""            2021 Popu… The La… 17     2021… 10.1… 1002…
    ## 10 0000-0001-6515-827X "Cameron Za…  2021 Risk… Journa… 18     174   10.1… 2020…
    ## 11 0000-0001-6515-827X "James M. T…  2021 Unde… Nature… 12     1     10.1… NA   
    ## 12 0000-0001-6515-827X "M. J. Lyde…  2022 Burd… Antimi… 11     1     10.1… NA   
    ## 13 0000-0001-6515-827X "Cameron Za…  2022 COVI… Scienc… 8      14    10.1… NA

``` r
mypubs_scholar
```

    ## # A tibble: 39 × 7
    ##    scholar_id   authors                    title  year journal details citations
    ##    <chr>        <chr>                      <chr> <int> <chr>   <chr>       <dbl>
    ##  1 miNl6rMAAAAJ M Lydeamore                Mode…  2013 NA      NA              0
    ##  2 miNl6rMAAAAJ M Lydeamore                Appr…  2015 NA      NA              0
    ##  3 miNl6rMAAAAJ M Lydeamore, PT Campbell,… A bi…  2016 arXiv … :1612.…         0
    ##  4 miNl6rMAAAAJ M Lydeamore, N Bean, AJ B… Choi…  2016 Bullet… 78 (2)…         3
    ##  5 miNl6rMAAAAJ T Vino, GR Singh, B Davis… Indi…  2017 PeerJ   5, e39…        22
    ##  6 miNl6rMAAAAJ MJ Lydeamore, PT Campbell… Calc…  2018 Epidem… 146 (9…        15
    ##  7 miNl6rMAAAAJ MJ Lydeamore               Mech…  2018 The Un… NA              2
    ##  8 miNl6rMAAAAJ MJ Lydeamore, PT Campbell… A bi…  2019 Mathem… 309, 1…        29
    ##  9 miNl6rMAAAAJ W Cuningham, J McVernon, … High…  2019 Austra… 43 (2)…        16
    ## 10 miNl6rMAAAAJ JH McMahon, MJ Lydeamore,… Brin…  2020 Journa… NA             24
    ## # ℹ 29 more rows

In general, ORCID will provide higher quality data, along with DOIs, bit
covers fewer publications than Google Scholar, and does not provide
citations. Some papers may have two DOIs — for example, when they appear
on both JSTOR and a journal website – so it may be necessary to remove
duplicates. In this example, there are no duplicates.

Next, we will try to combine the two tibbles using fuzzy joining on the
title and year fields. The idea here is to add the details from ORCID to
the more complete data set from Google Scholar.

``` r
mypubs <- mypubs_scholar |>
  # First remove any publications missing details.
  # These are usually talks and pre-prints
  filter(!is.na(year) & !is.na(journal)) |>
  # Now find matching entries
  fuzzyjoin::stringdist_left_join(
    mypubs_orcid,
    by = c(title = "title", year = "year"),
    max_dist = 2,
    ignore_case = TRUE
  ) |>
  # Keep any columns where ORCID missing
  mutate(
    authors.y = if_else(is.na(authors.y), authors.x, authors.y),
    title.y = if_else(is.na(title.y), title.x, title.y),
    journal.y = if_else(is.na(journal.y), journal.x, journal.y),
    year.y = if_else(is.na(year.y), year.x, year.y)
  ) |>
  # Keep the ORCID columns
  select(!ends_with(".x")) |>
  rename_all(~ stringr::str_remove_all(.x, ".y")) |>
  select(-scholar_id, -orcid_id) |>
  select(
    authors,
    year,
    title,
    journal,
    volume,
    issue,
    page,
    details,
    doi,
    citations
  )
```

The tibble contains Google scholar citations for all papers, so we can
find the most cited papers.

``` r
mypubs |>
  arrange(desc(citations))
```

    ## # A tibble: 34 × 10
    ##    authors         year title journal volume issue page  details doi   citations
    ##    <chr>          <int> <chr> <chr>   <chr>  <chr> <chr> <chr>   <chr>     <dbl>
    ##  1 Cameron Zachr…  2021 Risk… Journa… 18     174   2020… 18 (17… 10.1…        55
    ##  2 M. J. Lydeamo…  2022 Burd… Antimi… 11     1     NA    11 (1)… 10.1…        48
    ##  3 James M. Trau…  2021 Unde… Nature… 12     1     NA    12 (1)… 10.1…        43
    ##  4 M.J. Lydeamor…  2019 A bi… Mathem… 309    2019… 163-… 309, 1… 10.1…        29
    ##  5 James H McMah…  2020 Brin… Journa… 76     3     547-… NA      10.1…        24
    ##  6 Cameron Zachr…  2022 COVI… Scienc… 8      14    NA    8 (14)… 10.1…        24
    ##  7 Thiripura Vin…  2017 Indi… PeerJ   5      2017… e3958 5, e39… 10.7…        22
    ##  8 E Conway, CR …  2023 COVI… Procee… NA     NA    NA    290 (2… NA           22
    ##  9 FM Shearer, J…  2024 Esti… Epidem… NA     NA    NA    47, 10… NA           17
    ## 10 Will Cuningha…  2019 High… Austra… 43     2     149-… 43 (2)… 10.1…        16
    ## # ℹ 24 more rows

The `scholar` package provides tools for obtaining your profile
information, such as total citations, h-index, and lists of co-authors.

``` r
scholar::get_profile("miNl6rMAAAAJ")
```

    ## Warning in get_scholar_resp(url, attempts_left - 1): Cannot connect to Google
    ## Scholar. Is the ID you provided correct?

    ## [1] NA

## Teaching

The teaching section will usually involve collecting data on your
teaching performance and teaching innovations.

#### Teaching performance

- Student evaluations
- Emails from grateful students
- Peer review reports

#### Teaching innovations

- Development of new subjects or degrees
- New teaching methods or materials

#### Supervision

- Honours students supervised
- Masters students supervised
- PhD students supervised

Note that a list of PhD students may go in the Research section rather
than the Teaching section.

## Engagement

This section includes suggestions for engagement activities that could
be included in academic promotion applications. These examples are
indicative only and do not provide a list of expectations. Engagement is
interpreted in a broad sense to include discipline, industry, government
and community engagement.

#### Engagement with Industry

- Partnerships with organisations: for profit, not-for-profit,
  volunteering
- Consulting projects -\> could list value of projects, reports
  completed
- Participation in project development programs e.g. CSIRO On Prime
- Patents
- Service on industry boards and/or committees at the local, state or
  national level

#### Engagement with Government

- Policy development, such as changes resulting from your work
- Advocacy programs e.g. Science Meets Parliament
- Service with government bodies

#### Engagement with Public

- Public presentations - list of locations
- Blogging (own blog or collaborative), with stats available from blog
  backend e.g. views, visitors, followers.
- Twitter. Such as number of followers from profile, [Twitter
  analytics](https://analytics.twitter.com) shows impressions,
  engagement rate, likes, retweets, replies (only allows viewing of the
  last 90 days of data).
- Community programs e.g. National Science Week, etc.
- Media appearances e.g. appearances on TV, radio, web.
- Writing for general audience e.g. The Conversation, university news
  platforms (e.g. The Lighthouse).
- Public works e.g. art installations, consulting on museum exhibit.
- Service on community boards and/or committees at the local, state or
  national level.

#### Engagement with Professional Community

- Contributions to community support websites e.g. Stack Overflow
- Data science competitions e.g. Kaggle
- Community engagement projects e.g. citizen science
- Community development e.g. meetup groups, RLadies, rOpenSci,
  hackathons
- Creation of software packages/tools for open use

#### Engagement with Schools

- Curriculum development e.g. STEM at School.
- Interactions with school students e.g. Skype a Scientist (discussing
  science with students).
- University events e.g. Open Day.

#### Contributions to enhancing the employability of graduates

- Establishing student links with industry/professional societies.
- Participating in professional practice teaching e.g. teamwork,
  communication, problem solving, grant writing.

#### Engagement/leadership within one’s profession or discipline

- Professional society membership & activity.
- Membership of professional or foundation boards/councils
- Peer review *(It should go into the research section)*. This can
  include: journal article review, ARC college of experts, grant review
  panels.

## Leadership

This section includes examples of leadership activities in academic
promotion applications.

- University committee (e.g. department, faculty, university-level).
  List how many events/meetings you have in a year.
- Board membership, and list position, length of service.
- Conference organisation. List your role (e.g. scientific committee,
  symposium chair), scale of conference (e.g number of attendees,
  funding, international/local).
- Leading projects and initiatives (e.g. sustainability, diversity
  inclusion initiatives).
- Event organisation (e.g. writing retreat).
- Training events (e.g. university management course). List the course,
  completion date.
- Leadership roles in external professional or industry associations
- Mentoring. List how many mentees you have, length of relationship,
  where they are working now.
