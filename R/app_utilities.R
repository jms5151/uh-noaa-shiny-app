load_rds_files <- function ( ) {

  rds_filenames <- data_files(file_ext = c("RData", "Rds"))
  lapply(rds_filenames, load, .GlobalEnv)

}


app_file <- function (x) {

  system.file("app", "www", x, package = "uhnoaashinyapp")

}

data_files <- function (file_ext = NULL,
                        main_dir = ".", 
                        data_dir = "forec_shiny_app_data",
                        sub_dirs = c("Forecasts", "Scenarios", "Static_data")) {

  if (!is.null(file_ext)){
    file_ext <- paste0(paste0("\\.", file_ext, "$"), collapse = "|")
  }

  list.files(path       = file.path(main_dir, data_dir, sub_dirs),
             pattern    = file_ext,
             full.names = TRUE) 

}