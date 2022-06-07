# create plots for Fore-C shiny app -----------------------------------------------

# standard margins ----------------------------------------------------------------
plotly_margins <- list(
  l = 50,
  r = 20,
  b = 20,
  t = 60
)

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
              hoverinfo = "text") %>%
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
                     " colonies/75m<sup>2</sup><br>Combined adjusted disease risk = ",
                     adjusted_disease_risk,
                     " colonies/75m<sup>2<sup>")
      )
  }
  scenario_plot  
}  

# gauge plot -------------------------------------------------------------------
# figure out which date to use
nowcast_date_indexes <- which(ga_forecast$Date == max(ga_forecast$Date[ga_forecast$type == "nowcast"]))
current_nowcast_date <- ga_forecast[nowcast_date_indexes[1], "Date"][[1]]

# summary disease data to show the max value for each ID within
# the forecast period
# perhaps use the most recent nowcast instead
gax <- ga_forecast %>%
  filter(Date == current_nowcast_date) %>%
  group_by(ID, Region) %>%
  summarize("Growth anomalies" = max(drisk)) 

wsx <- ws_forecast %>%
  filter(Date == current_nowcast_date) %>%
  group_by(ID, Region) %>%
  summarize("White syndromes" = max(drisk))

# combine
dzx <- gax %>% 
  left_join(wsx) %>%
  gather(key = "Disease", 
         "drisk", 
         "Growth anomalies":"White syndromes") %>%
  filter(!is.na(drisk))

# update region
dzx$Region[dzx$Region == "wake" | dzx$Region == "johnston"] <- "prias"

# calculate total number of pixels per region
ntotals <- dzx %>%
  filter(Disease == "Growth anomalies") %>% # doesn't matter which disease we use here, they use the same grid 
  group_by(Region) %>%
  summarize("ntotal" = length(Region))

# summarize by stress level
# this may need adjustment when including all regions
# because GBR is 0-Inf and everywhere else is 0-1
gauge_data <- dzx %>%
  left_join(ntotals) %>%
  group_by(Disease, Region) %>%
  summarize(No_stress = sum(drisk == 0)/unique(ntotal),
            Watch = sum(drisk == 1)/unique(ntotal),
            Warning = sum(drisk == 2)/unique(ntotal),
            Alert_Level_1 = sum(drisk == 3)/unique(ntotal),
            Alert_Level_2 = sum(drisk == 4)/unique(ntotal)
  ) %>%
  gather(key = "Alert_Level", "Value", No_stress:Alert_Level_2)


# format colors
gauge_data$colors <- NA
gauge_data$colors[gauge_data$Alert_Level == "No_stress"] <-  "#CCFFFF"
gauge_data$colors[gauge_data$Alert_Level == "Watch"] <-  "#FFEF00"
gauge_data$colors[gauge_data$Alert_Level == "Warning"] <-  "#FFB300"
gauge_data$colors[gauge_data$Alert_Level == "Alert_Level_1"] <-  "#EB1F08"
gauge_data$colors[gauge_data$Alert_Level == "Alert_Level_2"] <-  "#8D1002"

# format alert names and make ordered factor 
gauge_data$name <- gsub("_", " ", gauge_data$Alert_Level)

gauge_data$name <- factor(gauge_data$name, 
                          levels = c("No stress",
                                     "Watch",
                                     "Warning",
                                     "Alert Level 1",
                                     "Alert Level 2"))

# subset and save 
# GBR - GA
gauge_gbr_ga <- subset(gauge_data, Disease == "Growth anomalies" & Region == "gbr")

# GBR - WS
gauge_gbr_ws <- subset(gauge_data, Disease == "White syndromes" & Region == "gbr")

# Hawaii - GA
gauge_hi_ga <- subset(gauge_data, Disease == "Growth anomalies" & Region == "hawaii")

# Hawaii - WS
gauge_hi_ws <- subset(gauge_data, Disease == "White syndromes" & Region == "hawaii")

# PRIAs - GA
gauge_prias_ga <- subset(gauge_data, Disease == "Growth anomalies" & Region == "prias")

# PRIAs - WS
gauge_prias_ws <- subset(gauge_data, Disease == "White syndromes" & Region == "prias")

# Samoas - GA
gauge_samoas_ga <- subset(gauge_data, Disease == "Growth anomalies" & Region == "samoas")

# Samoas - WS
gauge_samoas_ws <- subset(gauge_data, Disease == "White syndromes" & Region == "samoas")

# Guam/CNMI - GA
gauge_cnmi_ga <- subset(gauge_data, Disease == "Growth anomalies" & Region == "guam_cnmi")

# Guam/CNMI - WS
gauge_cnmi_ws <- subset(gauge_data, Disease == "White syndromes" & Region == "guam_cnmi")


# create plots -----------------------------------------------------------------
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
      title = 'Percent of pixels per risk category',
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
      annotations = c(
        aList,
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
  heights = rep(0.1, 10)
  , titleX = TRUE
  # , shareX = TRUE
) %>% 
  config(
    displayModeBar = F
  ) %>%
  layout(
    margin = list(
      t = 0,
      b = 60, 
      l = 0,
      r = 0
    )
  ) 

# remove plots and data not needed for app
rm(gax)
rm(wsx)
rm(dzx)
rm(gauge_data)
rm(gauge_ga_samoas)
rm(gauge_ws_samoas)
rm(gauge_ga_cnmi)
rm(gauge_ws_cnmi)
rm(gauge_ga_gbr)
rm(gauge_ga_hi)
rm(gauge_ws_gbr)
rm(gauge_ga_prias)
rm(gauge_ws_prias)

