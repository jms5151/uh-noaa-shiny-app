
file_paths <- function (app_text_file     = ,
                        app_settings_file = "settings.yml",
                        app_style_file    = "styles.css",
                        root              = "package", ...) {

  app <- app_path(root = root, ...)

  list(app_text     = file.path(app, app_text_file),
       app_settings = file.path(app, app_settings_file),
       app_style    = file.path(app, app_style_file))


}

# roots the app
app_path <- function (root = "package", ...) {

  if (root == "package") {
    system.file("app", package = "uhnoaashinyapp") 
  } else if (root == "local") {
    dots <- list(...)
    if (length(dots) == 0) {
      dots <- "."
    }
    normalizePath(path     = file.path(dots), 
                  winslash = "/")
  } else {
    stop("package must have `root` of `package` or `local`")
  }

}

