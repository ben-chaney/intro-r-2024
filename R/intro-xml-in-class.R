# Libraries
library(tidyr)
library(readr)
library(dplyr)
library(xml2)

# data comes in many, many different formats! 

# API type interfaces are usually returning XML or JSON, both of which are nested lists.
# S3 objects are typical for R

meta_xml <- as_list(read_xml("https://wsdot.wa.gov/Traffic/WebServices/SWRegion/Service.asmx/GetRTDBLocationData"))

# first unnest... getting closer
meta_df <- as_tibble(meta_xml) %>%
  unnest_longer(RTDBLocationList)

# now we'll get the attributes to the right columns...
meta_unnest_df <- meta_df |>
  filter(RTDBLocationList_id == "RTDBLocation") |>
  unnest_wider(RTDBLocationList)

# One more list layer to extract...
meta_unnest_more <- meta_unnest_df %>%
  unnest(cols = names(.))  %>%
  unnest(cols = names(.))  %>%
  type_convert()  # note that this tells readr to check for types again, now that everything is unnested

# Save it out ----
# you would generally want to save out some clean data and then start in a new script.

saveRDS(meta_unnest_more, "data/unnested_wsdot_stations.meta.rds")

