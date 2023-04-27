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

sentinel-2-l1c

download_satellite data <- function(start_date, period_length_days,number_periods, min_lat,
                                    max_lat,min_long,max_long, satellite_type, cloud_cover){

start_date <- lubridate::ymd("2017-5-01")
period_length_days <- 7
number_periods <- 2

for (i in 0:number_periods-1){
  
  Sys.sleep(1) #to respect API download limit rates
  
  request <- read_file("R Scripts/POST body request") # loads request from JSON in text file
  
  ### Create date parameters of request body----------
  current_date_start <- start_date+days(i*period_length_days)
  current_date_end <- start_date+days((i+1)*period_length_days)
  
  start_date_as_string <- format(current_date_start)
  end_date_as_string <- format(current_date_end)
  
  request_with_start <- str_replace(request, "InsertStartDateHere", start_date_as_string)
  request_with_end <- str_replace(request_with_start, "InsertEndDateHere", satellite_type)
  
  ### Create satellite type parameter of request body----------
  request_with_satellite <- str_replace(request_with_end, "InsertSatelliteTypeHere", end_date_as_string)
  
  ### Create cloud cover parameter of request body----------
  request_with_cloudcover <- str_replace(request_with_satellite, "InsertCloudCoverHere", cloud_cover)
  
  ### Create region of interest parameter of request body----------
  # Easiest to specify region of interest using maximum and minimum longitude and latitude
  # Specifying bounding box in this way didn't seem to work, instead used polygons parameter
  # Polygons specifies a series of coordinates, the same coordinate is specified at the start and end to close the polygon
  
  sentinel_endpoint <- "https://services.sentinel-hub.com/api/v1/process"
  
  # Specify which formats are accepted in request(JSON) and response(png)
  response <- httr::POST(sentinel_endpoint, body=request_with_end, add_headers(Accept = "image/png", `Content-Type`="application/json", Authorization = paste("Bearer", token$credentials[[1]], sep = " ")))
  
  data_filename <- paste("SatelliteData",start_date_as_string,".png",sep="")
  
  ###--- Process response into png image
  # get the content as a png
  rawPng = content(response)
  
  #Annotate png with Date
  
  #Display png
  #grid::grid.raster(rawPng)
  
  year <- lubridate::year(start_date)
  month <- lubridate::month(start_date, label=TRUE)
  day <- lubridate::day(start_date)
  
  complete_date <- paste(day, month, year, sep=" ")
  
  annotated_png <- image_annotate(rawPng, complete_date,location = "+450+10", size = 30, color = "white")
  
  #Save to file
  png::writePNG(annotated_png , target=data_filename)
}



