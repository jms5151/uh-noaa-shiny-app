# Fore-C interactive explorer -----------------------------------------------------
# load libraries (and install if not already installed) 
source("./forec_shiny_app_packages.R", local = TRUE)

# # load data -----------------------------------------------------------------------
filenames <- list.files("../forec_shiny_app_data/Forecasts/", full.names=TRUE)
filenames <- c(filenames, list.files("../forec_shiny_app_data/Scenarios/", full.names=TRUE))
filenames <- c(filenames, list.files("../forec_shiny_app_data/Static_data/", full.names=TRUE))

# filenames <- filenames[grep(".RData|.Rds", filenames)]
filenames <- filenames[grep(".csv|.shp|historical|placeholder", filenames)]

# load files into global environment
# lapply(filenames, load, .GlobalEnv)
# this is faster without update_shpfile function, much slower with the function
# st_simplify might not be helpful, may want to use rasters instead
# st <- Sys.time()
# shp_filenames <- filenames[grep(".shp", filenames)]
# rds_filenames <- filenames[grep("historicalMap|placeholder", filenames)]
# csv_filenames <- filenames[grep(".csv", filenames)]
# x <- lapply(shp_filenames, st_read)
# 
# update_shpfile <- function(df){
#   df <- st_simplify(df)
#   names(st_geometry(df)) = NULL
# }
# x2 <- lapply(x, function(x) update_shpfile(df = x))
# lapply(rds_filenames, load, .GlobalEnv)
# y <- lapply(csv_filenames, read.csv)
# newname <- gsub('.*Forecasts|.*Scenarios|.*Static_data|.csv|.shp', '', csv_filenames)
# newname <- gsub('/', '', newname, fixed = TRUE)
# names(y) <- newname
# fix_date_fun <- function(df){
#   if(length(grep('Date', colnames(df))) == 1){
#     df$Date <- as.Date(df$Date, '%Y-%m-%d')
#   }
#   return(df)
# }
# y2 <- lapply(y, function(x) fix_date_fun(df = x))
# et <- Sys.time()
# et-st

for(i in 1:length(filenames)){
  if(length(grep('.csv', filenames[i])) == 1){
    x <- read.csv(filenames[i], check.names = FALSE)
  } else if(length(grep('.Rds|.RData', filenames[i])) == 1){
    load(filenames[i])
  } else {
    x <- st_read(filenames[i])
    # do this
    # x <- st_simplify(x)
    # names(st_geometry(x)) = NULL
    # or this to turn into SpatialPolygonsDataFrame, which is slower to load but
    # might be faster with leaflet?
    # x <- as(x, 'Spatial')
    
  }
  
  if(length(grep('Date', colnames(x))) == 1){
    x$Date <- as.Date(x$Date, '%Y-%m-%d')
  }
  
  if(length(grep('.csv|.shp', filenames[i]) == 1)){
    newname <- gsub('.*Forecasts|.*Scenarios|.*Static_data|.csv|.shp', '', filenames[i])
    newname <- gsub('/', '', newname, fixed = TRUE)
    assign(newname, x)
  }
}

# temporary addition, eventually all data will be CSV and other forms
# warning_levels_table <- read.csv("../forec_shiny_app_data/Static_data/warning_levels_table.csv", check.names = FALSE)

# load functions, maps, plots, user interface and server for shiny app ------------
# load maps & mapping functions
source("./forec_shiny_app_maps.R", local = TRUE)

# load plots and plotting functions
source("./forec_shiny_app_plots.R", local = TRUE)

# load information text blocks and settings, must be loaded before sourcing UI and server
source("./forec_shiny_app_info_text_and_settings.R", local = TRUE)

# load user interface
source("./forec_shiny_app_user_interface.R", local = TRUE)

# load server
source("./forec_shiny_app_server.R", local = TRUE)

# run shiny app -------------------------------------------------------------------
shinyOptions(cache = cachem::cache_mem(max_size = 500e6))
shinyApp(ui, server)
