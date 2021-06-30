FROM openanalytics/r-base

# system libraries of general use
RUN apt-get update && apt-get install -y \
    sudo \
    pandoc \
    pandoc-citeproc \
    libcurl4-gnutls-dev \
    libcairo2-dev \
    libxt-dev \
    libssl-dev \
    libssh2-1-dev \
    libxml2-dev \
    libssl1.1 \
    gdal-bin \
    proj-bin \
    libgdal-dev \
    libproj-dev

# system library dependency for the euler app
# RUN apt-get update && apt-get install -y \
#    libmpfr-dev

# basic shiny functionality
RUN R -e "install.packages(c('shiny', 'shinythemes', 'leaflet', 'flexdashboard', 'tidyverse'), repos='https://cloud.r-project.org/')"

RUN R -e "install.packages(c('shinyWidgets', 'plotly', 'xts', 'shinydashboard', 'shinycssloaders', 'shinyBS', 'RColorBrewer', 'viridis'), repos='https://cloud.r-project.org/')"

# copy the app to the image
RUN mkdir /root/uh-noaa-shiny-app
RUN mkdir /root/uh-noaa-shiny-app/codes
RUN mkdir /root/uh-noaa-shiny-app/forec_shiny_app_data
COPY codes /root/uh-noaa-shiny-app/codes
COPY forec_shiny_app_data /root/uh-noaa-shiny-app/forec_shiny_app_data
COPY styles.css /root/uh-noaa-shiny-app/styles.css

COPY Rprofile.site /usr/lib/R/etc/


EXPOSE 3838

CMD ["R", "-e", "shiny::runApp('/root/uh-noaa-shiny-app/codes/forec_shiny_app.R', host = '0.0.0.0', port = 3838)"]
