# Fore-C interactive explorer -----------------------------------------------------
# load libraries (and install if not already installed) 
if (!require("shiny")) install.packages("shiny"); library(shiny)
if (!require("shinythemes")) install.packages("shinythemes"); library(shinythemes)
if (!require("flexdashboard")) install.packages("flexdashboard"); library(flexdashboard)
if (!require("tidyverse")) install.packages("tidyverse"); library(tidyverse)
if (!require("shinyWidgets")) install.packages("shinyWidgets"); library(shinyWidgets)
if (!require("xts")) install.packages("xts"); library(xts)
if (!require("shinydashboard")) install.packages("shinydashboard"); library(plotly)
if (!require("shinycssloaders")) install.packages("shinycssloaders"); library(shinycssloaders)
if (!require("shinyBS")) install.packages("shinyBS"); library(shinyBS) # for hover text
if (!require("leaflet")) install.packages("leaflet"); library(leaflet)
if (!require("RColorBrewer")) install.packages("RColorBrewer"); library(RColorBrewer)
if (!require("viridis")) install.packages("viridis"); library(viridis)
if (!require("plotly")) install.packages("plotly"); library(plotly)

# load data -----------------------------------------------------------------------
filenames <- list.files("../forec_shiny_app_data/Forecasts/", full.names=TRUE)
filenames <- c(filenames, list.files("../forec_shiny_app_data/Scenarios/", full.names=TRUE))
filenames <- c(filenames, list.files("../forec_shiny_app_data/Static_data/", full.names=TRUE))

# load files into global environment
lapply(filenames, load, .GlobalEnv)

# load functions, maps, plots, user interface and server for shiny app ------------
# load maps & mapping functions
source("../codes/forec_shiny_app_maps.R")

# load plots and plotting functions
source("../codes/forec_shiny_app_plots.R")

# load information text blocks and settings, must be loaded before sourcing UI and server
source("../codes/forec_shiny_app_info_text_and_settings.R")

# load user interface
source("../codes/forec_shiny_app_user_interface.R")

# load server
source("../codes/forec_shiny_app_server.R")

# run shiny app -------------------------------------------------------------------
shinyApp(ui, server)
