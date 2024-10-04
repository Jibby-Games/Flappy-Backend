# Flappy Backend
This repo contains all of the backend server code for the Flappy Race game which includes
the main server list (under `./list`) and the server game manager (under `./manager`) as submodules.

These services can all be run using docker compose for convenience:
- Server list (to show games on the server browser)
- Server game manager (to host official game servers)
- Watchtower (auto updates docker images)
- Nginx with certbot (reverse proxy to route connections to services and keeps HTTPS certificates updated automatically)
- Prometheus + Grafana (display server load and game metrics)
    - Access the dashboard through port 3000 on your server e.g. http://localhost:3000
- Dozzle (docker container log viewer)
    - View logs through port 8080 on your server e.g. http://localhost:8080

## Setup
### Certbot Automatic HTTPS Certificates
In order to support HTTPS a `./proxy/.env` file is needed with a valid email address which certbot can use to request certificates.
Make a copy of the `.env.example` file in the `proxy` directory and rename it `.env` and add your email address to set the `CERTBOT_EMAIL` env var.

***Do not commit the .env file!***

### Grafana Metrics
Setup admin access by going to the dashboard on http://localhost:3000 and then enter `admin` as username and password for the first time setup.

### Dozzle Log Viewer
To use it you must first generate credential by running this command:
```bash
docker run amir20/dozzle generate admin --password "YOUR PASSWORD" > dozzle/data/users.yml
```
This will store the credentials in the `./dozzle/users.yml` file with the password hashed for security.

***Do not commit the users.yml file!***
## Development
Ensure all submodules are cloned and updates using `git pull --recurse-submodules`.
Use `docker compose up` to build and run the services using the local code in the submodule repos,
without Watchtower auto updating images.

To get HTTPS to work correctly locally add jibby.localhost to your hosts file to point at 127.0.0.1 and add the local CA
from the proxy service container's files (the file to add is `/etc/local_ca/caCert.pem`).
## Production
Use the `./start-prod.sh` and `./stop-prod.sh` scripts to start and stop the services on production servers
which includes some extras such as auto restarting containers and pulling docker images from DockerHub with Watchtower to keep them updated.

You can use `./reload-nginx.sh` to update the nginx config without any downtime.