
# function to plot line graph of near-term forecasts -------------------------------
# will need to update to properly show abundance or prevalence
hline <- function(y, color) {
  list(
    type = "line", 
    x0 = 0, 
    x1 = 1, 
    xref = "paper",
    y0 = y, 
    y1 = y, 
    line = list(
      color = color, 
      dash = "dot"
      )
  )
}

diseaseRisk_plotly <- function(df, titleName){
  df <- data.frame(df)
  yMax <- max(df$Upr) + 2
  if(unique(df$Region) == 'gbr'){
    newTitle <- "Disease risk\n(#/75m<sup>2</sup>)"
    if(titleName == "Growth anomalies"){
      watchThreshold = 5
      warningThreshold = 15
      alert1Threshold = 25
      alert2Threshold = 50
    } else {
      watchThreshold = 1
      warningThreshold = 5
      alert1Threshold = 10
      alert2Threshold = 20
    }
  } else {
    newTitle <- "Disease risk\n(%)"
    if(titleName == "Growth anomalies"){
      watchThreshold = 5
      warningThreshold = 10
      alert1Threshold = 15
      alert2Threshold = 25
    } else {
      watchThreshold = 1
      warningThreshold = 5
      alert1Threshold = 10
      alert2Threshold = 15
    }
  }
  plot_ly() %>%
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
           margin = plotly_margins,
           shapes = list(
             hline(
               y = watchThreshold, 
               color = "#FFEF00"
               ),
             hline(
               y = warningThreshold, 
               color = "#FFB300"
             ),
             hline(
               y = alert1Threshold, 
               color = "#EB1F08"
             ),
             hline(
               y = alert2Threshold,
               color = "#8D1002"
             )
             
             )
           , annotations = list(
             x = c(df$Date[7], df$Date[16])
             , y = c(yMax, yMax)
             , text = c("Nowcasts", "Forecasts")
             , showarrow = c(FALSE, FALSE)
             , xanchor = c("right", 'right')
             )
           ) 
  }

# empty plot to display line graph before any pixel is selected -------------------
diseaseRisk_placeholder_plot <- function(titleName, dateRange) {
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
           margin = plotly_margins)
}

# Scenarios plots ------------------------------

scenarios_barplot_fun <- function(df, baselineValue, riskType){
  # format data
  df <- df[, c('Response', 'disease_risk_change')]
  df[nrow(df)+1, ] <- NA
  df$Response[nrow(df)] <- 'Combined'
  df$disease_risk_change[nrow(df)] <- sum(df$disease_risk_change, na.rm = T)
  baseplot <- plot_ly(
    data = df,
    x = ~Response,
    y = ~disease_risk_change,
    type = "bar",
    color = I('#003152'),
    text = ~paste(Response, ', ', disease_risk_change),
    hoverinfo = 'text'
  ) %>%
    layout(
      xaxis = list(
        showgrid = F,
        title = "",
        categoryorder = "array",
        categoryarray = ~df$Response
      ), 
      yaxis = list(
        showline = T,
        showgrid = F,
        range = c(-100, 200),
        title = "Change in disease risk<br>(from current conditions)"
      ),
      font = list(size = 12),
      showlegend = FALSE
      ) %>%
    add_text(
      text = ~disease_risk_change
      , hoverinfo = 'none'
      , textposition = 'top'
      , showlegend = FALSE
      , textfont = list(size = 15, color = "grey")
      )
  
  if(riskType == 'percent'){
    adjusted_disease_risk <- round(baselineValue + df$disease_risk_change[df$Response == "Combined"])
    adjusted_disease_risk[adjusted_disease_risk < 0] <- 0
    adjusted_disease_risk[adjusted_disease_risk > 100] <- 100
    
    scenario_plot <- baseplot %>% 
      layout(
        title = paste0("<br>Baseline disease risk = ",
                     round(baselineValue),
                     "%<br>Combined adjusted disease risk = ",
                     adjusted_disease_risk,
                     "%")
      )
  } else if(riskType == 'abundance'){
    adjusted_disease_risk <- round(baselineValue + df$disease_risk_change[df$Response == "Combined"])
    adjusted_disease_risk[adjusted_disease_risk < 0] <- 0

    scenario_plot <- baseplot %>% 
      layout(
        title = paste0("<br>Baseline disease risk = ",
                     round(baselineValue),
                     " colonies/75m<sup>2</sup><br>Combined adjusted disease risk = ",
                     adjusted_disease_risk,
                     " colonies/75m<sup>2<sup>")
      )
  }
  scenario_plot  
}  



