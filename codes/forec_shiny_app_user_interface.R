ui <- navbarPage(
  theme = shinytheme(
    "flatly"
  ), 
  collapsible = TRUE, 
  "", 
  id="nav",
  # Nowcasts and forecasts page
  tabPanel(
    "Coral disease predictions",
    fluidRow(
      style = "border-top: 2px double #00172D;",
      column(
        width = 3,
        style = "border-right: 2px double #00172D;",
        h4(
          "Risk nowcast",
          align = "center",
          style = "background-color: #00172D;
          color: white;
          padding-bottom: 3px"
          )
        ),
      column(
        width = 6,
        h4(
          "Risk map",
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
    hr(),
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
  # Management scenarios page
  # this is how to do conditional sliders based on region and disease:
  # https://stackoverflow.com/questions/68250593/how-to-show-slider-inputs-based-on-selected-radio-buttons-in-shiny-r
  tabPanel(
    "Investigating scenarios new",
    fluidRow(
      style = "border-top: 2px double #00172D;",
      column(
        width = 4,
        style = "border-right: 2px double #00172D;
        border-bottom: 2px double #00172D;
        padding-top: 15px;",
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
        conditionalPanel(
          condition = "input.Region == 'U.S. Pacific' & 
          input.Disease == 'Growth anomalies'",
          
            sliderInput("a",
                        label = "a:", 
                        min = 0, max = 1,step = 1, value = 0),
          
            sliderInput("b",
                        "b:", 
                        min = 0, max = 1,step = 1, value = 0),
            
            sliderInput("c",
                        "c:", 
                        min = 0, max = 1,step = 1, value = 0)
        ),
        
        conditionalPanel(
          condition = "input.Region == 'U.S. Pacific' & 
          input.Disease == 'White syndromes'",
          
          sliderInput("d",
                      label = "d:", 
                      min = 0, max = 1,step = 1, value = 0),
          
          sliderInput("e",
                      "e:", 
                      min = 0, max = 1,step = 1, value = 0),
          
          sliderInput("f",
                      "f:", 
                      min = 0, max = 1,step = 1, value = 0)
        ),

        conditionalPanel(
          condition = "input.Region == 'Great Barrier Reef, Australia' & 
          input.Disease == 'Growth anomalies'",

          sliderInput("g",
                      label = "g:", 
                      min = 0, max = 1,step = 1, value = 0),
          
          sliderInput("h",
                      "h:", 
                      min = 0, max = 1,step = 1, value = 0),
          
          sliderInput("i",
                      "i:", 
                      min = 0, max = 1,step = 1, value = 0)
        ),
        
        conditionalPanel(
          condition = "input.Region == 'Great Barrier Reef, Australia' & 
          input.Disease == 'White syndromes'",
          
          sliderInput("j",
                      label = "j:", 
                      min = 0, max = 1,step = 1, value = 0),
          
          sliderInput("k",
                      "k:", 
                      min = 0, max = 1,step = 1, value = 0),
          
          sliderInput("l",
                      "l:", 
                      min = 0, max = 1,step = 1, value = 0)
        )
        
      ),
      column(
        width = 8,
        style = "border-left: 2px double #00172D;
        border-bottom: 2px double #00172D;
        padding: 15px;",
        leafletOutput(
          "management_map", 
          height = "300px"
        ) %>% 
          withSpinner(
            color = spinColor
            ),
        plotlyOutput(
          "barplot",
          height = "300px"
          ) %>% 
          withSpinner(
            color = spinColor
          )
        )
      )
    )
  )#,
    
  tabPanel(
    "Investigating scenarios original", #HTML("Long-term mitigation<br/>potential"),
    leafletOutput(
      "management_map", 
      height = "300px"
    ) %>% 
      withSpinner(
        color = spinColor
      ),
    # set all slider colors at once, colors = deepskyblue4, dark red, black repeated\
    setSliderColor(
      c("#00688B", "#8B0000", "#000000", "#00688B", "#8B0000", "#000000"),
      c(1, 2, 3, 4, 5, 6)
    ),
    hr(),
    tabsetPanel(
      type = "tabs",
      tabPanel(
        "Growth anomalies",
        fluidRow(
          column(
            4,
            wellPanel(
              class = "dropdown",
              dropMenu(
                dropdownButton(
                  "Info2",
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
                  scenarios_page_info_txt
                )
              ),
              span(
                h5(
                  strong(
                    "Targets:"
                  )
                ),
              ),
              sliderInput(
                "wq_slider_ga",
                label = span(
                  h5(
                    strong(
                      "Water quality"
                    )
                  ),
                  tags$i(
                    h6(
                      htmlOutput(
                        "chlA_value_ga"
                      )
                    )
                  ),
                  tags$i(
                    h6(
                      htmlOutput(
                        "kd_value_ga"
                      )
                    )
                  ),
                  style = "color:#00688B",
                  div(
                    style = 'width:250px;',
                    div(
                      h6(
                        style ='float:left;', 
                        'Worse'
                      )
                    ),
                    div(
                      h6(
                        style = 'float:right;', 
                        'Better'
                      )
                    )
                  )
                ),
                min = -100,
                max = 100,
                step = 20,
                post = " %",
                value = 0,
                width = "250px"
              ),
              bsTooltip(
                "wq_slider_ga",
                wq_hover_txt,
                placement = "bottom",
                trigger = "hover",
                options = NULL
              ),
              sliderInput(
                "fish_slider_ga",
                label = span(
                  h5(
                    strong(
                      "Herbivorous fish"
                    )
                  ),
                  tags$i(
                    h6(
                      htmlOutput(
                        "fish_value_ga"
                      )
                    )
                  ),
                  style = "color:#8B0000",
                  div(
                    style = 'width:250px;',
                    div(
                      h6(
                        style = 'float:left;', 
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
                min = -100,
                max = 100,
                step = 20,
                post = " %",
                value = 0,
                width = "250px"
              ),
              bsTooltip(
                "fish_slider_ga",
                fish_hover_txt,
                placement = "bottom",
                trigger = "hover",
                options = NULL
              ),
              sliderInput(
                "coral_slider_ga",
                label = span(
                  h5(
                    strong(
                      "Coral"
                    )
                  ),
                  tags$i(
                    h6(
                      textOutput(
                        "corsize_value_ga"
                      )
                    )
                  ),
                  tags$i(
                    h6(
                      textOutput(
                        "corcov_value_ga"
                      )
                    )
                  ),
                  style = "color:#000000",
                  div(
                    style = 'width:250px;',
                    div(
                      h6(
                        style = 'float:left;', 
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
                min = -100, 
                max = 100, 
                step = 20, 
                post = " %", 
                value = 0, 
                width = "250px"
              ),
              bsTooltip(
                "coral_slider_ga", 
                coral_hover_txt, 
                placement = "bottom", 
                trigger = "hover", 
                options = NULL
              ),
              style = "background: white"
            )
          ),
          column(
            8, 
            wellPanel(
              plotlyOutput(
                "barplot_ga"
              ),
              style = "background: white",
              # tableOutput(
              #   "table_ga"
              # )
            )
          )
        )
      ),
      tabPanel(
        "White syndromes",
        column(
          4, 
          wellPanel(
            span(
              h5(
                strong(
                  "Targets:"
                )
              ),
            ),
            sliderInput(
              "wq_slider_ws",
              label = span(
                h5(
                  strong(
                    "Water quality"
                  )
                ),
                tags$i(
                  h6(
                    htmlOutput(
                      "chlA_value_ws"
                    )
                  )
                ),
                tags$i(
                  h6(
                    htmlOutput(
                      "kd_value_ws"
                    )
                  )
                ),
                style = "color:#00688B",
                div(style = 'width:250px;',
                    div(
                      h6(
                        style = 'float:left;', 
                        'Worse'
                      )
                    ),
                    div(
                      h6(
                        style = 'float:right;', 
                        'Better'
                      )
                    )
                )
              ),
              min = -100, 
              max = 100, 
              step = 20, 
              post = " %", 
              value = 0, 
              width = "250px"
            ),
            bsTooltip(
              "wq_slider_ga", 
              wq_hover_txt, 
              placement = "bottom", 
              trigger = "hover", 
              options = NULL
            ),
            sliderInput(
              "fish_slider_ws",
              label = span(
                h5(
                  strong(
                    "Herbivorous fish"
                  )
                ),
                tags$i(
                  h6(
                    htmlOutput(
                      "fish_value_ws"
                    )
                  )
                ),
                style = "color:#8B0000",
                div(
                  style = 'width:250px;',
                  div(
                    h6(
                      style = 'float:left;', 
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
              min = -100, 
              max = 100, 
              step = 20, 
              post = " %", 
              value = 0, 
              width = "250px"
            ),
            bsTooltip(
              "fish_slider_ga", 
              fish_hover_txt, 
              placement = "bottom", 
              trigger = "hover", 
              options = NULL
            ),
            sliderInput(
              "coral_slider_ws",
              label = span(
                h5(
                  strong(
                    "Coral"
                  )
                ),
                tags$i(
                  h6(
                    textOutput(
                      "corsize_value_ws"
                    )
                  )
                ),
                tags$i(
                  h6(
                    textOutput(
                      "corcov_value_ws"
                    )
                  )
                ),
                style = "color:#000000",
                div(
                  style = 'width:250px;',
                  div(
                    h6(
                      style = 'float:left;', 
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
              min = -100, 
              max = 100, 
              step = 20, 
              post = " %", 
              value = 0, 
              width = "250px"
            ),
            bsTooltip(
              "coral_slider_ga", 
              coral_hover_txt, 
              placement = "bottom", 
              trigger = "hover", 
              options = NULL
            ),
            style = "background: white"
          )
        ),
        column(
          8, 
          wellPanel(
            plotlyOutput(
              "barplot_ws"
            ),
            style = "background: white"
          )
        )
      )
    )
  ),
  # Historical data page
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
        width="100%", 
        height="100%"
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
  # About the project page
  tabPanel(
    "About",
    h3("Coral disease information:"),
    imageOutput("cdz_images"),
    disease_info_text,
    photo_credit,
    br(),
    h3("Funding:"),
    uiOutput("funding_statement"),
    br(),
    h3("Publications:"),
    uiOutput("cite1"),
    br(),
    uiOutput("cite2"),
    br(),
    uiOutput("cite3"),
    br(),
    uiOutput("cite4")
  )
)
