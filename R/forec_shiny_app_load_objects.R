# load all data -----------------------------------------------------------------------


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