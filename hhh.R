
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