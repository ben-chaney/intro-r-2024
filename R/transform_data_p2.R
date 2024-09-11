#### Transforming Data Part II ####

#### Load the libraries ####
library(readxl) # the difference between library and require.  library is more basic, will throw an error if not installed.  require returns t/f and will try to continue even if f. Library is the more simple option, require is useful in control flows.
library(dplyr)

#### Load in our data from Excel ####
df <- read_excel("data/icebreaker_answers.xlsx")
df
tail(df)

# example, to add to the bottom of the existing df and create a duplicate row.
df <- df |> bind_rows(slice_tail(df)) # take the last row and add to end of df.  slice does one by default, n=x for multiple rows
tail(df)

# Return only 1 unique row per set of values
df <- df |> distinct()
tail(df)

#### Selecting Columns ####
# selecting columns example.  let's focus on just the travel attributes
df_travel <- df |> select(travel_mode, travel_distance, travel_time) # select all columns except serial comma by inclusion


# select by exclusion
df |> select(-serial_comma)

# select by sequential columns
df |> select(travel_mode:travel_distance)

# select by expression
df |> select(starts_with("travel_"))

#### mutate and rename (creating and modifying data frames) ####

# with base R
df_travel$travel_speed <-  (df_travel$travel_distance /
                              df_travel$travel_time * 60) #speed in mph

# with tidyverse
df_travel <- df_travel |>
  mutate(travel_speed = travel_distance / travel_time * 60) # mph
summary(df_travel)

# renaming columns
df_travel <- df_travel |> rename(travel_speed_mph = travel_speed) # note it's rename(new = old)
colnames(df_travel)

#### Using Logic in a Mutate ####

df_travel <- df_travel |>
  mutate(long_trip = if_else(travel_distance > 20, 1, 0)) # using if_else to set a dummy variable based on simple logic.

# Using case_when to set a dummy variable based on more complex logic.
df_travel <- df_travel |>
  mutate(slow_trip = 
           case_when(
             travel_mode == "bike" & travel_speed_mph < 12 ~ 1,
             travel_mode == "car" & travel_speed_mph < 25 ~ 1,
             travel_mode == "bus" & travel_speed_mph < 15 ~ 1,
             travel_mode == "light rail" & travel_speed_mph < 20 ~ 1,
             .default = 0 # all FALSE or NA values go here.
           ))


#### arrange to order output ####
df_travel |> arrange(travel_speed_mph) |> print(n = 25) # from slowest to fastest; default is ascending order.
df_travel |> arrange(travel_mode, travel_speed_mph) |> print(n = 25) # from slowest to fastest; default is ascending order.
df_travel |> arrange(desc(travel_speed_mph)) |> print(n = 25) # from fastest to slowest; using the desc() modifier to indicate descending order.

# A very basic plot
boxplot(df_travel$travel_speed_mph ~ df_travel$long_trip) # plot in base R.  note the use of tilde here is different than in case_when. 
