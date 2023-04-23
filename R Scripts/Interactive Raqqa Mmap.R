library(leaflet)
library(dplyr)

###--- Create interactive leaflet map of Raqqa

#Coordinates centre of Raqqa from average of each column in UNOSAT data
#Calculated in Exploratory Data Analysis UNOSAT file

leaflet()%>% 
  addProviderTiles("CartoDB") %>% 
  
# Set centre of map
setView(lng=39.00897, lat= 35.95394, zoom=13) %>% #centred on Raqqa from UNOSAT data
  
# Set maximum map bounds, calculated for max and min bounds of UNOSAT data
setMaxBounds(lng1 = 39.05947, 
               lat1 = 35.9745, 
               lng2 = 38.93641, 
               lat2 = 35.92829)