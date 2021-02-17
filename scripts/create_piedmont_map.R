#------------------------------------------------------------------------------#
# Creates a map of the Pidedomnt ecoregion for the Natural History page
#------------------------------------------------------------------------------#
library(magrittr)
library(ggplot2)

proj <- sf::st_crs("EPSG:5070")
ecoregions <- sf::st_read(dsn = "scripts/NA_CEC_Eco_Level3")
ecoregions <- sf::st_transform(ecoregions, proj)
piedmont   <- ecoregions[ecoregions$NA_L3CODE == "8.3.4", ]
bbox_pied  <- sf::st_bbox(piedmont)

usa <- 
  maps::map('state', plot = FALSE, fill = TRUE) %>%
  sf::st_as_sf() %>%
  sf::st_transform(proj) %>%
  sf::st_make_valid() %>%
  sf::st_crop(bbox_pied + (c(-1, -1, 1, 1)*100000))

p <- 
  ggplot() + 
  geom_sf(data = usa, fill = "grey85", color = "grey55", size = 1) + 
  geom_sf(data = piedmont, fill = "#41ab5d", color = NA, alpha = 0.5) +
  theme_void() +
  theme(
    panel.background = element_rect(fill = "transparent", color = NA), # bg of the panel
    
    plot.background = element_rect(fill = "transparent", color = NA), # bg of the plot
    rect = element_rect(fill = "transparent", color = NA)
  )

ggsave(p, file = "static/images/map-piedmont.png", 
       width = 500, height = 500,
       units = "mm",
       bg = "transparent")
