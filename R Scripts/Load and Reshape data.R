library(rgdal) # loading spacial data
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

###--- Reshape Data ---

# Reshape data to find year when buildings were identified as "Destroyed", "Moderate Damage" or "Severe Damage"
# Buildings can remain destroyed over time or be rebuilt, it's important not to double count
# For the purposes of this analysis the same building can only be classified as damaged/destroyed once
# even if in reality it has been bombed and rebuilt several times, this could lead to under counting destruction

raqqa_dataframe <- as.data.frame(raqqa_data)

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

