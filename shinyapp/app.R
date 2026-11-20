library(shiny)
library(spiderorchid)
library(dplyr)

# Define UI for dataset viewer application
ui <- shinyUI(pageWithSidebar(
  # Application title
  headerPanel("Journal Rankings"),

  # Sidebar with controls to select a dataset and specify the number
  # of observations to view
  sidebarPanel(
    selectizeInput(
      "dataset",
      "Choose rankings databases:",
      choices = c("Monash", "ABDC", "CORE", "ERA2010", "SCImago"),
      selected = "Monash",
      multiple = TRUE,
      options = list(plugins = list("remove_button"))
    ),
    textInput("title", "Title to search for:", ""),
    checkboxInput("fuzzy", "Fuzzy matching?", TRUE),
    checkboxInput("only_best", "Only return the best match?", FALSE),
    width = 5,
  ),
  # Show an HTML table with the requested
  # number of observations
  mainPanel(tableOutput("view"), width = 7)
))

# Define server logic required to summarize and view the selected dataset
server <- shinyServer(function(input, output) {
  # Return the requested dataset
  datasetInput <- reactive({
    if (input$title == "" || length(input$dataset) == 0) {
      NULL
    } else {
      purrr::map_dfr(input$dataset, \(db) {
        journal_ranking(
          title = input$title,
          source = tolower(db),
          fuzzy = input$fuzzy,
          only_best = input$only_best
        ) |>
          mutate(database = db, rank = as.character(rank), .before = 1)
      })
    }
  })

  # Show the data
  output$view <- renderTable({
    datasetInput()
  })
})

shinyApp(ui = ui, server = server)
