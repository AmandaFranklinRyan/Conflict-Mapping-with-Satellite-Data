library(dplyr)
library(purrr) 
library(magick)

raqqa_gif2 <- list.files(path = "Sentinel 2A Imagery/", pattern = "*.png", full.names = T) %>% 
  map(image_read) %>% 
  image_join() %>% 
  image_annotate("Airstrikes on Raqqa, May 2017: November 2017", location = "+10+10", size = 20, color = "white") %>%
  image_animate(fps=1) %>% 
  image_write("raqqa2.gif") 