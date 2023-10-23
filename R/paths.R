file_paths <- function (webapp_text_file     = "webapp_text.yml",
                        webapp_settings_file = "webapp_settings.yml") {

  list(webapp_text     = file.path(webapp_text_file),
       webapp_settings = file.path(webapp_settings_file))
#  list(webapp_text = file.path(".", "inst", "app", webapp_text_file))

}