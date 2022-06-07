forecast_page <- function(input, output) {
  # Initial render, cache to prevent expensive re-render
  output$gauge_plots <- renderPlotly({
    gaugePlots
  }) %>% bindCache("gaugePlots")

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
}