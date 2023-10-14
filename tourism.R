library(tsibble)
library(tidyverse)
library(lubridate)

# Data downloaded from Monash A-Z Databases
# "Tourism Research Australia online for students"
# Row: Quarter/SA2
# Column: Stopover reason was Holiday, Visiting friends and relatives, Business, Other reason
# Sum Overnight trips ('000)
# Australia: Domestic Overnight Trips ('000) ----
domestic_trips <- read_csv(
  "data/domestic_trips_2023-10-08.csv",
  skip = 9,
  col_names = c("Quarter", "Region", "Holiday", "Visiting", "Business", "Other", "Total"),
  n_max = 248056
) %>% select(-X8)

# fill NA in "Quarter" using the last obs
fill_na <- domestic_trips %>%
  fill(Quarter, .direction = "down") %>%
  filter(Quarter != "Total")

# gather Stopover purpose of visit
long_data <- fill_na %>%
  pivot_longer(cols=Holiday:Total,
               names_to="Purpose",
               values_to="Trips")

# manipulate Quarter
qtr_data <- long_data %>%
  mutate(
    Quarter = paste(gsub(" quarter", "", Quarter), "01"),
    Quarter = yearquarter(myd(Quarter))
  )

# convert to tsibble
tourism <- qtr_data %>%
  as_tsibble(key = c(Region, Purpose), index = Quarter)
usethis::use_data(tourism, overwrite = TRUE, compress = "xz")

