library(shiny)
ui <- fluidPage(
  textInput("name", "Hi gorgeous! What's your name?"),
  textOutput("greeting")
)

server <- function(input, output, session) {
  output$greeting <- renderText({
    paste("Hi", input$name)
  })
}

shinyApp(ui, server)