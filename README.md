# Which Airport Should You Fly Out Of for the Holidays?

A dashboard comparing how often holiday flights leave late or get
cancelled at Philadelphia (PHL), Newark (EWR), and New York JFK.


## The decision and the audience

- **Decision:** Which airport, PHL, EWR, or JFK, gives you the best
  chance of leaving on time when you fly home for Thanksgiving or
  winter break?
- **Audience:** People who live within reach of all three airports
  and fly home for the holidays. Domestic flights only.
- **Area:** The three airports serving central and northern New
  Jersey. This project is about airports, not a single town.
- **Benchmark:** The national rate for all U.S. airports, for the
  same holiday days and years.

## Data

### 1. Airline On-Time Performance
- **Agency:** U.S. Department of Transportation, Bureau of
  Transportation Statistics (BTS)
- **Dataset:** Reporting Carrier On-Time Performance (1987-present)
- **Link:** https://www.transtats.bts.gov (Aviation → Airline
  On-Time Performance Data → Download)
- **Years:** November and December, 2021-2025 (10 files)
- **Downloaded:** November 5, 2026
- **Settings:** Filter Geography = All; "Prezipped File" unchecked
- **Fields:** Year, Month, DayofMonth, Reporting_Airline, Origin,
  Dest, DepDel15, Cancelled
- **One row is:** one scheduled domestic flight
- **Files:** `data/bts_ontime_YYYY-MM_downloaded-2026-11-05.zip`,
  kept zipped exactly as downloaded




## What is in each folder

- `data/` - raw data, exactly as downloaded. Never edited by hand.
- `scripts/` - R scripts, numbered in the order they run.
- `output/` - files the scripts make (coming soon).

