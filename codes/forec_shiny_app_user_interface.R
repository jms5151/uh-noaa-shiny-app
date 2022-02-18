library(shiny)

ui <- navbarPage(
  theme = shinythemes::shinytheme(
    "flatly"
  ), 
  collapsible = TRUE, 
  "", 
  id="nav",
  # Nowcasts and forecasts page --------------------
  tabPanel(
    "Coral disease predictions",
    fluidRow(
      style = "border-top: 2px double #00172D;",
      column(
        width = 3,
        style = "border-right: 2px double #00172D;",
        h4(
          "Risk nowcast (region, disease)",
          align = "center",
          style = "background-color: #00172D;
          color: white;
          padding-bottom: 3px"
          )
        ),
      column(
        width = 6,
        h4(
          "Risk map (total disease)",
          align = "center",
          style = "background-color: #00172D;
          color: white;
          padding-bottom: 3px"
          )
        ),
      column(
        width = 3,
        style = "border-left: 2px double #00172D",
        h4(
          "Risk forecast",
          align = "center",
          style = "background-color: #00172D;
          color: white;
          padding-bottom: 3px"
          )
        )
      ),
    fluidRow(
      column(
        width = 3,
        style = "border-right: 2px double #00172D;
        border-bottom: 2px double #00172D;
        padding-bottom: 15px;",
        plotlyOutput(
          "gauge_plots",
          height = 400
          ) %>%
          withSpinner(
            color = spinColor
          )
        ),
      column(
        style = "border-bottom: 2px double #00172D;
        padding-bottom: 15px;",
        width = 6,
        height = 500,
        leafletOutput(
          "map1"
          ) %>%
          withSpinner(
            color = spinColor
            )
        ),
      column(
        width = 3,
        style = "border-left: 2px double #00172D;
        border-bottom: 2px double #00172D;
        padding-bottom: 15px;",
        plotlyOutput(
          "plotlyGA",
          height = 200
          ) %>%
          withSpinner(
            color = spinColor
            ),
        plotlyOutput(
          "plotlyWS",
          height = 200
          ) %>%
          withSpinner(
            color = spinColor
            )
        )
    ),
    shiny::hr(),
    textOutput(
      "last_update"
      )
    # absolutePanel(
    #   id = "controls",
    #   class = "panel panel-default",
    #   top = 450,
    #   left = 30,
    #   fixed = TRUE,
    #   draggable = FALSE,
    #   height = "auto",
    #   class = "dropdown",
    #   dropMenu(
    #     dropdownButton(
    #       icon = icon(
    #         'info'
    #       ),
    #       size = "xs"
    #     ),
    #     h3(
    #       strong(
    #         'Information'
    #       )
    #     ),
    #     h5(
    #       landing_page_info_txt
    #       )
    #     )
    #   )
    ),
  # Management scenarios page --------------------
  tabPanel(
    "Investigating scenarios",
    fluidRow(
      column(
        width = 1
      ),

      column(
        width = 3,
        style = "height: 800px;
        border: 2px double #00172D;
        padding-top: 15px;
        padding-left: 20px;
        padding-bottom: 10px;", # background-color: lightgrey;

        selectInput(
          inputId = "Region",
          label = "Select region",
          selected = NULL,
          choices = c(
            "U.S. Pacific",
            "Great Barrier Reef, Australia"
          )
        ),

        selectInput(
          "Disease",
          "Select disease type",
          choices = c(
            "Growth anomalies",
            "White syndromes"
          )
        ),

        setSliderColor(c(rep("#003152", 14)), c(1:14)),

        # Scenarios - GA, Pacific -------------------
        conditionalPanel(
          condition = "input.Region == 'U.S. Pacific' &
          input.Disease == 'Growth anomalies'",

          sliderInput(
            "coral_size_slider_ga_pac",
            label = span(
              h5(
                strong(
                  "Median coral colony size"
                  )
                ),
              tags$i(
                h6(
                  textOutput(
                    "corsize_value_ga_pac"
                    )
                  )
                ),
              ),
            min = 5,
            max = 65,
            step = 10,
            post = " cm",
            value = 15,
            width = "275px"
            ),

          bsTooltip(
            id = "coral_size_slider_ga_pac",
            title = "Median colony size of corals in the family Poritidae",
            placement = "right",
            trigger = "hover"
          ),


          sliderInput(
            "coral_cover_slider_ga_pac",
            label = span(
              h5(
                strong(
                  tags$em(
                    "Porites"
                    ),
                  "coral cover"
                )
              ),
              tags$i(
                h6(
                  textOutput(
                    "corcov_value_ga_pac"
                    )
                  )
                )
            ),
            min = 5,
            max = 65,
            step = 10,
            post = " %",
            value = 15,
            width = "275px"
          ),

          sliderInput(
            "herb_fish_slider_ga_pac",
            label = span(
              h5(
                strong(
                  "Herbivorous fish density (fish/m",
                  tags$sup("2"),
                  ")"
                  )
                ),
              tags$i(
                h6(
                  htmlOutput(
                    "herb_fish_value_ga_pac"
                    )
                  )
                )
              ),
            min = 0.1,
            max = 0.7,
            step = 0.1,
            # post = " fish/m<sup>2</sup>",
            value = 0.3,
            width = "275px"
            ),

          sliderInput(
            "dev_slider_ga_pac",
            label = span(
              h5(
                strong(
                  "Coastal development index"
                )
              ),
              tags$i(
                h6(
                  htmlOutput(
                    "dev_value_ga_pac"
                  )
                )
              ),
              div(
                style = 'width:275px;',
                div(
                  h6(
                    style = 'float:left;',
                    'Undeveloped'
                  )
                ),
                div(
                  h6(
                    style = 'float:right;',
                    'Highly developed'
                  )
                )
              )
            ),
            min = 0.0,
            max = 1.0,
            step = 0.1,
            # post = "",
            value = 0.3,
            width = "275px"
            )
          ),

        # Scenarios - WS, Pacific -------------------
        conditionalPanel(
          condition = "input.Region == 'U.S. Pacific' &
          input.Disease == 'White syndromes'",

          sliderInput(
            "coral_size_slider_ws_pac",
            label = span(
              h5(
                strong(
                  "Median coral colony size"
                )
              ),
              tags$i(
                h6(
                  textOutput(
                    "corsize_value_ws_pac"
                  )
                )
              ),
            ),
            min = 5,
            max = 65,
            step = 10,
            post = " cm",
            value = 10,
            width = "275px"
          ),

          bsTooltip(
            id = "coral_size_slider_ws_pac",
            title = "Median colony size of corals in the family Acroporidae",
            placement = "right",
            trigger = "hover"
          ),

          sliderInput(
            "turbidity_slider_ws_pac", # long term kd median
            label = span(
              h5(
                strong(
                  "Turbidity"
                )
              ),
              tags$i(
                h6(
                  htmlOutput(
                    "kd_value_ws_pac"
                  )
                )
              ),
              div(
                style = 'width:250px;',
                div(
                  h6(
                    style ='float:left;',
                    'Less'
                  )
                ),
                div(
                  h6(
                    style = 'float:right;',
                    'More'
                  )
                )
              )
            ),
            min = 0,
            max = 2,
            step = 0.1,
            post = " m<sup>-1</sup>",
            value = 0.5,
            width = "275px"
            ),

          bsTooltip(
            id = "turbidity_slider_ws_pac",
            title = turbidity_hover_txt,
            placement = "right",
            trigger = "hover"
          ),

          sliderInput(
            "parrotfish_slider_ws_pac",
            label = span(
              h5(
                strong(
                  "Parrotfish density (fish/m",
                  tags$sup("2"),
                  ")"
                  )
                ),
              tags$i(
                h6(
                  htmlOutput(
                    "parrotfish_value_ws_pac"
                    )
                  )
                )
              ),
            min = 0.00,
            max = 0.06,
            step = 0.01,
            # post = " fish/m<sup>2</sup>",
            value = 0.02,
            width = "275px"
            ),

          sliderInput(
            "herb_fish_slider_ws_pac",
            label = span(
              h5(
                strong(
                  "Herbivorous fish density (fish/m",
                  tags$sup("2"),
                  ")"
                )
              ),
              tags$i(
                h6(
                  htmlOutput(
                    "herb_fish_value_ws_pac"
                  )
                )
              )
            ),
            min = 0.0,
            max = 0.6,
            step = 0.1,
            # post = "",
            value = 0.4,
            width = "275px"
            )
          ),

        # Scenarios - GA, GBR -------------------
        conditionalPanel(
          condition = "input.Region == 'Great Barrier Reef, Australia' &
          input.Disease == 'Growth anomalies'",

          sliderInput(
            "fish_slider_ga_gbr",
            label = span(
              h5(
                strong(
                  "Fish abundance"
                )
              ),
              tags$i(
                h6(
                  htmlOutput(
                    "fish_value_ga_gbr"
                  )
                )
              )
            ),
            min = 400,
            max = 800,
            step = 50,
            # post = "",
            value = 600,
            width = "275px"
          ),

          bsTooltip(
            id = "fish_slider_ga_gbr",
            title = "Fish count within ~2km",
            placement = "right",
            trigger = "hover"
          ),

          sliderInput(
            "turbidity_slider_ga_gbr", # three week kd variability
            label = span(
              h5(
                strong(
                  "Turbidity"
                )
              ),
              tags$i(
                h6(
                  htmlOutput(
                    "kd_value_ga_gbr"
                  )
                )
              ),
              div(
                style = 'width:250px;',
                div(
                  h6(
                    style ='float:left;',
                    'Less'
                  )
                ),
                div(
                  h6(
                    style = 'float:right;',
                    'More'
                  )
                )
              )
            ),
            min = 0,
            max = 2,
            step = 0.1,
            post = " m<sup>-1</sup>",
            value = 0.5,
            width = "275px"
          ),

          bsTooltip(
            id = "turbidity_slider_ga_gbr",
            title = turbidity_hover_txt,
            placement = "right",
            trigger = "hover"
          ),

        sliderInput(
          "coral_cover_slider_ga_gbr",
          label = span(
            h5(
              strong(
                "Coral cover"
              )
            ),
            tags$i(
              h6(
                textOutput(
                  "corcov_value_ga_gbr"
                )
              )
            )
          ),
          min = 5,
          max = 95,
          step = 10,
          post = " %",
          value = 35,
          width = "275px"
          )
        ),

        # Scenarios - WS, GBR --------------------
        conditionalPanel(
          condition = "input.Region == 'Great Barrier Reef, Australia' &
          input.Disease == 'White syndromes'",

          sliderInput(
            "coral_cover_slider_ws_gbr",
            label = span(
              h5(
                strong(
                  "Coral cover"
                )
              ),
              tags$i(
                h6(
                  textOutput(
                    "corcov_value_ws_gbr"
                  )
                )
              )
            ),
            min = 5,
            max = 95,
            step = 10,
            post = " %",
            value = 20,
            width = "275px"
          ),

          bsTooltip(
            id = "coral_cover_slider_ws_gbr",
            title = "Percent of live coral cover with plating and table morphologies",
            placement = "right",
            trigger = "hover"
          ),

          sliderInput(
            "fish_slider_ws_gbr",
            label = span(
              h5(
                strong(
                  "Fish abundance"
                )
              ),
              tags$i(
                h6(
                  htmlOutput(
                    "fish_value_ws_gbr"
                  )
                )
              )
            ),
            min = 400,
            max = 800,
            step = 50,
            post = "",
            value = 600,
            width = "275px"
          ),

          bsTooltip(
            id = "fish_slider_ws_gbr",
            title = "Fish count within ~2km",
            placement = "right",
            trigger = "hover"
          ),

          sliderInput(
            "turbidity_slider_ws_gbr", # three week kd variability
            label = span(
              h5(
                strong(
                  "Turbidity"
                )
              ),
              tags$i(
                h6(
                  htmlOutput(
                    "kd_value_ws_gbr"
                  )
                )
              ),
              div(
                style = 'width:250px;',
                div(
                  h6(
                    style ='float:left;',
                    'Less'
                  )
                ),
                div(
                  h6(
                    style = 'float:right;',
                    'More'
                  )
                )
              )
            ),
            min = 0,
            max = 2,
            step = 0.1,
            post = " m<sup>-1</sup>",
            value = 0,
            width = "275px"
            ),

          bsTooltip(
            id = "turbidity_slider_ga_gbr",
            title = turbidity_hover_txt,
            placement = "right",
            trigger = "hover"
            )
          )
        ),

      column(
        width = 7,
        style = "height: 800px;
        border-top: 2px double #00172D;
        border-right: 2px double #00172D;
        border-bottom: 2px double #00172D;
        padding: 25px;",
        leafletOutput(
          "management_map",
          height = "325px"
        ) %>%
          withSpinner(
            color = spinColor
            ),
        shiny::hr(),
        plotlyOutput(
          "scenarios_barplot",
          height = "350px"
          ) %>%
          withSpinner(
            color = spinColor
            )
        ),

      column(
        width = 1
        )

      ),

    fluidRow(
      shiny::hr()
    )


    ), # this closes the scenarios page

  # Historical data page --------------------
  tabPanel(
    "Historical data",
    div(
      class = "outer",
      tags$head(
        includeCSS(
          "styles.css"
        )
      ),
      leafletOutput(
        "historical_data_map",
        width = "100%",
        height = "100%"
      )
    ),
    absolutePanel(
      id = "controls",
      class = "panel panel-default",
      top = 80,
      left = 60,
      fixed = TRUE,
      draggable = FALSE,
      height = "auto",
      class = "dropdown",
      dropMenu(
        dropdownButton(
          icon = icon(
            'info'
          ),
          size = "xs"
        ),
        h3(
          strong(
            'Information'
          )
        ),
        h5(
          historical_data_txt1
        ),
        h5(
          historical_data_txt2
        ),
        h5(
          historical_data_txt3
        )
      )
    )
  ),

  # About the project page --------------------
  tabPanel(
    "About",
    h3(
      "Coral disease information:"
      ),
    imageOutput(
      "cdz_images"
      ) %>%
      withSpinner(
        color = spinColor
      ),
    disease_info_text,
    photo_credit,
    h3(
      "Disease risk warning levels:"
       ),
    shiny::dataTableOutput(
      "warning_levels_table"
    ) %>%
      withSpinner(
        color = spinColor
      ),
    br(),

    htmlOutput(
          "warning_levels_text",
    ),
    
    br(),
    h3(
      "Model description:"
    ),
    about_models_text,
    h3(
      "Funding:"
      ),
    uiOutput(
      "funding_statement"
      ),
    br(),
    h3(
      "Publications:"
      ),
    uiOutput(
      "cite1"
      ),
    br(),
    uiOutput(
      "cite2"
      ),
    br(),
    uiOutput(
      "cite3"
      ),
    br(),
    uiOutput(
      "cite4"
      )
  )
)
