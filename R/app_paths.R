file_paths <- function (app_text_file     = "app_text.yml",
                        app_settings_file = "app_settings.yml",
                        app_style_file    = "styles.css",
                        root              = "package") {

  app <- app_path(root = root)

  list(app_text     = file.path(app, app_text_file),
       app_settings = file.path(app, app_settings_file),
       app_style    = file.path(app, app_style_file))


}

app_path <- function (root = "package") {

  if (root == "package") {
    system.file("app", package = "uhnoaashinyapp") 
  } else if (root == "local") {
    normalizePath(".", "/")
  } else {
    stop("package must have `root` of `package` or `local`")
  }

}



app_file <- function (...) {

  system.file("app", "www", ..., package = "uhnoaashinyapp")

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