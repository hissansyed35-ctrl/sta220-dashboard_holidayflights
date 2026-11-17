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




# Thanksgiving figure ===============================================

# Keep only Thanksgiving -------------------------------------------

thanks_airports <- airport_rates |>
  filter(holiday == "Thanksgiving")

thanks_national <- national_rates |>
  filter(holiday == "Thanksgiving")

# Figure ------------------------------------------------------------

fig_thanks <- ggplot(thanks_airports,
                     aes(x = ORIGIN,
                         y = pct_delayed)) +
  geom_col() +
  geom_hline(data = thanks_national,
             aes(yintercept = pct_delayed),
             linetype = "dashed") +
  labs(
    title = "Share of flights leaving 15+ minutes late, Thanksgiving travel",
    subtitle = "Saturday-Wednesday before Thanksgiving, 2021-2025 combined. Dashed line = all U.S. airports.",
    x = "Departure airport",
    y = "Flights delayed (%)",
    caption = "Source: U.S. DOT, Bureau of Transportation Statistics, On-Time Performance, 2021-2025.",
    alt = "Bar chart of the percent of departing flights delayed 15 or more minutes during the Saturday through Wednesday before Thanksgiving, 2021-2025, at Newark, JFK, and LaGuardia, compared with a dashed line for all U.S. airports."
  )

fig_thanks

# Save --------------------------------------------------------------

ggsave("output/fig02_thanksgiving_delays.png",
       plot = fig_thanks,
       width = 7,
       height = 5)





# Passengers vs. delays figure =====================================

# Passengers in millions, so the axis is easy to read --------------

delays_passengers_plot <- delays_passengers |>
  mutate(passengers_millions = passengers / 1000000)

# Figure ------------------------------------------------------------

fig_busy <- ggplot(delays_passengers_plot,
                   aes(x = passengers_millions,
                       y = pct_delayed,
                       color = ORIGIN)) +
  geom_point(size = 3) +
  labs(
    title = "Are busier months more delayed at NYC airports?",
    subtitle = "Each point is one airport in one holiday period (Thanksgiving or Christmas), 2021-2025.",
    x = "Passengers boarding domestic flights that month (millions)",
    y = "Holiday flights delayed 15+ min (%)",
    color = "Airport",
    caption = "Sources: U.S. DOT, Bureau of Transportation Statistics: On-Time Performance and T-100 Domestic Segment, 2021-2025. Passengers are monthly totals; delays are for holiday travel days only.",
    alt = "Scatter plot of monthly domestic passengers against the percent of holiday flights delayed 15 or more minutes, for Newark, JFK, and LaGuardia, Thanksgiving and Christmas 2021-2025. Each airport is a different color."
  )

fig_busy

# Save --------------------------------------------------------------

ggsave("output/fig03_passengers_vs_delays.png",
       plot = fig_busy,
       width = 7,
       height = 5)