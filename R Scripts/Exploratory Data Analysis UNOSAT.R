library(dplyr)
library(ggplot2)
library(lubridate)
library(data.table)
library(formattable)

#Load UNOSAT data in dataframe form
raqqa_data <- readRDS("Datasets/Reshaped UNOSAT data.rds")

colnames(raqqa_data)

raqqa_data_summarised <- raqqa_data %>% 
  select(SiteID,Neigh,damage_year,destruction_type,coords.x1,coords.x2) %>% 
  mutate(damage_year=lubridate::ymd(damage_year))

### --- Exploratory Data Analysis---

#Total number of buildings destroyed
nrow(raqqa_data_summarised)
# 13155 buildings destroyed over 5 year period

### 1. When were most buildings destroyed or damaged?
no_building_destroyed <- raqqa_data_summarised %>% 
  group_by(damage_year, destruction_type) %>% 
  summarise(n())

#Unsurprisingly most damage occurred during coalition bombing in October 2017
# Over 100000 buildings damaged during this time

# Bar chart illustrating severity of damage by date
year_labels <- c("October 2013","February 2014","May 2015","February 2017", "October 2017")
damage_plot <- ggplot(data=no_building_destroyed, aes(x=damage_year, y=`n()`, fill=destruction_type)) +
  geom_bar(stat="identity", position=position_dodge())+
  theme_minimal()+
  ylab("Number of buildings")+
  xlab("")+
  scale_x_discrete( labels= year_labels)+
  ggtitle("Severity of damage to buildings in Raqqa (2013-2017)")
  
### 2. What kind of buildings were destroyed?

# Calculate type of buildings destroyed by year
buildings_destroyed <- raqqa_data_summarised %>% 
  group_by(damage_year,SiteID) %>% 
  summarise(n()) %>% 
  arrange(n()) %>% 
  ungroup()

# Focusing exclusively on the coalition bombing of October 2017
coalition_bombing <- buildings_destroyed %>% 
  filter(damage_year== "2017-10-21") %>% 
  arrange(desc(`n()`)) 

names(coalition_bombing) <- c('Year','Building type','Number')

coalition_bombing <- coalition_bombing %>% 
  select(`Building type`, Number)

coalition_bombing_data_table <- as.data.table(coalition_bombing)
formatted_table <- formattable(coalition_bombing, 
                               align=c("l","l"))

#3. Which neighbourhoods were targeted?
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