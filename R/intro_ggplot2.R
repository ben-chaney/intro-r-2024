#### Intro to the Grammar of Graphics ####

#### Load Libraries ####
library(dplyr)
library(ggplot2)
library(readxl)

#### Load Data ####
df_ice <- read_xlsx("data/icebreaker_answers.xlsx")

#### Let's make a figure! ####
tt_mi_fig <- df_ice |>
  ggplot(
    aes(x = travel_time,
        y = travel_distance)) + # in ggplot it's not exactly piping, it's more like layering.  So, use the plus sign.
      geom_point()

tt_mi_fig

tt_mi_ox_fig <- df_ice |>
  ggplot(
    aes(x = travel_time,
        y = travel_distance,
        color = serial_comma)) + # in ggplot it's not exactly piping, it's more like layering.  So, use the plus sign.
  geom_point()

tt_mi_ox_fig

tt_mi_ox_fig <- df_ice |>
  ggplot(
    aes(x = travel_time,
        y = travel_distance,
        color = serial_comma)) + # in ggplot it's not exactly piping, it's more like layering.  So, use the plus sign.
  geom_point() + 
  xlab("Travel Time") +
  ylab("Travel Distance")

tt_mi_ox_fig

tt_mi_ox_fig + theme_dark()

tt_mi_mode_fig <- df_ice |>
  ggplot(
    aes(x = travel_time,
        y = travel_distance,
        color = travel_mode)) + # in ggplot it's not exactly piping, it's more like layering.  So, use the plus sign.
  geom_point() + 
  xlab("Travel Time") +
  ylab("Travel Distance") + 
  labs(
    title = "Best Plot Ever",
    color = "Travel Mode"
  )

tt_mi_mode_fig

#### Faceting ####
ice_facet_fig_wrap <- df_ice |>
  ggplot(aes(x = travel_time, y = travel_distance)) +
  geom_point() +
  facet_wrap(. ~ travel_mode,
             scales = "free")

ice_facet_fig_wrap

ice_facet_fig_grid <- df_ice |>
  ggplot(aes(x = travel_time, y = travel_distance)) +
  geom_point() +
  facet_grid(. ~ travel_mode,
             scales = "free")

ice_facet_fig_grid


tt_mode_car_fig <- df_ice |>
  filter(travel_mode == "car") |>
  ggplot(aes(x = travel_time, y = travel_distance)) +
  geom_point() +
  theme_light()

tt_mode_car_fig
