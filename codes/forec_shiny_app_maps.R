
# create maps ------------------------------------------------------------------

# common map features ------- 
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
                na.color = "transparent")

legendLabels <- c("No/low risk", 
                  "Watch", 
                  "Warning", 
                  "Alert Level 1", 
                  "Alert Level 2")


# Nowcast and near-term forecasts Map -------
leaf_reefs <- mapFun(
  layerNames = c('nowcast_polygons_5km'
                 , 'one_month_forecast_polygons_5km'
                 , 'two_month_forecast_polygons_5km'
                 , 'three_month_forecast_polygons_5km'
                 , 'polygons_GBRMPA_zoning'
                 , 'polygons_management_zoning')
  , groupNames = c('Nowcast'
                   , 'One month forecast'
                   , 'Two month forecast'
                   , 'Three month forecast'
                   , 'GBRMPA nowcast'
                   , 'Management area nowcast')
)

# Scenarios maps  -------

# GA GBR  -------
scenarios_ga_gbr_map <- mapFun(
  layerNames = c('ga_gbr_nowcast_polygons_5km'
                 , 'ga_gbr_polygons_GBRMPA_zoning'
                 , 'ga_gbr_polygons_management_zoning')
  , groupNames = c('GA GBR nowcast'
                   , 'GA GBRMPA nowcast'
                   , 'GA GBR management area nowcast')
)

# WS GBR -------
scenarios_ws_gbr_map <- mapFun(
  layerNames = c('ws_gbr_nowcast_polygons_5km'
                 , 'ws_gbr_polygons_GBRMPA_zoning'
                 , 'ws_gbr_polygons_management_zoning')
  , groupNames = c('WS GBR nowcast'
                   , 'WS GBRMPA nowcast'
                   , 'WS GBR management area nowcast')
)

# GA Pacific -------
scenarios_ga_pac_map <- mapFun(
  layerNames = c('ga_pac_nowcast_polygons_5km'
                 , 'ga_pac_polygons_management_zoning')
  , groupNames = c('GA Pacific nowcast'
                   , 'GA Pacific management area nowcast')
)

# WS Pacific -------
scenarios_ws_pac_map <- mapFun(
  layerNames = c('ws_pac_nowcast_polygons_5km'
                 , 'ws_pac_polygons_management_zoning')
  , groupNames = c('WS Pacific nowcast'
                   , 'WS Pacific management area nowcast')
)

# Historical disease surveys map ------- 
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
