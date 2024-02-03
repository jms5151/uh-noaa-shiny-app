#'
#' @export
#'
run_app <- function (main_dir = ".", port = 3838, host = "0.0.0.0") {

  require(uhnoaashinyapp)
  onStop(fun = app_clear_global)

  app_global(main_dir = main_dir)

  shinyApp(ui      = app_ui( ),
           server  = app_server,
           options = list(host = host, 
                          port = port))

}

#'
#' @export
#'
app_global <- function (main_dir = ".") {

  assign(x     = "app_text",
         value = read_app_text( ),
         pos   = 1)

  assign(x     = "app_settings",
         value = read_app_settings( ),
         pos   = 1)

  assign(x     = "historical_data",
         value = load_historical_data( ),
         pos   = 1)

  assign(x     = "ga_forecast",
         value = load_ga_forecast(main_dir = main_dir),
         pos   = 1)

  assign(x     = "ws_forecast",
         value = load_ws_forecast(main_dir = main_dir),
         pos   = 1)

  assign(x     = "ga_nowcast_aggregated_to_management_zones",
         value = load_ga_nowcast_aggregated_to_management_zones(main_dir = main_dir),
         pos   = 1)

  assign(x     = "ws_nowcast_aggregated_to_management_zones",
         value = load_ws_nowcast_aggregated_to_management_zones(main_dir = main_dir),
         pos   = 1)

  assign(x     = "ga_gbr_nowcast_aggregated_to_gbrmpa_park_zones",
         value = load_ga_gbr_nowcast_aggregated_to_gbrmpa_park_zones(main_dir = main_dir),
         pos   = 1)

  assign(x     = "ws_gbr_nowcast_aggregated_to_gbrmpa_park_zones",
         value = load_ws_gbr_nowcast_aggregated_to_gbrmpa_park_zones(main_dir = main_dir),
         pos   = 1)

  assign(x     = "basemap",
         value = create_basemap( ),
         pos   = 1)

  assign(x     = "historicalMap",
         value = create_historicalMap( ),
         pos   = 1)

  assign(x     = "gauge_data",
         value = load_gauge_data( ),
         pos   = 1)

  assign(x     = "shpFiles",
         value = load_shape_files(main_dir = main_dir),
         pos   = 1)

  assign(x     = "ga_pac_basevals_ID",
         value = load_ga_pac_basevals_id(main_dir = main_dir),
         pos   = 1)

  assign(x     = "ga_pac_basevals_ID",
         value = load_ga_pac_basevals_id(main_dir = main_dir),
         pos   = 1)

  assign(x     = "ga_pac_scenarios",
         value = load_ga_pac_scenarios(main_dir = main_dir),
         pos   = 1)

  assign(x     = "ws_pac_basevals_ID",
         value = load_ws_pac_basevals_id(main_dir = main_dir),
         pos   = 1)

  assign(x     = "ws_pac_scenarios",
         value = load_ws_pac_scenarios(main_dir = main_dir),
         pos   = 1)

  assign(x     = "ga_gbr_basevals_ID",
         value = load_ga_gbr_basevals_id(main_dir = main_dir),
         pos   = 1)

  assign(x     = "ga_gbr_scenarios",
         value = load_ga_gbr_scenarios(main_dir = main_dir),
         pos   = 1)

  assign(x     = "ws_gbr_basevals_ID",
         value = load_ws_gbr_basevals_id(main_dir = main_dir),
         pos   = 1)

  assign(x     = "ws_gbr_scenarios",
         value = load_ws_gbr_scenarios(main_dir = main_dir),
         pos   = 1)




  assign(x     = "ga_pac_basevals_management",
         value = load_ga_pac_basevals_management(main_dir = main_dir),
         pos   = 1)

  assign(x     = "ga_pac_scenarios_aggregated_to_management_zones",
         value = load_ga_pac_scenarios_aggregated_to_management_zones(main_dir = main_dir),
         pos   = 1)

  assign(x     = "ws_pac_basevals_management",
         value = load_ws_pac_basevals_management(main_dir = main_dir),
         pos   = 1)

  assign(x     = "ws_pac_scenarios_aggregated_to_management_zones",
         value = load_ws_pac_scenarios_aggregated_to_management_zones(main_dir = main_dir),
         pos   = 1)


  assign(x     = "ga_gbr_basevals_management",
         value = load_ga_gbr_basevals_management(main_dir = main_dir),
         pos   = 1)

  assign(x     = "ga_gbr_scenarios_aggregated_to_management_zones",
         value = load_ga_gbr_scenarios_aggregated_to_management_zones(main_dir = main_dir),
         pos   = 1)

  assign(x     = "ws_gbr_basevals_management",
         value = load_ws_gbr_basevals_management(main_dir = main_dir),
         pos   = 1)

  assign(x     = "ws_gbr_scenarios_aggregated_to_management_zones",
         value = load_ws_gbr_scenarios_aggregated_to_management_zones(main_dir = main_dir),
         pos   = 1)

  assign(x     = "ga_gbr_basevals_gbrmpa",
         value = load_ga_gbr_basevals_gbrmpa(main_dir = main_dir),
         pos   = 1)

  assign(x     = "ga_gbr_scenarios_aggregated_to_gbrmpa_park_zones",
         value = load_ga_gbr_scenarios_aggregated_to_gbrmpa_park_zones(main_dir = main_dir),
         pos   = 1)

  assign(x     = "ws_gbr_basevals_gbrmpa",
         value = load_ws_gbr_basevals_gbrmpa(main_dir = main_dir),
         pos   = 1)

  assign(x     = "ws_gbr_scenarios_aggregated_to_gbrmpa_park_zones",
         value = load_ws_gbr_scenarios_aggregated_to_gbrmpa_park_zones(main_dir = main_dir),
         pos   = 1)

}

#'
#' @export
#'
app_clear_global <- function ( ) {

  rm("app_text", pos = 1)
  rm("app_settings", pos = 1)
  rm("historical_data", pos = 1)
  rm("ga_forecast", pos = 1)
  rm("ws_forecast", pos = 1)
  rm("ga_nowcast_aggregated_to_management_zones", pos = 1)
  rm("ws_nowcast_aggregated_to_management_zones", pos = 1)
  rm("ga_gbr_nowcast_aggregated_to_gbrmpa_park_zones", pos = 1)
  rm("ws_gbr_nowcast_aggregated_to_gbrmpa_park_zones", pos = 1)
  rm("basemap", pos = 1)
  rm("historicalMap", pos = 1)
  rm("gauge_data", pos = 1)
  rm("shpFiles", pos = 1)
  rm("ga_pac_basevals_ID", pos = 1)
  rm("ga_pac_basevals_ID", pos = 1)
  rm("ga_pac_scenarios", pos = 1)
  rm("ws_pac_basevals_ID", pos = 1)
  rm("ws_pac_scenarios", pos = 1)
  rm("ga_gbr_basevals_ID", pos = 1)
  rm("ga_gbr_scenarios", pos = 1)
  rm("ws_gbr_basevals_ID", pos = 1)
  rm("ws_gbr_scenarios", pos = 1)

  rm("ga_pac_basevals_management", pos = 1)
  rm("ga_pac_scenarios_aggregated_to_management_zones", pos = 1)
  rm("ws_pac_basevals_management", pos = 1)
  rm("ws_pac_scenarios_aggregated_to_management_zones", pos = 1)
  rm("ga_gbr_basevals_management", pos = 1)
  rm("ga_gbr_scenarios_aggregated_to_management_zones", pos = 1)
  rm("ws_gbr_basevals_management", pos = 1)
  rm("ws_gbr_scenarios_aggregated_to_management_zones", pos = 1)
  rm("ga_gbr_basevals_gbrmpa", pos = 1)
  rm("ga_gbr_scenarios_aggregated_to_gbrmpa_park_zones", pos = 1)
  rm("ws_gbr_basevals_gbrmpa", pos = 1)
  rm("ws_gbr_scenarios_aggregated_to_gbrmpa_park_zones", pos = 1)

}

