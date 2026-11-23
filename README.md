# Flying Home for the Holidays: Newark, JFK, or LaGuardia?

This dashboard helps people in the New York City area pick which airport to fly out of when they go home for Thanksgiving or winter break. It compares how often flights left late or got cancelled at Newark (EWR), JFK, and LaGuardia (LGA), and compares each one to all U.S. airports.

## The decision and the audience

- **Decision:** Which of the three big NYC-area airports gives me the best chance of leaving on time when I fly home for the holidays?
- **Audience:** People who live close enough to choose between Newark, JFK, and LaGuardia, and who fly home for Thanksgiving or winter break. Domestic flights only.
- **Area:** This project is about the three main NYC-area airports, not one town. My professor approved this.
- **Benchmark:** The rate for all U.S. airports on the same holiday days and years.

## Data

I used two datasets. Both come from the U.S. Department of Transportation, Bureau of Transportation Statistics (BTS). Both are free and public, and the raw files are in the `data/` folder exactly as I downloaded them.

### 1. On-time flight data (delays and cancellations)

- **Dataset:** Reporting Carrier On-Time Performance (1987-present)
- **Agency:** U.S. Department of Transportation, Bureau of Transportation Statistics
- **Download page:** https://www.transtats.bts.gov/DL_SelectFields.aspx?gnoyr_VQ=FGJ&QO_fu146_anzr=b0-gvzr
- **What each file is:** One full month of every domestic flight reported to BTS, from every U.S. airport. That is about 550,000 to 600,000 flights per file. One row is one scheduled flight.
- **Files:** 10 files, November and December of 2021, 2022, 2023, 2024, and 2025
- **Downloaded:** November 6, 2026
- **File names:** `data/bts_ontime_YYYY-MM_downloaded-2026-11-06.zip`

**How to get the same files:**
1. Go to https://www.transtats.bts.gov
2. Click **Aviation**, then **Airline On-Time Performance Data**, then **Reporting Carrier On-Time Performance (1987-present)**, then **Download**. (Or use the download page link above.)
3. Set **Filter Geography** to **All**.
4. Set **Filter Year** and **Filter Period** to one month (BTS only lets you download one month at a time).
5. Make sure **Prezipped File** is **unchecked**, so you only get the fields you pick.
6. Check only these 8 fields: `Year`, `Month`, `DayofMonth`, `Reporting_Airline`, `Origin`, `Dest`, `DepDel15`, `Cancelled`. Be careful to pick **DayofMonth**, not DayOfWeek. They are right next to each other.
7. Click **Download**. You get a .zip file with one .csv inside.
8. Rename it to the pattern above and put it in `data/`. Do not unzip it. R reads the zip file directly.
9. Repeat for all 10 months.

**Note:** BTS names some columns differently in the file than on the download page. For example, `DayofMonth` becomes `DAY_OF_MONTH`, and `Reporting_Airline` becomes `OP_UNIQUE_CARRIER`.

### 2. Passenger data (how busy each airport was)

- **Dataset:** T-100 Domestic Segment (All Carriers)
- **Agency:** U.S. Department of Transportation, Bureau of Transportation Statistics
- **Download page:** https://www.transtats.bts.gov/DL_SelectFields.aspx?gnoyr_VQ=FIM&QO_fu146_anzr=Nv4%20Pn44vr45 
- **What each file is:** One month of passenger counts reported by airlines. One row is one airline flying one route in one month (sometimes split by aircraft type). About 35,000 to 40,000 rows per file.
- **Files:** 10 files, November and December of 2021-2025
- **Downloaded:** November 17, 2026
- **File names:** `data/bts_t100_YYYY-MM_downloaded-2026-11-17.zip`

**How to get the same files:**
1. Go to https://www.transtats.bts.gov
2. Click **Aviation**, then **Air Carrier Statistics (Form 41 Traffic) - All Carriers**, then **T-100 Domestic Segment (All Carriers)**, then **Download**. (Or use the download page link above.)
3. Set **Filter Geography** to **All**, and set **Filter Year** and **Filter Period** to one month.
4. Make sure **Prezipped File** is **unchecked**.
5. Check only these 8 fields: `Year`, `Month`, `Origin`, `Dest`, `UniqueCarrier`, `Passengers`, `DeparturesPerformed`, `Class`.
6. Click **Download**, rename the .zip to the pattern above, and put it in `data/` without unzipping.
7. Repeat for all 10 months.


## How to run it

1. Install R and RStudio.
2. Install the packages (only once):
   ```r
   install.packages(c("tidyverse", "shiny"))
   ```
3. Download or clone this repository, then open `sta220-dashboard_holidayflights.Rproj`.
4. Run the scripts in order. Each one runs the one before it with `source()`, so running `04_figure.R` runs everything.

| Script | What it does |
|---|---|
| `scripts/01_import.R` | Reads the 20 raw files and checks them |
| `scripts/02_clean.R` | Keeps only the holiday travel days, and keeps only scheduled passenger flights from EWR, JFK, and LGA in the passenger data |
| `scripts/03_summarize.R` | Calculates delay and cancellation rates and the national benchmark, joins in the passenger counts, and saves the tables the app uses to `app/data/` |
| `scripts/04_figure.R` | Makes the figures and saves them to `output/` |

5. To open the dashboard on your computer, open `app/app.R` and click **Run App**.


## What is in each folder

- `data/` - the raw data, exactly as downloaded. Never edited by hand.
- `scripts/` - the R scripts, numbered in the order they run.
- `output/` - the figures the scripts make.
- `app/` - the dashboard. `app/app.R` is the app, and `app/data/` holds the small cleaned tables it reads (made by `03_summarize.R`).
- The research log (`research_log.docx`) has every coding decision and every AI chat.

## Main decisions

All my decisions and the reasons for them are in the research log. The main ones:

- **Holiday travel days:** the Saturday through Wednesday before Thanksgiving (the dates change every year), and December 18-24.
- **Years:** 2021-2025. I left out 2020 because COVID travel was not normal.
- **Departures only**, because the audience is leaving from these airports.
- **Delayed** means the flight left 15 or more minutes late. This is the U.S. Department of Transportation's standard. The delay rate only counts flights that actually left.
- **Cancelled** rate is cancelled flights out of all scheduled flights.
- **Passenger data:** I only kept scheduled passenger flights (service class F), because the on-time data only covers scheduled flights.
- **Joining the two datasets:** I joined them on airport, year, and month. All 30 rows matched (3 airports x 5 years x 2 months).

## What this dashboard cannot tell you

- Security line wait times (TSA does not publish this data)
- Ticket prices or how long it takes to get to each airport
- International flights, or flights on small airlines that do not report to BTS
- The passenger counts are for the whole month, not just the holiday days
- What will happen this year. It shows what happened in 2021-2025, not a prediction.

