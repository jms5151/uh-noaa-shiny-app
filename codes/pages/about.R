about_page <- function(input, output) {
  output$cdz_images <- renderImage({
    filename <- "../forec_shiny_app_data/disease_pictures.png"
    list(src = filename)
    },
  deleteFile = FALSE
  ) %>% bindCache("disease_pictures")

  output$warning_levels_table <- renderDataTable(
    warning_table,
    options(
      paging = FALSE,
      searching = FALSE,
      info = FALSE
    )
  ) %>% bindCache("warning_table")
  
  output$warning_levels_text <- renderText({
    paste0(
      warning_levels_txt,
      "<sup> 2 </sup>"
    )
  })
  
  output$funding_statement <- renderUI({
    funding_statement_txt
  })

  output$cite1 <- renderUI({
    Geigeretal2021_citation
  })

  output$cite2 <- renderUI({
    Greeneetal2020a_citation
  })

  output$cite3 <- renderUI({
    Greeneetal2020b_citation
  })

  output$cite4 <- renderUI({
    Caldwelletal2020_citation
  })
}