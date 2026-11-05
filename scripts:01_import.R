# 01_import.R
# Purpose: read the raw BTS on-time file and check what's in it.

library(tidyverse)  # for read_csv(), glimpse(), count()

# Read the zipped CSV directly; the raw file is never changed
dec25 <- read_csv("data/bts_ontime_2025-12_downloaded-2026-11-05.zip")

# How many rows (flights) and columns?
dim(dec25)

# Column names, types, and the first few values of each
glimpse(dec25)

# How many flights left from each of our three airports?
dec25 |>
  count(ORIGIN) |>
  filter(ORIGIN %in% c("PHL", "EWR", "JFK"))







# --- Convert the date from text to a real date ---
# "12/1/2025 12:00:00 AM" -> month/day/year, then drop the fake time
dec25 <- dec25 |>
  mutate(flight_date = as.Date(mdy_hms(FL_DATE)))

# Check: should show 2025-12-01 to 2025-12-31
range(dec25$flight_date)

# --- Check missing delay values ---
# Are the blank DEP_DEL15 values the cancelled flights?
dec25 |>
  count(CANCELLED, missing_delay = is.na(DEP_DEL15))

# --- First look at the rates for the whole month ---
# Delay rate: share of flights that actually left and were 15+ min late
# Cancel rate: share of all scheduled flights that were cancelled
dec25 |>
  mutate(airport = if_else(ORIGIN %in% c("PHL", "EWR", "JFK"), ORIGIN, "U.S. (all airports)")) |>
  group_by(airport) |>
  summarise(
    flights     = n(),
    pct_delayed = mean(DEP_DEL15[CANCELLED == 0], na.rm = TRUE) * 100,
    pct_cancel  = mean(CANCELLED) * 100
  )