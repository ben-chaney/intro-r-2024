# Aggregating and Summarizing Data ----

# Intro ----

## Load the libraries ####

library(readxl)
library(dplyr)
library(ggplot2)

## Read in the excel file ####
df <- read_excel("data/icebreaker_answers.xlsx")
df
summary(df) # includes just the basics, including the min/max and quartiles.

# Summarize and Aggregate Functions ----

# this is more flexible, lots of aggregation/summary functions available
df |> summarize(
  avg_dist = mean(travel_distance),
  sd_dist = sd(travel_distance),
  pct60_dist = quantile(travel_distance, prob = 0.6)
)

# Add travel speed
df <- df |> 
  mutate(travel_speed = travel_distance / travel_time * 60)

## Grouping ----

# works with groups too!
df_summ <- df |>
  group_by(travel_mode) |>
  summarize(
    avg_dist = mean(travel_speed),
    sd_dist = sd(travel_speed),
    pct85_dist = quantile(travel_speed, prob = 0.85)
  )

df_summ

df_grouped <- df |> group_by(travel_mode)

is_grouped_df(df_grouped)
str(df_grouped)

## Grouping by multiple attributes ----

df_summ2 <- df |>
  group_by(travel_mode, serial_comma) |>
  summarize(
    avg_dist = mean(travel_speed))

df_summ2

# Frequencies ----
## Basic Frequencies ----
# so common there are shortcuts
# Full tidy group_by and summarize
df |> group_by(serial_comma) |>
  summarize(n = n())

# compacter group by and tally
df |> group_by(serial_comma) |>
  tally()

# most compact "count"
df |> count(serial_comma, sort = T)

## Mode Split Calculations ----

