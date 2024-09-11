library(dplyr)
library(ggplot2)

#### import data sets ####

detectors <- read.csv("data/portal_detectors.csv", stringsAsFactors = F)
stations <- read.csv("data/portal_stations.csv", stringsAsFactors = F)
data <- read.csv("data/agg_data.csv", stringsAsFactors = F)

head(data)

#### Walk-through Join Exercise ####

table(data$detector_id) # this shows the unique values of the column attribute, along with the number of observations for each.

# create a list of the detectors present in our dataset
data_detectors <- data |>
  distinct(detector_id)

# join metadata to the list of detectors present in our dataset
data_detectors_meta <- data_detectors |>
  left_join(detectors, by = c("detector_id" = "detectorid"))

# use anti-join to find out which detectors are missing from our dataset (ie, are present in the metadata)

data_detectors_missing <- detectors |>
  anti_join(data_detectors, by = c("detectorid" = "detector_id")) |>
  distinct(detectorid)

data_detectors_missing

#### Next Exercise on our own ####
# Try to use the data_detectors_meta (many) to join with the stations metadata (one)

data_detectors_with_stations <- data_detectors_meta |>
  select(detector_id, stationid) |>
  left_join(stations, by = c("stationid"))

# This is a many-many because stationid is reused when the station closes-then-opens due to some sort or modification.



data_detectors_with_stations

