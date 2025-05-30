# # create maps for Fore-C shiny app --------------------------------------------------------
# 
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

# create maps ------------------------------------------------------------------
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

pal <- colorBin(cols, 
                domain = shpFiles[['nowcast_polygons_5km']]$drisk, 
                bins = bins, 
                na.color = "transparent"
)

legendLabels <- c("No/low risk", 
                  "Watch", 
                  "Warning", 
                  "Alert Level 1", 
                  "Alert Level 2"
)

# base map ---------------------------------------------------------------------
reefs_basemap <- leaflet() %>%
  addTiles(group = "OpenStreetMap") %>%
  addTiles(urlTemplate="http://server.arcgisonline.com/ArcGIS/rest/services/World_Imagery/MapServer/tile/{z}/{y}/{x}", group = "Satellite") %>%
  addScaleBar("topright") %>%
  leaflet::addLegend("topleft",
                     colors = cols,
                     labels = legendLabels,
                     title = "Disease risk",
                     opacity = 1)

# Map of nowcasts and near-term forecasts --------------------------------------
leaf_reefs <- reefs_basemap %>%
  addPolygons(data = shpFiles[['nowcast_polygons_5km']],
              layerId = ~ID,
              fillColor = ~pal(shpFiles[['nowcast_polygons_5km']]$drisk),
              weight = 2,
              opacity = 1,
              color = ~pal(shpFiles[['nowcast_polygons_5km']]$drisk),
              fillOpacity = 0.7,
              group = "Nowcast",
              highlightOptions = highlightOptions(color = "black", weight = 3, bringToFront = TRUE)
  ) %>%
  addPolygons(data = shpFiles[['one_month_forecast_polygons_5km']],
              layerId = ~ID,
              fillColor = ~pal(shpFiles[['one_month_forecast_polygons_5km']]$drisk),
              weight = 2,
              opacity = 1,
              color = ~pal(shpFiles[['one_month_forecast_polygons_5km']]$drisk),
              fillOpacity = 0.7,
              group = "One month forecast",
              highlightOptions = highlightOptions(color = "black", weight = 3, bringToFront = TRUE)
  ) %>%
  addPolygons(data = shpFiles[['two_month_forecast_polygons_5km']],
              layerId = ~ID,
              fillColor = ~pal(shpFiles[['two_month_forecast_polygons_5km']]$drisk),
              weight = 2,
              opacity = 1,
              color = ~pal(shpFiles[['two_month_forecast_polygons_5km']]$drisk),
              fillOpacity = 0.7,
              group = "Two month forecast",
              highlightOptions = highlightOptions(color = "black", weight = 3, bringToFront = TRUE)
  ) %>%
  addPolygons(data = shpFiles[['polygons_GBRMPA_zoning']],
              group = "GBRMPA nowcast",
              layerId = ~ID,
              color = ~pal(shpFiles[['polygons_GBRMPA_zoning']]$drisk),
              highlightOptions = highlightOptions(color = "black", weight = 2, bringToFront = TRUE)
  ) %>%
  addPolygons(data = shpFiles[['three_month_forecast_polygons_5km']],
              layerId = ~ID,
              fillColor = ~pal(shpFiles[['three_month_forecast_polygons_5km']]$drisk),
              weight = 2,
              opacity = 1,
              color = ~pal(shpFiles[['three_month_forecast_polygons_5km']]$drisk),
              fillOpacity = 0.7,
              group = "Three month forecast",
              highlightOptions = highlightOptions(color = "black", weight = 3, bringToFront = TRUE)
  ) %>%
  addPolygons(data = shpFiles[['polygons_management_zoning']],
              group = "Management area nowcast",
              layerId = ~ID,
              color = ~pal(shpFiles[['polygons_management_zoning']]$drisk),
              highlightOptions = highlightOptions(color = "black", weight = 2, bringToFront = TRUE)
  ) %>%
  addLayersControl(
    overlayGroups = c("Nowcast",
                      "One month forecast", 
                      "Two month forecast", 
                      "Three month forecast", 
                      "Management area nowcast", 
                      "GBRMPA nowcast"),
    baseGroups = c("Satellite", 
                   "OpenStreetMap"),
    options = layersControlOptions(collapsed = FALSE), # icon versus buttons with text
    position = c("bottomright")) %>%
  hideGroup(c("One month forecast", 
              "Two month forecast", 
              "Three month forecast", 
              "Management area nowcast", 
              "GBRMPA nowcast"))

# Scenarios maps ---------------------------------------------------------------
scenarios_placeholder_map <- reefs_basemap %>%
  setView(lng = -150, lat = 0, zoom = 3)

# ga gbr
scenarios_ga_gbr_map <- reefs_basemap %>% 
  addPolygons(data = shpFiles[['ga_gbr_nowcast_polygons_5km']],
              layerId = ~ID,
              fillColor = ~pal(shpFiles[['ga_gbr_nowcast_polygons_5km']]$drisk),
              weight = 2,
              opacity = 1,
              color = ~pal(shpFiles[['ga_gbr_nowcast_polygons_5km']]$drisk),
              fillOpacity = 0.7,
              group = "GA GBR nowcast",
              highlightOptions = highlightOptions(color = "black", weight = 3, bringToFront = TRUE)
  ) %>%
  addPolygons(data = shpFiles[['ga_gbr_polygons_GBRMPA_zoning']],
              group = "GA GBRMPA nowcast",
              layerId = ~ID,
              color = ~pal(shpFiles[['ga_gbr_polygons_GBRMPA_zoning']]$drisk),
              highlightOptions = highlightOptions(color = "black", weight = 2, bringToFront = TRUE)
  ) %>%
  addPolygons(data = shpFiles[['ga_gbr_polygons_management_zoning']],
              group = "GA GBR management area nowcast",
              layerId = ~ID,
              color = ~pal(shpFiles[['ga_gbr_polygons_management_zoning']]$drisk),
              highlightOptions = highlightOptions(color = "black", weight = 2, bringToFront = TRUE)
  ) %>%
  addLayersControl(
    overlayGroups = c("GA GBR nowcast",
                      "GA GBR management area nowcast", 
                      "GA GBRMPA nowcast"),
    baseGroups = c("Satellite", 
                   "OpenStreetMap"),
    options = layersControlOptions(collapsed = FALSE), # icon versus buttons with text
    position = c("bottomright")) %>%
  hideGroup(c("GA GBR management area nowcast", 
              "GA GBRMPA nowcast"))

# ws gbr
scenarios_ws_gbr_map <- reefs_basemap %>% 
  addPolygons(data = shpFiles[['ws_gbr_nowcast_polygons_5km']],
              layerId = ~ID,
              fillColor = ~pal(shpFiles[['ws_gbr_nowcast_polygons_5km']]$drisk),
              weight = 2,
              opacity = 1,
              color = ~pal(shpFiles[['ws_gbr_nowcast_polygons_5km']]$drisk),
              fillOpacity = 0.7,
              group = "WS GBR nowcast",
              highlightOptions = highlightOptions(color = "black", weight = 3, bringToFront = TRUE)
  ) %>%
  addPolygons(data = shpFiles[['ws_gbr_polygons_GBRMPA_zoning']],
              group = "WS GBRMPA nowcast",
              layerId = ~ID,
              color = ~pal(shpFiles[['ws_gbr_polygons_GBRMPA_zoning']]$drisk),
              highlightOptions = highlightOptions(color = "black", weight = 2, bringToFront = TRUE)
  ) %>%
  addPolygons(data = shpFiles[['ws_gbr_polygons_management_zoning']],
              group = "WS GBR management area nowcast",
              layerId = ~ID,
              color = ~pal(shpFiles[['ws_gbr_polygons_management_zoning']]$drisk),
              highlightOptions = highlightOptions(color = "black", weight = 2, bringToFront = TRUE)
  ) %>%
  addLayersControl(
    overlayGroups = c("WS GBR nowcast",
                      "WS GBR management area nowcast", 
                      "WS GBRMPA nowcast"),
    baseGroups = c("Satellite", 
                   "OpenStreetMap"),
    options = layersControlOptions(collapsed = FALSE), # icon versus buttons with text
    position = c("bottomright")) %>%
  hideGroup(c("WS GBR management area nowcast", 
              "WS GBRMPA nowcast"))

# ga pac
scenarios_ga_pac_map <- reefs_basemap %>% 
  addPolygons(data = shpFiles[['ga_pac_nowcast_polygons_5km']],
              layerId = ~ID,
              fillColor = ~pal(shpFiles[['ga_pac_nowcast_polygons_5km']]$drisk),
              weight = 2,
              opacity = 1,
              color = ~pal(shpFiles[['ga_pac_nowcast_polygons_5km']]$drisk),
              fillOpacity = 0.7,
              group = "GA Pacific nowcast",
              highlightOptions = highlightOptions(color = "black", weight = 3, bringToFront = TRUE)
  ) %>%
  addPolygons(data = shpFiles[['ga_pac_polygons_management_zoning']],
              group = "GA Pacific management area nowcast",
              layerId = ~ID,
              color = ~pal(shpFiles[['ga_pac_polygons_management_zoning']]$drisk),
              highlightOptions = highlightOptions(color = "black", weight = 2, bringToFront = TRUE)
  ) %>%
  addLayersControl(
    overlayGroups = c("GA Pacific nowcast",
                      "GA Pacific management area nowcast"),
    baseGroups = c("Satellite", 
                   "OpenStreetMap"),
    options = layersControlOptions(collapsed = FALSE), # icon versus buttons with text
    position = c("bottomright")) %>%
  hideGroup("GA Pacific management area nowcast")

# ws pac
scenarios_ws_pac_map <- reefs_basemap %>% 
  addPolygons(data = shpFiles[['ws_pac_nowcast_polygons_5km']],
              layerId = ~ID,
              fillColor = ~pal(shpFiles[['ws_pac_nowcast_polygons_5km']]$drisk),
              weight = 2,
              opacity = 1,
              color = ~pal(shpFiles[['ws_pac_nowcast_polygons_5km']]$drisk),
              fillOpacity = 0.7,
              group = "WS Pacific nowcast",
              highlightOptions = highlightOptions(color = "black", weight = 3, bringToFront = TRUE)
  ) %>%
  addPolygons(data = shpFiles[['ws_pac_polygons_management_zoning']],
              group = "WS Pacific management area nowcast",
              layerId = ~ID,
              color = ~pal(shpFiles[['ws_pac_polygons_management_zoning']]$drisk),
              highlightOptions = highlightOptions(color = "black", weight = 2, bringToFront = TRUE)
  ) %>%
  addLayersControl(
    overlayGroups = c("WS Pacific nowcast",
                      "WS Pacific management area nowcast"),
    baseGroups = c("Satellite", 
                   "OpenStreetMap"),
    options = layersControlOptions(collapsed = FALSE), # icon versus buttons with text
    position = c("bottomright")) %>%
  hideGroup("WS Pacific management area nowcast")

# Historical disease surveys map -----------------------------------------------
historicalMap = leaflet() %>%
  addTiles(urlTemplate = "http://server.arcgisonline.com/ArcGIS/rest/services/World_Imagery/MapServer/tile/{z}/{y}/{x}") %>%
  addCircleMarkers(data = historical_data,
                   lat = ~Latitude,
                   lng = ~Longitude,
                   radius = ~9, #sqrt(N)
                   color = ~'yellow',
                   popup = ~survey_text,
                   clusterOptions = markerClusterOptions()) %>%
  addScaleBar() %>%
  setView(lng = -180, lat = 16.4502 , zoom = 3)
