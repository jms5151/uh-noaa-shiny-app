
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


scenarios_placeholder_barplot <- function( ){

  plot_ly(
    type = "bar"

  ) %>%
    layout(
      xaxis = list(
        showgrid = FALSE,
        title = "", 
        visible = FALSE
      ), 
      yaxis = list(
        showline = TRUE,
        showgrid = FALSE,
        range = c(-100, 100),
        title = "Change in disease risk<br>(from current conditions)"
      ),
      font = list(size = 12),
      showlegend = FALSE
      ) 

 
} 
