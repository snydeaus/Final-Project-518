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

n_total <- nrow(Baseball)

# Defining UI
ui <- fluidPage(
  
  sidebarLayout(
    
    # Inputs: Select variables to plot
    sidebarPanel(
      
      # Select variables for y-axis
      HTML(paste("Enter a value between 1 and", n_total)),
      
      numericInput(
        inputId = "n",
        label = "Sample size:",
        value = 270,
        min = 1, max = n_total,
        step = 1
      )
    ),
    
    mainPanel(
      DT::dataTableOutput(outputId = "Baseballtable")
    )
  )
)

# Define server

server <- function(input, output, session) {
  output$Baseballtable <- DT::renderDataTable({
    Baseball_sample <- Baseball %>%
      sample_n(input$n) %>%
      select(PLAYER:OutPct)
    DT::datatable(
      data = Baseball_sample,
      options = list(pageLength = 10),
      rownames = FALSE
    )
  })
}
# Create a shiny app object
shinyApp(ui, server)


