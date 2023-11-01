devtools::document()
run_app()


#shinyApp(ui = app_ui(), server = app_server)
runApp(appDir = app_path( ))
shinyAppDir(appDir = app_path( ))


devtools::load_all()

devtools::build()

getShinyOption("cache")

app_ui()

