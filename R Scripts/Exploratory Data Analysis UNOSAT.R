library(dplyr)
library(ggplot2)
library(lubridate)

#Load UNOSAT data in dataframe form
raqqa_data <- readRDS("Datasets/Reshaped UNOSAT data.rds")

colnames(raqqa_data)

raqqa_data_summarised <- raqqa_data %>% 
  select(SiteID,Neigh,damage_year,destruction_type,coords.x1,coords.x2) %>% 
  mutate(damage_year=lubridate::ymd(damage_year))

### --- Exploratory Data Analysis

#Total number of buildings destroyed
nrow(raqqa_data_summarised)
# 13155 buildings destroyed over 5 year period

#When were most buildings destroyed or damaged?
no_building_destroyed <- raqqa_data_summarised %>% 
  group_by(damage_year, destruction_type) %>% 
  summarise(n())

#Unsurprisingly most damage occurred during coalition bombing in October 2017
# Over 100000 buildings damaged

colnames(no_building_destroyed)

# Bar chart illustrating severity of damage by date
year_labels <- c("October 2013","February 2014","May 2015","February 2017", "October 2017")
damage_plot <- ggplot(data=no_building_destroyed, aes(x=damage_year, y=`n()`, fill=destruction_type)) +
  geom_bar(stat="identity", position=position_dodge())+
  theme_minimal()+
  ylab("Number of buildings")+
  xlab("")+
  scale_x_discrete( labels= year_labels)+
  ggtitle("Severity of damage to buildings in Raqqa (2013-2017)")
  
scale_x_discrete(name, breaks, labels, limits)


str(no_building_destroyed)

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