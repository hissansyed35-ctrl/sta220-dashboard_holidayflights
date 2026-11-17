# Purpose: read the 10 raw files, then stack them into one table and check them before cleaning 
 library(tidyverse)
 
 # Find the raw files ---------------------------------------------
 #bts is The Breaue of Transportation Statistics
 
 bts_files <- c(
   "data/bts_ontime_2021-11_downloaded-2026-11-06.zip",
   "data/bts_ontime_2021-12_downloaded-2026-11-06.zip",
   "data/bts_ontime_2022-11_downloaded-2026-11-06.zip",
   "data/bts_ontime_2022-12_downloaded-2026-11-06.zip",
   "data/bts_ontime_2023-11_downloaded-2026-11-06.zip",
   "data/bts_ontime_2023-12_downloaded-2026-11-06.zip",
   "data/bts_ontime_2024-11_downloaded-2026-11-06.zip",
   "data/bts_ontime_2024-12_downloaded-2026-11-06.zip",
   "data/bts_ontime_2025-11_downloaded-2026-11-06.zip",
   "data/bts_ontime_2025-12_downloaded-2026-11-06.zip"
 )
 
 bts_files 

 length(bts_files) # How many zip files are in the bts_file
 
 # Read and stack the files -------------------------------------
 
 bts_raw <- read_csv(
   bts_files,
   id = "file",
   col_types = cols(
     OP_UNIQUE_CARRIER = col_character(),
     ORIGIN            = col_character(),
     DEST              = col_character()
   )
 )
 
 
 # The three checks --------------------------------------------------
 dim(bts_raw) # When we combine all 10 files into one table we have 5.6 million rows and 9 columns 
 names(bts_raw)
 summary(bts_raw)
 
 
 # Check each file: 
 bts_raw |>     # It should list the 10 files 
   count(file)
 bts_raw |> 
   count(YEAR,MONTH) # Counting each rows from the year and month (2021-2025, Nov-Dec). 
 # This shows that the number of flights in Nov, Dec throughout the years are sroudn the same! 
 
 
 
 
 # Check missing delay values-----------------------------------------
 # A cancellked fligth never depearted, so its delay should techincially be NA 
 
 bts_raw |> 
   count(CANCELLED, delay_missing = is.na(DEP_DEL15))
 
 
 
 
 
 
 
 
 
 
 # T-100 passenger data =============================================
 
 # List the raw files -----------------------------------------------
 
 # The 10 raw passenger files: November and December, 2021 to 2025
 t100_files <- c(
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
 
 # Read and stack ---------------------------------------------------
 
 # Prediction: about 40,000 rows per file, so roughly 400,000 rows,
 # and 9 columns (8 from BTS + 1 "file" column)
 # Codes are names, not amounts, so read them as text.
 t100_raw <- read_csv(
   t100_files,
   id = "file",
   col_types = cols(
     UNIQUE_CARRIER = col_character(),
     ORIGIN         = col_character(),
     DEST           = col_character(),
     CLASS          = col_character()
   )
 )
 
 
 # The three checks -------------------------------------------------
 
 dim(t100_raw)
 names(t100_raw)
 summary(t100_raw)
 
 
 # Check each file --------------------------------------------------
 
 # Expect 10 rows, each with a similar count
 t100_raw |>
   count(YEAR, MONTH)
 
 # What kinds of service are in the data?
 t100_raw |>
   count(CLASS)
 
 # Note on the key --------------------------------------------------
 
 # One row = one airline flying one route (origin to destination)
 # in one month, sometimes split by aircraft type. So airline +
 # origin + destination + month is NOT always unique. We will add
 # up passengers per airport per month before joining.
 