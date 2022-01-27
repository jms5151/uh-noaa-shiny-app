# create list of scenarios
# https://www.star.nesdis.noaa.gov/pub/sod/mecb/gliu/caldwell/20220124/
# ftp://ftp.star.nesdis.noaa.gov/pub/sod/mecb/gliu/caldwell/20220124/
  
# sst90d <- nc_open("C:/Users/jamie/OneDrive/Desktop/forec5km_sst-mean-90d_v1.0_gbr_reef-id_20220123.nc")
# sst90d_id <- sst90d$dim$reef_id$vals
# sst90d_vals <- ncvar_get(sst90d, varid = "sea_surface_temperature")
# sst90d_date <- ncvar_get(sst90d, varid = "data_date")

# should load most up-to-date nowcast, using forecast inputs for covariates
# and forecast outputs for disease risk values, 
y <- load("../compiled_data/forecast_inputs/ga_gbr_grid_week_1_ensemble_0")
grid_dz_covars <- get(y)

y <- load("../compiled_data/forecast_outputs/ga_gbr_grid_week_1_ensemble_0")
grid_dz <- get(y)

# but use below as placeholder
load("../compiled_data/grid_covariate_data/grid_with_static_covariates.RData")
load("../compiled_data/grid_covariate_data/grid_with_three_week_oc_metrics.RData")
oc <- subset(reef_grid_tw_oc, Date == "2022-01-24")

library(tidyverse)
grid_with_static_covariates <- grid_with_static_covariates %>%
  left_join(oc)

# model covariates
source("./codes/Final_covariates_by_disease_and_region.R")

# custom function for creating scenarios 
source("./codes/custom_functions/fun_create_scenarios.R")

# GA Pacific -------------------------------------
# dataset generation will get replaced once crw data is available --
ga_pac <- subset(grid_with_static_covariates, Region != 'gbr')

# add poritidae to specific variables, remove later
ga_pac_vars[grepl('colony', ga_pac_vars)] <- paste0(ga_pac_vars[grepl('colony', ga_pac_vars)], "_Poritidae")
ga_pac_vars <- ga_pac_vars[!grepl('Month|SST', ga_pac_vars)]

ga_pac <- ga_pac[, c("ID", "Region", ga_pac_vars)]
                     
ga_pac$Month <- 01
ga_pac$SST_90dMean <- rnorm(nrow(ga_pac), mean = 26, sd = 4)
ga_pac$value <- rnorm(nrow(ga_pac), mean = 0.05, sd = 0.02)
ga_pac$value[ga_pac$value < 0] <- 0
colnames(ga_pac) <- gsub("Poritidae_|_Poritidae", "", colnames(ga_pac))
# end of dataset generation ----------

ga_pac_scenarios <- data.frame()

# Colony size
ga_pac_coral_size_levels <- seq(from = 5, to = 55, by = 10) 

ga_pac_scenarios <- add_scenario_levels(
  df = ga_pac
  , scenario_levels = ga_pac_coral_size_levels
  , col_name = 'Median_colony_size'
  , response_name = 'colony_size'
  , scenarios_df = ga_pac_scenarios
)

# coral cover
ga_pac_coral_cover_levels <- seq(from = 5, to = 45, by = 10) 

ga_pac_scenarios <- add_scenario_levels(
  df = ga_pac
  , scenario_levels = ga_pac_coral_cover_levels
  , col_name = 'mean_cover'
  , response_name = 'coral_cover'
  , scenarios_df = ga_pac_scenarios
)

# herbivorous fish
ga_pac_herb_fish_levels <- seq(from = 0.1, to = 0.7, by = 0.2)

ga_pac_scenarios <- add_scenario_levels(
  df = ga_pac
  , scenario_levels = ga_pac_herb_fish_levels
  , col_name = 'H_abund'
  , response_name = 'herb_fish'
  , scenarios_df = ga_pac_scenarios
)

# coastal development
ga_pac_development_levels <- seq(from = 1, to = 255, by = 85)# seq(from = 0.1, to = 0.9, by = 0.3)

ga_pac_scenarios <- add_scenario_levels(
  df = ga_pac
  , scenario_levels = ga_pac_development_levels
  , col_name = 'BlackMarble_2016_3km_geo.3'
  , response_name = 'development'
  , scenarios_df = ga_pac_scenarios
)

# make up disease risk data rather than running for now
ga_pac_scenarios$estimate <- rnorm(nrow(ga_pac_scenarios), mean = 0.08, sd = 0.04)
ga_pac_scenarios$estimate[ga_pac_scenarios$estimate < 0] <- 0
ga_pac_scenarios$sd <- rnorm(nrow(ga_pac_scenarios), mean = 0.02, sd = 0.01)
ga_pac_scenarios$sd[ga_pac_scenarios$sd < 0] <- 0

# pre-calculate disease risk change
ga_pac_scenarios$disease_risk_change <- (ga_pac_scenarios$estimate - ga_pac_scenarios$value) * 100
ga_pac_scenarios$disease_risk_change[ga_pac_scenarios$disease_risk_change < -100] <- 0

# save data to run and then replace with same name
save(ga_pac_scenarios, file = "../uh-noaa-shiny-app/forec_shiny_app_data/Scenarios/ga_pac_scenarios.RData")

# WS Pacific -------------------------------------
# dataset generation will get replaced once crw data is available
ws_pac <- subset(grid_with_static_covariates, Region != 'gbr')

# add poritidae to specific variables, remove later
ws_pac_acr_vars[grepl('colony', ws_pac_acr_vars)] <- paste0(ws_pac_acr_vars[grepl('colony', ws_pac_acr_vars)], "_Acroporidae")
ws_pac_acr_vars <- ws_pac_acr_vars[!grepl('Month|Hot|Winter', ws_pac_acr_vars)]

ws_pac <- ws_pac[, c("ID", "Region", ws_pac_acr_vars)]

ws_pac$Month <- 01
ws_pac$Hot_snaps <- rnorm(nrow(ws_pac), mean = 1, sd = 2)
ws_pac$Hot_snaps[ws_pac$Hot_snaps < 0] <- 0
ws_pac$Winter_condition <- rnorm(nrow(ws_pac), mean = 0, sd = 4.5)

ws_pac$value <- rnorm(nrow(ws_pac), mean = 0.05, sd = 0.02)
ws_pac$value[ws_pac$value < 0] <- 0

colnames(ws_pac) <- gsub("Acroporidae_|_Acroporidae", "", colnames(ws_pac))
# end of dataset generation ------------

ws_pac_scenarios <- data.frame()

# colony size
ws_pac_coral_size_levels <- seq(from = 5, to = 55, by = 10) 

ws_pac_scenarios <- add_scenario_levels(
  df = ws_pac
  , scenario_levels = ws_pac_coral_size_levels
  , col_name = 'Median_colony_size'
  , response_name = 'development'
  , scenarios_df = ws_pac_scenarios
  )

# turbidity
ws_pac_turbidity_levels <- seq(from = 0, to = 2, by = 0.5) 

ws_pac_scenarios <- add_scenario_levels(
  df = ws_pac
  , scenario_levels = ws_pac_turbidity_levels
  , col_name = 'Long_Term_Kd_Median'
  , response_name = 'turbidity'
  , scenarios_df = ws_pac_scenarios
)

# parrotfish
ws_pac_parrotfish_levels <- seq(from = 0.0, to = 0.06, by = 0.02)

ws_pac_scenarios <- add_scenario_levels(
  df = ws_pac
  , scenario_levels = ws_pac_parrotfish_levels
  , col_name = 'Parrotfish_abund'
  , response_name = 'parrotfish'
  , scenarios_df = ws_pac_scenarios
)

# herbivorous fish
ws_pac_herb_fish_levels <- seq(from = 0.0, to = 0.6, by = 0.2)

ws_pac_scenarios <- add_scenario_levels(
  df = ws_pac
  , scenario_levels = ws_pac_herb_fish_levels
  , col_name = 'H_abund'
  , response_name = 'herb_fish'
  , scenarios_df = ws_pac_scenarios
)

# make up disease risk data rather than running for now
ws_pac_scenarios$estimate <- rnorm(nrow(ws_pac_scenarios), mean = 0.08, sd = 0.04)
ws_pac_scenarios$estimate[ws_pac_scenarios$estimate < 0] <- 0
ws_pac_scenarios$sd <- rnorm(nrow(ws_pac_scenarios), mean = 0.02, sd = 0.01)
ws_pac_scenarios$sd[ws_pac_scenarios$sd < 0] <- 0

# pre-calculate disease risk change
ws_pac_scenarios$disease_risk_change <- (ws_pac_scenarios$estimate - ws_pac_scenarios$value) * 100
ws_pac_scenarios$disease_risk_change[ws_pac_scenarios$disease_risk_change < -100] <- 0

# save data to run and then replace with same name
save(ws_pac_scenarios, file = "../uh-noaa-shiny-app/forec_shiny_app_data/Scenarios/ws_pac_scenarios.RData")

# GA GBR -----------------------------------------
# dataset generation will get replaced once crw data is available --
ga_gbr <- subset(grid_with_static_covariates, Region == 'gbr')

# add poritidae to specific variables, remove later
ga_gbr_vars <- ga_gbr_vars[!grepl('Month|SST', ga_gbr_vars)]

ga_gbr <- ga_gbr[, c("ID", "Region", ga_gbr_vars)]

ga_gbr$Month <- 01
ga_gbr$SST_90dMean <- rnorm(nrow(ga_gbr), mean = 26, sd = 4)
ga_gbr$value <- rnorm(nrow(ga_gbr), mean = 10, sd = 3)
ga_gbr$value[ga_gbr$value < 0] <- 0

# end of dataset generation ----------

ga_gbr_scenarios <- data.frame()

# Fish abundance
ga_gbr_fish_levels <- seq(from = 400, to = 800, by = 100)

ga_gbr_scenarios <- add_scenario_levels(
  df = ga_gbr
  , scenario_levels = ga_gbr_fish_levels
  , col_name = 'Fish_abund'
  , response_name = 'fish'
  , scenarios_df = ga_gbr_scenarios
)

# turbidity
ga_gbr_turbidity_levels <- seq(from = 0, to = 2, by = 0.5) 

ga_gbr_scenarios <- add_scenario_levels(
  df = ga_gbr
  , scenario_levels = ga_gbr_turbidity_levels
  , col_name = 'Three_Week_Kd_Variability'
  , response_name = 'turbidity'
  , scenarios_df = ga_gbr_scenarios
)

# coral cover
ga_gbr_coral_cover_levels <- seq(from = 5, to = 95, by = 15) 

ga_gbr_scenarios <- add_scenario_levels(
  df = ga_gbr
  , scenario_levels = ga_gbr_coral_cover_levels
  , col_name = 'Coral_cover'
  , response_name = 'coral_cover'
  , scenarios_df = ga_gbr_scenarios
)


# make up disease risk data rather than running for now
ga_gbr_scenarios$estimate <- rnorm(nrow(ga_gbr_scenarios), mean = 5, sd = 2)
ga_gbr_scenarios$estimate[ga_gbr_scenarios$estimate < 0] <- 0
ga_gbr_scenarios$sd <- rnorm(nrow(ga_gbr_scenarios), mean = 1, sd = 0.5)
ga_gbr_scenarios$sd[ga_gbr_scenarios$sd < 0] <- 0

# pre-calculate disease risk change
ga_gbr_scenarios$disease_risk_change <- (ga_gbr_scenarios$estimate - ga_gbr_scenarios$value) * 10
# can't decrease more than 100%
ga_gbr_scenarios$disease_risk_change[ga_gbr_scenarios$disease_risk_change < -100] <- -100
# save data to run and then replace with same name
save(ga_gbr_scenarios, file = "../uh-noaa-shiny-app/forec_shiny_app_data/Scenarios/ga_gbr_scenarios.RData")

# WS GBR -----------------------------------------
# dataset generation will get replaced once crw data is available --
ws_gbr <- subset(grid_with_static_covariates, Region == 'gbr')

# add poritidae to specific variables, remove later
ws_gbr_vars <- ws_gbr_vars[!grepl('Month|Hot', ws_gbr_vars)]

ws_gbr <- ws_gbr[, c("ID", "Region", ws_gbr_vars)]

ws_gbr$Month <- 01
ws_gbr$Hot_snaps <- rnorm(nrow(ws_gbr), mean = 1, sd = 2)
ws_gbr$Hot_snaps[ws_gbr$Hot_snaps < 0] <- 0
ws_gbr$value <- rnorm(nrow(ws_gbr), mean = 10, sd = 3)
ws_gbr$value[ws_gbr$value < 0] <- 0
# end of dataset generation ----------

ws_gbr_scenarios <- data.frame()

# coral cover
ws_gbr_coral_cover_levels <- seq(from = 5, to = 95, by = 15) 

ws_gbr_scenarios <- add_scenario_levels(
  df = ws_gbr
  , scenario_levels = ws_gbr_coral_cover_levels
  , col_name = 'Coral_cover'
  , response_name = 'coral_cover'
  , scenarios_df = ws_gbr_scenarios
)

# Fish abundance
ws_gbr_fish_levels <- seq(from = 400, to = 800, by = 100)

ws_gbr_scenarios <- add_scenario_levels(
  df = ws_gbr
  , scenario_levels = ws_gbr_fish_levels
  , col_name = 'Fish_abund'
  , response_name = 'fish'
  , scenarios_df = ws_gbr_scenarios
)

# turbidity
ws_gbr_turbidity_levels <- seq(from = 0, to = 2, by = 0.5) 

ws_gbr_scenarios <- add_scenario_levels(
  df = ws_gbr
  , scenario_levels = ws_gbr_turbidity_levels
  , col_name = 'Three_Week_Kd_Variability'
  , response_name = 'turbidity'
  , scenarios_df = ws_gbr_scenarios
)

# make up disease risk data rather than running for now
ws_gbr_scenarios$estimate <- rnorm(nrow(ws_gbr_scenarios), mean = 5, sd = 2)
ws_gbr_scenarios$estimate[ws_gbr_scenarios$estimate < 0] <- 0
ws_gbr_scenarios$sd <- rnorm(nrow(ws_gbr_scenarios), mean = 1, sd = 0.5)
ws_gbr_scenarios$sd[ws_gbr_scenarios$sd < 0] <- 0

# pre-calculate disease risk change
ws_gbr_scenarios$disease_risk_change <- (ws_gbr_scenarios$estimate - ws_gbr_scenarios$value) * 10
# can't decrease more than 100%
ws_gbr_scenarios$disease_risk_change[ws_gbr_scenarios$disease_risk_change < -100] <- -100
# save data to run and then replace with same name
save(ws_gbr_scenarios, file = "../uh-noaa-shiny-app/forec_shiny_app_data/Scenarios/ws_gbr_scenarios.RData")
