FROM rocker/geospatial:latest

# ~2s
RUN echo "Updating apt sources." && apt-get -qq update

# Install libss1.1
#  [Juniper: I'm not sure if we still need this given the current configuration, but need to test its removal]
ENV LIBSSL_URL=http://launchpadlibrarian.net/650099131/libssl1.1_1.1.1-1ubuntu2.1~18.04.21_amd64.deb
ENV LIBSSL_FILE=libssl1.1_1.1.1-1ubuntu2.1~18.04.21_amd64.deb
RUN wget $LIBSSL_URL
RUN dpkg -i $LIBSSL_FILE

# ~55s
RUN echo "Installing R package dependencies." && \
    apt-get -qq install \
    libcurl4-gnutls-dev \
    proj-bin 

# Install pak package manager - ~5s
RUN R -e 'install.packages("pak", repos = "https://r-lib.github.io/p/pak/dev")'

# Install R packages - ~550s (~2x faster using pak::pkg_install vs install.packages)
RUN R -e \
    'pak::pkg_install(c(\
    "shinythemes",\
    "leaflet",\
    "flexdashboard",\
    "tidyverse",\
    "shinyWidgets",\
    "plotly",\
    "xts",\
    "shinydashboard",\
    "shinycssloaders",\
    "shinyBS",\
    "sf"\
    ))'

WORKDIR /app

COPY forec_shiny_app_data /app/forec_shiny_app_data
COPY Rprofile.site /usr/lib/R/etc/

EXPOSE 3838

CMD ["R", "-e", "shiny::runApp('/app/codes/forec_shiny_app.R', host = '0.0.0.0', port = 3838)"]
