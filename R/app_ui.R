app_ui <- function (theme = shinytheme("flatly")) {

  app_text     <- read_app_text( )
  app_settings <- read_app_settings( )

  navbarPage(title       = "", 
             id          = "nav",
             collapsible = TRUE,
             theme       = theme,
             header      = app_css_header( ),

    app_ui_predictions(app_text     = app_text,
                       app_settings = app_settings),

    app_ui_scenarios(app_text     = app_text,
                     app_settings = app_settings),

    app_ui_historical_data(app_text     = app_text,
                           app_settings = app_settings),

    app_ui_about(app_text     = app_text,
                 app_settings = app_settings)

  )

}

app_ui_predictions <- function (app_text     = read_app_text( ),
                                app_settings = read_app_settings( )) { 

  tabPanel(title = "Coral disease predictions",
    fluidRow(
      column(width = 12,
             h2(strong(app_text$welcome, 
                       style = "color: #009999;")),
             h5(app_text$landing_page_info, 
                style = "color: #009999;"),
             HTML(app_text$noaa_ref)
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
        h4(app_text$forecasts_step_1, 
           style = "color: #009999;"),
        h6(app_text$forecasts_step_1_sub, 
           style = "color: #009999;"),
        plotlyOutput(outputId = "gauge_plots",
                     height   = 400) %>%
          withSpinner(color = app_settings$spinColor),
        br( )
      ),

      column(width = 6,
        h4("Risk map (total disease)",
           align = "center",
           style = "background-color: #00172D;
                    color: white;
                    padding-bottom: 3px"),
        h4(app_text$forecasts_step_2, 
           style = "color: #009999;"),
        h6(app_text$forecasts_step_2_sub, 
           style = "color: #009999;"),
       # leafletOutput(outputId = "map1") %>%
        #  withSpinner(color = app_settings$spinColor),
        br( )
      ),

      column(style = "border-left: double; border-color: #00172D;",
             width = 3,
        h4("Risk predictions",
           align = "center",
           style = "background-color: #00172D;
                    color: white;
                    padding-bottom: 3px"),
        h4(app_text$forecasts_step_3, 
           style = "color: #009999;"),
        h6(app_text$forecasts_step_3_sub, 
           style = "color: #009999;"),
    #    plotlyOutput(outputId = "plotlyGA",
     #                height   = 200) %>%
      #    withSpinner(color = app_settings$spinColor),
      #  plotlyOutput(outputId = "plotlyWS",
       #              height   = 200) %>%
        #  withSpinner(color = app_settings$spinColor),
        br( )
      )
    ),
    hr(),
    #textOutput(outputId = "last_update"),
    imageOutput("logo_images")
  )

}

app_ui_scenarios <- function (app_text     = read_yaml(app_file("text.yml")),
                              app_settings = read_yaml(app_file("settings.yml"))) { 

  tabPanel(title = "Investigating scenarios",

    fluidRow(column(width = 1),
             column(width = 10,
               h4(strong(app_text$scenarios_page_explainer, 
                         style = "color: #009999;")
                 )
               )
    ),
    br( )
  )
}



app_ui_historical_data <- function (app_text     = read_yaml(app_file("text.yml")),
                                    app_settings = read_yaml(app_file("settings.yml"))) { 

  tabPanel(title = "Historical data")


}

app_ui_about <- function (app_text     = read_yaml(app_file("text.yml")),
                          app_settings = read_yaml(app_file("settings.yml"))) { 

  tabPanel(title = "About",
    h3("Coral disease information:"),
    imageOutput("cdz_images") %>%
      withSpinner(color = app_settings$spinColor),
    app_text$disease_info,
    app_text$photo_credit,
    br( ), br( ), 

    h3("Disease risk warning levels:"),
    dataTableOutput("warning_levels_table"),
    br(),
    HTML(app_text$warning_levels),
    br( ), br( ),

    h3("Model description:"),
    app_text$about_models,
    br( ), br( ),

    h3("Funding:"),
    HTML(app_text$funding_statement),
    br( ),

    h3("Publications:"),
    HTML(app_text$publications)
  )

}

