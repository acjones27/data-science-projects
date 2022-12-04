library(shiny)
ui <- fluidPage(
  sliderInput("x", "If x is", min = 1, max = 50, value = 30),
  sliderInput("y", "If y is", min = 1, max = 50, value = 6),
  "then x multiplied by y is", textOutput("product")
)

server <- function(input, output, session){
  output$product <- renderText({
    input$x * input$y
  })
}

app <- shinyApp(ui, server)