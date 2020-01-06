library(shiny)

animals <- c("cat", "dog", "hamster", "penguin")

ui <- fluidPage(
  textInput("name", "What's your name?", placeholder = "Joe Bloggs"),
  passwordInput("password", "What's your password?"),
  textAreaInput("story", "Tell me a bit about yourself", rows = 3),
  numericInput("num", "Number one", value = 0, min = 0, max = 100),
  sliderInput("num2", "Number two", value = 50, min = 0, max = 100),
  sliderInput("rng", "Range", value = c(10,20), min = 0, max = 100),
  dateInput("dob", "Where were you born?"),
  dateRangeInput("holiday", "When do you want to go on holiday?"),
  selectInput("state", "What's your favourite state?", state.name, multiple = TRUE),
  radioButtons("animal", "What's your favourite animal?", animals),
  radioButtons("rb", "Pick one:", choiceNames = list(
    icon("angry"),
    icon("smile"),
    icon("sad-tear")
  ), 
  choiceValues = list("angry", "happy", "sad")
  ),
  checkboxGroupInput("animal", "What animals do you like?", animals),
  checkboxInput("cleanup", "Cleanup?", value = TRUE),
  checkboxInput("shutdown", "Shutdown?"),
  fileInput("upload", NULL),
  actionButton("click", "Click me!"),
  actionButton("drink", "Let's drink!", icon = icon("cocktail")),
  sliderInput("date_slide", "When should we deliver", value = as.Date("2019-08-10"), min = as.Date("2019-08-09"), max = as.Date("2019-08-16")),
  selectInput("state", "What's your favourite state?", list("Dogs" = c("Corgi", "Huskey", "Daschund"), "Cats" = c("Brown", "Black", "Siamese"), "Hamsters" = c("Hamster", "Russian Hamsters")), multiple = TRUE),
  sliderInput("range_step", "Range with step", value = 5, min = 0, max = 50, step = 5),
  textInput("blah", "Blah"),
  textOutput("text"),
  verbatimTextOutput("code"),
  tableOutput("static"),
  dataTableOutput("dynamic"),
  plotOutput("plot", width = "700px", height = "300px"),
  fluidRow(
    splitLayout(cellWidths = c("50%", "50%"), plotOutput("plot1"), plotOutput("plot2"))
  )
  
  
)

server <- function(input, output, session){
  # renderText() displays text returned by the code
  # renderPrint() displays text printed by the code
  output$text <- renderText("Hello, there!")
  output$code <- renderPrint(summary(1:10))
  
  # tableOutput is more useful for small, fixed summaries
  output$static <- renderTable(head(mtcars))
  # dataTableOutput is better if you want to give the complete dataframe to the user
  output$dynamic <- renderDataTable(mtcars, options = list(pageLength = 5, searching = FALSE, ordering = FALSE, filtering = FALSE))
  
  output$plot <- renderPlot(plot(1:5))
  output$plot1 <- renderPlot(plot(1:10))
  output$plot2 <- renderPlot(plot(1:20))
}

app <- shinyApp(ui, server)