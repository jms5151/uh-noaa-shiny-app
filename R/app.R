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


}

app_clear_global <- function ( ) {

  rm("app_text", pos = 1)
  rm("app_settings", pos = 1)

}

