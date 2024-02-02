FROM rocker/geospatial:latest

RUN echo "Updating apt sources." && apt-get -qq update

RUN echo "Installing system dependencies." && \
    apt-get -qq install \
    proj-bin 

# Install project package from github event that triggered the specific workflow
ARG event_sha="HEAD"
RUN echo "Installing uh-noaa-shiny-app from github at ref $event_sha"
RUN R -e "remotes::install_github('jms5151/uh-noaa-shiny-app', ref = '$event_sha')"

WORKDIR /app


COPY codes /app/codes
COPY forec_shiny_app_data /app/forec_shiny_app_data
COPY styles.css /app/styles.css
COPY Rprofile.site /usr/lib/R/etc/

EXPOSE 3838

CMD ["R", "-e", "uhnoaashinyapp::run_app( )"]
