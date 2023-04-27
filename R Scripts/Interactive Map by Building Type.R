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

###--- Create plot illustrating distribution of destroyed, moderately damaged and destroyed buildings---

# Create custom destruction colour palette
building_palette <- leaflet::colorFactor(palette=c('#a50026','#d73027','#f46d43','#fdae61','#fee090','#ffffbf','#e0f3f8','#abd9e9','#74add1','#4575b4','#313695'),
                                            levels=c(" General Building","Field","Road","School/University","Industrial Facility","Mosque","Government Building","Hospital","Tower","Market","Bridge"))

###--- Recreate above plot with groups to stop it looking so cluttered---

# Dataframe with only generic buildings buildings
building_only_dataframe <- coalition_strikes_2017 %>% 
  filter(SiteID=="Building (General / Default)")

grouped_building_plot <-   Building_only_dataframe %>%
  leaflet()%>% 
  addProviderTiles("CartoDB") %>% 
  setView(lng=39.00897, lat= 35.95394, zoom=14) %>% 
  setMaxBounds(lng1 = 39.05947, 
               lat1 = 35.9745, 
               lng2 = 38.93641, 
               lat2 = 35.92829) %>% 
  clearMarkers() %>%  
  addCircleMarkers(lng=building_only_dataframe$coords.x1, 
                   lat=building_only_dataframe$coords.x2,
                   radius = 3, 
                   stroke=FALSE,
                   fillOpacity= 1,
                   color = "#a50026", 
                   label=~destruction_type,
                   group="General Building")  

# Dataframe with only Fields
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
