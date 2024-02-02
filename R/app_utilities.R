app_css_header <- function (css_path = app_file("styles.css")) { 

  tags$head(includeCSS(path = css_path))

}