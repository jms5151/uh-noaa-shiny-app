# uh-noaa-shiny-app

Setup instructions

Build the container

```bash
DOCKER_BUILDKIT=1 docker build . -t noaa
```

Run the container

```bash
docker run -p 3838:3838 noaa
```

Visit [http://localhost:3838](http://localhost:3838) to view the dashboard.
