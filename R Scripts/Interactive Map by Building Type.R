# Leaflet/ documentation:https://rdrr.io/cran/leaflet/man/addLegend.html

library(leaflet)
library(dplyr)
library(rio)
library(leaflet.extras) # for extra features like adding search box and reset map button
library(htmltools) #for escaping html
library(htmlwidgets)

###--- Create "interactive leaflet map of Raqqa

###--- Import UNOSAT data and focus on October 2017 (Coalition bombing)
unosat_data <- rio::import("Datasets/Reshaped UNOSAT data.rds")

coalition_strikes_2017 <- unosat_data %>% 
  filter(damage_year=="2017/10/21")

###--- Create plot illustrating distribution of destroyed, moderately damaged and destroyed buildings---

# Create custom destruction colour palette
building_palette <- leaflet::colorFactor(palette=c("#00876c","#003f5c", "#85b96f", "#bdcf75","#f6bc63","#f19452","#e66a4d","#d43d51"),
                                            levels=c(" General Building","Field","Road","School/University","Industrial Facility","Mosque","Government Building","Hospital"))

###--- Create plot with groups to make it look less cluttered---

# Dataframe with only generic buildings buildings
building_only_dataframe <- coalition_strikes_2017 %>% 
  filter(SiteID=="Building (General / Default)")

grouped_building_plot <-   building_only_dataframe %>%
  leaflet()%>% 
  addProviderTiles("OpenStreetMap") %>% 
  setView(lng=39.00897, lat= 35.95394, zoom=14) %>% 
  setMaxBounds(lng1 = 39.05947, 
               lat1 = 35.9745, 
               lng2 = 38.93641, 
               lat2 = 35.92829) %>% 
  clearMarkers() %>%  
  addCircleMarkers(lng=building_only_dataframe$coords.x1, 
                   lat=building_only_dataframe$coords.x2,
                   radius = 2, 
                   stroke=FALSE,
                   fillOpacity= 0.8,
                   color = "#4fa16e", 
                   label=~destruction_type,
                   group="General Building")  

# Dataframe with only Fields
field_only_dataframe <- coalition_strikes_2017 %>% 
  filter(SiteID=="Field")

#Create field layer
grouped_building_plot <- grouped_building_plot %>% 
  addCircleMarkers(lng=field_only_dataframe$coords.x1, 
                   lat=field_only_dataframe$coords.x2,
                   radius = 2, 
                   stroke=FALSE,
                   fillOpacity= 1,
                   color = "#003f5c", 
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
                   radius = 2, 
                   stroke=FALSE,
                   fillOpacity= 1,
                   color = "#85b96f", 
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
                   radius = 2, 
                   stroke=FALSE,
                   fillOpacity= 1,
                   color = "#bdcf75", 
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
                   radius = 2, 
                   stroke=FALSE,
                   fillOpacity= 1,
                   color = "#f6bc63",
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
                   radius = 2, 
                   stroke=FALSE,
                   fillOpacity= 1,
                   color = "#f19452", 
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
                   radius = 2, 
                   stroke=FALSE,
                   fillOpacity= 1,
                   color = "#e66a4d", 
                   label=~destruction_type,
                   group="Government Building") %>% 
  addLayersControl(overlayGroups = c("General Building", "Field", "Road", "School/University", "Industrial Facility", "Mosque", "Government Building"))

# Dataframe with only hospitals
hospital_only_dataframe <- coalition_strikes_2017 %>% 
  filter(SiteID=="Hospital")

#Create hospital only layer
grouped_building_plot <- grouped_building_plot %>% 
  addCircleMarkers(lng=hospital_only_dataframe$coords.x1, 
                   lat=hospital_only_dataframe$coords.x2,
                   radius = 2, 
                   stroke=FALSE,
                   fillOpacity= 1,
                   color = "#d43d51", 
                   label=~destruction_type,
                   group="Hospital") %>% 
  addLayersControl(overlayGroups = c("General Building", "Field", "Road", "School/University", "Industrial Facility", "Mosque", "Government Building","Hospital")) %>% 
  addLegend(pal = building_palette,
            values = c("General Building", "Field", "Road", "School/University", "Industrial Facility", "Mosque", "Government Building","Hospital"),
            title = "Type of building",
            position = "bottomright") %>% 
  leaflet.extras::addResetMapButton()

saveWidget(grouped_building_plot, file="interactive_UNOSAT.html")

