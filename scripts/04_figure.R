# Purpose: first figure - Christmas delays @ NYC airports comapred with national rate. 

source("scripts/03_summarize.R")


# Keep only Christmas holiday -----------------------

xmas_airports <- airport_rates |> 
  filter(holiday== "Christmas")

xmas_national <- national_rates |> 
  filter(holiday=="Christmas")

# Figure ------------------------------------------------------------

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

fig_xmas


# Save --------------------------------------------------------------

ggsave("output/fig01_christmas_delays.png",
       plot = fig_xmas,
       width = 7,
       height = 5)