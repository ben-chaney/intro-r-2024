#### Practice Problem: Loading and manipulating a data frame ####
# Don't forget: Comment anywhere the code isn't obvious to you!

# Load the readxl and dplyr packages
library(readxl)
library(dplyr)

# Use the read_excel function to load the class survey data
survey_data <- read_excel("data/icebreaker_answers.xlsx")

# Take a peek!
head(survey_data)
str(survey_data)

# Create a travel_speed column in your data frame using vector operations and 
#   assignment

# speed in mph = miles / minutes * 60
survey_data$travel_speed <- survey_data$travel_distance / survey_data$travel_time * 60

# Look at a summary of the new variable--seem reasonable?
summary(survey_data$travel_speed)

# Choose a travel mode, and use a pipe to filter the data by your travel mode

lightrail_riders <- survey_data |>
  filter(
    travel_mode == "light rail"
  )


# Note the frequency of the mode (# of rows returned)

nrow(lightrail_riders)

# Repeat the above, but this time assign the result to a new data frame

## already did that 

# Look at a summary of the speed variable for just your travel mode--seem 
#   reasonable?

summary(lightrail_riders$travel_speed)


# Filter the data by some arbitrary time, distance, or speed threshold

fast_lr_riders <- lightrail_riders |>
  filter(travel_speed >= 10)

# Stretch yourself: Repeat the above, but this time filter the data by two 
#   travel modes (Hint: %in%)

fast_transit_riders <- survey_data |>
  filter(travel_speed >= 10,
         travel_mode %in% c("light rail", "bus"))

summary(fast_transit_riders)
