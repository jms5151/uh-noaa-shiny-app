# Create maps for Fore-C shiny app --------------------------------------------------------

# function to add scale bar that adjusts with zoom -----

addScaleBar <- function(map,
                        position = c('topright', 'bottomright', 'bottomleft', 'topleft'),
                        options  = scaleBarOptions()) {
  
  options = c(options, list(position = match.arg(position)))
  invokeMethod(map, getMapData(map), 'addScaleBar', options)
}

scaleBarOptions <- function(maxWidth       = 100, 
                            metric         = TRUE, 
                            imperial       = TRUE,
                            updateWhenIdle = TRUE) {

  list(maxWidth = maxWidth, 
       metric         = metric, 
       imperial       = imperial,
       updateWhenIdle = updateWhenIdle)
}

# Function to add polygon layers to a basemap -----

mapFun <- function (layerNames, 
                    groupNames) {

  newMap <- reefs_basemap
  
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
