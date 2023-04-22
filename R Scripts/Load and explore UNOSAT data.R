# Map download link:https://unosat.org/products/1156
# Spatial Data in tidyverse: https://mhallwor.github.io/_pages/Tidyverse_intro
# Sentinel hub link: https://docs.sentinel-hub.com/api/latest/api/process/
library(rgdal)
library(sp)
library(raster)

# Load and view dataset
directory <- "C:\\Users\\amand\\OneDrive\\Bureau\\Conflict mapping with Satellite Imagery\\Conflict Detection with Satellite Imagery\\UNOSAT Data\\RaqqaDamage"
raqqa_data <- rgdal::readOGR(directory,"Damage_Sites_Raqqa_CDA")
View(head(raqqa_data,30))

str(raqqa_data)
raqqa_data@data$SiteID

###---- 1 Identify key characteristics of spacial data
str(raqqa_data)
# Data from 5 sets of satellite images from 2013-2017
# For each set of satellite data contains information on level and destruction and level of confidence.
# Estimates of destruction made entirely from satellite imagery and not verified on the ground

#Data projection
raqqa_data@proj4string
# No projection just latitude and longitude WG584

# Coordinates of area covered by dataset
raqqa_data@bbox

#Coordinates of damaged buildings
raqqa_data@coords

#plot raqqa data
plot(raqqa_data)

###--- Exploratory data analysis
# Convert spacial dataframe to dataframe and clean