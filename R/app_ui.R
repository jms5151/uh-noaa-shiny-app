app_ui <- function (theme = shinytheme("flatly")) {

  app_text <- read_yaml("inst/app/www/text.yml")

  navbarPage(title       = "", 
             id          = "nav",
             collapsible = TRUE,
             theme       = theme,
             header      = includeCSS("inst/app/www/styles.css"),

    tabPanel(title = "Coral disease predictions",
      fluidRow(
        column(width = 12,
               h2(strong(app_text$welcome_txt, 
                         style = "color: #009999;")),
               h5(app_text$landing_page_info_txt, 
                  style = "color: #009999;"),
               uiOutput("noaa_ref")
        )
      ),
      br( ),
      fluidRow(style = "border-style: double; border-color: #00172D;",
        column(style = "border-right: double; border-color: #00172D;",
               width = 3,
          h4("Risk nowcast",
             align = "center",
             style = "background-color: #00172D;
                      color: white;
                      padding-bottom: 3px"),
          h4(app_text$forecasts_step_1_txt, 
             style = "color: #009999;"),
          h6(app_text$forecasts_step_1_txt_sub, 
             style = "color: #009999;"),
          #plotlyOutput( ),
          br( )
        ),

        column(width = 6,
          h4("Risk map",
             align = "center",
             style = "background-color: #00172D;
                      color: white;
                      padding-bottom: 3px"),
          h4(app_text$forecasts_step_2_txt, 
             style = "color: #009999;"),
          h6(app_text$forecasts_step_2_txt_sub, 
             style = "color: #009999;"),
          #leafletOutput( ),
          br( )
        ),

        column(style = "border-left: double; border-color: #00172D;",
               width = 3,
          h4("Risk predictions",
             align = "center",
             style = "background-color: #00172D;
                      color: white;
                      padding-bottom: 3px"),
          h4(app_text$forecasts_step_3_txt, 
             style = "color: #009999;"),
          h6(app_text$forecasts_step_3_txt_sub, 
             style = "color: #009999;"),
          #plotlyOutput( ),
          #plotlyOutput( ),
          br( )
        )
      )
    ),
    tabPanel(title = "Investigating scenarios",

      fluidRow(column(width = 1
               ),
               column(width = 10,
                 h4(
                   strong(app_text$scenarios_page_explainer_txt, 
                          style = "color: #009999;")
                 )
               )
      ),
      br( )


    ),
    tabPanel(title = "Historical data"

    ),
    tabPanel(title = "About",
      h3("Coral disease information:"),
      br(),
      HTML(app_text$warning_levels_txt),
    
      br(),
      h3("Model description:"),
      app_text$about_models_text,
    
      br(),
      h3("Funding:"),
      HTML(app_text$funding_statement_txt),
    
      br(),
      h3("Publications:"),
      HTML(app_text$publications_txt)
    )

  )

}


