# create maps for Fore-C shiny app --------------------------------------------------------

# libraries required :
# if (!require("leaflet")) install.packages("leaflet"); library(leaflet)
# # if (!require("leaflet.extras")) install.packages("leaflet.extras"); library(leaflet.extras) # need if using drawable polygons

# polygons and data layers required (added in forec_shiny_app.R): 
# load("./forec_shiny_app_data/Static_data/historical_surveys.RData")
# load("./forec_shiny_app_data/Forecasts/polygons_5km.Rds")
# load("./forec_shiny_app_data/Static_data/polygons_management_areas.Rds")
# load("./forec_shiny_app_data/Static_data/polygons_GBRMPA_park_zoning.Rds")

# function to add scale bar that adjusts with zoom ---------------------------------------
addScaleBar = function(map,
                       position = c('topright', 'bottomright', 'bottomleft', 'topleft'),
                       options = scaleBarOptions()) {
  
  options = c(options, list(position = match.arg(position)))
  invokeMethod(map, getMapData(map), 'addScaleBar', options)
}

scaleBarOptions = function(maxWidth = 100, metric = TRUE, imperial = TRUE,
                           updateWhenIdle = TRUE) {
  list(maxWidth=maxWidth, metric=metric, imperial=imperial,
       updateWhenIdle=updateWhenIdle)
}

# set colors for different polygon layers -------------------------------------------------
bins <- seq(from = 0,
            to = 4, 
            by = 1
            )

cols <- c("#CCFFFF", 
          "#FFEF00",
          "#FFB300",
          "#EB1F08",
          "#8D1002"
          )

#colorBin function is from leaflet!
pal <- colorBin(cols, 
                domain = polygons_5km$drisk, 
                bins = bins, 
                na.color = "transparent"
                )

# legendLabels <- c("0-5", "6-10", "11-15", "16-25", "26-50", "51-75", "76-100", "NA")
legendLabels <- c("No stress", 
                  "Watch", 
                  "Warning", 
                  "Alert Level 1", 
                  "Alert Level 2"
                  )

gbrmpa_zone_pal <- colorBin(cols,
                            domain = polygons_GBRMPA_park_zoning$drisk,
                            bins = bins,
                            na.color = "transparent"
                            )


management_zone_pal <- colorBin(cols,
                                domain = polygons_management_zoning$drisk,
                                bins = bins,
                                na.color = "transparent"
                                )

# create landing page map of near-term forecasts ------------------------------------------
leaf_reefs <- leaflet() %>%
  addTiles(group = "OpenStreetMap") %>%
  addTiles(urlTemplate="http://server.arcgisonline.com/ArcGIS/rest/services/World_Imagery/MapServer/tile/{z}/{y}/{x}", group = "Satellite") %>%
  addScaleBar("topright") %>% # bottomleft
  addPolygons(data = polygons_5km,
              layerId = ~ID,
              fillColor = ~pal(polygons_5km$drisk),
              weight = 2,
              opacity = 1,
              color = ~pal(polygons_5km$drisk),
              fillOpacity = 0.7,
              group = "5km forecasts",
              highlightOptions = highlightOptions(color = "black", weight = 3, bringToFront = TRUE)
  ) %>%
  addPolygons(data = polygons_GBRMPA_park_zoning,
              group = "GBRMPA park zoning forecasts",
              layerId = ~ID,
              color = ~gbrmpa_zone_pal(polygons_GBRMPA_park_zoning$drisk),
              highlightOptions = highlightOptions(color = "black", weight = 2, bringToFront = TRUE)
  ) %>%
  addPolygons(data = polygons_management_zoning,
              group = "Management area forecasts",
              layerId = ~ID,
              color = ~management_zone_pal(polygons_management_zoning$drisk),
              highlightOptions = highlightOptions(color = "black", weight = 2, bringToFront = TRUE)
  ) %>%
  addLayersControl(
    overlayGroups = c("5km forecasts", 
                      "Management area forecasts", 
                      "GBRMPA park zoning forecasts"),
    baseGroups = c("Satellite", 
                   "OpenStreetMap"),
    options = layersControlOptions(collapsed = FALSE), # icon versus buttons with text
    position = c("bottomright")) %>%
  hideGroup(c("Management area forecasts", 
              "GBRMPA park zoning forecasts")) %>%
  leaflet::addLegend("topleft", 
                     pal = pal, 
                     values = polygons_5km$drisk,
                     title = "Disease risk",
                     labFormat = function(type, cuts, p) {  # Here's the trick
                       paste0(legendLabels) }) 

# create map for scenarios page ------------------------------------------------------------
leaf_scenarios <- leaf_reefs

# x <- leaflet() %>%
#   # addTiles(group = "OpenStreetMap") %>%
#   addTiles(urlTemplate="http://server.arcgisonline.com/ArcGIS/rest/services/World_Imagery/MapServer/tile/{z}/{y}/{x}", group = "Satellite") %>%
#   addScaleBar("topright") %>%
#   setView(lng = -170, lat = 0, zoom = 2)

# create map of historical disease surveys -------------------------------------------------
historicalMap = leaflet() %>%
  addTiles(urlTemplate = "http://server.arcgisonline.com/ArcGIS/rest/services/World_Imagery/MapServer/tile/{z}/{y}/{x}") %>%
  addCircleMarkers(data = historical_data, 
                   lat = ~Latitude, 
                   lng = ~Longitude, 
                   radius = ~sqrt(N), 
                   color = ~'white', 
                   popup = ~survey_text, 
                   clusterOptions = markerClusterOptions()) %>%
  addScaleBar() %>%
  setView(lng = -180, lat = 16.4502 , zoom = 3)
