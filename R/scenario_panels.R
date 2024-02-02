

scenario_panel_ga_gbr <- function ( ) {

  conditionalPanel(condition = "input.Region == 'Great Barrier Reef, Australia' &
                                input.Disease == 'Growth anomalies'",

                   sliderInput(inputId = "fish_slider_ga_gbr",
                               label   = span(h5(strong("Fish abundance")),
                                              tags$i(h6(htmlOutput(outputId = "fish_value_ga_gbr")))),
                                min    = 400,
                                max    = 800,
                                step   = 50,
                                value  = 600,
                                width  = "275px"), 
                   bsTooltip(id        = "fish_slider_ga_gbr",
                             title     = "Fish count within ~2km.",
                             placement = "right",
                             trigger   = "hover"),

                   sliderInput(inputId = "coral_cover_slider_ga_gbr",
                               label   = span(h5(strong("Coral cover")),
                                              tags$i(h6(htmlOutput(outputId = "corcov_value_ga_gbr")))),
                                min    = 5,
                                max    = 95,
                                step   = 10,
                                post   = "%",
                                value  = 35,
                                width  = "275px"),

                   sliderInput(inputId = "turbidity_slider_ga_gbr",
                               label   = span(h5(strong("Turbidity")),
                                              tags$i(h6(htmlOutput(outputId = "kd_value_ga_gbr"))),
                                              div(style = 'width:250px;',
                                                  div(h6('Less', style = 'float:left;')),
                                                  div(h6('More', style = 'float:right;')))),
                                min    = 0.0,
                                max    = 1.0,
                                step   = 0.1,
                                post   = " m<sup>-1</sup>",
                                value  = 0.5,
                                width  = "275px"),
                   bsTooltip(id        = "turbidity_slider_ga_gbr",
                             title     = app_text$turbidity_hover,
                             placement = "right",
                             trigger   = "hover")
  )

}


scenario_panel_ws_gbr <- function ( ) {

  conditionalPanel(condition = "input.Region == 'Great Barrier Reef, Australia' &
                                input.Disease == 'White syndromes'",

                   sliderInput(inputId = "coral_cover_slider_ws_gbr",
                               label   = span(h5(strong("Coral cover")),
                                              tags$i(h6(htmlOutput(outputId = "corcov_value_ws_gbr")))),
                                min    = 5,
                                max    = 85,
                                step   = 10,
                                post   = "%",
                                value  = 15,
                                width  = "275px"), 
                   bsTooltip(id        = "coral_cover_slider_ws_gbr",
                             title     = "Percent of live coral cover with plating and table morphologies.",
                             placement = "right",
                             trigger   = "hover"),

                   sliderInput(inputId = "fish_slider_ws_gbr",
                               label   = span(h5(strong("Fish abundance")),
                                              tags$i(h6(htmlOutput(outputId = "fish_value_ws_gbr")))),
                                min    = 400,
                                max    = 800,
                                step   = 50,
                                value  = 600,
                                width  = "275px"), 
                   bsTooltip(id        = "fish_slider_ws_gbr",
                             title     = "Fish count within ~2km.",
                             placement = "right",
                             trigger   = "hover"),


                   sliderInput(inputId = "turbidity_slider_ws_gbr",
                               label   = span(h5(strong("Turbidity")),
                                              tags$i(h6(htmlOutput(outputId = "kd_value_ws_gbr"))),
                                              div(style = 'width:250px;',
                                                  div(h6('Less', style = 'float:left;')),
                                                  div(h6('More', style = 'float:right;')))),
                                min    = 0.0,
                                max    = 1.0,
                                step   = 0.1,
                                post   = " m<sup>-1</sup>",
                                value  = 0,
                                width  = "275px"),

                   bsTooltip(id        = "turbidity_slider_ws_gbr",
                             title     = app_text$turbidity_hover,
                             placement = "right",
                             trigger   = "hover")

  )

}





scenario_panel_ga_pacific <- function ( ) {

  conditionalPanel(condition = "input.Region == 'U.S. Pacific' &
                                input.Disease == 'Growth anomalies'",
                   sliderInput(inputId = "coral_size_slider_ga_pac",
                               label   = span(h5(strong("Median coral colony size")),
                                              tags$i(h6(textOutput(outputId = "corsize_value_ga_pac")))),
                               min     = 5,
                               max     = 65,
                               step    = 10,
                               post    = " cm",
                               value   = 15,
                               width   = "275px"), 
                   bsTooltip(id        = "coral_size_slider_ga_pac",
                             title     = "Median colony size of corals in the family Poritidae.",
                             placement = "right",
                             trigger   = "hover"),
                   sliderInput(inputId = "dev_slider_ga_pac",
                               label   = span(h5(strong("Coastal development index")),
                                              tags$i(h6(htmlOutput(outputId = "dev_value_ga_pac"))),
                                              div(style = 'width:275px;',
                                                  div(h6('Undeveloped', style = 'float:left;')),
                                                  div(h6('Highly developed', style = 'float:right;')))),
                                min    = 0.0,
                                max    = 1.0,
                                step   = 0.1,
                                value  = 0.3,
                                width  = "275px"),
                   bsTooltip(id        = "dev_slider_ga_pac",
                             title     = "Proxy of coastal development based on artifical light.",
                             placement = "right",
                             trigger   = "hover"),
                   sliderInput(inputId = "herb_fish_slider_ga_pac",
                               label   = span(h5(strong("Herbivorous fish density (fish/m", tags$sup("2"), ")")),
                                              tags$i(h6(htmlOutput(outputId = "herb_fish_value_ga_pac")))),
                                min    = 0.1,
                                max    = 0.7,
                                step   = 0.1,
                                value  = 0.3,
                                width  = "275px"),
                   sliderInput(inputId = "turbidity_slider_ga_pac",
                               label   = span(h5(strong("Turbidity")),
                                              tags$i(h6(htmlOutput(outputId = "turbidity_value_ga_pac"))),
                                              div(style = 'width:250px;',
                                                  div(h6('Less', style = 'float:left;')),
                                                  div(h6('More', style = 'float:right;')))),
                                min    = 0.0,
                                max    = 0.5,
                                step   = 0.1,
                                post   = " m<sup>-1</sup>",
                                value  = 0.2,
                                width  = "275px"),
                   bsTooltip(id        = "turbidity_slider_ga_pac",
                             title     = app_text$turbidity_hover,
                             placement = "right",
                             trigger   = "hover")

  )

}


scenario_panel_ws_pacific <- function ( ) {

  conditionalPanel(condition = "input.Region == 'U.S. Pacific' &
                                input.Disease == 'White syndromes'",
                   sliderInput(inputId = "coral_size_slider_ws_pac",
                               label   = span(h5(strong("Median coral colony size")),
                                              tags$i(h6(textOutput(outputId = "corsize_value_ws_pac")))),
                               min     = 5,
                               max     = 65,
                               step    = 10,
                               post    = " cm",
                               value   = 10,
                               width   = "275px"), 
                   bsTooltip(id        = "coral_size_slider_ws_pac",
                             title     = "Median colony size of corals in the family Acroporidae.",
                             placement = "right",
                             trigger   = "hover"),
                   sliderInput(inputId = "parrotfish_slider_ws_pac",
                               label   = span(h5(strong("Parrotfish density (fish/m", tags$sup("2"), ")")),
                                              tags$i(h6(htmlOutput(outputId = "parrotfish_value_ws_pac")))),
                                min    = 0.00,
                                max    = 0.06,
                                step   = 0.01,
                                value  = 0.02,
                                width  = "275px"),

                   sliderInput(inputId = "turbidity_slider_ws_pac",
                               label   = span(h5(strong("Turbidity")),
                                              tags$i(h6(htmlOutput(outputId = "kd_value_ws_pac"))),
                                              div(style = 'width:250px;',
                                                  div(h6('Less', style = 'float:left;')),
                                                  div(h6('More', style = 'float:right;')))),
                                min    = 0.0,
                                max    = 2.0,
                                step   = 0.1,
                                post   = " m<sup>-1</sup>",
                                value  = 0.5,
                                width  = "275px"),

                   bsTooltip(id        = "turbidity_slider_ws_pac",
                             title     = app_text$turbidity_hover,
                             placement = "right",
                             trigger   = "hover"),

                   sliderInput(inputId = "herb_fish_slider_ws_pac",
                               label   = span(h5(strong("Herbivorous fish density (fish/m", tags$sup("2"), ")")),
                                              tags$i(h6(htmlOutput(outputId = "herb_fish_value_ws_pac")))),
                                min    = 0.0,
                                max    = 0.6,
                                step   = 0.1,
                                value  = 0.4,
                                width  = "275px"),

                   sliderInput(inputId = "coral_cover_slider_ws_pac",
                               label   = span(h5(strong(em("Acroporidae"), "coral cover")),
                                              tags$i(h6(htmlOutput(outputId = "corcov_value_ws_pac")))),
                                min    = 5,
                                max    = 65,
                                step   = 10,
                                post   = "%",
                                value  = 15,
                                width  = "275px")

  )

}


