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

i though i brough over all the functions and object we need but it still isnt working

wondering if there's a cleaner way to do hover text box?
almost certainly