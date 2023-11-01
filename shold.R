,
    br( ),
,

      column(width = 6,
        h4("Risk map (total disease)",
           align = "center",
           style = "background-color: #00172D;
                    color: white;
                    padding-bottom: 3px"),
        h4(app_text$forecasts_step_2, 
           style = "color: #009999;"),
        h6(app_text$forecasts_step_2_sub, 
           style = "color: #009999;"),
       # leafletOutput(outputId = "map1") %>%
        #  withSpinner(color = app_settings$spinColor),
        br( )
      ),

      column(style = "border-left: double; border-color: #00172D;",
             width = 3,
        h4("Risk predictions",
           align = "center",
           style = "background-color: #00172D;
                    color: white;
                    padding-bottom: 3px"),
        h4(app_text$forecasts_step_3, 
           style = "color: #009999;"),
        h6(app_text$forecasts_step_3_sub, 
           style = "color: #009999;"),
    #    plotlyOutput(outputId = "plotlyGA",
     #                height   = 200) %>%
      #    withSpinner(color = app_settings$spinColor),
      #  plotlyOutput(outputId = "plotlyWS",
       #              height   = 200) %>%
        #  withSpinner(color = app_settings$spinColor),
        br( )
      )
    ),

    #textOutput(outputId = "last_update"),

