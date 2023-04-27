library(dplyr)
library(purrr) 
library(magick)

chennai_gif <- list.files(path = "Sentinel 2 Satellite Imagery/", pattern = "*.png", full.names = T) %>% 
  map(image_read) %>% 
  image_join() %>% 
  image_annotate("Airstrikes on Raqqa, May 2017: November 2017", location = "+10+10", size = 20, color = "white") %>%
  image_animate(fps=4) %>% 
  image_write("raqqa.gif") 