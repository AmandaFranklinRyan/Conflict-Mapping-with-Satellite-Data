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