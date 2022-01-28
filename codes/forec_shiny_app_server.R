server <- function(input, output, session) {
  
  # Nowcasts/forecasts outputs -------------------------------
  
  output$gauge_plots <- renderPlotly({
    gaugePlots
  })
  
  output$map1 <- renderLeaflet({
    leaf_reefs
  })
  
  #create empty vector to hold all click ids
  selected <- reactiveValues(
    groups = vector()
  )
  
  output$plotlyGA <- renderPlotly({
    diseaseRisk_placeholder_plot(
      "Growth anomalies", 
      ga_forecast$Date
    )
  })
  
  output$plotlyWS <- renderPlotly({
    diseaseRisk_placeholder_plot(
      "White syndromes", 
      ws_forecast$Date
    )
  })
  
  observeEvent(
    input$map1_shape_click, 
    {
      if(input$map1_shape_click$group == "5km forecasts")
      {
        
        z <- subset(
          ga_forecast, 
          ID == input$map1_shape_click$id
        )
        
        z2 <- subset(
          ws_forecast, 
          ID == input$map1_shape_click$id
        )
        
        output$plotlyGA <- renderPlotly({
          diseaseRisk_plotly(
            z, 
            "Growth anomalies"
          )
        })
        
        output$plotlyWS <- renderPlotly({
          diseaseRisk_plotly(
            z2, 
            "White syndromes"
          )
        })
      }
      
      else if(input$map1_shape_click$group == "Management area forecasts")
      {
        
        z5 <- subset(
          ga_forecast_aggregated_to_management_zones, 
          PolygonID == input$map1_shape_click$id
        )
        
        z6  <- subset(
          ws_forecast_aggregated_to_management_zones, 
          PolygonID == input$map1_shape_click$id
        )
        
        output$plotlyGA <- renderPlotly({
          diseaseRisk_plotly(
            z5, 
            "Growth anomalies"
          )
        })
        
        output$plotlyWS <- renderPlotly({
          diseaseRisk_plotly(
            z6, 
            "White syndromes"
          )
        })
      }
      
      else if(input$map1_shape_click$group == "GBRMPA park zoning forecasts")
      {
        
        z3 <- subset(
          ga_forecast_aggregated_to_gbrmpa_park_zones, 
          PolygonID == input$map1_shape_click$id
        )
        
        z4 <- subset(
          ws_forecast_aggregated_to_gbrmpa_park_zones, 
          PolygonID == input$map1_shape_click$id
        )
        
        output$plotlyGA <- renderPlotly({
          diseaseRisk_plotly(
            z3, 
            "Growth anomalies"
          )
        })
        
        output$plotlyWS <- renderPlotly({
          diseaseRisk_plotly(
            z4, 
            "White syndromes"
          )
        })
      }
    })
  
  output$gauge_plots <- renderPlotly({
    gaugePlots
  })
  
  output$last_update <- renderText({
    last_update_txt
  })

  
  # Investigating scenarios outputs -------------------------------

  output$management_map <- renderLeaflet({
    leaf_scenarios
  })
  
  output$scenarios_barplot <- renderPlotly({
    scenarios_placeholder_plot
  })
  
  #create empty vector to hold all click ids, not sure if this is needed anymore
  selected2 <- reactiveValues(
    groups = vector()
  )
  
  observeEvent(
    input$management_map_shape_click,
      {
        # 5 km map -------------------------------------
        if(input$management_map_shape_click$group == "5km forecasts")
        {
          # 5km map, GA, Pacific ----
          if(input$Region == 'U.S. Pacific' & 
             input$Disease == 'Growth anomalies')
          {
            
            baseVals <- reactive({
              subset(
                ga_pac_basevals_ID,
                ID == input$management_map_shape_click$id
                )
            })
            
            output$corsize_value_ga_pac <- renderText({
              paste0(
                "Location-specific size = ",
                round(baseVals()$Median_colony_size),
                "  cm"
              )
            })
            
            output$corcov_value_ga_pac <- renderText({
              paste0(
                "Location-specific cover = ",
                round(baseVals()$mean_cover),
                "  %"
              )
            })

            output$herb_fish_value_ga_pac <- renderText({
              paste0(
                "Location-specific density = ",
                round(baseVals()$H_abund, 2),
                " fish/m<sup>2<sup>"
              )
            })
            
            output$dev_value_ga_pac <- renderText({
              paste0(
                "Location-specific development = ",
                round((baseVals()$BlackMarble_2016_3km_geo.3/255), 1)
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
            
            cover_ga_pac <- reactive({
              subset(
                ga_pac_scenarios,
                ID == input$management_map_shape_click$id &
                  Response == 'Coral cover' &
                  Response_level == input$coral_cover_slider_ga_pac
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
            
            development_ga_pac <- reactive({
              subset(
                ga_pac_scenarios,
                ID == input$management_map_shape_click$id &
                  Response == 'Development' &
                  Response_level == input$dev_slider_ga_pac
              )
            })
            
            df_ga_pac <- reactive({
              rbind(
                size_ga_pac(),
                cover_ga_pac(),
                fish_ga_pac(),
                development_ga_pac()
              )
            })
            
            output$scenarios_barplot <- renderPlotly({
              scenarios_barplot_fun(
                df = df_ga_pac(),
                baselineValue = baseVals()$value,
                riskType = 'abundance'
              )
            })
            
          }

          # 5km map, WS, Pacific ----
          if(input$Region == 'U.S. Pacific' & 
             input$Disease == 'White syndromes')
          {
            
            baseVals <- reactive({
              subset(
                ws_pac_basevals_ID,
                ID == input$management_map_shape_click$id
              )
            })
            
            output$corsize_value_ws_pac <- renderText({
              paste0(
                "Location-specific size = ",
                round(baseVals()$Median_colony_size),
                "  cm"
              )
            })
            
            output$kd_value_ws_pac <- renderText({
              paste0(
                "Location-specific turbidity = ",
                round(baseVals()$Long_Term_Kd_Median, 2),
                "  m<sup>-1</sup>"
              )
            })
            
            output$parrotfish_value_ws_pac <- renderText({
              paste0(
                "Location-specific density = ",
                round(baseVals()$Parrotfish_abund),
                " fish/m<sup>2<sup>"
              )
            })
            
            output$herb_fish_value_ws_pac <- renderText({
              paste0(
                "Location-specific density = ",
                round(baseVals()$H_abund, 2),
                "/m<sup>2<sup>"
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
            
            turbidity_ws_pac <- reactive({
              subset(
                ws_pac_scenarios,
                ID == input$management_map_shape_click$id &
                  Response == 'Turbidity' &
                  Response_level == input$turbidity_slider_ws_pac
              )
            })
            
            parrotfish_ws_pac <- reactive({
              subset(
                ws_pac_scenarios,
                ID == input$management_map_shape_click$id &
                  Response == 'Parrotfish' &
                  Response_level == input$parrotfish_slider_ws_pac
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
            
            df_ws_pac <- reactive({
              rbind(
                size_ws_pac(),
                turbidity_ws_pac(),
                parrotfish_ws_pac(),
                herb_fish_ws_pac()
              )
            })
            
            output$scenarios_barplot <- renderPlotly({
              scenarios_barplot_fun(
                df = df_ws_pac(),
                baselineValue = baseVals()$value,
                riskType = 'abundance'
              )
            })
            
            
          }
          
          # 5km map, GA, GBR ----
          if(input$Region == 'Great Barrier Reef, Australia' & 
             input$Disease == 'Growth anomalies')
            {
            
            baseVals <- reactive({
              subset(
                ga_gbr_basevals_ID,
                ID == input$management_map_shape_click$id
                )
            })

            output$fish_value_ga_gbr <- renderText({
              paste0(
                "Location-specific abundance = ",
                round(baseVals()$Fish_abund),
                " fish"
                )
              })
            
            output$kd_value_ga_gbr <- renderText({
              paste0(
                "Location-specific turbidity = ",
                round(baseVals()$Three_Week_Kd_Variability, 2),
                "  m<sup>-1</sup>"
              )
            })
            
            output$corcov_value_ga_gbr <- renderText({
              paste0(
                "Location-specific cover = ",
                round(baseVals()$Coral_cover),
                "  %"
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
            
            turbidity_ga_gbr <- reactive({
              subset(
                ga_gbr_scenarios,
                ID == input$management_map_shape_click$id &
                  Response == 'Turbidity' &
                  Response_level == input$turbidity_slider_ga_gbr
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
                  
            df_ga_gbr <- reactive({
              rbind(
                fish_ga_gbr(),
                turbidity_ga_gbr(),
                cover_ga_gbr()
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
          if(input$Region == 'Great Barrier Reef, Australia' & 
             input$Disease == 'White syndromes')
          {

            baseVals <- reactive({
              subset(
                ws_gbr_basevals_ID,
                ID == input$management_map_shape_click$id
                )
            })
            
            output$corcov_value_ws_gbr <- renderText({
              paste0(
                "Location-specific cover = ",
                round(baseVals()$Coral_cover),
                "  %"
              )
            })
            
            output$fish_value_ws_gbr <- renderText({
              paste0(
                "Location-specific abundance = ",
                round(baseVals()$Fish_abund),
                " fish"
              )
            })
            
            output$kd_value_ws_gbr <- renderText({
              paste0(
                "Location-specific turbidity = ",
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
        }
        # management areas map ---------------------------------
        if(input$management_map_shape_click$group == "Management area forecasts")
        {
          # management map, GA, Pacific ----
          if(input$Region == 'U.S. Pacific' & 
             input$Disease == 'Growth anomalies')
          {
            
            baseVals <- reactive({
              subset(
                ga_pac_basevals_management,
                ID == input$management_map_shape_click$id
              )
            })
            
            output$corsize_value_ga_pac <- renderText({
              paste0(
                "Location-specific size = ",
                round(baseVals()$Median_colony_size),
                "  cm"
              )
            })
            
            output$corcov_value_ga_pac <- renderText({
              paste0(
                "Location-specific cover = ",
                round(baseVals()$mean_cover),
                "  %"
              )
            })
            
            output$herb_fish_value_ga_pac <- renderText({
              paste0(
                "Location-specific density = ",
                round(baseVals()$H_abund, 2),
                " fish/m<sup>2<sup>"
              )
            })
            
            output$dev_value_ga_pac <- renderText({
              paste0(
                "Location-specific development = ",
                round((baseVals()$BlackMarble_2016_3km_geo.3/255), 1)
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
            
            cover_ga_pac <- reactive({
              subset(
                ga_pac_scenarios_aggregated_to_management_zones,
                ID == input$management_map_shape_click$id &
                  Response == 'Coral cover' &
                  Response_level == input$coral_cover_slider_ga_pac
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
            
            development_ga_pac <- reactive({
              subset(
                ga_pac_scenarios_aggregated_to_management_zones,
                ID == input$management_map_shape_click$id &
                  Response == 'Development' &
                  Response_level == input$dev_slider_ga_pac
              )
            })
            
            df_ga_pac <- reactive({
              rbind(
                size_ga_pac(),
                cover_ga_pac(),
                fish_ga_pac(),
                development_ga_pac()
              )
            })
            
            output$scenarios_barplot <- renderPlotly({
              scenarios_barplot_fun(
                df = df_ga_pac(),
                baselineValue = baseVals()$value,
                riskType = 'abundance'
              )
            })
            
          }
          
          # management map, WS, Pacific ----
          if(input$Region == 'U.S. Pacific' & 
             input$Disease == 'White syndromes')
          {
            
            baseVals <- reactive({
              subset(
                ws_pac_basevals_management,
                ID == input$management_map_shape_click$id
              )
            })
            
            output$corsize_value_ws_pac <- renderText({
              paste0(
                "Location-specific size = ",
                round(baseVals()$Median_colony_size),
                "  cm"
              )
            })
            
            output$kd_value_ws_pac <- renderText({
              paste0(
                "Location-specific turbidity = ",
                round(baseVals()$Long_Term_Kd_Median, 2),
                "  m<sup>-1</sup>"
              )
            })
            
            output$parrotfish_value_ws_pac <- renderText({
              paste0(
                "Location-specific density = ",
                round(baseVals()$Parrotfish_abund),
                " fish/m<sup>2<sup>"
              )
            })
            
            output$herb_fish_value_ws_pac <- renderText({
              paste0(
                "Location-specific density = ",
                round(baseVals()$H_abund, 2),
                "/m<sup>2<sup>"
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
            
            turbidity_ws_pac <- reactive({
              subset(
                ws_pac_scenarios_aggregated_to_management_zones,
                ID == input$management_map_shape_click$id &
                  Response == 'Turbidity' &
                  Response_level == input$turbidity_slider_ws_pac
              )
            })
            
            parrotfish_ws_pac <- reactive({
              subset(
                ws_pac_scenarios_aggregated_to_management_zones,
                ID == input$management_map_shape_click$id &
                  Response == 'Parrotfish' &
                  Response_level == input$parrotfish_slider_ws_pac
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
            
            df_ws_pac <- reactive({
              rbind(
                size_ws_pac(),
                turbidity_ws_pac(),
                parrotfish_ws_pac(),
                herb_fish_ws_pac()
              )
            })
            
            output$scenarios_barplot <- renderPlotly({
              scenarios_barplot_fun(
                df = df_ws_pac(),
                baselineValue = baseVals()$value,
                riskType = 'abundance'
              )
            })
            
            
          }
          
          # management map, GA, GBR ----
          if(input$Region == 'Great Barrier Reef, Australia' & 
             input$Disease == 'Growth anomalies')
          {
            
            baseVals <- reactive({
              subset(
                ga_gbr_basevals_management,
                ID == input$management_map_shape_click$id
              )
            })
            
            output$fish_value_ga_gbr <- renderText({
              paste0(
                "Location-specific abundance = ",
                round(baseVals()$Fish_abund),
                " fish"
              )
            })
            
            output$kd_value_ga_gbr <- renderText({
              paste0(
                "Location-specific turbidity = ",
                round(baseVals()$Three_Week_Kd_Variability, 2),
                "  m<sup>-1</sup>"
              )
            })
            
            output$corcov_value_ga_gbr <- renderText({
              paste0(
                "Location-specific cover = ",
                round(baseVals()$Coral_cover),
                "  %"
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
            
            turbidity_ga_gbr <- reactive({
              subset(
                ga_gbr_scenarios_aggregated_to_management_zones,
                ID == input$management_map_shape_click$id &
                  Response == 'Turbidity' &
                  Response_level == input$turbidity_slider_ga_gbr
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
            
            df_ga_gbr <- reactive({
              rbind(
                fish_ga_gbr(),
                turbidity_ga_gbr(),
                cover_ga_gbr()
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
          
          # management map, WS, GBR ----
          if(input$Region == 'Great Barrier Reef, Australia' & 
             input$Disease == 'White syndromes')
          {
            
            baseVals <- reactive({
              subset(
                ws_gbr_basevals_management,
                ID == input$management_map_shape_click$id
              )
            })
            
            output$corcov_value_ws_gbr <- renderText({
              paste0(
                "Location-specific cover = ",
                round(baseVals()$Coral_cover),
                "  %"
              )
            })
            
            output$fish_value_ws_gbr <- renderText({
              paste0(
                "Location-specific abundance = ",
                round(baseVals()$Fish_abund),
                " fish"
              )
            })
            
            output$kd_value_ws_gbr <- renderText({
              paste0(
                "Location-specific turbidity = ",
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
        }
        
        # gbrmpa map ---------------------------------
        if(input$management_map_shape_click$group == "GBRMPA park zoning forecasts")
        {
          # gbrmpa map, GA, GBR ----
          if(input$Region == 'Great Barrier Reef, Australia' & 
             input$Disease == 'Growth anomalies')
          {
            
            baseVals <- reactive({
              subset(
                ga_gbr_basevals_gbrmpa,
                ID == input$management_map_shape_click$id
              )
            })
            
            output$fish_value_ga_gbr <- renderText({
              paste0(
                "Location-specific abundance = ",
                round(baseVals()$Fish_abund),
                " fish"
              )
            })
            
            output$kd_value_ga_gbr <- renderText({
              paste0(
                "Location-specific turbidity = ",
                round(baseVals()$Three_Week_Kd_Variability, 2),
                "  m<sup>-1</sup>"
              )
            })
            
            output$corcov_value_ga_gbr <- renderText({
              paste0(
                "Location-specific cover = ",
                round(baseVals()$Coral_cover),
                "  %"
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
            
            turbidity_ga_gbr <- reactive({
              subset(
                ga_gbr_scenarios_aggregated_to_gbrmpa_park_zones,
                ID == input$management_map_shape_click$id &
                  Response == 'Turbidity' &
                  Response_level == input$turbidity_slider_ga_gbr
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
            
            df_ga_gbr <- reactive({
              rbind(
                fish_ga_gbr(),
                turbidity_ga_gbr(),
                cover_ga_gbr()
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
          if(input$Region == 'Great Barrier Reef, Australia' & 
             input$Disease == 'White syndromes')
          {
            
            baseVals <- reactive({
              subset(
                ws_gbr_basevals_gbrmpa,
                ID == input$management_map_shape_click$id
              )
            })
            
            output$corcov_value_ws_gbr <- renderText({
              paste0(
                "Location-specific cover = ",
                round(baseVals()$Coral_cover),
                "  %"
              )
            })
            
            output$fish_value_ws_gbr <- renderText({
              paste0(
                "Location-specific abundance = ",
                round(baseVals()$Fish_abund),
                " fish"
              )
            })
            
            output$kd_value_ws_gbr <- renderText({
              paste0(
                "Location-specific turbidity = ",
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
        }
    )
  # map historical data -------------
  output$historical_data_map <- renderLeaflet({
    historicalMap
  })
  
  # about page ----------------
  output$cdz_images <- renderImage({
    filename <- "./forec_shiny_app_data/disease_pictures.png"
    # filename <- "../forec_shiny_app_data/disease_pictures.png"
    list(src = filename)
    }, 
  deleteFile = FALSE
  )
  
  output$warning_levels_table <- renderDataTable(
    warning_table, 
    options(
      paging = FALSE,
      searching = FALSE
    )
    
  )
  
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
