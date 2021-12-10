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

all_players <- sort(unique(Baseball$PLAYER))

# Defining UI
ui <- fluidPage(
  
  sidebarLayout(
    
    # Inputs:
    sidebarPanel(
      selectInput(
        inputId = "PLAYER",
        label = "Select Player(s):",
        choices = all_players,
        selected = "Javier Baez",
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
    req(input$PLAYER)
    selected_players <- Baseball %>%
      filter(PLAYER %in% input$PLAYER) %>%
      select(PLAYER:OutPct)
    DT::datatable(
      data = selected_players,
      options = list(pageLength = 10),
      rownames = FALSE
    )
  })
}
# Create a shiny app object
shinyApp(ui, server)


