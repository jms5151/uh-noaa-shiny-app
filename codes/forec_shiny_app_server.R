source("./pages/forecasts.R", local = TRUE)
source("./pages/scenarios.R", local = TRUE)
source("./pages/historical_data.R", local = TRUE)
source("./pages/about.R", local = TRUE)


server <- function(input, output, session) {
  forecast_page(input, output)
  scenarios_page(input, output)
  historical_data_page(input, output)
  about_page(input, output)
}
