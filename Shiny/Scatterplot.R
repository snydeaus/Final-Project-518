# Loading Packages

library(shiny)
library(ggplot2)
library(dplyr)
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
                  choices = c("TEAM", "POSITION", "Bats"),
                  selected = "TEAM")
      
    ),
    mainPanel(
      tabsetPanel(type = "tabs",
                  tabPanel("scatterplot", plotOutput("scatterplot")),
                  tabPanel("Baseball", tableOutput("mytable")))
    )
  )
)

# Define server

server <- function(input, output, session) {
  
  output$scatterplot <- renderPlot({
    ggplot(data = Baseball, aes_string(x = input$x,
                                       y = input$y,
                                       color = input$z)) +
      geom_point()
  })
}

# Create a shiny app object
shinyApp(ui = ui, server = server)


