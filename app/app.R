# app.R
# Dashboard: Which NYC-area airport should you fly out of for the holidays?
# Built from the class template. See "Using the Dashboard Template."
# The data files in app/data/ are made by scripts/03_summarize.R.

library(shiny)
library(tidyverse)


# The Data ---------------------------------------------------------------------------------------

# One row per airport + holiday (2021-2025 combined)
airport_rates <- read_csv("data/airport_rates.csv")

# One row per holiday: all U.S. airports (the benchmark)
national_rates <- read_csv("data/national_rates.csv")

# One row per airport + year + holiday, with that month's passengers
delays_passengers <- read_csv("data/delays_passengers.csv")


# The UI (what the reader sees) ------------------------------------------------------------------

ui <- fluidPage(
  
  titlePanel("Flying home for the holidays: Newark, JFK, or LaGuardia?"),
  p("For: people in the New York City area who fly home for Thanksgiving or winter break (domestic flights)."),
  p("The decision: which of the three big NYC-area airports gives you the best chance of leaving on time."),
  
  selectInput(inputId = "holiday",
              label = "Pick a holiday:",
              choices = c("Thanksgiving", "Christmas")),
  
  h3("Figure 1. Share of flights leaving 15+ minutes late"),
  plotOutput(outputId = "fig_1"),
  p("Each bar is one airport, with all five years (2021-2025) combined. The dashed line is the rate for all U.S. airports on the same days. A bar above the line means that airport had more delays than the country as a whole."),
  
  h3("Table 1. The numbers behind Figure 1"),
  tableOutput(outputId = "table_1"),
  p("The delay rate counts only flights that actually left. The cancellation rate counts every scheduled flight."),
  
  h3("Figure 2. Are busier months more delayed?"),
  plotOutput(outputId = "fig_2"),
  p("Each point is one airport in one year. The x-axis is how many passengers boarded domestic flights at that airport in the whole month. The y-axis is the share of flights delayed on the holiday travel days only."),
  
  h3("What this dashboard cannot tell you"),
  p("It does not measure security lines (TSA does not publish this data), ticket prices, or how long it takes to get to each airport. It covers domestic flights on the larger U.S. airlines only. It shows what happened in 2021-2025, not a prediction for this year."),
  
  h3("Sources"),
  p("U.S. Department of Transportation, Bureau of Transportation Statistics: Reporting Carrier On-Time Performance and T-100 Domestic Segment (All Carriers), November and December 2021-2025. Downloaded November 2026. Holiday travel days: the Saturday through Wednesday before Thanksgiving, and December 18-24.")
  
)


# The Server (how the figures are made) ----------------------------------------------------------

server <- function(input, output) {
  
  output$fig_1 <- renderPlot({
    
    # keep only the holiday the reader picked
    picked_airports <- airport_rates |>
      filter(holiday == input$holiday)
    
    picked_national <- national_rates |>
      filter(holiday == input$holiday)
    
    ggplot(picked_airports,
           aes(x = ORIGIN,
               y = pct_delayed)) +
      geom_col() +
      geom_hline(data = picked_national,
                 aes(yintercept = pct_delayed),
                 linetype = "dashed") +
      labs(
        title = paste0("Share of flights leaving 15+ minutes late: ", input$holiday, " travel days"),
        subtitle = "NYC-area airports, 2021-2025 combined. Dashed line = all U.S. airports.",
        x = "Departure airport",
        y = "Flights delayed (%)",
        caption = "Source: U.S. DOT, Bureau of Transportation Statistics, On-Time Performance, 2021-2025.",
        alt = "Bar chart of the percent of departing flights delayed 15 or more minutes during the chosen holiday travel days, 2021-2025, at Newark, JFK, and LaGuardia, compared with a dashed line for all U.S. airports."
      )
    
  })
  
  output$table_1 <- renderTable({
    
    airport_rates |>
      filter(holiday == input$holiday) |>
      select(ORIGIN, flights_scheduled, flights_departed,
             pct_delayed, pct_cancelled) |>
      mutate(pct_delayed   = round(pct_delayed, digits = 1),
             pct_cancelled = round(pct_cancelled, digits = 1))
    
  })
  
  output$fig_2 <- renderPlot({
    
    picked_passengers <- delays_passengers |>
      filter(holiday == input$holiday) |>
      mutate(passengers_millions = passengers / 1000000)
    
    ggplot(picked_passengers,
           aes(x = passengers_millions,
               y = pct_delayed,
               color = ORIGIN)) +
      geom_point(size = 3) +
      labs(
        title = paste0("Passengers vs. delays: ", input$holiday, ", 2021-2025"),
        subtitle = "Each point is one airport in one year.",
        x = "Passengers boarding domestic flights that month (millions)",
        y = "Holiday flights delayed 15+ min (%)",
        color = "Airport",
        caption = "Sources: U.S. DOT, BTS On-Time Performance and T-100 Domestic Segment, 2021-2025.",
        alt = "Scatter plot of monthly domestic passengers against the percent of holiday flights delayed 15 or more minutes, for Newark, JFK, and LaGuardia, one point per airport per year."
      )
    
  })
  
}


# Run the App ------------------------------------------------------------------------------------

shinyApp(ui = ui, server = server)