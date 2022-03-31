# uh-noaa-shiny-app

### Setup

You can either pull the container

```
docker pull jamiecaldwell/uh-crw:latest
```

Or you can build the container

```bash
DOCKER_BUILDKIT=1 docker build \
    --tag jamiecaldwell/uh-crw:latest \
    --cache-from jamiecaldwell/uh-crw:latest \
    --build-arg BUILDKIT_INLINE_CACHE=1 .
```

After that you can run the container

```bash
docker run -p 3838:3838 jamiecaldwell/uh-crw:latest
```

Visit [http://localhost:3838](http://localhost:3838) to view the dashboard.

## Secrets

Secrets are encrypted using [transcrypt](https://github.com/elasticdog/transcrypt). You can see encryoted files with `transcrypt --list`.

To intialise the repository on cloning run

```bash
transcrypt -c aes-256-cbc -p $TRANSCRYPT_PASSWORD
```
