#'
#' @export
#'
app_server <- function (input,
                        output,
                        session) {

  #forecast_page(input, output)
 # scenarios_page(input, output)
 # historical_data_page(input, output)
  about_page(input, output)

}


about_page <- function(input, output) {

  output$cdz_images <- renderImage({
      list(src = app_disease_pictures_path( ))
    }, 
    deleteFile = FALSE
  )

  warning_levels_table <- read.csv(app_file("warning_levels_table.csv"))
  colnames(warning_levels_table) <- gsub('\\_', ' ', colnames(warning_levels_table))

  output$warning_levels_table <- renderDataTable(expr    = warning_levels_table,
                                                 options = list(paging    = FALSE,
                                                                searching = FALSE,
                                                                info      = FALSE))

}
