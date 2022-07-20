# load all data -----------------------------------------------------------------------

# list files
filenames <- list.files("../forec_shiny_app_data/Forecasts/", full.names=TRUE)
filenames <- c(filenames, list.files("../forec_shiny_app_data/Scenarios/", full.names=TRUE))
filenames <- c(filenames, list.files("../forec_shiny_app_data/Static_data/", full.names=TRUE))

# load rds files
rds_filenames <- filenames[grep("historical|placeholder", filenames)]
lapply(rds_filenames, load, .GlobalEnv)

# load shapefiles
shp_filenames <- filenames[grep(".shp", filenames)]
shpFiles <- lapply(shp_filenames, st_read)
names(shpFiles) <- gsub('.*\\/|\\.shp', '', shp_filenames)
# list2env(shpFiles, envir = .GlobalEnv)

# load csv files
csv_filenames <- filenames[grep(".csv", filenames)]
csvFiles <- lapply(csv_filenames, read.csv)
names(csvFiles)<- gsub('.*\\/|\\.csv', '', csv_filenames)

# format functions
update_drisk <- function(df){
  df$drisk <- as.numeric(df$drisk) 
  return(df)
}

update_date <- function(df){
  if(length(grep('Date', colnames(df))) == 1){
    df$Date <- as.Date(df$Date, '%Y-%m-%d')
  }
  return(df)
}

# format data
shpFiles <- lapply(shpFiles, function(x) update_drisk(df = x))
csvFiles <- lapply(csvFiles, function(x) update_date(df = x))

# load individual dataframes from list of csv files 
list2env(csvFiles, envir = .GlobalEnv)
