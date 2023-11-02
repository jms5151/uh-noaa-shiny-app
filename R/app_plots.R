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

gauge_plots <- function ( ) {
#Sys.sleep(10)
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

plotly_margins <- function ( ) {

  list(l = 50,
       r = 20,
       b = 20,
       t = 60)

}



diseaseRisk_placeholder_plot <- function (titleName, 
                                          dateRange) {

  plot_ly() %>%
    add_trace(x = ~range(dateRange), 
              y = 0, 
              type = 'scatter', 
              mode = 'lines') %>%
    layout(title = titleName,
           xaxis = list(showgrid = F, 
                        title = ""), 
           yaxis = list(showline = T, 
                        showgrid = F, 
                        range = c(0, 12),
                        title = "Disease risk"),
           font = list(size = 14),
           showlegend = FALSE,
           margin = plotly_margins( ))
}





diseaseRisk_plotly <- function (df, 
                                titleName){
  df <- data.frame(df)
  yMax <- max(df$Upr) + 2
  if(unique(df$Region) == 'gbr'){

    newTitle <- "Disease risk\n(#/75m<sup>2</sup>)"

    if(titleName == "Growth anomalies"){

      watchThreshold   <- 5
      warningThreshold <- 15
      alert1Threshold  <- 25
      alert2Threshold  <- 50

    } else {

      watchThreshold   <- 1
      warningThreshold <- 5
      alert1Threshold  <- 10
      alert2Threshold  <- 20

    }
  } else {

    newTitle <- "Disease risk\n(%)"

    if(titleName == "Growth anomalies"){

      watchThreshold   <- 5
      warningThreshold <- 10
      alert1Threshold  <- 15
      alert2Threshold  <- 25

    } else {

      watchThreshold   <- 1
      warningThreshold <- 5
      alert1Threshold  <- 10
      alert2Threshold  <- 15
    }
  }
  plot_ly( ) %>%
    add_trace(data = df,
              x = ~Date,
              y = ~value,
              type = 'scatter',
              mode = 'lines+markers',
              color = ~type,
              colors = c("midnightblue", "midnightblue"),
              text = ~paste("Date:", Date,
                            "<br>Disease risk:",
                            "<br>90th percentile", round(Upr), #"%", # IQR90
                            "<br>75th percentile", round(value), #"%", #IQR75
                            "<br>50th percentile", round(Lwr)#, "%" #IQR50
              ),
              hoverinfo = "text"

              ) %>%

    add_ribbons(data = df, 
                x = ~Date, 
                ymin = ~Lwr, 
                ymax = ~Upr,
                color = ~type,
                opacity = 0.3,
                hoverinfo='skip') %>%
    layout(title = titleName,
           xaxis = list(showgrid = F, 
                        title = ""), 
           yaxis = list(showline = T, 
                        showgrid = F, 
                        range = c(0, yMax),
                        title = newTitle),
           font = list(size = 11),
           showlegend = FALSE,
           # updatemenus = button_info, 
           margin = plotly_margins ( ),
           shapes = list(hline(y     = watchThreshold, 
                               color = "#FFEF00"),
                         hline(y     = warningThreshold, 
                               color = "#FFB300"),
                         hline(y     = alert1Threshold, 
                               color = "#EB1F08"),
                         hline(y = alert2Threshold,
                               color = "#8D1002")),
            annotations = list(x = c(df$Date[7], df$Date[16]), 
                               y = c(yMax, yMax),
                               text = c("Nowcasts", "Forecasts"),
                               showarrow = c(FALSE, FALSE),
                               xanchor = c("right", 'right'))) 
  }

