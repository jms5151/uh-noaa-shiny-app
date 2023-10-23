  flexdashboard:::withSpinner
  leaflet:::withSpinner
  plotly:::withSpinner
  sf:::withSpinner
  shiny:::withSpinner
  shinyBS:::withSpinner
  shinycssloaders:::withSpinner
  shinydashboard:::withSpinner
  shinythemes:::withSpinner
  shinyWidgets:::withSpinner
  tidyverse:::withSpinner
  xts:::withSpinner

devtools::load_all()
devtools::document()
devtools::build()

putting app code into inst

runApp("./inst/app")

cachem::cache_mem

