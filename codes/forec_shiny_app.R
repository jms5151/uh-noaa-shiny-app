# Fore-C interactive explorer -----------------------------------------------------
# load libraries (and install if not already installed) 
source("./codes/forec_shiny_app_packages.R", local = TRUE)

# # load data -----------------------------------------------------------------------
filenames <- list.files("./forec_shiny_app_data/Forecasts/", full.names=TRUE)
filenames <- c(filenames, list.files("./forec_shiny_app_data/Scenarios/", full.names=TRUE))
filenames <- c(filenames, list.files("./forec_shiny_app_data/Static_data/", full.names=TRUE))

# load files into global environment
lapply(filenames, load, .GlobalEnv)

# temporary addition, eventually all data will be CSV and other forms
warning_table <- read.csv("./forec_shiny_app_data/Static_data/warning_levels_table.csv", check.names = FALSE)

# load functions, maps, plots, user interface and server for shiny app ------------
# load maps & mapping functions
source("./codes/forec_shiny_app_maps.R", local = TRUE)

# load plots and plotting functions
source("./codes/forec_shiny_app_plots.R", local = TRUE)

# load information text blocks and settings, must be loaded before sourcing UI and server
source("./codes/forec_shiny_app_info_text_and_settings.R", local = TRUE)

# load user interface
source("./codes/forec_shiny_app_user_interface.R", local = TRUE)

# load server
source("./codes/forec_shiny_app_server.R", local = TRUE)

# run shiny app -------------------------------------------------------------------
shinyApp(ui, server)

