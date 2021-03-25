#------------------------------------------------------------------------------#
# Functions for creating inaturalist maps
#------------------------------------------------------------------------------#
library(magrittr)
library(ggplot2)

proj <- sf::st_crs("EPSG:5070")
ecoregions <- sf::st_read(dsn = "scripts/NA_CEC_Eco_Level3")
ecoregions <- sf::st_transform(ecoregions, proj)
piedmont   <- ecoregions[ecoregions$NA_L3CODE == "8.3.4", ]
bbox_pied  <- sf::st_bbox(piedmont)

clip_box <- bbox_pied + (c(-1, -1, 1, 1)*1000000)

usa <- 
  maps::map('state', plot = FALSE, fill = TRUE) %>%
  sf::st_as_sf() %>%
  sf::st_transform(proj) %>%
  sf::st_make_valid() %>%
  sf::st_crop(clip_box)

get_inaturalist_obs <- function(taxon, .proj = proj){
  rinat::get_inat_obs(
    taxon_id = taxon,
    place_id = "united-states",
    quality = "research", 
    maxresults = 10000) %>%
    sf::st_as_sf(
      coords = c("longitude", "latitude"), 
      crs = sf::st_crs("+proj=longlat +datum=WGS84")
    ) %>%
    sf::st_transform(.proj) %>%
    sf::st_crop(clip_box)
}


map_taxon <- function(taxon){
  obs <- get_inaturalist_obs(taxon)
  
  ggplot() + 
    geom_sf(data = usa, fill = "grey85", color = "grey55", size = 0.1) + 
    geom_sf(data = piedmont, fill = "#41ab5d", color = NA, alpha = 0.5) +
    geom_sf(data = obs, size = 1) +
    theme_void()
}

plants <- c(
  `Parthenium integrolium`      = 83893,
  `Asclepias tuberosa`          = 47912,
  `Coreopsis major`             = 129672,
  `Marshallia obovata`          = 129317,
  `Quercus marilandica`         = 82329,
  `Schizachyrium scoparium`     = 122603,
  `Sorghastrum nutans`          = 122608,
  `Symphyotrichum grandiflorum` = 169466
)


purrr::walk(
  .x = plants,
  .f = ~ {
    print(sprintf("Mapping %s", .x))
    p <- map_taxon(.x)
    ggsave(p, file = sprintf("static/images/map-%s.png", .x), 
           width = 500, height = 500,
           units = "mm")
  }
)





