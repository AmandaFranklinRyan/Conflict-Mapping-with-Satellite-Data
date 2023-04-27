library(httr)
library(jsonlite)

### --- Load Raqqa Geographic data and select columns of interest

#Load UNOSAT data in dataframe form
raqqa_data <- readRDS("Datasets/Reshaped UNOSAT data.rds")

raqqa_data_summarised <- raqqa_data %>% 
  select(SiteID,Neigh,damage_year,destruction_type,coords.x1,coords.x2) 

#Convert latitude and longitude columns to vectors
longitude <- (raqqa_data$coords.x1)
latitude <- (raqqa_data$coords.x2)

# Connect to OpenCage API by defining API key and endpoint
api_key <- readRDS("Secrets/api_key_open_cage.rds")
base_url <- "https://api.opencagedata.com/geocode/v1/json"

list_extra_info <- list()

for(x in 1:length(longitude)){
  Sys.sleep=0.1
  current_location <- paste(latitude[[x]],"+",longitude[[x]], sep="")
  geocoding_response <- httr::GET(url = base_url, 
                                  query = list(key = api_key, q = current_location)) 
  current_address <- httr::content(geocoding_response)
  current_extra_info <- current_address$results[[1]]$formatted
  list_extra_info <-append(list_extra_info,current_extra_info)
}

#Convert list back to a dataframe
extra_data_dataframe <- data.frame(list_extra_info)
transpose <- data.frame(t(extra_data_dataframe))




address <- "35.96738+38.99149"

geocoding_response <- httr::GET(url = base_url, 
                                query = list(key = api_key, q = address))

http_status(geocoding_response)

geocoding_data <- httr::content(geocoding_response)
str(geocoding_data)
extra_info <- geocoding_data$results[[1]]$formatted
