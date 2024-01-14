
scenarios_page <- function(input, output) {
  
  output$management_map <- renderLeaflet({
    scenarios_placeholder_map
  }) %>% 
  bindCache("placeholder-map")

  observeEvent(
    { 
      input$Region
      input$Disease
    }, 
    handle_dropdown_change(input, output)
  )
}


handle_dropdown_change <- function(input, output) {

  if(input$Region == 'U.S. Pacific' &&
      input$Disease == 'Growth anomalies'){
    
    output$management_map <- renderLeaflet({
      mapFun(basemap = basemap,
             layerNames = c('ga_pac_nowcast_polygons_5km', 'ga_pac_polygons_management_zoning'),
             groupNames = c('GA Pacific nowcast', 'GA Pacific management area nowcast'))
    })
    
  }
  
  if(input$Region == 'U.S. Pacific' &&
      input$Disease == 'White syndromes'){
    
    output$management_map <- renderLeaflet({
      mapFun(basemap = basemap,
             layerNames = c('ws_pac_nowcast_polygons_5km', 'ws_pac_polygons_management_zoning'),
             groupNames = c('WS Pacific nowcast', 'WS Pacific management area nowcast'))
    })
    
  }

  if(input$Region == 'Great Barrier Reef, Australia' &&
      input$Disease == 'Growth anomalies'){
    
    output$management_map <- renderLeaflet({
      mapFun(basemap = basemap,
             layerNames = c('ga_gbr_nowcast_polygons_5km', 'ga_gbr_polygons_GBRMPA_zoning', 'ga_gbr_polygons_management_zoning'), 
             groupNames = c('GA GBR nowcast', 'GA GBRMPA nowcast', 'GA GBR management area nowcast'))
    })
    
  }
  
  if(input$Region == 'Great Barrier Reef, Australia' &&
      input$Disease == 'White syndromes'){
    
    output$management_map <- renderLeaflet({
      mapFun(basemap = basemap,
             layerNames = c('ws_gbr_nowcast_polygons_5km', 'ws_gbr_polygons_GBRMPA_zoning', 'ws_gbr_polygons_management_zoning'),
             groupNames = c('WS GBR nowcast', 'WS GBRMPA nowcast', 'WS GBR management area nowcast'))
    })
    
  }
  
}