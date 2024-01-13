app_ui <- function ( ) {

  navbarPage(title       = "", 
             id          = "nav",
             collapsible = TRUE,
             theme       = shinytheme("flatly"),
             header      = app_css_header( ),

    app_ui_predictions( ),

    app_ui_scenarios( ),

    app_ui_historical_data( ),

    app_ui_about( )

  )

}

app_ui_predictions <- function ( ) { 

  tabPanel(title = "Coral disease predictions",

    app_ui_predictions_welcome( ),

    br( ),

    app_ui_predictions_figures( ),

    hr( ),

    app_ui_predictions_last_update( ),

    app_ui_predictions_logos( )
  )

}

app_ui_predictions_figures <- function ( ) {

  fluidRow(style = "border-style: double; border-color: #00172D;",
    app_ui_predictions_gauge_plots( ),
    app_ui_predictions_reef_map( ),
    app_ui_predictions_disease_risk_plots( )
  )

}

app_ui_predictions_disease_risk_plots <- function ( ) {

  column(width = 3,
         style = "border-left: double; border-color: #00172D;",
         h4("Risk predictions",
            align = "center",
            style = "background-color: #00172D;
                     color: white;
                     padding-bottom: 3px"),
         h4(HTML(app_text$forecasts_step_3),
                 style = "color: #009999;"),
         h6(HTML(app_text$forecasts_step_3_sub),
                 style = "color: #009999;"),
         plotlyOutput(outputId = "plotlyGA",
                      height = 200) %>%
           withSpinner(color = app_settings$spinColor),
         plotlyOutput(outputId = "plotlyWS",
                     height = 200) %>%
           withSpinner(color = app_settings$spinColor),
         br( ))

}

app_ui_predictions_reef_map <- function ( ) {

  column(width = 6,
         h4("Risk map (total disease)",
            align = "center",
            style = "background-color: #00172D;
                     color: white;
                     padding-bottom: 3px"),
         h4(HTML(app_text$forecasts_step_2), 
                 style = "color: #009999;"),
         h6(HTML(app_text$forecasts_step_2_sub), 
                 style = "color: #009999;"), 
         leafletOutput(outputId = "map1") %>%
           withSpinner(color = app_settings$spinColor),
         br( ))
}

app_ui_predictions_gauge_plots <- function ( ) {

  column(style = "border-right: double; border-color: #00172D;",
         width = 3,
        h4("Risk nowcast",
           align = "center",
           style = "background-color: #00172D;
                    color: white;
                    padding-bottom: 3px"),
        h4(HTML(app_text$forecasts_step_1), 
           style = "color: #009999;"),
        h6(HTML(app_text$forecasts_step_1_sub), 
           style = "color: #009999;"),
        plotlyOutput(outputId = "gauge_plots",
                     height   = 400) %>%
          withSpinner(color = app_settings$spinColor),
        br( )
      )

}

app_ui_predictions_last_update <- function ( ) {

  textOutput(outputId = "last_update")

}

app_ui_predictions_logos <- function ( ) {

  imageOutput(outputId = "logo_images")

}

app_ui_predictions_welcome <- function ( ) {

  fluidRow(
      column(width = 12,
             h2(strong(HTML(app_text$welcome), 
                       style = "color: #009999;")),
             h5(HTML(app_text$landing_page_info),
                style = "color: #009999;"),
             HTML(app_text$noaa_ref)
      )
    )

}

app_ui_scenarios <- function ( ) {

  tabPanel(title = "Investigating scenarios",

    app_ui_scenarios_explainer_top( ),
    
    br( ),
    
    app_ui_scenarios_row( ),

    app_ui_scenarios_explainer_bottom( ),

    hr( )

  )

}

app_ui_scenarios_row <- function ( ) {

  fluidRow(column(width = 1),
    app_ui_scenarios_row_inputs( ))

}

app_ui_scenarios_row_inputs <- function ( ) {

  column(width = 3,
         style = "height: 1050px;
                  border: 2px double #00172D;
                  padding-top: 15px;
                  padding-left: 20px;
                  padding-bottom: 10px;",
         h4(strong(HTML(app_text$scenarios_step_1), 
                         style = "color: #009999;")), 

         selectInput(inputId  = "Region",
                     label    = "Select region",
                     selected = NULL,
                     choices  = c("U.S. Pacific", "Great Barrier Reef, Australia")),
         selectInput(InputId  = "Disease",
                     label    = "Select disease type",
                     choices = c("Growth anomalies", "White syndromes"))

 )

}


app_ui_scenarios_explainer_top <- function ( ) {

  fluidRow(column(width = 1),
           column(width = 10,
               h4(strong(HTML(app_text$scenarios_page_explainer_top), 
                         style = "color: #009999;"))))

}

app_ui_scenarios_explainer_bottom <- function ( ) {

  fluidRow(column(width = 1),
           column(width = 10,
               h5(HTML(app_text$scenarios_page_explainer_bottom))))

}




app_ui_historical_data <- function ( ) {

  tabPanel(title = "Historical data")


}



app_ui_about <- function ( ) {

  tabPanel(title = "About",

    app_ui_about_disease_information( ),

    br( ), br( ), 

    app_ui_about_warning_levels( ),

    br( ), br( ),

    app_ui_about_models( ),

    br( ), br( ),

    app_ui_about_funding( ),

    br( ), br( ), 
    
    app_ui_about_publications( )

  )

}

app_ui_about_disease_information <- function ( ) {

  div(h3("Coral disease information:"),
      imageOutput("cdz_images") %>%
        withSpinner(color = app_settings$spinColor),
      HTML(app_text$disease_info),
      HTML(app_text$photo_credit))

}

app_ui_about_warning_levels <- function ( ) {

  div(h3("Disease risk warning levels:"),
      dataTableOutput("warning_levels_table"),
       br( ),
       HTML(app_text$warning_levels))

}

app_ui_about_models <- function ( ) {

  div(h3("Model description:"),
      HTML(app_text$about_models))

}

app_ui_about_funding <- function ( ) {

  div(h3("Funding:"),
      HTML(app_text$funding_statement))

}


app_ui_about_publications <- function ( ) {

  div(h3("Publications:"),
      HTML(app_text$publications))

}