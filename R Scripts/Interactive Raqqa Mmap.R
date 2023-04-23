library(leaflet)
library(dplyr)
library(rio)

###--- Create interactive leaflet map of Raqqa

###--- Import UNOSAT data and focus on October 2017 (Coalition bombing)
unosat_data <- rio::import("Datasets/Reshaped UNOSAT data.rds")

coalition_strikes_2017 <- unosat_data %>% 
  filter(damage_year=="2017/10/21")

#Coordinates centre of Raqqa from average of each column in UNOSAT data
#Calculated in Exploratory Data Analysis UNOSAT file

#Possible lap tile options: CartoDB, Esri, OpenStreetMap
map_raqqa <- coalition_strikes_2017 %>% 
  leaflet()%>% 
  addProviderTiles("CartoDB") %>% 
  
# Set centre of map
setView(lng=39.00897, lat= 35.95394, zoom=14) %>% #centred on Raqqa from UNOSAT data
  
# Set maximum map bounds, calculated for max and min bounds of UNOSAT data
setMaxBounds(lng1 = 39.05947, 
               lat1 = 35.9745, 
               lng2 = 38.93641, 
               lat2 = 35.92829)

###--- Add locations of bombed buildings from October 2017 Coalition bombing

map_raqqa_annotated <-map_raqqa %>% 
  clearMarkers() %>%  #clear large pin markers
  addCircleMarkers(lng=coalition_strikes_2017$coords.x1, lat=coalition_strikes_2017$coords.x2,
             radius = 0.1, color = "#790C0E", popup = ~SiteID)