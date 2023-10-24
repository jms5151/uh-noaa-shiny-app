app_server <- function (input,
                        output,
                        session) {

message("poop")
  forecast_page(input, output)

message("flush")

}

forecast_page <- function(input, output) {


  # replace this link when avaialble
  mfdz_url <- a("NOAA Coral Reef Watch", href = 'https://coralreefwatch.noaa.gov/')

  noaa_return <- tagList('Return to ', mfdz_url, '.')


  output$noaa_ref <- renderUI({
    noaa_return
  })


  output$last_update <- renderText({ "hi" })

}