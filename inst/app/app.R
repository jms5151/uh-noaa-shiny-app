# This file launches the shiny app from a clean R session.
# running library on the package installs all necessary R dependencies and sources all internal functions 

library("uhnoaashinyapp")

# here is where any additional code can be run

shinyOptions(cache = cache_mem(max_size = 500e6))


# launch the app.

shinyApp(ui     = app_ui( ),
         server = app_server)