library(leaflet)
library(readr)
library(dataRetrieval)
library(sf)

sites_all3_streams <- read_csv("/nfs/rivershift-data/us-data/sites_all3_streams.csv", col_types = "c")

site_info <- dataRetrieval::readNWISsite(sites_all3_streams$site_no)

head(site_info)
unique(site_info$dec_coord_datum_cd) # all in NAD83, epsg:4269
# https://spatialreference.org/ref/epsg/nad83/

sites_sf <- st_as_sf(site_info, 
                     coords = c("dec_long_va", "dec_lat_va"),
                     crs = 4269)

leaflet() %>%
  addTiles() %>%
  addMarkers(data = sites_sf, clusterOptions = markerClusterOptions(), 
             popup = ~glue("{station_nm} <br> Drainage Area: {drain_area_va}"))
