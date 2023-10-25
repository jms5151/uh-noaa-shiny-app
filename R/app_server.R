app_server <- function (input,
                        output,
                        session) {

message("poop")
  forecast_page(input, output)
  about_page(input, output)
message("flush")

}

about_page <- function(input, output) {

  output$cdz_images <- renderImage({
      list(src = app_file("disease_pictures.png"))
    }, 
    deleteFile = FALSE
  )

  warning_levels_table <- read.csv(app_file("warning_levels_table.csv"))
  colnames(warning_levels_table) <- gsub('\\_', ' ', colnames(warning_levels_table))

  output$warning_levels_table <- renderDataTable(
    warning_levels_table,
    options =list(
      paging = FALSE,
      searching = FALSE,
      info = FALSE
    )
  )

}

forecast_page <- function(input, output) {



}