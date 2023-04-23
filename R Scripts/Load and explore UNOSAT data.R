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
unique(raqqa_dataframe$DaSitCl)

###--- Reshape Data ---

# Reshape data to find year when buildings were identified as "Destroyed", "Moderate Damage" or "Severe Damage"
# Buildings can remain destroyed over time or be rebuilt, it's important not to double count
# For the purposes of this analysis the same building can only be classified as damaged/destroyed once
# even if in reality it has been bombed and rebuilt several times, this could lead to under counting destruction

# Remove duplicate rows
raqqa_dataframe <-raqqa_dataframe %>% 
  distinct()

#Identify first date building destruction detected
destroyed_dates <- raqqa_dataframe %>% 
  mutate(damage_year=case_when(DaSitCl=="Destroyed"~"2013/10/22",
                                  DaSitCl2=="Destroyed"~"2014/02/12",
                                  DaSitCl3=="Destroyed"~"2015/05/29",
                                  DaSitCl4=="Destroyed"~"2017/02/03",
                                  DaSitCl5=="Destroyed"~"2017/10/21"))

#Add destroyed column
destroyed_dates <- destroyed_dates %>% 
  mutate(destruction_type=if_else(!is.na(damage_year),"Destroyed",damage_year))

# Extract destroyed entries into single dataframe
destroyed_dataframe <- destroyed_dates %>% 
  filter(destruction_type=="Destroyed")
         
# Remove rows from data frame and use same method to identify dates buildings had "Moderate Damage"
severe_damaged_dates <- destroyed_dates %>% 
  filter(is.na(destruction_type)) %>% #  Can't use != as doesn't handle NAs well
  mutate(damage_year=case_when(DaSitCl=="Severe Damage"~"2013/10/22",
                                  DaSitCl2=="Severe Damage"~"2014/02/12",
                                  DaSitCl3=="Severe Damage"~"2015/05/29",
                                  DaSitCl4=="Severe Damage"~"2017/02/03",
                                  DaSitCl5=="Severe Damage"~"2017/10/21"))
  
#Add "Severe damage" column
severe_damaged_dates  <- severe_damaged_dates  %>% 
  mutate(destruction_type=if_else(!is.na(damage_year),"Severe Damage",damage_year)) 

# Extract "Severe damage" into single dataframe
severe_damage_dataframe <- severe_damaged_dates %>% 
  filter(destruction_type=="Severe Damage")

# Remove rows from data frame and use same method to identify dates buildings had "Moderate Damage"
moderate_damaged_dates <- severe_damaged_dates %>% 
  filter(is.na(destruction_type)) %>% #  Can't use != as doesn't handle NAs well
  mutate(damage_year=case_when(DaSitCl=="Moderate Damage"~"2013/10/22",
                               DaSitCl2=="Moderate Damage"~"2014/02/12",
                               DaSitCl3=="Moderate Damage"~"2015/05/29",
                               DaSitCl4=="Moderate Damage"~"2017/02/03",
                               DaSitCl5=="Moderate Damage"~"2017/10/21",
                               SiteID=="Road"~"2017/10/21",
                               SiteID=="Field"~"2017/10/21"))

#Add "Moderate damage" column
moderate_damaged_dates  <- moderate_damaged_dates %>% 
  mutate(destruction_type=if_else(!is.na(damage_year),"Moderate Damage",damage_year))

# Extract Moderate" entries into single dataframe
moderate_damage_dataframe <- moderate_damaged_dates %>% 
  filter(destruction_type=="Moderate Damage")

# Combine destroyed, severe and moderate dataframes into single dataframe

raqqa_dataframe_reshaped <- rbind(severe_damage_dataframe, moderate_damage_dataframe, destroyed_dataframe)

undefined_damaged_dates <- moderate_damaged_dates %>% 
  filter(is.na(destruction_type))





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