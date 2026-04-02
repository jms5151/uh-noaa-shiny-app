FROM rocker/geospatial:latest

# System deps
RUN apt-get -qq update && \
    apt-get -qq install -y \
        proj-bin && \
    rm -rf /var/lib/apt/lists/*

# Install R package needed for GitHub installs
RUN R -e "install.packages('remotes', repos='https://cloud.r-project.org')"

# Build arg (default to main, not HEAD)
ARG event_sha=main
ENV event_sha=${event_sha}

# Debug (can remove later)
RUN echo "Installing uh-noaa-shiny-app from ref: ${event_sha}"

# Install your package
RUN R -e "remotes::install_github('jms5151/uh-noaa-shiny-app', ref = Sys.getenv('event_sha'))"

WORKDIR /app

COPY forec_shiny_app_data /app/forec_shiny_app_data
COPY Rprofile.site /usr/lib/R/etc/

EXPOSE 3838

CMD ["R", "-e", "uhnoaashinyapp::run_app()"]
