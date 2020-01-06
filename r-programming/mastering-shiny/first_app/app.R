library(shiny)
ui <- fluidPage(
  "Hello, Anna!\n\n",
  selectInput("dataset", label = "Dataset", choices = ls("package:datasets")),
  verbatimTextOutput("summary"),
  tableOutput("table")
)

server <- function(input, output, session) {
  dataset <- reactive({
    get(input$dataset, "package:datasets")
  })
  
  output$summary <- renderPrint({
    summary(dataset())
  })
  
  output$table <- renderTable({
    # dataset <- get(input$dataset, "package:datasets")
    # dataset
    # Now that we have the reactive function, we can replace the above code with something simpler
    dataset()
  })
}

shinyApp(ui, server)