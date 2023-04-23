# Leaflet/ documentation:https://rdrr.io/cran/leaflet/man/addLegend.html

library(leaflet)
library(dplyr)
library(rio)
library(leaflet.extras) # for extra features like adding search box and reset map button
library(htmltools) #for escaping html

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
  addProviderTiles("Esri") %>% 
  
# Set centre of map
setView(lng=39.00897, lat= 35.95394, zoom=14) %>% #centred on Raqqa from UNOSAT data
  
# Set maximum map bounds, calculated for max and min bounds of UNOSAT data
setMaxBounds(lng1 = 39.05947, 
               lat1 = 35.9745, 
               lng2 = 38.93641, 
               lat2 = 35.92829)

###--- Add locations of bombed buildings from October 2017 Coalition bombing
#colour for entity and degree of destruction

map_raqqa_annotated <-map_raqqa %>% 
  clearMarkers() %>%  #clear large pin markers
  addCircleMarkers(lng=coalition_strikes_2017$coords.x1, lat=coalition_strikes_2017$coords.x2,
             radius = 0.1, color = "#790C0E", 
             label = ~paste0(SiteID, # label displays info on hover, pop-up displays on click
                            "<br/>",
                            "<b>",
                            destruction_type,
                            "</b>"))

###--- Create plot illustrating distribution of destroyed, moderately damaged and destroyed buildings---

# Create custom destruction colour palette
destruction_palette <- leaflet::colorFactor(palette=c("#92140d","#ce5e09","#ffa600"),
                                            levels=c("Destroyed","Severe Damage","Moderate Damage"))
destruction_level_plot <- map_raqqa %>% 
  clearMarkers() %>%  #clear large pin markers
  addCircleMarkers(lng=coalition_strikes_2017$coords.x1, lat=coalition_strikes_2017$coords.x2,
                   radius = 2, 
                   stroke=FALSE, 
                   fillOpacity=0.9,
                   color = ~destruction_palette(destruction_type),
                   label=~SiteID) %>% 
                   #clusterOptions = markerClusterOptions())# For clustering points
            addLegend(pal = destruction_palette,
            values = c("Destroyed","Severe Damage","Moderate Damage"),
            title = "Level of Destruction",
            position = "bottomright") %>% 
            leaflet.extras::addResetMapButton()

###--- Recreate above plot with groups to stop it looking so cluttered---

# Dataframe with only destroyed buildings
destroyed_only_dataframe <- coalition_strikes_2017 %>% 
  filter(destruction_type=="Destroyed")

grouped_damage_plot <-   destroyed_only_dataframe %>%
  leaflet()%>% 
  addProviderTiles("CartoDB") %>% 
  setView(lng=39.00897, lat= 35.95394, zoom=14) %>% 
  setMaxBounds(lng1 = 39.05947, 
               lat1 = 35.9745, 
               lng2 = 38.93641, 
               lat2 = 35.92829) %>% 
  clearMarkers() %>%  
  addCircleMarkers(lng=destroyed_only_dataframe$coords.x1, 
                   lat=destroyed_only_dataframe$coords.x2,
                   radius = 3, 
                   stroke=FALSE,
                   fillOpacity= 1,
                   color = "#92140d", 
                   label=~SiteID,
                   group="Destroyed")  

# Dataframe with only severely damaged buildings
severe_damage_only_dataframe <- coalition_strikes_2017 %>% 
  filter(destruction_type=="Severe Damage")

#Create severe damage layer
grouped_damage_plot <- grouped_damage_plot %>% 
  addCircleMarkers(lng=severe_damage_only_dataframe$coords.x1, 
                   lat=severe_damage_only_dataframe$coords.x2,
                   radius = 3, 
                   stroke=FALSE,
                   fillOpacity= 1,
                   color = "#ce5e09", 
                   label=~SiteID,
                   group="Severe Damage") %>% 
                   addLayersControl(overlayGroups = c("Destroyed", "Severe Damage"))

# Dataframe with only moderately damaged buildings
moderate_damage_only_dataframe <- coalition_strikes_2017 %>% 
  filter(destruction_type=="Moderate Damage")

#Create moderate damage layer
grouped_damage_plot <- grouped_damage_plot %>% 
  addCircleMarkers(lng=moderate_damage_only_dataframe$coords.x1, 
                   lat=moderate_damage_only_dataframe$coords.x2,
                   radius = 3, 
                   stroke=FALSE,
                   fillOpacity= 1,
                   color = "#ffa600", 
                   label=~SiteID,
                   group="Moderate Damage") %>% 
                   addLayersControl(overlayGroups = c("Destroyed", "Severe Damage", "Moderate Damage"))
