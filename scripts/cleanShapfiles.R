if (exists("startrun")) {
  print(fortunes::fortune())
} else {
  source(here::here("scripts", "startHere.R"))
}

# source https://www.census.gov/geographies/mapping-files/time-series/geo/cartographic-boundary.html



saveCountyShapefile <- function(CountyName) {
  countyShapefile <- sf::read_sf(here::here("data", "raw", "shapefiles", "counties", "cb_2023_us_county_500k", "cb_2023_us_county_500k.shp")) %>%
    # select(STATE_NAME) %>% unique()
    filter(STATE_NAME == "Tennessee" &
      str_detect(NAME, CountyName))
  fileName <- here::here("data", "processed", "shapefiles", CountyName, str_c(CountyName, "Shapefile.shp"))
  if (file.exists(fileName)) {
    print(str_c(CountyName, " file already exists"))
  } else {
    sf::st_write(countyShapefile, fileName)
  }
}

countyNames <- c(
  "Anderson",
  "Blount",
  "Campbell",
  "Claiborne",
  "Cocke",
  "Grainger",
  "Hamblen",
  "Jefferson",
  "Knox",
  "Loudon",
  "Monroe",
  "Morgan",
  "Roane",
  "Scott",
  "Sevier",
  "Union"
)
for (name in countyNames) {
  saveCountyShapefile(name)
}


# sf::read_sf(here::here("data",'raw',"shapefiles","counties","cb_2023_us_county_500k","cb_2023_us_county_500k.shp")) %>%
#   # select(STATE_NAME) %>% unique()
#   filter(STATE_NAME=="Tennessee"
#          & str_detect(NAME,"Grainger")
#   ) %>%
#  plot()

load(here::here('data',"interim", "CountyPlaceNameLists.rda"))

placeName <- ETDDPlaces[1]


saveplaceShapefile <- function(placeName) {
  
placeShapefile <- sf::read_sf(here::here("data", "raw", "shapefiles", "places", "cb_2023_47_place_500k", "cb_2023_47_place_500k.shp")) %>%
  # select(STATE_NAME) %>% unique()
  filter(STATE_NAME == "Tennessee" &
           str_detect(NAME, placeName))
fileName <- here::here("data", "processed", "shapefiles", "places", str_c(placeName, "Shapefile.shp"))
if (file.exists(fileName)) {
  print(str_c(placeName, " file already exists"))
} else {
  sf::st_write(placeShapefile, fileName)
}
}
for (place in ETDDPlaces) {
  saveplaceShapefile(place)
}



# states <- terra::
