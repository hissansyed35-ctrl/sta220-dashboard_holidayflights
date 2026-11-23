# Purpose: delay and cancellation rates by airport and holiday, plus the national benchmark 

source("scripts/02_clean.R")

# Rates for EWR, LGA, JFK ----------------

# Delay rates count only flights that left (CANCELLED ==0)
#Cancel rates count all scheduled flights. 

airport_rates <- bts_holiday |> 
  filter(ORIGIN %in% c("EWR","JFK","LGA")) |> 
  group_by(ORIGIN, holiday) |> 
  summarize ( 
    flights_scheduled = n(), 
    flights_departed = sum(CANCELLED ==0), 
    flights_delayed = sum(DEP_DEL15 ==1 & CANCELLED ==0), 
    flights_cancelled = sum(CANCELLED ==1), 
    pct_delayed = flights_delayed / flights_departed * 100, 
    pct_cancelled = flights_cancelled / flights_scheduled * 100, 
    .group = "drop"  #removes the grouping afterward, so later steps don’t get confused
    )

airport_rates



# National Benchmark: all US airports ------------- 

national_rates <- bts_holiday |> 
  group_by(holiday) |> 
  summarize(
    flights_scheduled = n(), 
    flights_departed = sum(CANCELLED ==0), 
    flights_delayed = sum(DEP_DEL15==1 & CANCELLED ==0), 
    flights_cancelled = sum(CANCELLED ==1), 
    pct_delayed = flights_delayed / flights_departed *100, 
    pct_cancelled = flights_cancelled / flights_scheduled * 100, 
    .groups="drop"
    )

national_rates






# Rates by airport, year, and holiday ------------------------------

# Same math as airport_rates, but split by YEAR too, so each row can
# be matched to one month of passenger data.
# Thanksgiving travel is in November (11), Christmas in December (12).
airport_year_rates <- bts_holiday |>
  filter(ORIGIN %in% c("EWR", "JFK", "LGA")) |>
  group_by(ORIGIN, YEAR, holiday) |>
  summarize(
    flights_scheduled = n(),
    flights_departed  = sum(CANCELLED == 0),
    flights_delayed   = sum(DEP_DEL15 == 1 & CANCELLED == 0),
    flights_cancelled = sum(CANCELLED == 1),
    pct_delayed   = flights_delayed / flights_departed * 100,
    pct_cancelled = flights_cancelled / flights_scheduled * 100,
    .groups = "drop"
  ) |>
  mutate(MONTH = if_else(holiday == "Thanksgiving", 11, 12))

# Expect 30 rows: 3 airports x 5 years x 2 holidays
dim(airport_year_rates)

# Key check: airport + year + month should be unique (expect 0 rows)
airport_year_rates |>
  count(ORIGIN, YEAR, MONTH) |>
  filter(n > 1)



# Join delay rates with passenger counts ---------------------------

# Before joining (workbook merge check):
#   Key: ORIGIN + YEAR + MONTH
#   Unique in both tables? Yes - both key checks returned 0 rows
#   Same types? ORIGIN is text in both; YEAR and MONTH are numbers
#   Prediction: 30 rows in, 30 rows out, every row matches

delays_passengers <- airport_year_rates |>
  left_join(t100_monthly,
            by = c("ORIGIN", "YEAR", "MONTH"))

# Check 1: still 30 rows? (A bigger number means duplicate keys.)
dim(delays_passengers)

# Check 2: any delay rows with no passenger match? (Expect 0)
airport_year_rates |>
  anti_join(t100_monthly,
            by = c("ORIGIN", "YEAR", "MONTH"))

# Check 3: any passenger rows with no delay match? (Expect 0)
t100_monthly |>
  anti_join(airport_year_rates,
            by = c("ORIGIN", "YEAR", "MONTH"))










# Save the tables the dashboard reads ------------------------------

write_csv(airport_rates, "app/data/airport_rates.csv")
write_csv(national_rates, "app/data/national_rates.csv")
write_csv(delays_passengers, "app/data/delays_passengers.csv")