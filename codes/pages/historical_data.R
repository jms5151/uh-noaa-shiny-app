historical_data_page <- function(input, output) {
  output$historical_data_map <- renderLeaflet({
    historicalMap
  })  %>% bindCache("historicalMap")
}