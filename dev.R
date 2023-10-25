


  flexdashboard:::
  leaflet:::
  plotly:::
  sf:::
  shiny:::
  shinyBS:::
  shinycssloaders:::
  shinydashboard:::
  shinythemes:::
  shinyWidgets:::
  tidyverse:::
  xts:::

devtools::load_all()
devtools::document()
devtools::build()

shinyOptions(cache = cache_mem(max_size = 500e6))

app_ui()


putting app code into inst

source("./inst/app/app.R")

devtools::document();shinyApp(ui = app_ui(), server = app_server)