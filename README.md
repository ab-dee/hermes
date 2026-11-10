# hermes

A minimal Ubuntu 24.04 sandbox for a Hermes agent. It isolates the agent in its own container and keeps its config and API keys in a host-mounted `data/` directory, so they survive container restarts.

## Files

- `Dockerfile`: Ubuntu 24.04 base, core dependencies, the official Hermes install script, and `hermes` as the entrypoint.
- `data/`: persistent agent state (config, API keys, memory). Mounted at `/data`. Git-ignored.
- `.gitignore`: excludes `data/`.

## Build

```bash
docker build -t hermes .
docker images    # "hermes" should appear
```

## Setup (first run)

Runs the interactive wizard to configure your LLM provider and API keys. Settings are saved to `data/`.

```bash
docker run -it --rm \
  -v "$(pwd)/data:/data" \
  hermes setup
```

## Run the gateway

```bash
docker run -d \
  --name hermes-sandbox \
  --restart unless-stopped \
  -p 8642:8642 \
  -v "$(pwd)/data:/data" \
  hermes gateway run
```

Health check:

```bash
curl http://localhost:8642/health
```

## Open a shell in the running container

The `hermes` command exists only inside the container, so run Hermes commands through `docker exec`:

```bash
docker exec -it hermes-sandbox bash    # open a shell; type exit to leave
docker exec -it hermes-sandbox hermes setup   # or run one command directly
```

## Maintenance

```bash
docker logs -f hermes-sandbox       # follow logs
docker stop hermes-sandbox
docker restart hermes-sandbox
docker run -it --rm --entrypoint /bin/bash -v "$(pwd)/data:/data" hermes   # debug shell
```

## Notes

- Back up `data/` regularly. It holds your API keys.
