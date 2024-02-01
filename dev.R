devtools::document()
run_app()


#shinyApp(ui = app_ui(), server = app_server)
runApp(appDir = app_path( ))
shinyAppDir(appDir = app_path( ))

runApp(appDir = run_app( ))



devtools::load_all()

devtools::build()

getShinyOption("cache")

app_ui()


# bsToolTip is not working unless i load the whole shinyBS library
# it's gotta be some function we need
# i tried to bring over the functions, but it still wasn't working
# it must be some setting setup stuff, so im making shinyBS required

remotes::install_github('jms5151/uh-noaa-shiny-app', ref = remotes::github_pull(7), force = TRUE)
pak::pkg_install('jms5151/uh-noaa-shiny-app#7')


uhnoaashinyapp::run_app()



uhnoaashinyapp:::app_global