library(shiny)
library(bslib)
library(spiderorchid)
library(dplyr)

databases <- c("Monash", "ABDC", "CORE", "SCImago", "ERA2010")

# Map each database's rank labels onto a common scale for colouring and sorting:
# 0 (Monash Group 1+ only), then 1 (best) to 4. Monash Group 1 = A*, Group 2 = A.
rank_tiers <- c(
  "Group 1+" = 0,
  "A*" = 1, "Q1" = 1, "Group 1" = 1,
  "A" = 2, "Q2" = 2, "Group 2" = 2,
  "B" = 3, "Q3" = 3,
  "C" = 4, "Q4" = 4
)

rank_badge <- function(rank) {
  tier <- unname(rank_tiers[as.character(rank)])
  if (is.na(tier)) {
    span(class = "rank tier-NA", "Unranked")
  } else {
    span(class = paste0("rank tier-", tier), rank)
  }
}

# Order rows by a column; rank uses the common tier scale, with unranked rows always last
sort_results <- function(df, col, desc) {
  key <- switch(
    col,
    database = tolower(df$database),
    title = tolower(df$title),
    rank = unname(rank_tiers[df$rank])
  )
  key <- xtfrm(key)
  if (desc) key <- -key
  df[order(is.na(key), key, tolower(df$database), tolower(df$title)), ]
}

sort_header <- function(label, col, sort, class = NULL) {
  active <- !is.null(sort) && sort$col == col
  arrow <- if (!active) "\u21c5" else if (sort$desc) "\u25BC" else "\u25B2"
  tags$th(
    class = paste(c("sortable", if (active) "active", class), collapse = " "),
    `aria-sort` = if (active) (if (sort$desc) "descending" else "ascending") else "none",
    role = "button",
    tabindex = "0",
    onclick = sprintf("Shiny.setInputValue('sort_click', '%s', {priority: 'event'})", col),
    onkeydown = sprintf(
      "if (event.key === 'Enter' || event.key === ' ') { event.preventDefault(); Shiny.setInputValue('sort_click', '%s', {priority: 'event'}); }",
      col
    ),
    label,
    span(class = "sort-arrow", arrow)
  )
}

theme <- bs_theme(
  version = 5,
  preset = "flatly",
  primary = "#234460",
  "link-color" = "#234460",
  base_font = font_google("Fira Sans"),
  heading_font = font_google("Fira Sans"),
  "border-radius" = "0.6rem"
) |>
  bs_add_rules(
    "
    body { background: #f4f6f9; }
    .app-header { display: flex; align-items: center; gap: 1rem; margin: 2rem 0 1.5rem; }
    .app-header img { height: 72px; }
    .app-header h1 { margin: 0; font-weight: 700; color: $primary; }
    .app-header p { margin: 0; color: #5a6b7b; }
    .search-box .form-control { font-size: 1.25rem; padding: 0.75rem 1rem; }
    .search-box .shiny-input-container { width: 100%; }
    .rank {
      display: inline-block; min-width: 4.5em; padding: 0.25em 0.6em;
      border-radius: 999px; font-weight: 600; text-align: center; font-size: 0.9em;
      white-space: nowrap;
    }
    .tier-0 { background: #ffb81c; color: #1b3349; }
    .tier-1 { background: #234460; color: #fff; }
    .tier-2 { background: #4f7397; color: #fff; }
    .tier-3 { background: #b9cbdd; color: #1b3349; }
    .tier-4 { background: #e3e8ee; color: #1b3349; }
    .tier-NA { background: #f1f1f1; color: $gray-600; }
    .db-label { color: $gray-600; font-size: 0.85em; text-transform: uppercase; letter-spacing: 0.05em; }
    .results-table td { vertical-align: middle; }
    .results-table th:first-child, .results-table td:first-child { padding-left: 1rem; }
    .results-table th:last-child, .results-table td:last-child { padding-right: 1rem; }
    .results-table th.sortable { cursor: pointer; user-select: none; white-space: nowrap; }
    .results-table th.sortable:hover, .results-table th.sortable.active { color: $primary; }
    .sort-arrow { margin-left: 0.35em; font-size: 0.75em; opacity: 0.35; }
    .results-table th.active .sort-arrow { opacity: 1; }
    .results-table tr.group-start td { border-top: 2px solid $gray-300; }
    .empty-state { text-align: center; color: $gray-600; padding: 3rem 1rem; }
    .nav-underline { margin-bottom: 1rem; }
    .nav-underline .nav-link { font-weight: 500; }
    .about h2 { font-size: 1.25rem; font-weight: 700; margin: 0 0 0.75rem; }
    .about .card-header { font-weight: 700; }
    .about .card-header small { display: block; font-weight: 400; color: $gray-600; }
    .about p:last-child { margin-bottom: 0; }
    .about dl { display: grid; grid-template-columns: max-content 1fr; gap: 0.4rem 0.75rem; align-items: center; margin: 0.75rem 0; }
    .about dd { margin: 0; }
    .tier-table td { vertical-align: middle; }
    .tier-table .rank { margin: 0.1rem 0.15rem; }
    .app-footer { color: $gray-600; font-size: 0.85em; text-align: center; margin: 2rem 0; }
    .app-footer a { color: inherit; }
    "
  )

ranking_card <- function(name, full_name, description, ranks, source_text, source_url, updated = NULL) {
  card(
    card_header(div(name, tags$small(full_name))),
    card_body(
      p(description),
      tags$dl(purrr::imap(ranks, \(meaning, rank) {
        tagList(tags$dt(rank_badge(rank)), tags$dd(meaning))
      })),
      p(
        class = "small",
        if (!is.null(updated)) tagList("Last updated: ", updated, br()),
        "Source: ",
        a(source_text, href = source_url, target = "_blank")
      )
    )
  )
}

about_panel <- div(
  class = "about",
  card(
    card_body(
      h2("Reading the ranks"),
      p(
        "Each list uses its own labels. To make them easier to compare, ranks are coloured on a",
        "common scale, from darkest (best) to lightest. Sorting by rank uses the same scale."
      ),
      tags$table(
        class = "table table-sm tier-table mb-0",
        tags$tbody(
          tags$tr(tags$td("Elite"), tags$td(rank_badge("Group 1+"))),
          tags$tr(tags$td("Top tier"), tags$td(rank_badge("A*"), rank_badge("Group 1"), rank_badge("Q1"))),
          tags$tr(tags$td("Second tier"), tags$td(rank_badge("A"), rank_badge("Group 2"), rank_badge("Q2"))),
          tags$tr(tags$td("Third tier"), tags$td(rank_badge("B"), rank_badge("Q3"))),
          tags$tr(tags$td("Fourth tier"), tags$td(rank_badge("C"), rank_badge("Q4"))),
          tags$tr(tags$td("Not ranked"), tags$td(rank_badge(NA)))
        )
      ),
      p(
        class = "small text-muted mt-3",
        "The scales are only roughly comparable: a SCImago quartile is based on citations,",
        "while the other lists are assessed by expert panels."
      )
    )
  ),
  layout_column_wrap(
    width = "24rem",
    ranking_card(
      "Monash Business School",
      "Quality Journal List",
      paste(
        "The list used by Monash Business School for research assessment.",
        "It mostly follows ABDC, with extra journals classified by the School",
        "and some highly ranked ERA 2010 journals that are not on ABDC.",
        "Only Group 1+, Group 1 and Group 2 journals are included."
      ),
      c(
        "Group 1+" = "A small set of the very best journals",
        "Group 1" = "Usually ABDC A*",
        "Group 2" = "Usually ABDC A"
      ),
      "Monash research standards (staff login)",
      "https://www.intranet.monash/business/research-services/research-standards",
      updated = "10 July 2025"
    ),
    ranking_card(
      "ABDC",
      "Australian Business Deans Council Journal Quality List",
      "The 2025 ABDC list, covering journals in business, economics and related fields.",
      c(
        "A*" = "Highest quality",
        "A" = "Excellent",
        "B" = "Good",
        "C" = "Meets the quality threshold"
      ),
      "abdc.edu.au",
      "https://abdc.edu.au/abdc-journal-quality-list/",
      updated = "March 2026"
    ),
    ranking_card(
      "CORE",
      "Computing Research and Education Association of Australasia",
      paste(
        "Rankings of computing conferences and journals, set by academic committees",
        "using citation rates, acceptance rates and the standing of the people involved."
      ),
      c(
        "A*" = "Flagship venue, a leader in its discipline",
        "A" = "Excellent and highly respected",
        "B" = "Good and well regarded",
        "C" = "Meets minimum standards"
      ),
      "core.edu.au",
      "https://www.core.edu.au/conference-portal",
      updated = "2023 (conferences), 2020 (journals)"
    ),
    ranking_card(
      "SCImago",
      "SCImago Journal Rank (2025)",
      paste(
        "A citation-based ranking of every journal indexed by Scopus, across all disciplines.",
        "The rank shown is the journal's best quartile over the subject categories it belongs to."
      ),
      c(
        "Q1" = "Top 25% of its category",
        "Q2" = "25\u201350%",
        "Q3" = "50\u201375%",
        "Q4" = "Bottom 25%"
      ),
      "scimagojr.com",
      "https://www.scimagojr.com/journalrank.php",
      updated = "2025"
    ),
    ranking_card(
      "ERA 2010",
      "Excellence in Research for Australia 2010 journal list",
      paste(
        "The Australian Research Council's ranked journal list from the 2010 ERA round.",
        "It was dropped after 2010, so it is out of date, but it covers every discipline",
        "and is still sometimes cited."
      ),
      c(
        "A*" = "Top 5% of journals in the field",
        "A" = "Next 15%",
        "B" = "Next 30%",
        "C" = "Remaining 50%"
      ),
      "Right to Know release of the ERA 2010 list",
      "https://www.righttoknow.org.au/request/journal_list_relating_to_the_201",
      updated = "2010 (no longer updated)"
    )
  )
)

ui <- page_fixed(
  theme = theme,
  title = "Journal Rankings",
  div(
    class = "app-header",
    img(src = "logo.png", alt = "spiderorchid logo"),
    div(
      h1("Journal Rankings"),
      p("Look up journals and conferences across Monash Business School, ABDC, CORE, SCImago and ERA 2010 lists.")
    )
  ),
  navset_underline(
    nav_panel(
      "Search",
      card(
        card_body(
          div(
            class = "search-box",
            textInput(
              "title",
              label = NULL,
              placeholder = "Search for a journal title, e.g. Annals of Statistics"
            )
          ),
          layout_columns(
            col_widths = c(8, 4),
            selectizeInput(
              "dataset",
              "Ranking lists",
              choices = databases,
              selected = "Monash",
              multiple = TRUE,
              width = "100%",
              options = list(plugins = list("remove_button"), dropdownParent = "body")
            ),
            div(
              class = "pt-md-4",
              input_switch("fuzzy", "Fuzzy matching", TRUE),
              input_switch("only_best", "Best match only", FALSE)
            )
          )
        )
      ),
      card(
        card_header(textOutput("summary", inline = TRUE)),
        card_body(uiOutput("results"), padding = 0)
      )
    ),
    nav_panel("About the rankings", about_panel)
  ),
  div(
    class = "app-footer",
    "Built with the ",
    a("spiderorchid", href = "https://numbats.github.io/spiderorchid/"),
    " R package."
  )
)

server <- function(input, output, session) {
  title <- debounce(reactive(trimws(input$title)), 400)

  results <- reactive({
    req(nzchar(title()), length(input$dataset) > 0)
    purrr::map_dfr(input$dataset, \(db) {
      journal_ranking(
        title = title(),
        source = tolower(db),
        fuzzy = input$fuzzy,
        only_best = input$only_best
      ) |>
        mutate(database = db, rank = as.character(rank), .before = 1)
    })
  })

  # NULL means the default order: grouped by list, in the order the lists were chosen
  sort <- reactiveVal(NULL)
  observeEvent(input$sort_click, {
    current <- sort()
    if (!is.null(current) && current$col == input$sort_click) {
      sort(list(col = current$col, desc = !current$desc))
    } else {
      sort(list(col = input$sort_click, desc = FALSE))
    }
  })

  output$summary <- renderText({
    if (!nzchar(title())) {
      "Results"
    } else if (length(input$dataset) == 0) {
      "Choose at least one ranking list"
    } else {
      n <- nrow(results())
      paste0(n, " match", if (n != 1) "es", " for “", title(), "”")
    }
  })

  output$results <- renderUI({
    if (!nzchar(title()) || length(input$dataset) == 0) {
      return(div(class = "empty-state", "Start typing a title above to see its rankings."))
    }
    df <- results()
    if (nrow(df) == 0) {
      return(div(
        class = "empty-state",
        "No matches found. Try turning on fuzzy matching or adding more ranking lists."
      ))
    }
    if (!is.null(sort())) df <- sort_results(df, sort()$col, sort()$desc)
    grouped <- is.null(sort()) || sort()$col == "database"
    first_in_group <- if (grouped) !duplicated(df$database) else rep(TRUE, nrow(df))
    rows <- purrr::pmap(
      list(df$database, df$title, df$rank, first_in_group),
      \(database, title, rank, first) {
        tags$tr(
          class = if (grouped && first) "group-start",
          tags$td(if (first) span(class = "db-label", database)),
          tags$td(title),
          tags$td(class = "text-end", rank_badge(rank))
        )
      }
    )
    tags$table(
      class = "table table-hover results-table mb-0",
      tags$thead(tags$tr(
        sort_header("List", "database", sort()),
        sort_header("Title", "title", sort()),
        sort_header("Rank", "rank", sort(), class = "text-end")
      )),
      tags$tbody(rows)
    )
  })
}

shinyApp(ui = ui, server = server)
