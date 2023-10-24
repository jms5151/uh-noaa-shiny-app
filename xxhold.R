
nowcasts_and_forecasts_panel <- function (app_text     = app_text( ),
                                          app_settings = app_settings( )) {

  tabPanel(title = "Coral disease predictions",
           fluidRow(column(width = 12,
                           h2(strong(app_text$welcome_txt, 
                                     style = "color: #009999;")),
                           h5(app_text$landing_page_info_txt, 
                              style = "color: #009999;"))), 
                           uiOutput("noaa_ref"),
           br( ),
           fluidRow(style = "border-style: double; border-color: #00172D;"),
                    column(width = 3,
                           style = "border-right: double; border-color: #00172D;",
                           h4("Risk nowcast (region, disease)",
                              align = "center",
                              style = "background-color: #00172D;
                              color: white;
                              padding-bottom: 3px"),
                           h4(app_text$forecasts_step_1_txt, 
                              style = "color: #009999;"),
                           h6(app_text$forecasts_step_1_txt_sub, 
                              style = "color: #009999;"), 
                           br( )),
                    column(width = 6,
                           h4("Risk map (total disease)",
                              align = "center",
                              style = "background-color: #00172D;
                              color: white;
                              padding-bottom: 3px"),
                           h4(app_text$forecasts_step_2_txt, 
                              style = "color: #009999;"),
                           h6(app_text$forecasts_step_2_txt_sub, 
                              style = "color: #009999;"), 
                           br( )),
                    column(width = 3,
                           style = "border-left: double; border-color: #00172D;",
                           h4("Risk predictions",
                              align = "center",
                              style = "background-color: #00172D;
                              color: white;
                              padding-bottom: 3px"),
                           h4(app_text$forecasts_step_3_txt,
                              style = "color: #009999;"),
                           h6(app_text$forecasts_step_3_txt_sub,
                              style = "color: #009999;"),
                           br( )),

           hr( ),
           textOutput(outputId = "last_update"))



}


  forecast_page(input, output)

forecast_page <- function(input, output) {


  # replace this link when avaialble
  mfdz_url <- a("NOAA Coral Reef Watch", href = 'https://coralreefwatch.noaa.gov/')

  noaa_return <- tagList('Return to ', mfdz_url, '.')


  output$noaa_ref <- renderUI({
    noaa_return
  })


  output$last_update <- renderText({ "hi" })

}
about_page <- function(input, output) {
  output$cdz_images <- renderImage({
    filename <- "../forec_shiny_app_data/disease_pictures.png"
    list(src = filename)
    },
  deleteFile = FALSE
  )

  output$warning_levels_table <- renderDataTable(
    warning_levels_table,
    options(
      paging = FALSE,
      searching = FALSE,
      info = FALSE
    )
  )
  
  output$warning_levels_text <- renderText({
    paste0(
      warning_levels_txt,
      "<sup> 2 </sup>"
    )
  })
  
  output$funding_statement <- renderUI({
    funding_statement_txt
  })

  output$cite1 <- renderUI({
    Geigeretal2021_citation
  })

  output$cite2 <- renderUI({
    Greeneetal2020a_citation
  })

  output$cite3 <- renderUI({
    Greeneetal2020b_citation
  })

  output$cite4 <- renderUI({
    Caldwelletal2020_citation
  })
}

historical_data_page <- function(input, output) {
  output$historical_data_map <- renderLeaflet({
    historicalMap
  })  %>% bindCache("historicalMap")
}
# Investigating scenarios outputs
scenarios_page <- function(input, output) {
  
  output$scenarios_barplot <- renderPlotly({
    scenarios_placeholder_plot
  }) %>% bindCache("placeholder-bar-plot")
  
  output$management_map <- renderLeaflet({
    scenarios_placeholder_map
  }) %>% bindCache("placeholder-map")

  observeEvent(input$management_map_shape_click, handle_map_click(input, output))
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
      scenarios_ga_pac_map
    })
    
    output$scenarios_barplot <- renderPlotly({
      scenarios_placeholder_plot
    })

  }
  
  if(input$Region == 'U.S. Pacific' &&
      input$Disease == 'White syndromes'){
    
    output$management_map <- renderLeaflet({
      scenarios_ws_pac_map
    })
    
    output$scenarios_barplot <- renderPlotly({
      scenarios_placeholder_plot
    })
    
  }

  if(input$Region == 'Great Barrier Reef, Australia' &&
      input$Disease == 'Growth anomalies'){
    
    output$management_map <- renderLeaflet({
      scenarios_ga_gbr_map
    })
    
    output$scenarios_barplot <- renderPlotly({
      scenarios_placeholder_plot
    })
    
  }
  
  if(input$Region == 'Great Barrier Reef, Australia' &&
      input$Disease == 'White syndromes'){
    
    output$management_map <- renderLeaflet({
      scenarios_ws_gbr_map
    })
    
    output$scenarios_barplot <- renderPlotly({
      scenarios_placeholder_plot
    })
    
  }
  
}

handle_map_click <- function(input, output) {
  # 5 km maps -------------------------------------
  # 5km map, GA, Pacific ----
  if(input$management_map_shape_click$group == "GA Pacific nowcast")
  {
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

  # 5km map, WS, Pacific ----
    if(input$management_map_shape_click$group == "WS Pacific nowcast")
    {

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

  # 5km map, GA, GBR ----
  if(input$management_map_shape_click$group == "GA GBR nowcast")
  {

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

  # 5km map, WS, GBR ----
  if(input$management_map_shape_click$group == "WS GBR nowcast")
  {

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

  # management areas map ---------------------------------
  # management map, GA, Pacific
  if(input$management_map_shape_click$group == "GA Pacific management area nowcast")
  {
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

    # size_ga_pac <- reactive({
    #   subset(
    #     ga_pac_scenarios_aggregated_to_management_zones,
    #     ID == input$management_map_shape_click$id &
    #       Response == 'Coral size' &
    #       Response_level == input$coral_size_slider_ga_pac
    #   )
    # })
    # 
    # development_ga_pac <- reactive({
    #   subset(
    #     ga_pac_scenarios_aggregated_to_management_zones,
    #     ID == input$management_map_shape_click$id &
    #       Response == 'Development' &
    #       Response_level == input$dev_slider_ga_pac
    #   )
    # })
    # 
    # fish_ga_pac <- reactive({
    #   subset(
    #     ga_pac_scenarios_aggregated_to_management_zones,
    #     ID == input$management_map_shape_click$id &
    #       Response == 'Fish' &
    #       Response_level == input$herb_fish_slider_ga_pac
    #   )
    # })
    # 
    # 
    # turbidity_ga_pac <- renderText({
    #   subset(
    #     ga_pac_scenarios_aggregated_to_management_zones,
    #     ID == input$management_map_shape_click$id &
    #       Response == 'Turbidity' &
    #       Response_level == input$turbidity_slider_ga_pac
    #   )
    # })
    # 
    # df_ga_pac <- reactive({
    #   rbind(
    #     size_ga_pac(),
    #     development_ga_pac(),
    #     fish_ga_pac(),
    #     turbidity_ga_pac()
    #   )
    # })
    # 
    # output$scenarios_barplot <- renderPlotly({
    #   scenarios_barplot_fun(
    #     df = df_ga_pac(),
    #     baselineValue = baseVals()$value,
    #     riskType = 'percent'
    #   )
    # })
    
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
  # }
  }

  # management map, WS, Pacific ----
    if(input$management_map_shape_click$group == "WS Pacific management area nowcast")
    {
      
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
  # 
  # management map, GA, GBR ----
    if(input$management_map_shape_click$group == "GA GBR management area nowcast")
    {
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
  # 
  # management map, WS, GBR ----
    if(input$management_map_shape_click$group == "WS GBR management area nowcast")
    {
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
  # 
  # gbrmpa map ---------------------------------
  # gbrmpa ga gbr -----
  if(input$management_map_shape_click$group == "GA GBRMPA nowcast")
  {
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

  # gbrmpa map, WS, GBR ----
if(input$management_map_shape_click$group == "WS GBRMPA nowcast")
{
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





  # Initial render, cache to prevent expensive re-render


  output$map1 <- renderLeaflet({
    leaf_reefs
  }) %>% bindCache("leaf_reefs")

  output$plotlyGA <- renderPlotly({
    diseaseRisk_placeholder_plot(
      "Growth anomalies",
      ga_forecast$Date
    )
  }) %>% bindCache("Growth anomalies")

  output$plotlyWS <- renderPlotly({
    diseaseRisk_placeholder_plot(
      "White syndromes",
      ws_forecast$Date
    )
  })  %>% bindCache("White syndromes")

  output$last_update <- renderText({ last_update_txt })
  
  output$logo_images <- renderImage({
    filename <- "../forec_shiny_app_data/logos.png"
    list(src = filename)
  },
  deleteFile = FALSE
  )

  # Handle click on map shapes - update risk forecast
  observeEvent(input$map1_shape_click, handle_map_shape_click(input, output))
}

handle_map_shape_click <- function(input, output) {
    if(input$map1_shape_click$group == "Nowcast" | 
        input$map1_shape_click$group == "One month forecast"|
        input$map1_shape_click$group == "Two month forecast"|
        input$map1_shape_click$group == "Three month forecast")
    {
      # Grid of pixels
      ga_5km_forecast <- subset(
          ga_forecast,
          ID == input$map1_shape_click$id
      )

      ws_5km_forecast <- subset(
          ws_forecast,
          ID == input$map1_shape_click$id
      )

      output$plotlyGA <- renderPlotly({
          diseaseRisk_plotly(
          ga_5km_forecast,
          "Growth anomalies"
          )
      })

      output$plotlyWS <- renderPlotly({
          diseaseRisk_plotly(
          ws_5km_forecast,
          "White syndromes"
          )
      })
    } else if(input$map1_shape_click$group == "Management area nowcast") {
      # Management area polygons
      ga_management_forecasts <- subset(
          ga_nowcast_aggregated_to_management_zones,
          ID == input$map1_shape_click$id # PolygonID
      )

      ws_management_forecasts  <- subset(
          ws_nowcast_aggregated_to_management_zones,
          ID == input$map1_shape_click$id # PolygonID
      )

      output$plotlyGA <- renderPlotly({
          diseaseRisk_plotly(
          ga_management_forecasts,
          "Growth anomalies"
          )
      })

      output$plotlyWS <- renderPlotly({
          diseaseRisk_plotly(
          ws_management_forecasts,
          "White syndromes"
          )
      })
    } else if(input$map1_shape_click$group == "GBRMPA nowcast") {
      # GBRMPA polygons
      ga_gbrmpa_forecast <- subset(
          ga_gbr_nowcast_aggregated_to_gbrmpa_park_zones,
          ID == input$map1_shape_click$id # PolygonID
          )

      ws_gbrmpa_forecast <- subset(
          ws_gbr_nowcast_aggregated_to_gbrmpa_park_zones,
          ID == input$map1_shape_click$id # PolygonID
      )

      output$plotlyGA <- renderPlotly({
          diseaseRisk_plotly(
          ga_gbrmpa_forecast,
          "Growth anomalies"
          )
      })

      output$plotlyWS <- renderPlotly({
          diseaseRisk_plotly(
          ws_gbrmpa_forecast,
          "White syndromes"
          )
      })
    }

