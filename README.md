# Flappy Backend
This repo contains all of the backend server code for the Flappy Race game which includes
the main server list (under `./list`) and the server game manager (under `./manager`) as submodules.

These services can all be run using docker compose for convenience:
- Server list (to show games on the server browser)
- Server game manager (to host official game servers)
- Nginx with certbot (reverse proxy to route connections to services and keeps HTTPS certificates updated automatically)
- Prometheus + Grafana (display server load and game metrics)
    - Access the dashboard at `/grafana/` on your server e.g. https://localhost/grafana/
- Dozzle (docker container log viewer)
    - View logs at `/dozzle/` on your server e.g. https://localhost/dozzle/

## First Time Setup

1. Copy the `.env.example` file to `.env`:
   ```bash
   cp .env.example .env
   ```

2. Edit `.env` and configure the required values:
   - `HOST_DOMAIN` - Your website domain
   - `CERTBOT_EMAIL` - Your email for HTTPS certificate registration
   - `DOZZLE_ADMIN_PASSWORD` - Password for the Dozzle log viewer
   - `GRAFANA_ADMIN_PASSWORD` - Password for the Grafana dashboard

   ***Do not commit the .env file!***

3. Run the setup script to initialize the environment:
   ```bash
   ./setup.sh
   ```

The setup script will validate your configuration and automatically generate the Dozzle credentials file.
## Development
Ensure all submodules are cloned and updates using `git pull --recurse-submodules`.
Use `docker compose up` to build and run the services using the local code in the submodule repos.

To get HTTPS to work correctly locally add jibby.localhost to your hosts file to point at 127.0.0.1 and add the local CA
from the proxy service container's files (the file to add is `/etc/local_ca/caCert.pem`).
## Production
Use the `./start-prod.sh` and `./stop-prod.sh` scripts to start and stop the services on production servers
which includes some extras such as auto restarting containers and pulling docker images from DockerHub with Watchtower to keep them updated.

You can use `./reload-nginx.sh` to update the nginx config without any downtime.

## Migration
Files and directories to copy across:
- `.env` - All user configuration
- `proxy/user_conf.d/` - Custom NGINX settings

Docker volumes to copy across:
- `grafana-data` - Dashboards and configuration
- `prometheus-data` - (Optional) historical data
