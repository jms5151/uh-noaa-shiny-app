devtools::document()

read.csv(app_file("text.yml"))

read.csv(data_file("Forecasts", "ga_forecast.csv"))



basemap <-create_basemap()
usethis::use_data(basemap)

shinyApp(ui = app_ui(), server = app_server)
runApp(appDir = app_path( ))


devtools::load_all()

devtools::build()

shinyOptions(cache = cache_mem(max_size = 500e6))

app_ui()


file_paths(root = "package")

run_app



source("./inst/app/app.R")

devtools::document();

profvis::profvis({
  shinyApp(ui = app_ui(), server = app_server)
})


devtools::document()
f <- data_files(file_ext = c("RData", "Rds"))
load_rds_files()


basemap <- create_basemap()
mapFun(basemap, 
layerNames = c('nowcast_polygons_5km'
                 , 'one_month_forecast_polygons_5km'
                 , 'two_month_forecast_polygons_5km'
                 , 'three_month_forecast_polygons_5km'
                 , 'polygons_GBRMPA_zoning'
                 , 'polygons_management_zoning')
  , groupNames = c('Nowcast'
                   , 'One month forecast'
                   , 'Two month forecast'
                   , 'Three month forecast'
                   , 'GBRMPA nowcast'
                   , 'Management area nowcast')) 