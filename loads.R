


uhnoaashinyapp:::load_shape_files(main_dir = main_dir)




uhnoaashinyapp:::load_gauge_data( )
uhnoaashinyapp:::create_basemap( )
uhnoaashinyapp:::create_historicalMap( )


uhnoaashinyapp:::load_ga_pac_basevals_management(main_dir = main_dir)
uhnoaashinyapp:::load_ga_pac_scenarios_aggregated_to_management_zones(main_dir = main_dir)
uhnoaashinyapp:::load_ws_pac_basevals_management(main_dir = main_dir)
uhnoaashinyapp:::load_ws_pac_scenarios_aggregated_to_management_zones(main_dir = main_dir)
uhnoaashinyapp:::load_ga_gbr_basevals_management(main_dir = main_dir)
uhnoaashinyapp:::load_ga_gbr_scenarios_aggregated_to_management_zones(main_dir = main_dir)
uhnoaashinyapp:::load_ws_gbr_basevals_management(main_dir = main_dir)
uhnoaashinyapp:::load_ws_gbr_scenarios_aggregated_to_management_zones(main_dir = main_dir)
uhnoaashinyapp:::load_ga_gbr_basevals_gbrmpa(main_dir = main_dir)
uhnoaashinyapp:::load_ga_gbr_scenarios_aggregated_to_gbrmpa_park_zones(main_dir = main_dir)
uhnoaashinyapp:::load_ws_gbr_basevals_gbrmpa(main_dir = main_dir)
uhnoaashinyapp:::load_ws_gbr_scenarios_aggregated_to_gbrmpa_park_zones(main_dir = main_dir)



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




