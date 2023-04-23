library(rgdal)
library(sp)
library(raster)
library(dplyr)


# Load and view dataset
directory <- "UNOSAT Data/RaqqaDamage"
raqqa_data <- rgdal::readOGR(directory,"Damage_Sites_Raqqa_CDA")
View(head(raqqa_data,30))

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

###--- Exploratory data analysis ---
# Convert spacial dataframe to dataframe and clean

raqqa_dataframe <- as.data.frame(raqqa_data)

colnames(raqqa_dataframe)

# Remove duplicate rows
raqqa_dataframe <-raqqa_dataframe %>% 
  distinct() 

#Identify first date building destruction detected
destroyed_dates <- raqqa_dataframe %>% 
  mutate(destroyed_year=case_when(DaSitCl=="Destroyed"~"2013/10/22",
                                  DaSitCl2=="Destroyed"~"2014/02/12",
                                  DaSitCl3=="Destroyed"~"2015/05/29",
                                  DaSitCl4=="Destroyed"~"2017/02/03",
                                  DaSitCl5=="Destroyed"~"2017/10/21"
                                  ))

#Total number of buildings destroyed
destroyed_no_nas <- destroyed_dates %>% 
  filter(!is.na(destroyed_year))

no_building_destroyed <- destroyed_no_nas %>% 
  group_by(destroyed_year) %>% 
  summarise(n())
# Over 3000 buildings destroyed, 2470 between March and October 2017 during coalition airstrikes

#1. What kind of buildings were destroyed?

# Select destruction of columns by date showing all results where at least 3 buildings of that type have been destroyed
buildings_destroyed <- destroyed_no_nas %>% 
  select(SiteID, Neigh, destroyed_year) %>% 
  group_by(destroyed_year,SiteID) %>% 
  summarise(sum(total=n())) %>% 
  arrange(sum(total=n())) %>% 
  ungroup() %>% 
  dplyr::filter(sum(total=n()) > 5)

top_buildings_destroyed <- dplyr::rename(buildings_destroyed, total=`sum(total=n())`)

#2. Which neighbourhoods were targeted?
neighbourhoods_targeted <- destroyed_no_nas %>% 
  select(SiteID, Neigh, destroyed_year) %>% 
  group_by(destroyed_year,Neigh) %>% 
  summarise(sum(total=n())) %>% 
  arrange(sum(total=n())) %>% 
  ungroup() %>% 
  dplyr::filter(sum(total=n()) > 5)




colnames(buildings_destroyed)
 

#Identify dates of building destruction


nrow(raqqa_summarised)

sum(is.na(raqqa_summarised$DaSitCl))

nrow(raqqa_summarised)

#Identify dates of building destruction



# 1. How many of each type of building have been destroyed, damaged etc?
unique(raqqa_summarised$SiteID) # list of building types
unique(raqqa_summarised$DaSitCl)
unique(raqqa_summarised$DaSitCl)