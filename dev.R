# only needed the first time
# usethis::use_description(fields = list(), check_name = FALSE, roxygen = TRUE)
# devtools::install_deps()

# working off of this idea to re-organize 
# https://mastering-shiny.org/scaling-packaging.html#deploying-your-app-package
#
# this involves turning the codebase into more of a 'package'


# Fore-C interactive explorer -----------------------------------------------------

# load libraries (and install if not already installed) 
# should no longer be needed given package management
# source("codes/forec_shiny_app_packages.R", local = TRUE)



# load data 
source("codes/forec_shiny_app_load_objects.R", local = TRUE)





# load functions, maps, plots, user interface and server for shiny app 
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

