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
 