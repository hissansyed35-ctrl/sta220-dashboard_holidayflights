# Purpose: Keep only holiday travel days and label them (Thanksgiving and Winter break)


# runs all of the 01 imports, so bts_raw is ready to use -------------
source ("scripts/01_import.R")




# Label holiday travel days ----------------------------------------

# Thanksgiving = Saturday to Wednesday before Thanksgiving
# (dates change each year). Christmas = Dec 18-24.

bts_labeled <- bts_raw |>
  mutate(
    holiday = case_when(
      YEAR == 2021 & MONTH == 11 & DAY_OF_MONTH >= 20 & DAY_OF_MONTH <= 24 ~ "Thanksgiving",
      YEAR == 2022 & MONTH == 11 & DAY_OF_MONTH >= 19 & DAY_OF_MONTH <= 23 ~ "Thanksgiving",
      YEAR == 2023 & MONTH == 11 & DAY_OF_MONTH >= 18 & DAY_OF_MONTH <= 22 ~ "Thanksgiving",
      YEAR == 2024 & MONTH == 11 & DAY_OF_MONTH >= 23 & DAY_OF_MONTH <= 27 ~ "Thanksgiving",
      YEAR == 2025 & MONTH == 11 & DAY_OF_MONTH >= 22 & DAY_OF_MONTH <= 26 ~ "Thanksgiving",
      MONTH == 12 & DAY_OF_MONTH >= 18 & DAY_OF_MONTH <= 24 ~ "Christmas",
      .default = NA
    )
  )




# Keep only holiday travel days and remove the rest--------------

# Prediction: 50 travel days (10 per year both months x 5 years)
bts_holiday <- bts_labeled |> 
  filter(!is.na(holiday))

dim(bts_holiday)

# Expect 10 rows: Thanksgiving and Christmas for each year 
bts_holiday |> 
  count(YEAR, holiday)

# Expect 50 rows: one per travel day 
bts_holiday |> 
  count(YEAR, MONTH, DAY_OF_MONTH)
