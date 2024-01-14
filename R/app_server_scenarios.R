
scenarios_page <- function(input, output) {
  
  output$scenarios_barplot <- renderPlotly({
    scenarios_placeholder_barplot( )
  }) %>% bindCache("placeholder-bar-plot")

  observeEvent(eventExpr   = {
                input$Region
                input$Disease
               }, 
               handlerExpr = handle_dropdown_change(input, output))

  observeEvent(eventExpr   = input$management_map_shape_click, 
               handlerExpr = handle_map_click(input, output))

}


handle_dropdown_change <- function(input, output) {

  if(input$Region == 'U.S. Pacific' && input$Disease == 'Growth anomalies'){
    
    output$management_map <- renderLeaflet({
      mapFun(basemap = basemap,
             layerNames = c('ga_pac_nowcast_polygons_5km', 'ga_pac_polygons_management_zoning'),
             groupNames = c('GA Pacific nowcast', 'GA Pacific management area nowcast'))
    })
    
  }
  
  if(input$Region == 'U.S. Pacific' && input$Disease == 'White syndromes'){
    
    output$management_map <- renderLeaflet({
      mapFun(basemap = basemap,
             layerNames = c('ws_pac_nowcast_polygons_5km', 'ws_pac_polygons_management_zoning'),
             groupNames = c('WS Pacific nowcast', 'WS Pacific management area nowcast'))
    })
    
  }

  if(input$Region == 'Great Barrier Reef, Australia' && input$Disease == 'Growth anomalies'){
    
    output$management_map <- renderLeaflet({
      mapFun(basemap = basemap,
             layerNames = c('ga_gbr_nowcast_polygons_5km', 'ga_gbr_polygons_GBRMPA_zoning', 'ga_gbr_polygons_management_zoning'), 
             groupNames = c('GA GBR nowcast', 'GA GBRMPA nowcast', 'GA GBR management area nowcast'))
    })
    
  }
  
  if(input$Region == 'Great Barrier Reef, Australia' && input$Disease == 'White syndromes'){
    
    output$management_map <- renderLeaflet({
      mapFun(basemap = basemap,
             layerNames = c('ws_gbr_nowcast_polygons_5km', 'ws_gbr_polygons_GBRMPA_zoning', 'ws_gbr_polygons_management_zoning'),
             groupNames = c('WS GBR nowcast', 'WS GBRMPA nowcast', 'WS GBR management area nowcast'))
    })
    
  }
  
}


handle_map_click <- function(input, output) {

  if (input$management_map_shape_click$group == "GA Pacific nowcast") {

    baseVals <- reactive({
      subset(
        ga_pac_basevals_ID,
        ID == input$management_map_shape_click$id
        )
      })

    output$corsize_value_ga_pac <- renderText({
      paste0(
        "Location-specific size, ",
        round(baseVals()$Median_colony_size),
        "  cm"
        )
      })

    output$dev_value_ga_pac <- renderText({
      paste0(
        "Location-specific development, ",
        round((baseVals()$BlackMarble_2016_3km_geo.3/255), 1)
        )
      })
    
    output$herb_fish_value_ga_pac <- renderText({
      paste0(
        "Location-specific density, ",
        round(baseVals()$H_abund, 2),
        " fish/m<sup>2<sup>"
        )
      })
    
    output$turbidity_value_ga_pac <- renderText({
      paste0(
        "Location-specific turbidity, ",
        round(baseVals()$Long_Term_Kd_Median),
        " m<sup>-1</sup>"
      )
    })
    
    size_ga_pac <- reactive({
      subset(
        ga_pac_scenarios,
        ID == input$management_map_shape_click$id &
          Response == 'Coral size' &
          Response_level == input$coral_size_slider_ga_pac
      )
    })
    
    development_ga_pac <- reactive({
      subset(
        ga_pac_scenarios,
        ID == input$management_map_shape_click$id &
          Response == 'Development' &
          Response_level == input$dev_slider_ga_pac
      )
    })
    
    fish_ga_pac <- reactive({
      subset(
        ga_pac_scenarios,
        ID == input$management_map_shape_click$id &
          Response == 'Fish' &
          Response_level == input$herb_fish_slider_ga_pac
      )
    })
    
    turbidity_ga_pac <- reactive({
      subset(
        ga_pac_scenarios,
        ID == input$management_map_shape_click$id &
          Response == 'Turbidity' &
          Response_level == input$turbidity_slider_ga_pac
      )
    })
    
    df_ga_pac <- reactive({
      rbind(
        size_ga_pac(),
        development_ga_pac(),
        fish_ga_pac(),
        turbidity_ga_pac()
      )
    })
    
    output$scenarios_barplot <- renderPlotly({
      scenarios_barplot_fun(
        df = df_ga_pac(),
        baselineValue = baseVals()$value,
        riskType = 'percent'
        )
      })

  }

}