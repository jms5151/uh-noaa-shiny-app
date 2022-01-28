ui <- navbarPage(
  theme = shinytheme(
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
  # Management scenarios page --------------------
  # this is how to do conditional sliders based on region and disease:
  # https://stackoverflow.com/questions/68250593/how-to-show-slider-inputs-based-on-selected-radio-buttons-in-shiny-r
  tabPanel(
    "Investigating scenarios new",
    fluidRow(
      style = "border-top: 2px double #00172D;",
      column(
        width = 4,
        style = "border-right: 2px double #00172D;
        padding-top: 15px;
        padding-left: 20px;",
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
            max = 55,
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
            max = 45,
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
            step = 0.2,
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
            max = 0.9,
            step = 0.3,
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
            max = 55,
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
            step = 0.5,
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
            step = 0.02,
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
            step = 0.2,
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
            step = 100,
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
            step = 0.5,
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
          step = 15,
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
            max = 65,
            step = 15,
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
            step = 100,
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
            step = 0.5,
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
        width = 8,
        style = "padding: 15px;",
        leafletOutput(
          "management_map", 
          height = "300px"
        ) %>% 
          withSpinner(
            color = spinColor
            ),
        plotlyOutput(
          "scenarios_barplot",
          height = "300px"
          ) %>% 
          withSpinner(
            color = spinColor
            )
        )
      )
    ),
  
  # old scenarios ---------------------------  
  # tabPanel(
  #   "Investigating scenarios original", #HTML("Long-term mitigation<br/>potential"),
  #   leafletOutput(
  #     "management_map", 
  #     height = "300px"
  #   ) %>% 
  #     withSpinner(
  #       color = spinColor
  #     ),
  #   # set all slider colors at once, colors = deepskyblue4, dark red, black repeated\
  #   setSliderColor(
  #     c("#00688B", "#8B0000", "#000000", "#00688B", "#8B0000", "#000000"),
  #     c(1, 2, 3, 4, 5, 6)
  #   ),
  #   hr(),
  #   tabsetPanel(
  #     type = "tabs",
  #     tabPanel(
  #       "Growth anomalies",
  #       fluidRow(
  #         column(
  #           4,
  #           wellPanel(
  #             class = "dropdown",
  #             dropMenu(
  #               dropdownButton(
  #                 "Info2",
  #                 icon = icon(
  #                   'info'
  #                 ),
  #                 size = "xs"
  #               ),
  #               h3(
  #                 strong(
  #                   'Information'
  #                 )
  #               ),
  #               h5(
  #                 scenarios_page_info_txt
  #               )
  #             ),
  #             span(
  #               h5(
  #                 strong(
  #                   "Targets:"
  #                 )
  #               ),
  #             ),
  #             sliderInput(
  #               "wq_slider_ga",
  #               label = span(
  #                 h5(
  #                   strong(
  #                     "Water quality"
  #                   )
  #                 ),
  #                 tags$i(
  #                   h6(
  #                     htmlOutput(
  #                       "chlA_value_ga"
  #                     )
  #                   )
  #                 ),
  #                 tags$i(
  #                   h6(
  #                     htmlOutput(
  #                       "kd_value_ga"
  #                     )
  #                   )
  #                 ),
  #                 style = "color:#00688B",
  #                 div(
  #                   style = 'width:250px;',
  #                   div(
  #                     h6(
  #                       style ='float:left;', 
  #                       'Worse'
  #                     )
  #                   ),
  #                   div(
  #                     h6(
  #                       style = 'float:right;', 
  #                       'Better'
  #                     )
  #                   )
  #                 )
  #               ),
  #               min = -100,
  #               max = 100,
  #               step = 20,
  #               post = " %",
  #               value = 0,
  #               width = "250px"
  #             ),
  #             bsTooltip(
  #               "wq_slider_ga",
  #               wq_hover_txt,
  #               placement = "bottom",
  #               trigger = "hover",
  #               options = NULL
  #             ),
  #             sliderInput(
  #               "fish_slider_ga",
  #               label = span(
  #                 h5(
  #                   strong(
  #                     "Herbivorous fish"
  #                   )
  #                 ),
  #                 tags$i(
  #                   h6(
  #                     htmlOutput(
  #                       "fish_value_ga"
  #                     )
  #                   )
  #                 ),
  #                 style = "color:#8B0000",
  #                 div(
  #                   style = 'width:250px;',
  #                   div(
  #                     h6(
  #                       style = 'float:left;', 
  #                       'Less'
  #                     )
  #                   ),
  #                   div(
  #                     h6(
  #                       style = 'float:right;', 
  #                       'More'
  #                     )
  #                   )
  #                 )
  #               ),
  #               min = -100,
  #               max = 100,
  #               step = 20,
  #               post = " %",
  #               value = 0,
  #               width = "250px"
  #             ),
  #             bsTooltip(
  #               "fish_slider_ga",
  #               fish_hover_txt,
  #               placement = "bottom",
  #               trigger = "hover",
  #               options = NULL
  #             ),
  #             sliderInput(
  #               "coral_slider_ga",
  #               label = span(
  #                 h5(
  #                   strong(
  #                     "Coral"
  #                   )
  #                 ),
  #                 tags$i(
  #                   h6(
  #                     textOutput(
  #                       "corsize_value_ga"
  #                     )
  #                   )
  #                 ),
  #                 tags$i(
  #                   h6(
  #                     textOutput(
  #                       "corcov_value_ga"
  #                     )
  #                   )
  #                 ),
  #                 style = "color:#000000",
  #                 div(
  #                   style = 'width:250px;',
  #                   div(
  #                     h6(
  #                       style = 'float:left;', 
  #                       'Less'
  #                     )
  #                   ),
  #                   div(
  #                     h6(
  #                       style = 'float:right;', 
  #                       'More'
  #                     )
  #                   )
  #                 )
  #               ),
  #               min = -100, 
  #               max = 100, 
  #               step = 20, 
  #               post = " %", 
  #               value = 0, 
  #               width = "250px"
  #             ),
  #             bsTooltip(
  #               "coral_slider_ga", 
  #               coral_hover_txt, 
  #               placement = "bottom", 
  #               trigger = "hover", 
  #               options = NULL
  #             ),
  #             style = "background: white"
  #           )
  #         ),
  #         column(
  #           8, 
  #           wellPanel(
  #             plotlyOutput(
  #               "barplot_ga"
  #             ),
  #             style = "background: white",
  #             # tableOutput(
  #             #   "table_ga"
  #             # )
  #           )
  #         )
  #       )
  #     ),
  #     tabPanel(
  #       "White syndromes",
  #       column(
  #         4, 
  #         wellPanel(
  #           span(
  #             h5(
  #               strong(
  #                 "Targets:"
  #               )
  #             ),
  #           ),
  #           sliderInput(
  #             "wq_slider_ws",
  #             label = span(
  #               h5(
  #                 strong(
  #                   "Water quality"
  #                 )
  #               ),
  #               tags$i(
  #                 h6(
  #                   htmlOutput(
  #                     "chlA_value_ws"
  #                   )
  #                 )
  #               ),
  #               tags$i(
  #                 h6(
  #                   htmlOutput(
  #                     "kd_value_ws"
  #                   )
  #                 )
  #               ),
  #               style = "color:#00688B",
  #               div(style = 'width:250px;',
  #                   div(
  #                     h6(
  #                       style = 'float:left;', 
  #                       'Worse'
  #                     )
  #                   ),
  #                   div(
  #                     h6(
  #                       style = 'float:right;', 
  #                       'Better'
  #                     )
  #                   )
  #               )
  #             ),
  #             min = -100, 
  #             max = 100, 
  #             step = 20, 
  #             post = " %", 
  #             value = 0, 
  #             width = "250px"
  #           ),
  #           bsTooltip(
  #             "wq_slider_ga", 
  #             wq_hover_txt, 
  #             placement = "bottom", 
  #             trigger = "hover", 
  #             options = NULL
  #           ),
  #           sliderInput(
  #             "fish_slider_ws",
  #             label = span(
  #               h5(
  #                 strong(
  #                   "Herbivorous fish"
  #                 )
  #               ),
  #               tags$i(
  #                 h6(
  #                   htmlOutput(
  #                     "fish_value_ws"
  #                   )
  #                 )
  #               ),
  #               style = "color:#8B0000",
  #               div(
  #                 style = 'width:250px;',
  #                 div(
  #                   h6(
  #                     style = 'float:left;', 
  #                     'Less'
  #                   )
  #                 ),
  #                 div(
  #                   h6(
  #                     style = 'float:right;', 
  #                     'More'
  #                   )
  #                 )
  #               )
  #             ),
  #             min = -100, 
  #             max = 100, 
  #             step = 20, 
  #             post = " %", 
  #             value = 0, 
  #             width = "250px"
  #           ),
  #           bsTooltip(
  #             "fish_slider_ga", 
  #             fish_hover_txt, 
  #             placement = "bottom", 
  #             trigger = "hover", 
  #             options = NULL
  #           ),
  #           sliderInput(
  #             "coral_slider_ws",
  #             label = span(
  #               h5(
  #                 strong(
  #                   "Coral"
  #                 )
  #               ),
  #               tags$i(
  #                 h6(
  #                   textOutput(
  #                     "corsize_value_ws"
  #                   )
  #                 )
  #               ),
  #               tags$i(
  #                 h6(
  #                   textOutput(
  #                     "corcov_value_ws"
  #                   )
  #                 )
  #               ),
  #               style = "color:#000000",
  #               div(
  #                 style = 'width:250px;',
  #                 div(
  #                   h6(
  #                     style = 'float:left;', 
  #                     'Less'
  #                   )
  #                 ),
  #                 div(
  #                   h6(
  #                     style = 'float:right;', 
  #                     'More'
  #                   )
  #                 )
  #               )
  #             ),
  #             min = -100, 
  #             max = 100, 
  #             step = 20, 
  #             post = " %", 
  #             value = 0, 
  #             width = "250px"
  #           ),
  #           bsTooltip(
  #             "coral_slider_ga", 
  #             coral_hover_txt, 
  #             placement = "bottom", 
  #             trigger = "hover", 
  #             options = NULL
  #           ),
  #           style = "background: white"
  #         )
  #       ),
  #       column(
  #         8, 
  #         wellPanel(
  #           plotlyOutput(
  #             "barplot_ws"
  #           ),
  #           style = "background: white"
  #         )
  #       )
  #     )
  #   )
  # ),
  
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
      ),
    disease_info_text,
    photo_credit,
    br(),
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
