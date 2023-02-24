FROM rocker/r-base:latest

# ~2s
RUN echo "Updating apt sources." && apt-get -qq update

# Install libss1.1
ENV LIBSSL_URL=http://launchpadlibrarian.net/650099131/libssl1.1_1.1.1-1ubuntu2.1~18.04.21_amd64.deb
ENV LIBSSL_FILE=libssl1.1_1.1.1-1ubuntu2.1~18.04.21_amd64.deb
RUN wget $LIBSSL_URL
RUN dpkg -i $LIBSSL_FILE

# ~55s
RUN echo "Installing R package dependencies." && \
    apt-get -qq install \
    pandoc \
    libcurl4-gnutls-dev \
    libcairo2-dev \
    libxt-dev \
    libssl-dev \
    libssh2-1-dev \
    libxml2-dev \
    gdal-bin \
    proj-bin \
    libgdal-dev \
    libproj-dev \
    libudunits2-dev \
    libharfbuzz-dev \
    libfribidi-dev

# Install pak package manager - ~5s
RUN R -e 'install.packages("pak", repos = "https://r-lib.github.io/p/pak/dev")'

# Install R packages - ~550s (~2x faster using pak::pkg_install vs install.packages)
RUN R -e \
    'pak::pkg_install(c(\
    "shiny",\
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

COPY codes /app/codes
COPY forec_shiny_app_data /app/forec_shiny_app_data
COPY styles.css /app/styles.css
COPY Rprofile.site /usr/lib/R/etc/

EXPOSE 3838

CMD ["R", "-e", "shiny::runApp('/app/codes/forec_shiny_app.R', host = '0.0.0.0', port = 3838)"]
