# Loading Packages

library(shiny)
library(ggplot2)
library(dplyr)
library(tools)
library(DT)
library(tidyverse)
library(shiny)
library(rsconnect)

# Loading data

Baseball <- read_csv(here::here("Shiny/Player spreadsheet-CSV.csv"))

Baseball <- rename(Baseball, "Single" = "1B")
Baseball <- rename(Baseball, "SinglePct" = "1B%")
Baseball <- rename(Baseball, "Double" = "2B")
Baseball <- rename(Baseball, "DoublePct" = "2B%")
Baseball <- rename(Baseball, "Triple" = "3B")
Baseball <- rename(Baseball, "TriplePct" = "3B%")
Baseball <- rename(Baseball, "HomeRunPct" = "HR%")
Baseball <- rename(Baseball, "StolenBasePct" = "SB%")
Baseball <- rename(Baseball, "BaseOnBallsPct" = "BB%")
Baseball <- rename(Baseball, "StrikeoutPct" = "K%")
Baseball <- rename(Baseball, "OutPct" = "OUT%")

# Defining UI
ui <- fluidPage(
  titlePanel("Team browser"),
  
  sidebarLayout(
    
    # Inputs: Select variables to plot
    sidebarPanel(
      
      # Select variables for y-axis
      selectInput(
        inputId = "y",
        label = "Y-Axis:",
        choices = c("Plate Appearances" = "PA",
                    "Batting Average" = "AVG",
                    "On-Base Percentage" = "OBP",
                    "Slugging Percentage" = "SLG",
                    "On-base plus Slugging Percentage" = "OPS",
                    "Singles" = "Single", "Single Percentage" = "SinglePct",
                    "Doubles" = "Double", "Double Percentage" = "DoublePct",
                    "Triples" = "Triple", "Triple Percentage" = "TriplePct",
                    "Home Runs" = "HR","Home Run Percentage" = "HomeRunPct",
                    "Runs" = "R",
                    "Runs Batted In" = "RBI",
                    "Stolen Bases" = "SB",
                    "Caught Stealing" = "CS",
                    "Stolen Base Percentage" = "StolenBasePct",
                    "Base on Balls" = "BB", "Base on Balls Percentage" = "BaseOnBallsPct",
                    "Strikeouts" = "K", "Strikeout Percentage" = "StrikeoutPct", 
                    "Hit by Pitch" = "HBP",
                    "Percentage of all other Outs" = "OutPct"),
        selected = "PA"),
      
      
      # Select variables for x-axis
       selectInput(
       inputId = "x",
       label = "X-axis:",
       choices = c("Plate Appearances" = "PA",
                   "Batting Average" = "AVG",
                   "On-Base Percentage" = "OBP",
                   "Slugging Percentage" = "SLG",
                   "On-base plus Slugging Percentage" = "OPS",
                   "Singles" = "Single", "Single Percentage" = "SinglePct",
                   "Doubles" = "Double", "Double Percentage" = "DoublePct",
                   "Triples" = "Triple", "Triple Percentage" = "TriplePct",
                   "Home Runs" = "HR","Home Run Percentage" = "HomeRunPct",
                   "Runs" = "R",
                   "Runs Batted In" = "RBI",
                   "Stolen Bases" = "SB",
                   "Caught Stealing" = "CS",
                   "Stolen Base Percentage" = "StolenBasePct",
                   "Base on Balls" = "BB", "Base on Balls Percentage" = "BaseOnBallsPct",
                   "Strikeouts" = "K", "Strikeout Percentage" = "StrikeoutPct", 
                   "Hit by Pitch" = "HBP",
                   "Percentage of all other Outs" = "OutPct"),
       selected = "AVG"),
      
      # Select variables for color
      selectInput(inputId = "z", 
                  label = "Color by:",
                  choices = c("PLAYER", "POSITION", "Bats"),
                  selected = "PLAYER"),
      
      textInput(
        inputId = "plot_title",
        label = "Plot title",
        placeholder = "Enter text for plot title"),
      
      checkboxGroupInput(
        inputId = "selected_team",
        label = "Select Team(s):",
        choices = c("Arizona Diamondbacks", "Atlanta Braves", "Baltimore Orioles", 
                    "Boston Red Sox", "Chicago Cubs", "Chicago White Sox", "Cincinnati Reds", 
                    "Cleveland Indians", "Colorado Rockies", "Detroit Tigers", 
                    "Houston Astros", "Kansas City Royals", "Los Angeles Angels", 
                    "Los Angeles Dodgers", "Miami Marlins", "Milwaukee Brewers", 
                    "Minnesota Twins", "New York Mets", "New York Yankees", 
                    "Oakland Athletics", "Philadelphia Phillies", "Pittsburgh Pirates", 
                    "San Diego Padres", "San Francisco Giants", "Seattle Mariners", 
                    "St. Louis Cardinals", "Tampa Bay Rays", "Texas Rangers", 
                    "Toronto Blue Jays", "Washington Nationals"),
        selected = "Chicago Cubs")
    ),
    
    mainPanel(
      plotOutput(outputId = "scatterplot"),
      textOutput(outputId = "description")
    )
  )
)

# Define server

server <- function(input, output, session) {
  
  # Create a subset of data filtering for selected teams
  Baseball_subset <- reactive({
    req(input$selected_team)
    filter(Baseball, TEAM %in% input$selected_team)
  })
  
  #Convert plot_title toTitleCase
  cool_plot_title <- reactive({
    toTitleCase(input$plot_title)
  })
  
  #Create scatterplot object the plotOutput function is expecting
  output$scatterplot <- renderPlot({
    ggplot(data = Baseball_subset(), aes_string(x = input$x,
                                       y = input$y,
                                       color = input$z)) +
      geom_point() +
      labs(title = cool_plot_title())
  })
  
  # Create descriptive text
  output$description <- renderText({
    paste0("The plot above titled '", cool_plot_title(), "' visualizes the 
           relationship between ", input$x, " and ", input$y, ", conditional on ",
           input$z, ".")
  })
}

# Create a shiny app object
shinyApp(ui = ui, server = server)


