
library(sf)
library(rmapshaper)

# 📍 Mapping: sighting per region?

# According to the Data Source [TRA](https://www.tra.gov.au/en/regional/tourism-regions.html), tourism regions are Statistical Area Level 2s (SA2s).
# Get tourism regions **Shapes files** data from [ABS's Australian Statistical Geography Standard (ASGS) Edition 3](https://www.abs.gov.au/statistics/standards/australian-statistical-geography-standard-asgs-edition-3/jul2021-jun2026/access-and-downloads/digital-boundary-files)

# Count sighting per each tourism region (SA2)

# Get shapefile
t_region <- st_read(here::here("data/SA2_2021_AUST_SHP_GDA2020/SA2_2021_AUST_GDA2020.shp")) |>
  ms_simplify(keep = 0.1) |>
  st_transform(crs = st_crs("WGS84")) |>
  st_make_valid() |>
  select(STE_NAME21, SA2_NAME21, SA2_CODE21, geometry) |>
  rename("state" = STE_NAME21,
         "region" = SA2_NAME21,
         "sa2_code21" = SA2_CODE21)

# Convert Sighting data to a sf object
woylie_sf <- woylie |>
  filter(!is.na(decimalLongitude) & !is.na(decimalLatitude)) |>
  select(-c(dataResourceName , recordID,scientificName,taxonConceptID)) |>
  st_as_sf(coords = c("decimalLongitude", "decimalLatitude"),
  crs = st_crs("WGS84"))

# Join
# some points are out of the polygon, lets filter out so we get only points in the polygon
pt_sf <-
  st_join(t_region, woylie_sf, left = TRUE) %>%  # spatial join to get intersection of points and poly
  filter(!is.na(region)) # get only the points (sightings) that fall in the polygon (tourism region)

# Aggregate by Region, Year
woylie_region <- left_join(
  t_region |> select(region, geometry),
  pt_sf |>
    as_tibble() |>
    group_by(region) |>
    summarise(sighting = n()),
  by = c("region" = "region")
)

save(file = "data/woylie_region.rda",woylie_region)
