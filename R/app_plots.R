individual_gauges <- function (df) {
  plot_ly(df,
          x = ~Value,
          y = ~Disease,
          type = 'bar',
          # text = ~N,
          color = ~name,
          marker = list(color = ~colors,
                        line = list(color = I("black"),
                                    width = 1.5)),
          hovertemplate = '%{x:.2p} of reef pixels <extra></extra>'
  ) %>%
    layout(yaxis = list(title = '',
                        showticklabels = FALSE,
                        tickformat = ""),
           xaxis = list(title = '',
                        showticklabels = FALSE,
                        tickformat = "",
                        showgrid = FALSE,
                        zeroline = FALSE),
           barmode = 'stack',
           showlegend = FALSE,
           margin = list(
             l = 0,
             r = 0,
             b = 0,
             t = 0
           )
    )
}

gauge_plots <- function (main_dir = ".") {

  aList <- list(xanchor   = 'left',
                x         = 0,
                y         = 0.9,
                font      = list(size = 11,
                                 family = "Arial"),
                showarrow = FALSE)


  gauge_ga_samoas <- gauge_data %>%
                       subset(Disease == "Growth anomalies" & Region == "samoas") %>%
                       individual_gauges( ) %>%
                       layout(annotations = c(aList, 
                                              text = "American Samoa - growth anomalies"))

  gauge_ws_samoas <- gauge_data %>%
                       subset(Disease == "White syndromes" & Region == "samoas") %>%
                       individual_gauges( ) %>%
                       layout(annotations = c(aList, 
                                              text = "American Samoa - white syndromes"))

  gauge_ws_cnmi <- gauge_data %>%
                       subset(Disease == "White syndromes" & Region == "guam_cnmi") %>%
                       individual_gauges( ) %>%
                       layout(annotations = c(aList, 
                                              text = "Guam/CNMI - white syndromes"))

  gauge_ga_cnmi <- gauge_data %>%
                       subset(Disease == "Growth anomalies" & Region == "guam_cnmi") %>%
                       individual_gauges( ) %>%
                       layout(annotations = c(aList, 
                                              text = "Guam/CNMI - growth anomalies"))

  gauge_ga_gbr <- gauge_data %>%
                       subset(Disease == "Growth anomalies" & Region == "gbr") %>%
                       individual_gauges( ) %>%
                       layout(annotations = c(aList, 
                                              text = "Great Barrier Reef - growth anomalies"))

  gauge_ws_gbr <- gauge_data %>%
                       subset(Disease == "White syndromes" & Region == "gbr") %>%
                       individual_gauges( ) %>%
                       layout(annotations = c(aList, 
                                              text = "Great Barrier Reef - white syndromes"))

  gauge_ga_hi <- gauge_data %>%
                       subset(Disease == "Growth anomalies" & Region == "hawaii") %>%
                       individual_gauges( ) %>%
                       layout(annotations = c(aList, 
                                              text = "Hawaii - growth anomalies"))

  gauge_ws_hi <- gauge_data %>%
                       subset(Disease == "White syndromes" & Region == "hawaii") %>%
                       individual_gauges( ) %>%
                       layout(annotations = c(aList, 
                                              text = "Hawaii - white syndromes"))

  gauge_ga_prias <- gauge_data %>%
                       subset(Disease == "Growth anomalies" & Region == "prias") %>%
                       individual_gauges( ) %>%
                       layout(annotations = c(aList, 
                                              text = "PRIAs - growth anomalies"))

  gauge_ws_prias <- gauge_data %>%
                       subset(Disease == "White syndromes" & Region == "prias") %>%
                       individual_gauges( ) %>%
                       layout(annotations = c(aList, 
                                              text = "PRIAs - white syndromes")) %>%
                       layout(xaxis = list(title = 'Percent of pixels per risk category',
                                           showticklabels = TRUE,
                                           tickformat = ".0%",
                                           showgrid = FALSE,
                                           zeroline = FALSE,
                                           font = list(size = 11,
                                                       family = "Arial")))


  subplot(gauge_ga_samoas, 
          gauge_ws_samoas,
          gauge_ws_cnmi,
          gauge_ga_cnmi, 
          gauge_ga_gbr, 
          gauge_ws_gbr,
          gauge_ga_hi, 
          gauge_ws_hi, 
          gauge_ga_prias,
          gauge_ws_prias,
          nrows = 10,
          margin = 0.01,
          heights = rep(0.1, 10), 
          titleX = TRUE) %>% 
    config(displayModeBar = FALSE) %>%
    layout(margin = list(t = 0,
                         b = 60, 
                         l = 0,
                         r = 0)) 


}