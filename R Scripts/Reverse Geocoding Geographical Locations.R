library(httr)
library(jsonlite)

#Load UNOSAT data in dataframe form
raqqa_data <- readRDS("Datasets/Reshaped UNOSAT data.rds")

raqqa_data_summarised <- raqqa_data %>% 
  select(SiteID,Neigh,damage_year,destruction_type,coords.x1,coords.x2) %>% 
  mutate(damage_year=lubridate::ymd(damage_year))

# Connect to OpenCage API
browseURL(url = "https://opencagedata.com/api")
api_key <- readRDS("Secrets/api_key_open_cage.rds")
base_url <- "https://api.opencagedata.com/geocode/v1/json"

address <- "Frohburgstrasse 3, 6002 Luzern"

geocoding_response <- httr::GET(url = base_url, 
                                query = list(key = api_key, q = address))

http_status(geocoding_response)

geocoding_data <- httr::content(geocoding_response)
