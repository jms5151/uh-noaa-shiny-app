app_ui <- function ( ) {

  webapp_text     <- webapp_text( )
  webapp_settings <- webapp_settings( )

  navbarPage(title       = "",
             theme       = shinytheme("flatly"), 
             collapsible = TRUE, 
             id          = "nav",
             nowcasts_and_forecasts_panel(webapp_text     = webapp_text, 
                                          webapp_settings = webapp_settings))

}

nowcasts_and_forecasts_panel <- function (webapp_text     = webapp_text( ),
                                          webapp_settings = webapp_settings( )) {

  tabPanel(
    "Coral disease predictions",
    
    fluidRow(
      column(
        width = 12,
        h2(
          strong(
            webapp_text$welcome_txt
            , style = "color: #009999;"
          )
        ),
        h5(
            webapp_text$landing_page_info_txt
            , style = "color: #009999;"
        ),
        uiOutput(
          'noaa_ref'
          )
        )
    )
  )

}