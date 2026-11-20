# app.R
# A base dashboard to edit for your final project. See "Using the Dashboard Template."
# Based on "Hello Shiny!" https://shiny.posit.co/r/gallery/start-simple/faithful/

library(shiny)
library(tidyverse)


# The Data ---------------------------------------------------------------------------------------

# Save your cleaned data in app/data/, then delete the # below.
# Yes, you will have cleaned data in two places in your repo.
my_data <- c(
  "data/bts_ontime_2021-11_downloaded-2026-11-06.zip",
  "data/bts_ontime_2021-12_downloaded-2026-11-06.zip",
  "data/bts_ontime_2022-11_downloaded-2026-11-06.zip",
  "data/bts_ontime_2022-12_downloaded-2026-11-06.zip",
  "data/bts_ontime_2023-11_downloaded-2026-11-06.zip",
  "data/bts_ontime_2023-12_downloaded-2026-11-06.zip",
  "data/bts_ontime_2024-11_downloaded-2026-11-06.zip",
  "data/bts_ontime_2024-12_downloaded-2026-11-06.zip",
  "data/bts_ontime_2025-11_downloaded-2026-11-06.zip",
  "data/bts_ontime_2025-12_downloaded-2026-11-06.zip", 
  "data/bts_t100_2021-11_downloaded-2026-11-17.zip",
  "data/bts_t100_2021-12_downloaded-2026-11-17.zip",
  "data/bts_t100_2022-11_downloaded-2026-11-17.zip",
  "data/bts_t100_2022-12_downloaded-2026-11-17.zip",
  "data/bts_t100_2023-11_downloaded-2026-11-17.zip",
  "data/bts_t100_2023-12_downloaded-2026-11-17.zip",
  "data/bts_t100_2024-11_downloaded-2026-11-17.zip",
  "data/bts_t100_2024-12_downloaded-2026-11-17.zip",
  "data/bts_t100_2025-11_downloaded-2026-11-17.zip",
  "data/bts_t100_2025-12_downloaded-2026-11-17.zip"
) 


# The UI (what the reader sees) ------------------------------------------------------------------

ui <- fluidPage(
  
  titlePanel("your title"),
  p("For: who is making the decision"),
  p("The decision: the one decision this dashboard helps with"),
  
  selectInput(inputId = "pick", label = "Pick one:", choices = c("choice 1", "choice 2")),
  
  h3("Figure 1. title"),
  plotOutput(outputId = "fig_1"),
  p("a sentence or two saying what the figure shows."),
  
  h3("Figure 2. title"),
  plotOutput(outputId = "fig_2"),
  p("a sentence or two saying what the figure shows."),
  
  h3("What this dashboard cannot tell you"),
  p("the limits of your data.")
  
)


# The Server (how the figures are made) ----------------------------------------------------------

server <- function(input, output) {
  
  output$fig_1 <- renderPlot({
    
    fig_xmas <- ggplot(xmas_airports,
                       aes(x = ORIGIN,
                           y = pct_delayed)) +
      geom_col() +
      geom_hline(data = xmas_national,
                 aes(yintercept = pct_delayed),
                 linetype = "dashed") +
      labs(
        title = "Share of flights leaving 15+ minutes late, Dec 18-24",
        subtitle = "NYC-area airports, 2021-2025 combined. Dashed line = all U.S. airports.",
        x = "Departure airport",
        y = "Flights delayed (%)",
        caption = "Source: U.S. DOT, Bureau of Transportation Statistics, On-Time Performance, 2021-2025.",
        alt = "Bar chart of the percent of departing flights delayed 15 or more minutes during Dec 18-24, 2021-2025, at Newark, JFK, and LaGuardia, compared with a dashed line for all U.S. airports."
      )
    
    fig_xmas     # replace with your code for Figure 1
    
  })
  
  output$fig_2 <- renderPlot({
    
    ggplot()     # replace with your code for Figure 2
    
  })
  
}


# Run the App ------------------------------------------------------------------------------------

shinyApp(ui = ui, server = server)