# Loading Packages
library(shiny)
library(ggplot2)
library(dplyr)
library(DT)
library(tidyverse)
library(shiny)
library(rsconnect)

# Loading data
Baseball <- read_csv(here::here("~/STA 518/Final-Project-518/Shiny/Player spreadsheet-CSV.csv"))
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

all_teams <- sort(unique(Baseball$TEAM))

# Defining UI
ui <- fluidPage(
  
  sidebarLayout(
    
    # Inputs:
    sidebarPanel(
      selectInput(
        inputId = "TEAM",
        label = "Select Team(s):",
        choices = all_teams,
        selected = "Chicago Cubs",
        multiple = TRUE
        
      )
    ),
    
    mainPanel(
      DT::dataTableOutput(outputId = "Baseballtable")
    )
  )
)

# Define server

server <- function(input, output, session) {
  
  #Create data table
  output$Baseballtable <- DT::renderDataTable({
    req(input$TEAM)
    players_from_selected_teams <- Baseball %>%
      filter(TEAM %in% input$TEAM) %>%
      select(PLAYER:OutPct)
    DT::datatable(
      data = players_from_selected_teams,
      options = list(pageLength = 10),
      rownames = FALSE
    )
  })
}
# Create a shiny app object
shinyApp(ui, server)


