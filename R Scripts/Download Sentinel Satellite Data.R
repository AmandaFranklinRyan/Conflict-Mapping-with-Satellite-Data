library(httr)
library(brio)# for loading text file with no extension
library(rio)
library(png)

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

request <- read_file("R Scripts/POST body request") # loads request from JSON in text file
sentinel_endpoint <- "https://services.sentinel-hub.com/api/v1/process"

# Specify which formats are accepted in request(JSON) and response(png)
response <- httr::POST(sentinel_endpoint, body=request, add_headers(Accept = "image/png", `Content-Type`="application/json", Authorization = paste("Bearer", token$credentials[[1]], sep = " ")))

###--- Process response into png image
# get the content as a png
rawPng = content(response)

#Display png
grid::grid.raster(rawPng)

#Save to file
png::writePNG(rawPng, target="Visualisations/cloudyzoomedoutraqqa.png")

