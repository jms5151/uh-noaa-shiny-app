run_app <- function ( ) {

  onStop(fun = app_clear_global)

  app_global( )

# at least when working locally, cache_mem doesn't work for me right now?
#  shinyOptions(cache = cache_mem(max_size = 500e6))
#  shinyOptions(cache = cache_disk(file.path(dirname(tempdir()), "myapp-cache")))

  shinyApp(ui      = app_ui( ),
           server  = app_server)

}

app_global <- function ( ) {


  assign(x     = "app_text",
         value = read_app_text( ),
         pos   = 1)

  assign(x     = "app_settings",
         value = read_app_settings( ),
         pos   = 1)

  assign(x     = "ga_forecast",
         value = load_ga_forecast( ),
         pos   = 1)

  assign(x     = "ws_forecast",
         value = load_ws_forecast( ),
         pos   = 1)

  assign(x     = "ga_nowcast_aggregated_to_management_zones",
         value = load_ga_nowcast_aggregated_to_management_zones( ),
         pos   = 1)

  assign(x     = "ws_nowcast_aggregated_to_management_zones",
         value = load_ws_nowcast_aggregated_to_management_zones( ),
         pos   = 1)

  assign(x     = "ga_gbr_nowcast_aggregated_to_gbrmpa_park_zones",
         value = load_ga_gbr_nowcast_aggregated_to_gbrmpa_park_zones( ),
         pos   = 1)

  assign(x     = "ws_gbr_nowcast_aggregated_to_gbrmpa_park_zones",
         value = load_ws_gbr_nowcast_aggregated_to_gbrmpa_park_zones( ),
         pos   = 1)

  assign(x     = "gauge_data",
         value = load_gauge_data( ),
         pos   = 1)

  assign(x     = "basemap",
         value = create_basemap( ),
         pos   = 1)

  assign(x     = "shpFiles",
         value = load_shape_files( ),
         pos   = 1)

  assign(x     = "ga_pac_basevals_ID",
         value = load_ga_pac_basevals_id( ),
         pos   = 1)

  assign(x     = "ga_pac_scenarios",
         value = load_ga_pac_scenarios( ),
         pos   = 1)

  assign(x     = "basemap",
         value = create_basemap( ),
         pos   = 1)

}

app_clear_global <- function ( ) {

  rm("app_text", pos = 1)
  rm("app_settings", pos = 1)
  rm("ga_forecast", pos = 1)
  rm("ws_forecast", pos = 1)
  rm("ga_nowcast_aggregated_to_management_zones", pos = 1)
  rm("ws_nowcast_aggregated_to_management_zones", pos = 1)
  rm("ga_gbr_nowcast_aggregated_to_gbrmpa_park_zones", pos = 1)
  rm("ws_gbr_nowcast_aggregated_to_gbrmpa_park_zones", pos = 1)
  rm("gauge_data", pos = 1)
  rm("basemap", pos = 1)
  rm("shpFiles", pos = 1)
  rm("ga_pac_basevals_ID", pos = 1)
  rm("ga_pac_scenarios", pos = 1)

}

