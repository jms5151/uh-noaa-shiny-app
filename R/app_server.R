app_server <- function (input,
                        output,
                        session) {

  forecast_page(input, output)
  about_page(input, output)

}


forecast_page <- function(input, output) {

  output$logo_images <- renderImage({
      list(src = app_logo_path( ))
    }, 
    deleteFile = FALSE
  )

  output$gauge_plots <- renderPlotly({
    gauge_plots( )
  }) %>%
  bindCache(Sys.Date( ))


  output$map1 <- renderLeaflet({
    mapFun(basemap = basemap)
  }) %>%
  bindCache(Sys.Date( )) 


  output$plotlyGA <- renderPlotly({

    ga_forecast <- read.csv(data_file("Forecasts", "ga_forecast.csv"))

    diseaseRisk_placeholder_plot(titleName = "Growth anomalies",
                                 dateRange = ga_forecast$Date)
  }) 

  output$plotlyWS <- renderPlotly({

    ws_forecast <- read.csv(data_file("Forecasts", "ws_forecast.csv"))

    diseaseRisk_placeholder_plot(titleName = "White syndromes",
                                 dateRange = ws_forecast$Date)
  })


}


about_page <- function(input, output) {

  output$cdz_images <- renderImage({
      list(src = app_disease_pictures_path( ))
    }, 
    deleteFile = FALSE
  )

  warning_levels_table <- read.csv(app_file("warning_levels_table.csv"))
  colnames(warning_levels_table) <- gsub('\\_', ' ', colnames(warning_levels_table))

  output$warning_levels_table <- renderDataTable(expr    = warning_levels_table,
                                                 options = list(paging    = FALSE,
                                                                searching = FALSE,
                                                                info      = FALSE))

}
