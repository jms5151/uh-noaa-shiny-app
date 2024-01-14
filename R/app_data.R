# need to generalize the file locations

load_shape_files <- function (main_dir = ".") {

  shp_files <- data_files(file_ext = "shp", main_dir = main_dir)

  out <- lapply(X     = shp_files, 
                FUN   = st_read,
                quiet = TRUE)

  names(out) <- gsub('.*\\/|\\.shp', '', shp_files)
  out
}

load_historical_data <- function ( ) {

  read_csv_arrow(file = app_file("historical_surveys.csv"))

}

load_ws_pac_scenarios <- function (main_dir = ".") {

  read_csv_arrow(file = data_file("Scenarios", "ws_pac_scenarios.csv", main_dir = main_dir))

}

load_ws_pac_basevals_id <- function (main_dir = ".") {

  read_csv_arrow(file = data_file("Scenarios", "ws_pac_basevals_id.csv", main_dir = main_dir))

}

load_ga_pac_scenarios <- function (main_dir = ".") {

  read_csv_arrow(file = data_file("Scenarios", "ga_pac_scenarios.csv", main_dir = main_dir))

}

load_ga_pac_basevals_id <- function (main_dir = ".") {

  read_csv_arrow(file = data_file("Scenarios", "ga_pac_basevals_id.csv", main_dir = main_dir))

}


load_ga_gbr_scenarios <- function (main_dir = ".") {

  read_csv_arrow(file = data_file("Scenarios", "ga_gbr_scenarios.csv", main_dir = main_dir))

}

load_ga_gbr_basevals_id <- function (main_dir = ".") {

  read_csv_arrow(file = data_file("Scenarios", "ga_gbr_basevals_id.csv", main_dir = main_dir))

}


load_ws_gbr_scenarios <- function (main_dir = ".") {

  read_csv_arrow(file = data_file("Scenarios", "ws_gbr_scenarios.csv", main_dir = main_dir))

}

load_ws_gbr_basevals_id <- function (main_dir = ".") {

  read_csv_arrow(file = data_file("Scenarios", "ws_gbr_basevals_id.csv", main_dir = main_dir))

}

load_ga_pac_basevals_management <- function (main_dir = ".") {

  read_csv_arrow(file = data_file("Scenarios", "ga_pac_basevals_management.csv", main_dir = main_dir))

}

load_ga_pac_scenarios_aggregated_to_management_zones <- function (main_dir = ".") {

  read_csv_arrow(file = data_file("Scenarios", "ga_pac_scenarios_aggregated_to_management_zones.csv", main_dir = main_dir))

}


load_ws_pac_basevals_management <- function (main_dir = ".") {

  read_csv_arrow(file = data_file("Scenarios", "ws_pac_basevals_management.csv", main_dir = main_dir))

}

load_ws_pac_scenarios_aggregated_to_management_zones <- function (main_dir = ".") {

  read_csv_arrow(file = data_file("Scenarios", "ws_pac_scenarios_aggregated_to_management_zones.csv", main_dir = main_dir))

}


load_ga_gbr_basevals_management <- function (main_dir = ".") {

  read_csv_arrow(file = data_file("Scenarios", "ga_gbr_basevals_management.csv", main_dir = main_dir))

}

load_ga_gbr_scenarios_aggregated_to_management_zones <- function (main_dir = ".") {

  read_csv_arrow(file = data_file("Scenarios", "ga_gbr_scenarios_aggregated_to_management_zones.csv", main_dir = main_dir))

}



load_ws_gbr_basevals_management <- function (main_dir = ".") {

  read_csv_arrow(file = data_file("Scenarios", "ws_gbr_basevals_management.csv", main_dir = main_dir))

}

load_ws_gbr_scenarios_aggregated_to_management_zones <- function (main_dir = ".") {

  read_csv_arrow(file = data_file("Scenarios", "ws_gbr_scenarios_aggregated_to_management_zones.csv", main_dir = main_dir))

}



load_ga_gbr_basevals_gbrmpa <- function (main_dir = ".") {

  read_csv_arrow(file = data_file("Scenarios", "ga_gbr_basevals_gbrmpa.csv", main_dir = main_dir))

}

load_ga_gbr_scenarios_aggregated_to_gbrmpa_park_zones <- function (main_dir = ".") {

  read_csv_arrow(file = data_file("Scenarios", "ga_gbr_scenarios_aggregated_to_gbrmpa_park_zones.csv", main_dir = main_dir))

}


load_ws_gbr_basevals_gbrmpa <- function (main_dir = ".") {

  read_csv_arrow(file = data_file("Scenarios", "ws_gbr_basevals_gbrmpa.csv", main_dir = main_dir))

}

load_ws_gbr_scenarios_aggregated_to_gbrmpa_park_zones <- function (main_dir = ".") {

  read_csv_arrow(file = data_file("Scenarios", "ws_gbr_scenarios_aggregated_to_gbrmpa_park_zones.csv", main_dir = main_dir))

}

load_ga_forecast <- function (main_dir = ".") {

  read_csv_arrow(file = data_file("Forecasts", "ga_forecast.csv", main_dir = main_dir))

}

load_ws_forecast <- function (main_dir = ".") {

  read_csv_arrow(file = data_file("Forecasts", "ws_forecast.csv", main_dir = main_dir))

}

load_ga_nowcast_aggregated_to_management_zones <- function (main_dir = ".") {

  read_csv_arrow(file = data_file("Forecasts", "ga_nowcast_aggregated_to_management_zones.csv", main_dir = main_dir))

}

load_ws_nowcast_aggregated_to_management_zones <- function (main_dir = ".") {

  read_csv_arrow(file = data_file("Forecasts", "ws_nowcast_aggregated_to_management_zones.csv", main_dir = main_dir))

}

load_ga_gbr_nowcast_aggregated_to_gbrmpa_park_zones <- function (main_dir = ".") {

  read_csv_arrow(file = data_file("Forecasts", "ga_gbr_nowcast_aggregated_to_gbrmpa_park_zones.csv", main_dir = main_dir))

}

load_ws_gbr_nowcast_aggregated_to_gbrmpa_park_zones <- function (main_dir = ".") {

  read_csv_arrow(file = data_file("Forecasts", "ws_gbr_nowcast_aggregated_to_gbrmpa_park_zones.csv", main_dir = main_dir))

}


load_gauge_data <- function ( ) {

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

  gauge_data
}