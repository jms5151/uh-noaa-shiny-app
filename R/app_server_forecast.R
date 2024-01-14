
forecast_page <- function(input, output) {

  output$logo_images <- renderImage({
      list(src = app_logo_path( ))
    }, 
    deleteFile = FALSE
  )

  output$gauge_plots <- renderPlotly({
    gauge_plots( )
  }) %>%
  bindCache("gaugePlots")


  output$map1 <- renderLeaflet({
    mapFun(basemap = basemap)
  }) %>%
  bindCache("leaf_reefs") 


  output$plotlyGA <- renderPlotly({
    diseaseRisk_placeholder_plot(titleName = "Growth anomalies",
                                 dateRange = ga_forecast$Date)
  })  %>%
  bindCache("Growth anomalies")

  output$plotlyWS <- renderPlotly({
    diseaseRisk_placeholder_plot(titleName = "White syndromes",
                                 dateRange = ws_forecast$Date)
  }) %>%
  bindCache("White syndromes")

  output$last_update <- renderText({
    last_update_text( )
  }) 

  observeEvent(eventExpr   = input$map1_shape_click, 
               handlerExpr = handle_map_shape_click(input  = input, 
                                                    output = output))

}

handle_map_shape_click <- function(input, 
                                   output) {


  if(input$map1_shape_click$group %in% c("Nowcast", "One month forecast", "Two month forecast", "Three month forecast")) {

    # Grid of pixels
    ga_5km_forecast <- subset(x = ga_forecast,
                              ID == input$map1_shape_click$id)

    ws_5km_forecast <- subset(x = ws_forecast,
                              ID == input$map1_shape_click$id)

    output$plotlyGA <- renderPlotly({
      diseaseRisk_plotly(df        = ga_5km_forecast,
                         titleName = "Growth anomalies")
    })

    output$plotlyWS <- renderPlotly({
      diseaseRisk_plotly(df        = ws_5km_forecast,
                         titleName = "White syndromes")
    })
       

  } else if(input$map1_shape_click$group == "Management area nowcast") {

    # Management area polygons
    ga_management_forecasts <- subset(x = ga_nowcast_aggregated_to_management_zones,
                                      ID == input$map1_shape_click$id)

    ws_management_forecasts  <- subset(x = ws_nowcast_aggregated_to_management_zones,
                                       ID == input$map1_shape_click$id)

    output$plotlyGA <- renderPlotly({
      diseaseRisk_plotly(df        = ga_management_forecasts,
                         titleName = "Growth anomalies")
    })

    output$plotlyWS <- renderPlotly({
      diseaseRisk_plotly(df        = ws_management_forecasts,
                         titleName = "White syndromes")
    })



  } else if(input$map1_shape_click$group == "GBRMPA nowcast") {


    # GBRMPA polygons
    ga_gbrmpa_forecast <- subset(x = ga_gbr_nowcast_aggregated_to_gbrmpa_park_zones,
                                 ID == input$map1_shape_click$id)

      ws_gbrmpa_forecast <- subset(x = ws_gbr_nowcast_aggregated_to_gbrmpa_park_zones,
                                   ID == input$map1_shape_click$id)

    output$plotlyGA <- renderPlotly({
      diseaseRisk_plotly(df        = ga_gbrmpa_forecast,
                         titleName = "Growth anomalies")
    })

    output$plotlyWS <- renderPlotly({
      diseaseRisk_plotly(df        = ws_gbrmpa_forecast,
                         titleName = "White syndromes")
    })

  }


}

last_update_text <- function ( ) {

  last_update_date <- ga_forecast[which(ga_forecast$Date == max(ga_forecast$Date[ga_forecast$type == "nowcast"]))[1], "Date"] + 1
  last_update_date <- as.Date(last_update_date[[1]], "%Y-%m-%d")

  paste0('Last update: ', last_update_date)

}
