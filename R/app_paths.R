

app_file <- function (...) {

  system.file("app", ..., package = "uhnoaashinyapp")

}

app_logo_path <- function ( ) {

  app_file("logos.png")

}

app_disease_pictures_path <- function ( ) {

  app_file("disease_pictures.png")

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

data_file <- function (...,
                       main_dir = ".", 
                       data_dir = "forec_shiny_app_data") {

  file.path(main_dir, data_dir, ...)

}

read_app_text <- function ( ) {

  read_yaml(app_file("text.yml"))
  
}

read_app_settings <- function ( ) {

  read_yaml(app_file("settings.yml"))

}