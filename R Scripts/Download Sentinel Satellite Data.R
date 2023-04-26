library(httr)
library(brio)# for loading text file with no extension
library(rio)
library(png)
library(lubridate)
library(stringr)

### --- Oauth authorisation to access API


# IDs and secrets
client_id <- readRDS("Secrets/oauth_client_id.rds")
client_secret <- readRDS("Secrets/oauth_secret.rds")

# Create the app
app <- oauth_app(appname = "SatelliteImageryAnalysis",
                 key = client_id,
                 secret = client_secret)

# Create the oauth endpoint
endpoint <- oauth_endpoint(
  request = NULL,
  authorize = NULL,
  access = "token",
  base_url = "https://services.sentinel-hub.com/oauth")

# Cache the token to prevent API being called multiple times (token lasts 1 hour)
options(httr_oauth_cache=T) # prevents pop-up asking to cache token
token <- oauth2.0_token(endpoint = endpoint,
                        app = app,
                        use_basic_auth = T,
                        client_credentials = T)

### --- Build request

start_date <- lubridate::ymd("2019-10-01")
period_length_days <- 7
number_periods <- 8

for (i in 0:number_periods-1){
  
  request <- read_file("R Scripts/POST body request") # loads request from JSON in text file
  
  current_date_start <- start_date+days(i*period_length_days)
  current_date_end <- start_date+days((i+1)*period_length_days)
  
  start_date_as_string <- format(current_date_start)
  end_date_as_string <- format(current_date_end)
  
  request_with_start <- str_replace(request, "InsertStartDateHere", start_date_as_string)
  request_with_end <- str_replace(request_with_start, "InsertEndDateHere", end_date_as_string)
  
  sentinel_endpoint <- "https://services.sentinel-hub.com/api/v1/process"
  
  # Specify which formats are accepted in request(JSON) and response(png)
  response <- httr::POST(sentinel_endpoint, body=request_with_end, add_headers(Accept = "image/png", `Content-Type`="application/json", Authorization = paste("Bearer", token$credentials[[1]], sep = " ")))
  
  data_filename <- paste("SatelliteData",start_date_as_string,".png",sep="")
  
  ###--- Process response into png image
  # get the content as a png
  rawPng = content(response)
  
  #Display png
  #grid::grid.raster(rawPng)
  
  #Save to file
  png::writePNG(rawPng, target=data_filename)
}



