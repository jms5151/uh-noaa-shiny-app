# create plots for Fore-C shiny app -----------------------------------------------

# libraries required :
# if (!require("plotly")) install.packages("plotly"); library(plotly)

# function to show and hide confidence intervals ----------------------------------
button_info = list(
  list(
    active = -1, # not dropdown menu
    x = 0.2, # x location, if excluded, plots outside graph
    y = 1.0, # y location
    type = 'buttons',
    buttons = list(
      list(method = "restyle",
           args = list("visible", rep(list(TRUE), 29*2)), # first 29 = lines, second 29 = ribbons
           label = "Show CI"
           ),
      list(method = "restyle",
           args = list("visible", c(rep(list(TRUE), 29), rep(list(FALSE), 29))),
           label = "Hide CI"
           )
      )
    )
  )

# standard margins ----------------------------------------------------------------
plotly_margins <- list(
  l = 50,
  r = 20,
  b = 20,
  t = 60
)

# function to plot line graph of near-term foreensembles -------------------------------
# will need to update to properly show abundance or prevalence
diseaseRisk_plotly <- function(df, titleName){
  if(unique(df$Region) == 'gbr'){
    newTitle <- "Disease risk\n(#/50m)"
  } else {
    newTitle <- "Disease risk\n(%)"
  }
  plot_ly() %>%
    add_trace(data = df, 
              x = ~Date, 
              y = ~value,
              y = ~round(value),
              split = ~ensemble, 
              type = 'scatter', 
              mode = 'lines',
              color = ~type,
              colors = c("darkolivegreen", "darkslategray"),
              text = ~paste("Date:", Date,
                            "<br>Disease risk:",
                            "<br>90th percentile", round(Upr), #"%", # IQR90
                            "<br>75th percentile", round(value), #"%", #IQR75
                            "<br>50th percentile", round(Lwr)#, "%" #IQR50
              ),
              hoverinfo = "text") %>%
    add_ribbons(data = df, 
                x= ~Date, 
                split = ~ensemble, 
                ymin = ~round(Lwr), 
                ymax = ~round(Upr),
                color = ~type,
                colors = c("Salmon", "Midnight blue"),
                opacity = 0.3,
                hoverinfo='skip') %>%
    layout(title = titleName,
           xaxis = list(showgrid = F, 
                        title = ""), 
           yaxis = list(showline = T, 
                        showgrid = F, 
                        range = c(0, 40),
                        title = newTitle),
           font = list(size = 11),
           showlegend = FALSE,
           # updatemenus = button_info, 
           margin = plotly_margins)      
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
                        range = c(0, 40),
                        title = "Disease risk"),
           font = list(size = 14),
           showlegend = FALSE,
           margin = plotly_margins)
}
# diseaseRisk_plotly <- function(df, titleName){
#   plot_ly() %>%
#     add_trace(data = df, 
#               x = ~Date, 
#               y = ~value,
#               y = ~round(value*100),
#               split = ~ensemble, 
#               type = 'scatter', 
#               mode = 'lines',
#               color = ~type,
#               colors = c("Salmon", "Midnight blue"),
#               text = ~paste("Date:", Date,
#                             "<br>Disease risk:",
#                             "<br>90th percentile", round(Upr*100), "%", # IQR90
#                             "<br>75th percentile", round(value*100), "%", #IQR75
#                             "<br>50th percentile", round(Lwr*100), "%" #IQR50
#                             ),
#               hoverinfo = "text") %>%
#     add_ribbons(data = df, 
#                 x= ~Date, 
#                 split = ~ensemble, 
#                 ymin = ~round(Lwr*100), 
#                 ymax = ~round(Upr*100),
#                 color = ~type,
#                 colors = c("Salmon", "Midnight blue"),
#                 opacity = 0.3,
#                 hoverinfo='skip') %>%
#     layout(title = titleName,
#            xaxis = list(showgrid = F, 
#                         title = ""), 
#            yaxis = list(showline = T, 
#                         showgrid = F, 
#                         range = c(0, 100),
#                         title = "Disease risk"),
#            font = list(size = 14),
#            showlegend = FALSE,
#            updatemenus = button_info, 
#            margin = plotly_margins)      
# }
# 
# # empty plot to display line graph before any pixel is selected -------------------
# diseaseRisk_placeholder_plot <- function(titleName, dateRange) {
#   plot_ly() %>%
#     add_trace(x = ~range(dateRange), 
#               y = 0, 
#               type = 'scatter', 
#               mode = 'lines') %>%
#     layout(title = titleName,
#            xaxis = list(showgrid = F, 
#                         title = ""), 
#            yaxis = list(showline = T, 
#                         showgrid = F, 
#                         range = c(0, 100),
#                         title = "Disease risk"),
#            font = list(size = 14),
#            showlegend = FALSE,
#            margin = plotly_margins)
# }

# gauge plots -----------------------------------------------------------------
individual_gauges <- function(df){
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
                        showgrid = F,
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

gauge_ga_samoas <- individual_gauges(gauge_samoas_ga)
gauge_ws_samoas <- individual_gauges(gauge_samoas_ws)

gauge_ga_cnmi <- individual_gauges(gauge_cnmi_ga)
gauge_ws_cnmi <- individual_gauges(gauge_cnmi_ws) 

gauge_ga_gbr <- individual_gauges(gauge_gbr_ga)
gauge_ws_gbr <- individual_gauges(gauge_gbr_ws)

gauge_ga_hi <- individual_gauges(gauge_hi_ga)
gauge_ws_hi <- individual_gauges(gauge_hi_ws)

gauge_ga_prias <- individual_gauges(gauge_prias_ga)
gauge_ws_prias <- individual_gauges(gauge_prias_ws) %>%
  layout(
    xaxis = list(
      title = 'Precent of pixels per risk category',
      showticklabels = TRUE,
      tickformat = ".0%",
      showgrid = FALSE,
      zeroline = FALSE,
      font = list(
        size = 11,
        family = "Arial"
      )
    )
  )

xlab_placement = 0
ylab_placement = 0.9
fontSize = 11

aList <- list(  
  xanchor = 'left',
  x = xlab_placement,
  y = ylab_placement,
  font = list(size = fontSize,
              family = "Arial"
  ),
  showarrow = F
)

gaugePlots <- subplot(
  gauge_ga_samoas %>%
    layout(
      annotations = c(
        aList, 
        text = "American Samoa - growth anomalies"
      )
    ),
  gauge_ws_samoas %>%
    layout(
      annotations = c(
        aList,
        text = "American Samoa - white syndromes"
      )
    ),
  gauge_ws_cnmi %>%
    layout(
      annotations = c(aList,
                      text = "Guam/CNMI - white syndromes"
      )
    ),
  gauge_ga_cnmi %>%
    layout(
      annotations = c(
        aList,
        text = "Guam/CNMI - growth anomalies"
      )
    ),
  gauge_ga_gbr %>%
    layout(
      annotations = c(
        aList,
        text = "Great Barrier Reef - growth anomalies"
      )
    ),
  gauge_ws_gbr %>%
    layout(
      annotations = c(
        aList,
        text = "Great Barrier Reef - white syndromes"
      )
    ),
  gauge_ga_hi %>%
    layout(
      annotations = c(
        aList,
        text = "Hawaii - growth anomalies"
      )
    ),
  gauge_ws_hi %>%
    layout(
      annotations = c(
        aList,
        text = "Hawaii - white syndromes"
      )
    ),
  gauge_ga_prias %>%
    layout(
      annotations = c(
        aList,
        text = "PRIAs - growth anomalies"
      )
    ),
  gauge_ws_prias %>%
    layout(
      annotations = c(
        aList, 
        text = "PRIAs - white syndromes"
      )
    ),
  nrows = 10,
  margin = 0.01,
  heights = rep(0.1, 10),
  shareX = TRUE
) %>% 
  config(
    displayModeBar = F
  )

# function to bound numbers between 0 and 100 % -----------------------------------
bound0100 <- function(x){
  if(x < 0){
    x <- 0
  } else if(x > 100){
    x <- 100
  } else {
    x
  }
  x
}

# Scenarios plots ------------------------------

scenarios_barplot_fun <- function(df, baselineValue, riskType){
  # format data
  df <- df[, c('Response', 'disease_risk_change', 'sd')]
  df[nrow(df)+1, ] <- NA
  df$Response[nrow(df)] <- 'Combined'
  df$disease_risk_change[nrow(df)] <- sum(df$disease_risk_change, na.rm = T)
  df$sd[nrow(df)] <- sum(df$sd, na.rm = T)
  # baseplot
  baseplot <- plot_ly(
    data = df,
    x = ~Response,
    y = ~disease_risk_change,
    error_y = list(value = ~sd),
    type = "bar",
    color = I('#003152')
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
        range = c(-100, 100),
        title = "Change in disease risk<br>(from current conditions)"
      ),
      font = list(size = 12),
      showlegend = FALSE)
  
  if(riskType == 'percent'){
    adjusted_disease_risk <- round(baselineValue + df$disease_risk_change[df$Response == "Combined"])
    adjusted_disease_risk[adjusted_disease_risk < 0] <- 0
    adjusted_disease_risk[adjusted_disease_risk > 100] <- 100
    
    scenario_plot <- baseplot %>% layout(    
      title = paste0("<br>Baseline disease risk = ",
                     round(baselineValue),
                     "%<br>Combined adjusted disease risk = ",
                     adjusted_disease_risk,
                     "%")
      )
  } else if(riskType == 'abundance'){
    adjusted_disease_risk <- round(baselineValue + df$disease_risk_change[df$Response == "Combined"])
    adjusted_disease_risk[adjusted_disease_risk < 0] <- 0

    scenario_plot <- baseplot %>% layout(    
      title = paste0("<br>Baseline disease risk = ",
                     round(baselineValue),
                     " colonies/50m<br>Combined adjusted disease risk = ",
                     adjusted_disease_risk,
                     " colonies/50m")
      )
  }
  scenario_plot  
}  

# empty barplot to display before any pixel or conditions is selected -------------
scenarios_placeholder_plot <- plot_ly(
  x = "",
  y = 0, 
  type = "bar"
  ) %>%
  layout(
    xaxis = list(
      showgrid = F,
      title = ""
      ), 
    yaxis = list(
      showline = T,
      showgrid = F,
      range = c(-100, 100),
      title = "Change in disease risk<br>(from current conditions)"
      ),
    font = list(size = 14),
    showlegend = FALSE) 

