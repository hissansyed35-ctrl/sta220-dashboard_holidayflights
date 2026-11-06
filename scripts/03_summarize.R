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