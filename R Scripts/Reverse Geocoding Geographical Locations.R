library(httr)
library(jsonlite)
library(dplyr)

### --- Load Raqqa Geographic data and select columns of interest

#Load UNOSAT data in dataframe form
raqqa_data <- readRDS("Datasets/Reshaped UNOSAT data.rds")

raqqa_data_summarised <- raqqa_data %>% 
  select(SiteID,Neigh,damage_year,destruction_type,coords.x1,coords.x2) 

###--- Connect to GeoCage API perforl reverse geocoding on all destruction sites to get
# more information on the sites as just referred to as Building "(General / Default)" in the UNOSAT data

#Convert latitude and longitude columns to vectors
longitude <- (raqqa_data$coords.x1)
latitude <- (raqqa_data$coords.x2)

# Connect to OpenCage API by defining API key and endpoint
api_key <- readRDS("Secrets/api_key_open_cage.rds")
base_url <- "https://api.opencagedata.com/geocode/v1/json"

list_extra_info <- list() # for storing list of additional address information

for(x in 1:length(longitude)){
  Sys.sleep=0.1  #to respect API limits
  current_location <- paste(latitude[[x]],"+",longitude[[x]], sep="") # create query string from dataframe information
  geocoding_response <- httr::GET(url = base_url, 
                                  query = list(key = api_key, q = current_location)) 
  current_address <- httr::content(geocoding_response)
  current_extra_info <- current_address$results[[1]]$formatted # additional information in formatted section of results
  list_extra_info <-append(list_extra_info,current_extra_info)
}

#Convert list back to a dataframe
extra_data_dataframe <- data.frame(list_extra_info)
transpose <- data.frame(t(extra_data_dataframe))
rownames(transpose) <- seq(from=1, to=length(list_extra_info), by=1)

#Filter for useful additional information by dropping all rows that contain only "unnamed road"
filtered_address_info <- transpose %>% 
  filter(!str_detect(t.extra_data_dataframe., "unnamed road"))

#Export final list of additional information
saveRDS(filtered_address_info,"Visualisations/filtered address info.rds")
