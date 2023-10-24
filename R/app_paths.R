file_paths <- function (app_text_file     = "app_text.yml",
                        app_settings_file = "app_settings.yml",
                        app_style_file    = "styles.css") {

  list(app_text     = file.path(app_text_file),
       app_settings = file.path(app_settings_file),
       app_style    = file.path(app_style_file))


}