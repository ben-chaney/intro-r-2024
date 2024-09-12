
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
# This one tidys the ACS API results
tidy_acs_result <- function(raw_result, include_moe = FALSE) {
  # takes a tidycensus acs result and returns a wide and tidy table
  # this is lazy documentation, there is a docstring way to do it right
  if (isTRUE(include_moe)) {
    new_df <- raw_result |> pivot_wider(
      id_cols = GEOID:NAME,
      names_from = variable,
      values_from = estimate:moe
    )
    
  } else {
    new_df <- raw_result |> pivot_wider(
      id_cols = GEOID:NAME,
      names_from = variable,
      values_from = estimate
    )
  }
  return(new_df)
}


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

comm_19 <- tidy_acs_result(comm_19_raw)

# Get 2022 ACS Data ----
comm_22_raw <- get_acs(geography = "tract",
                       variables = c(wfh = "B08006_017",
                                     transit = "B08006_008",
                                     tot = "B08006_001"),
                       county = "Multnomah",
                       state = "OR",
                       year = 2022,
                       survey = "acs5",
                       geometry = FALSE)

# tidy 2022 data using our own function!
comm_22 <- tidy_acs_result(comm_22_raw) # note the census tracts have changed since the 2019 data.  For now we'll only keep matches.

# join the years ----
comm_19_22 <- comm_19 |> inner_join(comm_22,
                                    by = "GEOID",
                                    suffix = c("_19", "_22")) |>
  select(-starts_with("NAME"))

# create some change variables ----
comm_19_22 <- comm_19_22 |>
  mutate(wfh_chg = wfh_22 - wfh_19,
         transit_chg = transit_22 - transit_19)

# quickly look at them at summary level
summary(comm_19_22 |> select(ends_with("_chg")))

# plot them ----
# basic plot structure
p <- comm_19_22 |>
  ggplot(aes(x = wfh_chg, y = transit_chg))

p #see it's just axes

p + geom_point() # basic plot, generally a cloud with negative looking correlation

p + geom_point() + geom_smooth(method = "lm") # add a simple linear model for the smoothed line method

# add some labels and a basic correlation stat as an annotation
p + geom_point() +
  geom_smooth(method = "lm") +
  labs(x = "Change in WFH",
       y = "change in Transit",
       title = "ACS 2022 vs. 2019") +
  annotate("text",
           x = 800,
           y = 50,
           label = paste("r =", round(
             cor(comm_19_22$wfh_chg,
                 comm_19_22$transit_chg), 3
           )))

# Simple linear (default Pearson) correlation
cor(comm_19_22$wfh_chg,
    comm_19_22$transit_chg)

# model it! ----
# model formula is dependent_variable ~ 1 + independent_variable_1 + independent_variable_2 + ...

m <- lm(transit_chg ~ wfh_chg,
        data = comm_19_22) # now the model is assigned to a variable.

summary(m) # get some stats about the high level performance of the model

# model is an object ready for re-use!!
# model is a totally portable object, data included. Not the whole dataframe, just the variables used.
head(m$model)

# create a new scenario of data, then use it to predict using the model.
scen1 <- comm_19_22 |>
  mutate(wfh_chg = wfh_chg * 1.5)

scen1_pred <- predict(m, newdata = scen1) # The prediction is a vector of the dependent variable of the model.

# diff in total daily transit impact from 50% increase in WFH commuters.
sum(comm_19_22$transit_chg)
sum(scen1_pred)

# note that we could use update() function to re-estimate model on new data.