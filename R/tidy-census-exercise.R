
# Libraries ----

library(tidycensus) # acts as a gateway to the Census API for ACS and Deceniial data
                    # for more info: walker-data.com/tidycensus/
library(dplyr)
library(tidyr)
library(ggplot2)

# Census API Key ----
# Run on first use if not already stored in R
# census_api_key("[myCensusAPIKey]", install = T )

# Your API key has been stored in your .Renviron and can be accessed by Sys.getenv("CENSUS_API_KEY"). 
# To use now, restart R or run `readRenviron("~/.Renviron")
# readRenviron("~/.Renviron")

# User Functions ----



# Working with Census part 1 ----
##  get a searchable census variable table ----
v19 <- load_variables(2019, "acs5")
v19 |> filter(grepl("^B08006_", name)) |> print(n = 25)
# then we examined to find the table we wanted.

## get the data for transit, wfh, and total workers ----
# remember, you can always ask for help with ?get_acs
comm_19_raw <- get_acs(geography = "tract",
                       variables = c(wfh = "B08006_017",
                                     transit = "B08006_008",
                                     tot = "B08006_001"),
                       county = "Multnomah",
                       state = "OR",
                       year = 2019,
                       survey = "acs5",
                       geometry = FALSE) # you can retrieve spatial data pre-joined too.

comm_19_raw_sf <- get_acs(geography = "tract",
                       variables = c(wfh = "B08006_017",
                                     transit = "B08006_008",
                                     tot = "B08006_001"),
                       county = "Multnomah",
                       state = "OR",
                       year = 2019,
                       survey = "acs5",
                       geometry = TRUE) # you can retrieve spatial data pre-joined too.

# This is a tall structure of data, we want it to be wide.

# Manually restructure data from census API ----
# Let's pivot wider

comm_19 <- comm_19_raw |>
  pivot_wider(id_cols = GEOID, # could have included multiple columns that taken together are a unique identifier.
              names_from = variable,
              values_from = estimate:moe)
