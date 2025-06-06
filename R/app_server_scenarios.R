
scenarios_page <- function(input, output) {
  
  output$scenarios_barplot <- renderPlotly({
    scenarios_placeholder_barplot( )
  }) %>% 
  bindCache(Sys.Date( ))

  output$management_map <- renderPlotly({
    create_basemap( )
  }) %>% 
  bindCache(Sys.Date( ))

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
    
    output$scenarios_barplot <- renderPlotly({
      scenarios_placeholder_barplot( )
    })

  }
  
  if(input$Region == 'U.S. Pacific' && input$Disease == 'White syndromes'){
    
    output$management_map <- renderLeaflet({
      mapFun(basemap = basemap,
             layerNames = c('ws_pac_nowcast_polygons_5km', 'ws_pac_polygons_management_zoning'),
             groupNames = c('WS Pacific nowcast', 'WS Pacific management area nowcast'))
    })
    
    output$scenarios_barplot <- renderPlotly({
      scenarios_placeholder_barplot( )
    })
    
  }

  if(input$Region == 'Great Barrier Reef, Australia' && input$Disease == 'Growth anomalies'){
    
    output$management_map <- renderLeaflet({
      mapFun(basemap = basemap,
             layerNames = c('ga_gbr_nowcast_polygons_5km', 'ga_gbr_polygons_GBRMPA_zoning', 'ga_gbr_polygons_management_zoning'), 
             groupNames = c('GA GBR nowcast', 'GA GBRMPA nowcast', 'GA GBR management area nowcast'))
    })
    
    output$scenarios_barplot <- renderPlotly({
      scenarios_placeholder_barplot( )
    })
    
  }
  
  if(input$Region == 'Great Barrier Reef, Australia' && input$Disease == 'White syndromes'){
    
    output$management_map <- renderLeaflet({
      mapFun(basemap = basemap,
             layerNames = c('ws_gbr_nowcast_polygons_5km', 'ws_gbr_polygons_GBRMPA_zoning', 'ws_gbr_polygons_management_zoning'),
             groupNames = c('WS GBR nowcast', 'WS GBRMPA nowcast', 'WS GBR management area nowcast'))
    })
    
    output$scenarios_barplot <- renderPlotly({
      scenarios_placeholder_barplot( )
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


  if (input$management_map_shape_click$group == "WS Pacific nowcast") {

      baseVals <- reactive({
        subset(
          ws_pac_basevals_ID,
          ID == input$management_map_shape_click$id
        )
      })
      
      output$corsize_value_ws_pac <- renderText({
        paste0(
          "Location-specific size, ",
          round(baseVals()$Median_colony_size),
          "  cm"
        )
      })

      output$parrotfish_value_ws_pac <- renderText({
        paste0(
          "Location-specific density, ",
          round(baseVals()$Parrotfish_abund, 2),
          " fish/m<sup>2<sup>"
        )
      })
      
      output$kd_value_ws_pac <- renderText({
        paste0(
          "Location-specific turbidity, ",
          round(baseVals()$Long_Term_Kd_Median, 2),
          "  m<sup>-1</sup>"
        )
      })


      output$herb_fish_value_ws_pac <- renderText({
        paste0(
          "Location-specific density, ",
          round(baseVals()$H_abund, 2),
          " fish/m<sup>2<sup>"
        )
      })
      
      output$corcov_value_ws_pac <- renderText({
        paste0(
          "Location-specific cover, ",
          round(baseVals()$mean_cover),
          "  %"
        )
      })

      size_ws_pac <- reactive({
        subset(
          ws_pac_scenarios,
          ID == input$management_map_shape_click$id &
            Response == 'Coral size' &
            Response_level == input$coral_size_slider_ws_pac
        )
      })

      parrotfish_ws_pac <- reactive({
        subset(
          ws_pac_scenarios,
          ID == input$management_map_shape_click$id &
            Response == 'Parrotfish density' &
            Response_level == input$parrotfish_slider_ws_pac
        )
      })
      
      turbidity_ws_pac <- reactive({
        subset(
          ws_pac_scenarios,
          ID == input$management_map_shape_click$id &
            Response == 'Turbidity' &
            Response_level == input$turbidity_slider_ws_pac
        )
      })

      herb_fish_ws_pac <- reactive({
        subset(
          ws_pac_scenarios,
          ID == input$management_map_shape_click$id &
            Response == 'Herb. fish' &
            Response_level == input$herb_fish_slider_ws_pac
        )
      })
      
      cover_ws_pac <- reactive({
        subset(
          ws_pac_scenarios,
          ID == input$management_map_shape_click$id &
            Response == 'Coral cover' &
            Response_level == input$coral_cover_slider_ws_pac
        )
      })

      df_ws_pac <- reactive({
        rbind(
          size_ws_pac(),
          parrotfish_ws_pac(),
          turbidity_ws_pac(),
          herb_fish_ws_pac(),
          cover_ws_pac()
        )
      })

      output$scenarios_barplot <- renderPlotly({
        scenarios_barplot_fun(
          df = df_ws_pac(),
          baselineValue = baseVals()$value,
          riskType = 'percent'
        )
      })
  }

  if (input$management_map_shape_click$group == "GA GBR nowcast") {

    baseVals <- reactive({
      subset(
        ga_gbr_basevals_ID,
        ID == input$management_map_shape_click$id
      )
    })
    
    output$fish_value_ga_gbr <- renderText({
      paste0(
        "Location-specific abundance, ",
        round(baseVals()$Fish_abund),
        " fish"
      )
    })
    
    output$corcov_value_ga_gbr <- renderText({
      paste0(
        "Location-specific cover, ",
        round(baseVals()$Coral_cover),
        "  %"
      )
    })
    
    output$kd_value_ga_gbr <- renderText({
      paste0(
        "Location-specific turbidity, ",
        round(baseVals()$Long_Term_Kd_Variability, 2),
        "  m<sup>-1</sup>"
      )
    })
    
    fish_ga_gbr <- reactive({
      subset(
        ga_gbr_scenarios,
        ID == input$management_map_shape_click$id &
          Response == 'Fish' &
          Response_level == input$fish_slider_ga_gbr
      )
    })
    
    cover_ga_gbr <- reactive({
      subset(
        ga_gbr_scenarios,
        ID == input$management_map_shape_click$id &
          Response == 'Coral cover' &
          Response_level == input$coral_cover_slider_ga_gbr
      )
    })
    
    turbidity_ga_gbr <- reactive({
      subset(
        ga_gbr_scenarios,
        ID == input$management_map_shape_click$id &
          Response == 'Turbidity' &
          Response_level == input$turbidity_slider_ga_gbr
      )
    })
    
    df_ga_gbr <- reactive({
      rbind(
        fish_ga_gbr(),
        cover_ga_gbr(),
        turbidity_ga_gbr()
      )
    })
    
    output$scenarios_barplot <- renderPlotly({
      scenarios_barplot_fun(
        df = df_ga_gbr(),
        baselineValue = baseVals()$value,
        riskType = 'abundance'
      )
    })
    
  }

  if (input$management_map_shape_click$group == "WS GBR nowcast") {

    baseVals <- reactive({
      subset(
        ws_gbr_basevals_ID,
        ID == input$management_map_shape_click$id
        )
    })

    output$corcov_value_ws_gbr <- renderText({
      paste0(
        "Location-specific cover, ",
        round(baseVals()$Coral_cover),
        "  %"
      )
    })

    output$fish_value_ws_gbr <- renderText({
      paste0(
        "Location-specific abundance, ",
        round(baseVals()$Fish_abund),
        " fish"
      )
    })

    output$kd_value_ws_gbr <- renderText({
      paste0(
        "Location-specific turbidity, ",
        round(baseVals()$Three_Week_Kd_Variability, 2),
        "  m<sup>-1</sup>"
        )
      })

    cover_ws_gbr <- reactive({
      subset(
        ws_gbr_scenarios,
        ID == input$management_map_shape_click$id &
          Response == 'Coral cover' &
          Response_level == input$coral_cover_slider_ws_gbr
      )
    })

    fish_ws_gbr <- reactive({
      subset(
        ws_gbr_scenarios,
        ID == input$management_map_shape_click$id &
          Response == 'Fish' &
          Response_level == input$fish_slider_ws_gbr
      )
    })

    turbidity_ws_gbr <- reactive({
      subset(
        ws_gbr_scenarios,
        ID == input$management_map_shape_click$id &
          Response == 'Turbidity' &
          Response_level == input$turbidity_slider_ws_gbr
      )
    })

    df_ws_gbr <- reactive({
      rbind(
        cover_ws_gbr(),
        fish_ws_gbr(),
        turbidity_ws_gbr()
      )
    })

    output$scenarios_barplot <- renderPlotly({
      scenarios_barplot_fun(
        df = df_ws_gbr(),
        baselineValue = baseVals()$value,
        riskType = 'abundance'
      )
    })

  }


  if(input$management_map_shape_click$group == "GA Pacific management area nowcast") {

    baseVals <- reactive({
      subset(
        ga_pac_basevals_management,
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
        "  m<sup>-1</sup>"
      )
    })


    
    size_ga_pac <- reactive({
      subset(
        ga_pac_scenarios_aggregated_to_management_zones,
        ID == input$management_map_shape_click$id &
          Response == 'Coral size' &
          Response_level == input$coral_size_slider_ga_pac
      )
    })
    
    development_ga_pac <- reactive({
      subset(
        ga_pac_scenarios_aggregated_to_management_zones,
        ID == input$management_map_shape_click$id &
          Response == 'Development' &
          Response_level == input$dev_slider_ga_pac
      )
    })
    
    fish_ga_pac <- reactive({
      subset(
        ga_pac_scenarios_aggregated_to_management_zones,
        ID == input$management_map_shape_click$id &
          Response == 'Fish' &
          Response_level == input$herb_fish_slider_ga_pac
      )
    })
    
    turbidity_ga_pac <- reactive({
      subset(
        ga_pac_scenarios_aggregated_to_management_zones,
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

    if (input$management_map_shape_click$group == "WS Pacific management area nowcast") {
      
      baseVals <- reactive({
        subset(
          ws_pac_basevals_management,
          ID == input$management_map_shape_click$id
        )
      })
      
      output$corsize_value_ws_pac <- renderText({
        paste0(
          "Location-specific size, ",
          round(baseVals()$Median_colony_size),
          "  cm"
        )
      })
      
      output$kd_value_ws_pac <- renderText({
        paste0(
          "Location-specific turbidity, ",
          round(baseVals()$Long_Term_Kd_Median, 2),
          "  m<sup>-1</sup>"
        )
      })
      
      output$corcov_value_ws_pac <- renderText({
        paste0(
          "Location-specific cover, ",
          round(baseVals()$mean_cover),
          "  %"
        )
      })
      
      output$herb_fish_value_ws_pac <- renderText({
        paste0(
          "Location-specific density, ",
          round(baseVals()$H_abund, 2),
          " fish/m<sup>2<sup>"
        )
      })
      
      size_ws_pac <- reactive({
        subset(
          ws_pac_scenarios_aggregated_to_management_zones,
          ID == input$management_map_shape_click$id &
            Response == 'Coral size' &
            Response_level == input$coral_size_slider_ws_pac
        )
      })
      
      parrotfish_ws_pac <- reactive({
        subset(
          ws_pac_scenarios_aggregated_to_management_zones,
          ID == input$management_map_shape_click$id &
            Response == 'Parrotfish density' &
            Response_level == input$parrotfish_slider_ws_pac
        )
      })
      
      turbidity_ws_pac <- reactive({
        subset(
          ws_pac_scenarios_aggregated_to_management_zones,
          ID == input$management_map_shape_click$id &
            Response == 'Turbidity' &
            Response_level == input$turbidity_slider_ws_pac
        )
      })
      
      herb_fish_ws_pac <- reactive({
        subset(
          ws_pac_scenarios_aggregated_to_management_zones,
          ID == input$management_map_shape_click$id &
            Response == 'Herb. fish' &
            Response_level == input$herb_fish_slider_ws_pac
        )
      })
      
      cover_ws_pac <- reactive({
        subset(
          ws_pac_scenarios_aggregated_to_management_zones,
          ID == input$management_map_shape_click$id &
            Response == 'Coral cover' &
            Response_level == input$coral_cover_slider_ws_pac
        )
      })
      
      df_ws_pac <- reactive({
        rbind(
          size_ws_pac(),
          parrotfish_ws_pac(),
          turbidity_ws_pac(),
          herb_fish_ws_pac(),
          cover_ws_pac()
        )
      })
      
      output$scenarios_barplot <- renderPlotly({
        scenarios_barplot_fun(
          df = df_ws_pac(),
          baselineValue = baseVals()$value,
          riskType = 'percent'
        )
      })
      
    }
 

    if (input$management_map_shape_click$group == "GA GBR management area nowcast") {

      baseVals <- reactive({
        subset(
          ga_gbr_basevals_management,
          ID == input$management_map_shape_click$id
        )
      })
      
      output$fish_value_ga_gbr <- renderText({
        paste0(
          "Location-specific abundance, ",
          round(baseVals()$Fish_abund),
          " fish"
        )
      })
      
      output$corcov_value_ga_gbr <- renderText({
        paste0(
          "Location-specific cover, ",
          round(baseVals()$Coral_cover),
          "  %"
        )
      })
      
      output$kd_value_ga_gbr <- renderText({
        paste0(
          "Location-specific turbidity, ",
          round(baseVals()$Long_Term_Kd_Variability, 2),
          "  m<sup>-1</sup>"
        )
      })

      fish_ga_gbr <- reactive({
        subset(
          ga_gbr_scenarios_aggregated_to_management_zones,
          ID == input$management_map_shape_click$id &
            Response == 'Fish' &
            Response_level == input$fish_slider_ga_gbr
        )
      })
      
      cover_ga_gbr <- reactive({
        subset(
          ga_gbr_scenarios_aggregated_to_management_zones,
          ID == input$management_map_shape_click$id &
            Response == 'Coral cover' &
            Response_level == input$coral_cover_slider_ga_gbr
        )
      })
      
      turbidity_ga_gbr <- reactive({
        subset(
          ga_gbr_scenarios_aggregated_to_management_zones,
          ID == input$management_map_shape_click$id &
            Response == 'Turbidity' &
            Response_level == input$turbidity_slider_ga_gbr
        )
      })
      
      df_ga_gbr <- reactive({
        rbind(
          fish_ga_gbr(),
          cover_ga_gbr(),
          turbidity_ga_gbr()
        )
      })

      output$scenarios_barplot <- renderPlotly({
        scenarios_barplot_fun(
          df = df_ga_gbr(),
          baselineValue = baseVals()$value,
          riskType = 'abundance'
        )
      })
  }

  if (input$management_map_shape_click$group == "WS GBR management area nowcast") {

      baseVals <- reactive({
        subset(
          ws_gbr_basevals_management,
          ID == input$management_map_shape_click$id
        )
      })
      
      output$corcov_value_ws_gbr <- renderText({
        paste0(
          "Location-specific cover, ",
          round(baseVals()$Coral_cover),
          "  %"
        )
      })
      
      output$fish_value_ws_gbr <- renderText({
        paste0(
          "Location-specific abundance, ",
          round(baseVals()$Fish_abund),
          " fish"
        )
      })
      
      output$kd_value_ws_gbr <- renderText({
        paste0(
          "Location-specific turbidity, ",
          round(baseVals()$Three_Week_Kd_Variability, 2),
          "  m<sup>-1</sup>"
        )
      })
      
      cover_ws_gbr <- reactive({
        subset(
          ws_gbr_scenarios_aggregated_to_management_zones,
          ID == input$management_map_shape_click$id &
            Response == 'Coral cover' &
            Response_level == input$coral_cover_slider_ws_gbr
        )
      })
      
      fish_ws_gbr <- reactive({
        subset(
          ws_gbr_scenarios_aggregated_to_management_zones,
          ID == input$management_map_shape_click$id &
            Response == 'Fish' &
            Response_level == input$fish_slider_ws_gbr
        )
      })
      
      turbidity_ws_gbr <- reactive({
        subset(
          ws_gbr_scenarios_aggregated_to_management_zones,
          ID == input$management_map_shape_click$id &
            Response == 'Turbidity' &
            Response_level == input$turbidity_slider_ws_gbr
        )
      })
      
      df_ws_gbr <- reactive({
        rbind(
          cover_ws_gbr(),
          fish_ws_gbr(),
          turbidity_ws_gbr()
        )
      })
      
      output$scenarios_barplot <- renderPlotly({
        scenarios_barplot_fun(
          df = df_ws_gbr(),
          baselineValue = baseVals()$value,
          riskType = 'abundance'
        )
      })
  }

 if (input$management_map_shape_click$group == "GA GBRMPA nowcast") {

    baseVals <- reactive({
      subset(
        ga_gbr_basevals_gbrmpa,
        ID == input$management_map_shape_click$id
      )
    })
    
    output$fish_value_ga_gbr <- renderText({
      paste0(
        "Location-specific abundance, ",
        round(baseVals()$Fish_abund),
        " fish"
      )
    })
    
    output$corcov_value_ga_gbr <- renderText({
      paste0(
        "Location-specific cover, ",
        round(baseVals()$Coral_cover),
        "  %"
      )
    })
    
    output$kd_value_ga_gbr <- renderText({
      paste0(
        "Location-specific turbidity, ",
        round(baseVals()$Long_Term_Kd_Variability, 2),
        "  m<sup>-1</sup>"
      )
    })

    fish_ga_gbr <- reactive({
      subset(
        ga_gbr_scenarios_aggregated_to_gbrmpa_park_zones,
        ID == input$management_map_shape_click$id &
          Response == 'Fish' &
          Response_level == input$fish_slider_ga_gbr
      )
    })
    
    cover_ga_gbr <- reactive({
      subset(
        ga_gbr_scenarios_aggregated_to_gbrmpa_park_zones,
        ID == input$management_map_shape_click$id &
          Response == 'Coral cover' &
          Response_level == input$coral_cover_slider_ga_gbr
      )
    })
    
    turbidity_ga_gbr <- reactive({
      subset(
        ga_gbr_scenarios_aggregated_to_gbrmpa_park_zones,
        ID == input$management_map_shape_click$id &
          Response == 'Turbidity' &
          Response_level == input$turbidity_slider_ga_gbr
      )
    })
    
    df_ga_gbr <- reactive({
      rbind(
        fish_ga_gbr(),
        cover_ga_gbr(),
        turbidity_ga_gbr()
      )
    })
    
    output$scenarios_barplot <- renderPlotly({
      scenarios_barplot_fun(
        df = df_ga_gbr(),
        baselineValue = baseVals()$value,
        riskType = 'abundance'
      )
    })
    
  }


 if (input$management_map_shape_click$group == "WS GBRMPA nowcast") {

  baseVals <- reactive({
    subset(
      ws_gbr_basevals_gbrmpa,
      ID == input$management_map_shape_click$id
    )
  })
  
  output$corcov_value_ws_gbr <- renderText({
    paste0(
      "Location-specific cover, ",
      round(baseVals()$Coral_cover),
      "  %"
    )
  })
  
  output$fish_value_ws_gbr <- renderText({
    paste0(
      "Location-specific abundance, ",
      round(baseVals()$Fish_abund),
      " fish"
    )
  })
  
  output$kd_value_ws_gbr <- renderText({
    paste0(
      "Location-specific turbidity, ",
      round(baseVals()$Three_Week_Kd_Variability, 2),
      "  m<sup>-1</sup>"
    )
  })
  
  cover_ws_gbr <- reactive({
    subset(
      ws_gbr_scenarios_aggregated_to_gbrmpa_park_zones,
      ID == input$management_map_shape_click$id &
        Response == 'Coral cover' &
        Response_level == input$coral_cover_slider_ws_gbr
    )
  })
  
  fish_ws_gbr <- reactive({
    subset(
      ws_gbr_scenarios_aggregated_to_gbrmpa_park_zones,
      ID == input$management_map_shape_click$id &
        Response == 'Fish' &
        Response_level == input$fish_slider_ws_gbr
    )
  })
  
  turbidity_ws_gbr <- reactive({
    subset(
      ws_gbr_scenarios_aggregated_to_gbrmpa_park_zones,
      ID == input$management_map_shape_click$id &
        Response == 'Turbidity' &
        Response_level == input$turbidity_slider_ws_gbr
    )
  })
  
  df_ws_gbr <- reactive({
    rbind(
      cover_ws_gbr(),
      fish_ws_gbr(),
      turbidity_ws_gbr()
    )
  })
  
  output$scenarios_barplot <- renderPlotly({
    scenarios_barplot_fun(
      df = df_ws_gbr(),
      baselineValue = baseVals()$value,
      riskType = 'abundance'
      )
  })

  }


}