# Loading Packages

library(tidyverse)
library(shiny)

# Loading data

Player_spreadsheet_CSV <- read_csv("Player spreadsheet-CSV.csv")
View(Player_spreadsheet_CSV)

# Defining UI
ui <- fluidPage(
  
  sidebarLayout(
    
    # Inputs: Select variables to plot
    sidebarPanel(
      
      # Select variables for y-axis
      selectInput(
        inputId = "y",
        label = "Y-Axis:",
        choices = c("PA", "AVG", "OBP",
                    "SLG", "OPS", "1B", "1B%", "2B", "2B%", "3B", "3B%", "HR",
                    "HR%", "R", "RBI", "SB", "CS", "SB%", "BB", "BB%", "K",
                    "K%", "HBP", "OUT%"),
        selected = "PA"),
      
      
      # Select variables for x-axis
       selectInput(
       inputId = "x",
       label = "X-axis:",
       choices = c("PA", "AVG", "OBP",
                   "SLG", "OPS", "1B", "1B%", "2B", "2B%", "3B", "3B%", "HR",
                   "HR%", "R", "RBI", "SB", "CS", "SB%", "BB", "BB%", "K",
                   "K%", "HBP", "OUT%"),
       selected = "AVG"),
      
     # selectizeInput(
      #  inputId = "PLAYER",
       # label = "Select Player",
        #choices = unique(Player_spreadsheet_CSV$PLAYER),
        #multiple = TRUE
      #),
      
      # Select variables for color
      selectInput(inputId = "z", 
                  label = "Color by:",
                  choices = c("TEAM", "POSITION", "BATS"),
                  selected = "TEAM")
      
    ),

    mainPanel(
      plotOutput(outputId = "scatterplot")
    )
  )
)

# Define server

server <- function(input, output, session) {
  output$scatterplot <- renderPlot({
    ggplot(data = Player_spreadsheet_CSV, aes_string(x = input$x,
                                                     y = input$y,
                                                     color = input$z)) +
      geom_point()
  })
}

# Create a shiny app object
shinyApp(ui, server)


