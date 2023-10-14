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
  skip = 11,
  col_names = c("Quarter", "Region", "Holiday", "Visiting", "Business", "Other"),
  n_max = 6804
)

# fill NA in "Quarter" using the last obs
fill_na <- domestic_trips %>%
  fill(Quarter, .direction = "down") %>%
  filter(Quarter != "Total")

# separate State from "Region"
state <- c(
  "New South Wales", "Victoria", "Queensland", "South Australia",
  "Western Australia", "Tasmania", "Northern Territory", "ACT"
)
state_na <- fill_na %>%
  mutate(State = if_else(Region %in% state, Region, NA_character_)) %>%
  fill(State, .direction = "up") %>%
  filter(!(Region %in% state))

# gather Stopover purpose of visit
long_data <- state_na %>%
  gather("Purpose", "Trips", Holiday:Other)

# maniputate Quarter
qtr_data <- long_data %>%
  mutate(
    Quarter = paste(gsub(" quarter", "", Quarter), "01"),
    Quarter = yearquarter(myd(Quarter))
  )

# convert to tsibble
tourism <- qtr_data %>%
  as_tsibble(key = c(Region, State, Purpose), index = Quarter)
usethis::use_data(tourism, overwrite = TRUE, compress = "xz")

