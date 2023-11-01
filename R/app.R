run_app <- function ( ) {

  onStop(fun = app_clear_global)

  app_global( )

shinyOptions(cache = cachem::cache_disk(file.path(dirname(tempdir()), "myapp-cache")))


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

  assign(x     = "gauge_data",
         value = load_gauge_data( ),
         pos   = 1)

  assign(x     = "basemap",
         value = create_basemap( ),
         pos   = 1)

  assign(x     = "shpFiles",
         value = load_shape_files( ),
         pos   = 1)

}

app_clear_global <- function ( ) {

  rm("app_text", pos = 1)
  rm("app_settings", pos = 1)
  rm("gauge_data", pos = 1)
  rm("basemap", pos = 1)
  rm("shpFiles", pos = 1)

}

