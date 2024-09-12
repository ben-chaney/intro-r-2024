# Intro Dates Class ####

## Load Libraries ----
library(dplyr)
library(ggplot2)
library(lubridate)

## Load Data ----
stations <- read.csv("data/portal_stations.csv", stringsAsFactors = F)
detectors <- read.csv("data/portal_detectors.csv", stringsAsFactors = F)
data <- read.csv("data/agg_data.csv", stringsAsFactors = F)

# Inspect the data ----

str(detectors)
head(detectors$start_date)

## convert datetime format using lubridate
detectors$start_date <- ymd_hms(detectors$start_date) |>
  with_tz("US/Pacific") # if we didn't include the with_tz, it would have correctly converted to UTC and left it there.

# list of acceptable timezones
OlsonNames()

str(detectors)
head(detectors$start_date)

detectors$end_date <- ymd_hms(detectors$end_date) |>
  with_tz("US/Pacific")

## Filter ----
# create a filter to just select detectors that don't have an end date, ie a NA

open_det <- detectors |>
  filter(is.na(end_date))

## Total Daily Volume and Average Volume; Avg speed/statistics ----

data_stid <- data |>
  left_join(open_det, by = c("detector_id" = "detectorid")) |>
  select(detector_id, starttime, volume, speed, countreadings, stationid) # note this select is acting on the joined tables, and we know there were no name clashes.  But, you can't always count on having no conflicting variable names.

str(data_stid)

# Convert starttime to dattime format from character string
data_stid$starttime <- ymd_hms(data_stid$starttime) |>
  with_tz("US/Pacific")

# Aggregate by the day with lubridate
daily_data <- data_stid |>
  mutate(date = floor_date(starttime, unit = "day")) |>
  group_by(stationid, date) |>
  summarize(
    daily_volume = sum(volume),
    daily_obs = sum(countreadings),
    mean_speed = mean(speed)
  ) 

str(daily_data)

daily_data <- daily_data |> as.data.frame() 
#sometimes a grouped or processed tibble will have attributes that cause problems, you can force to a dataframe to clean it up. 

str(daily_data)
summary(daily_data)

# visuals!!!!! as a quick visual check of the data

daily_volume_fig <- daily_data |>
  ggplot(aes(x = date, y = daily_volume)) +
  geom_line() + 
  geom_point() +
  facet_grid(stationid ~ ., scales = "free")
daily_volume_fig

# We want an interactive visual, let's try Plotly
library(plotly)
ggplotly(daily_volume_fig)

## Compare to expectations
# we expect a certain number of stations and days

# how many distinct stations in the data?
length(unique(daily_data$stationid))  # This is base R so needs to use unique not distinct.  There's 23

# creating a date matrix.  If you have a better way, let Tammy know

stids <- unique(daily_data$stationid) #vector of station ids
start_date <- ymd("2023-03-01") # first date
end_date <- ymd("2023-03-31") # last date

# Create a matrix
date_df <- data.frame(
  date_seq = rep(seq(start_date, end_date, by = "1 day")),
  station_id = rep(stids, each = 31)
)

str(date_df)
head(date_df)

# Join the date matrix and the data, now there'll be NAs for days w/o expected data
data_with_gaps <- date_df |>
  left_join(daily_data, by = c("date_seq" = "date",
                               "station_id" = "stationid")
  )

# Let's save the data!  SO we can reuse it later.
# As a csv using base R
write.csv(data_with_gaps, "data/data_with_gaps.csv", row.names = F)
# as a R data object, which retains all the type attributes.
saveRDS(data_with_gaps, "data/data_with_gaps.rds")

# Now, the plot with the gaps...
daily_volume_fig2 <- data_with_gaps |>
  filter(station_id %in% c(1056, 1057, 1059)) |>
  ggplot(aes(x = as.Date(date_seq), y = daily_volume)) +
  geom_line() + 
  geom_point() +
  facet_grid(station_id ~ ., scales = "free") + 
  scale_x_date(date_breaks = "1 day") + 
  theme(axis.text.x = element_text(angle = 45, hjust = 1)) +
  geom_hline(yintercept = mean(daily_data$daily_volume))

ggplotly(daily_volume_fig2)
