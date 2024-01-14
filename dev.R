devtools::document()
run_app()


#shinyApp(ui = app_ui(), server = app_server)
runApp(appDir = app_path( ))
shinyAppDir(appDir = app_path( ))


devtools::load_all()

devtools::build()

getShinyOption("cache")

app_ui()


# bsToolTip is not working unless i load the whole shinyBS library
# it's gotta be some function we need
# i tried to bring over the functions, but it still wasn't working
# it must be some setting setup stuff, so im making shinyBS required

# working in the scenarios page server code
#
#  where is scenarios_placeholder_map defined? is it anywhere?
# same with the scenarios_placeholder_plot