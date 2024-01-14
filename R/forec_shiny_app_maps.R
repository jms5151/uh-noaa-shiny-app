# Create maps for Fore-C shiny app --------------------------------------------------------

# function to add scale bar that adjusts with zoom -----

addScaleBar <- function(map,
                        position = c("topright", "bottomright", "bottomleft", "topleft"),
                        options  = scaleBarOptions( )) {
  
  options <- c(options, list(position = match.arg(position)))

  invokeMethod(map    = map, 
               data   = getMapData(map), 
               method = "addScaleBar", 
                        options)

}

scaleBarOptions <- function(maxWidth       = 100, 
                            metric         = TRUE, 
                            imperial       = TRUE,
                            updateWhenIdle = TRUE) {

  list(maxWidth       = maxWidth, 
       metric         = metric, 
       imperial       = imperial,
       updateWhenIdle = updateWhenIdle)

}

create_basemap <- function (cols         = c("#CCFFFF", "#FFEF00", "#FFB300", "#EB1F08", "#8D1002"),
                            legendLabels = c("No/low risk", "Watch", "Warning", "Alert Level 1", "Alert Level 2")) {

  leaflet( ) %>%
  addTiles(group = "OpenStreetMap") %>%
  addTiles(urlTemplate = "http://server.arcgisonline.com/ArcGIS/rest/services/World_Imagery/MapServer/tile/{z}/{y}/{x}", 
           group       = "Satellite") %>%
  addScaleBar(position = "topright") %>%
  addLegend(position = "topleft",
            colors   = cols,
            labels   = legendLabels,
            title    = "Disease risk",
            opacity  = 1)

}



mapFun <- function (basemap,
                    layerNames = c('nowcast_polygons_5km', 
                                   'one_month_forecast_polygons_5km',
                                   'two_month_forecast_polygons_5km',
                                   'three_month_forecast_polygons_5km',
                                   'polygons_GBRMPA_zoning',
                                   'polygons_management_zoning'),
                     groupNames = c('Nowcast',
                                    'One month forecast',
                                    'Two month forecast',
                                    'Three month forecast',
                                    'GBRMPA nowcast',
                                    'Management area nowcast'), 
                    pal = colorBin(c("#CCFFFF", "#FFEF00", "#FFB300", "#EB1F08", "#8D1002"), 
                                   domain = shpFiles[['nowcast_polygons_5km']]$drisk, 
                                   bins = 0:4, 
                                   na.color = "transparent")) {

  newMap <- basemap
  
  for(i in 1:length(layerNames)){
    newMap <- newMap %>%
      addPolygons(data = shpFiles[[layerNames[i]]],
                  layerId = ~ID,
                  fillColor = ~pal(shpFiles[[layerNames[i]]]$drisk),
                  weight = 2,
                  opacity = 1,
                  color = ~pal(shpFiles[[layerNames[i]]]$drisk),
                  fillOpacity = 0.7,
                  group = groupNames[i],
                  highlightOptions = highlightOptions(color = "black", weight = 3, bringToFront = TRUE)
      )
  }
  
  hideGroupNames <- groupNames[2:length(groupNames)]
  
  newMap %>%
    addLayersControl(
      overlayGroups = groupNames,
      baseGroups = c("Satellite", 
                     "OpenStreetMap"),
      options = layersControlOptions(collapsed = FALSE), # icon versus buttons with text
      position = c("bottomright")) %>%
    hideGroup(hideGroupNames)
  
}

create_historicalMap <- function ( ) {

  leaflet( ) %>%
  addTiles(urlTemplate = "http://server.arcgisonline.com/ArcGIS/rest/services/World_Imagery/MapServer/tile/{z}/{y}/{x}") %>%
  addCircleMarkers(data = historical_data,
                   lat = ~Latitude,
                   lng = ~Longitude,
                   radius = ~9, #sqrt(N)
                   color = ~'yellow',
                   popup = ~survey_text,
                   clusterOptions = markerClusterOptions()) %>%
  addScaleBar( ) %>%
  setView(lng = -180, lat = 16.4502 , zoom = 3)

}


