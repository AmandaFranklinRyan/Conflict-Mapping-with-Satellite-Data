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
field_only_dataframe <- coalition_strikes_2017 %>% 
  filter(SiteID=="Field")

#Create field layer
grouped_building_plot <- grouped_building_plot %>% 
  addCircleMarkers(lng=field_only_dataframe$coords.x1, 
                   lat=field_only_dataframe$coords.x2,
                   radius = 3, 
                   stroke=FALSE,
                   fillOpacity= 1,
                   color = "#d73027", 
                   label=~destruction_type,
                   group="Field") %>% 
  addLayersControl(overlayGroups = c("General Building", "Field"))

# Dataframe with only roads
road_only_dataframe <- coalition_strikes_2017 %>% 
  filter(SiteID=="Road")

#Create road only layer
grouped_building_plot <- grouped_building_plot %>% 
  addCircleMarkers(lng=road_only_dataframe$coords.x1, 
                   lat=road_only_dataframe$coords.x2,
                   radius = 3, 
                   stroke=FALSE,
                   fillOpacity= 1,
                   color = "#f46d43", 
                   label=~destruction_type,
                   group="Road") %>% 
  addLayersControl(overlayGroups = c("General Building", "Field", "Road"))

# Dataframe with only schools/universities
school_only_dataframe <- coalition_strikes_2017 %>% 
  filter(SiteID=="School / University")

#Create school only layer
grouped_building_plot <- grouped_building_plot %>% 
  addCircleMarkers(lng=school_only_dataframe$coords.x1, 
                   lat=school_only_dataframe$coords.x2,
                   radius = 3, 
                   stroke=FALSE,
                   fillOpacity= 1,
                   color = "#fee090", 
                   label=~destruction_type,
                   group="School/University") %>% 
  addLayersControl(overlayGroups = c("General Building", "Field", "Road", "School/University"))

# Dataframe with only Industrial facilities
industrial_only_dataframe <- coalition_strikes_2017 %>% 
  filter(SiteID=="Industrial Facility")

#Create industrial only layer
grouped_building_plot <- grouped_building_plot %>% 
  addCircleMarkers(lng=industrial_only_dataframe$coords.x1, 
                   lat=industrial_only_dataframe$coords.x2,
                   radius = 3, 
                   stroke=FALSE,
                   fillOpacity= 1,
                   color = "#ffffbf", 
                   label=~destruction_type,
                   group="Industrial Facility") %>% 
  addLayersControl(overlayGroups = c("General Building", "Field", "Road", "School/University", "Industrial Facility"))

# Dataframe with only mosques
mosque_only_dataframe <- coalition_strikes_2017 %>% 
  filter(SiteID=="Mosque")

#Create mosque only layer
grouped_building_plot <- grouped_building_plot %>% 
  addCircleMarkers(lng=mosque_only_dataframe$coords.x1, 
                   lat=mosque_only_dataframe$coords.x2,
                   radius = 3, 
                   stroke=FALSE,
                   fillOpacity= 1,
                   color = "black", 
                   label=~destruction_type,
                   group="Mosque") %>% 
  addLayersControl(overlayGroups = c("General Building", "Field", "Road", "School/University", "Industrial Facility", "Mosque"))

# Dataframe with only government buildings
government_only_dataframe <- coalition_strikes_2017 %>% 
  filter(SiteID=="Government Building")

#Create government building only layer
grouped_building_plot <- grouped_building_plot %>% 
  addCircleMarkers(lng=government_only_dataframe$coords.x1, 
                   lat=government_only_dataframe$coords.x2,
                   radius = 3, 
                   stroke=FALSE,
                   fillOpacity= 1,
                   color = "#4575b4", 
                   label=~destruction_type,
                   group="Government Building") %>% 
  addLayersControl(overlayGroups = c("General Building", "Field", "Road", "School/University", "Industrial Facility", "Mosque", "Government Building"))

# Dataframe with only hospitals
hospital_only_dataframe <- coalition_strikes_2017 %>% 
  filter(SiteID=="Hospital")

#Create government building only layer
grouped_building_plot <- grouped_building_plot %>% 
  addCircleMarkers(lng=hospital_only_dataframe$coords.x1, 
                   lat=hospital_only_dataframe$coords.x2,
                   radius = 3, 
                   stroke=FALSE,
                   fillOpacity= 1,
                   color = "#313695", 
                   label=~destruction_type,
                   group="Hospital") %>% 
  addLayersControl(overlayGroups = c("General Building", "Field", "Road", "School/University", "Industrial Facility", "Mosque", "Government Building","Hospital"))
