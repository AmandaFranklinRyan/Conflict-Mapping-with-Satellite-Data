library(httr)
library(brio)# for loading text file with no extension
library(rio)
library(png)
library(lubridate)
library(stringr)

download_satellite_data <- function(start_date, period_length_days,number_periods, min_lat,
                                    max_lat,min_long,max_long, satellite_type, cloud_cover){

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

### --- Build request in loop to get imagery for multiple dates

# Specify time range for data collection
# Good imagery is weather dependent, but sentinel-2 data collected every 5 days
start_date <- lubridate::ymd(start_date)

for (i in 0:number_periods-1){
  
  Sys.sleep(1) #to respect API download limit rates
  
  request <- read_file("R Scripts/POST body request") # loads request from JSON in text file
  
  ### Create date parameters of request body----------
  ## Code replaces strings in the JSON body request.txt with arguments from function
  current_date_start <- start_date+days(i*period_length_days)
  current_date_end <- start_date+days((i+1)*period_length_days)
  
  start_date_as_string <- format(current_date_start)
  end_date_as_string <- format(current_date_end)
  
  request_with_start <- str_replace(request, "InsertStartDateHere", start_date_as_string)
  request_with_end <- str_replace(request_with_start, "InsertEndDateHere", end_date_as_string)
  
  ### Create satellite type parameter of request body----------
  request_with_satellite <- str_replace(request_with_end, "InsertSatelliteTypeHere", satellite_type)
  
  ### Create cloud cover parameter of request body----------
  request_with_cloudcover <- str_replace(request_with_satellite, "InsertCloudCoverHere", as.character(cloud_cover))
  
  ### Create region of interest parameter of request body----------
  # Easiest to specify region of interest using maximum and minimum longitude and latitude
  # Specifying bounding box in this way didn't seem to work, instead used polygons parameter
  # Polygons specifies a series of coordinates, the same coordinate is specified at the start and end to close the polygon
  
  request_with_region1 <- str_replace_all(request_with_cloudcover, "InsertMinLong", as.character(min_long))
  request_with_region2 <- str_replace_all(request_with_region1, "InsertMaxLong", as.character(max_long))
  request_with_region3 <- str_replace_all(request_with_region2, "InsertMinLat", as.character(min_lat))
  request_with_region4 <- str_replace_all(request_with_region3, "InsertMaxLat", as.character(max_lat))
  
  ### Calculate optimum image size
  # API demands user specifies the dimensions of the output image
  # To ensure it is not stretched, dimensions have been calculated based on user specifying desired number of pixels in horizontal direction
  

  # Specify Sentinel endpoint
  sentinel_endpoint <- "https://services.sentinel-hub.com/api/v1/process"
  
  # Specify which formats are accepted in request(JSON) and response(png)
  response <- httr::POST(sentinel_endpoint, body=request_with_region4, add_headers(Accept = "image/png", `Content-Type`="application/json", Authorization = paste("Bearer", token$credentials[[1]], sep = " ")))
  
  data_filename <- paste("SatelliteData",start_date_as_string,".png",sep="")
  
  ###--- Process response into png image---
  
  #Get the content as a png
  rawPng = content(response)
  png::writePNG(rawPng , target=data_filename)
  
  ### Annotate png with Date---
  
  year <- lubridate::year(current_date_start)
  month <- lubridate::month(current_date_start, label=TRUE)
  day <- lubridate::day(current_date_start)
  
  complete_date <- paste(day, month, year, sep=" ")
  
  processed_png <- image_read(data_filename)
  annotated_png <- image_annotate(processed_png, complete_date,location = "+10+450", size = 30, color = "white")
  
  #Save to file
  image_write(annotated_png , data_filename)
}
}

download_satellite_data("2017-05-01", 7, 3, 35.92829,35.9745,38.93641,39.05947,"sentinel-2-l2a",10)

