FROM jonasal/nginx-certbot:4.3.0-nginx1.25.2

# Install curl for healthcheck
RUN apt update && apt install -y curl

HEALTHCHECK --interval=1m --timeout=10s --retries=3 --start-period=1m \
    CMD curl --fail localhost || exit 1
