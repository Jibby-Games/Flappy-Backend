#!/bin/bash
set -e

echo "=== Flappy Backend First-Time Setup ==="
echo ""

# Check if .env file exists
if [ ! -f .env ]; then
    echo "ERROR: .env file not found!"
    echo "Please copy .env.example to .env and fill in the required values:"
    echo "  cp .env.example .env"
    echo "  nano .env  # or use your preferred editor"
    echo ""
    exit 1
fi

echo "✓ Found .env file"

# Load environment variables from .env
set -a
source .env
set +a

echo "✓ Loaded environment variables"

# Validate required variables
MISSING_VARS=""

if [ -z "$CERTBOT_EMAIL" ] || [ "$CERTBOT_EMAIL" = "your-email-address" ]; then
    MISSING_VARS="${MISSING_VARS}  - CERTBOT_EMAIL\n"
fi

if [ -z "$DOZZLE_PASSWORD" ] || [ "$DOZZLE_PASSWORD" = "your-secure-password" ]; then
    MISSING_VARS="${MISSING_VARS}  - DOZZLE_PASSWORD\n"
fi

if [ -z "$GRAFANA_ADMIN_PASSWORD" ] || [ "$GRAFANA_ADMIN_PASSWORD" = "your-secure-password" ]; then
    MISSING_VARS="${MISSING_VARS}  - GRAFANA_ADMIN_PASSWORD\n"
fi

if [ -n "$MISSING_VARS" ]; then
    echo ""
    echo "ERROR: The following required variables are not set in .env:"
    echo -e "$MISSING_VARS"
    echo "Please edit .env and set these values."
    exit 1
fi

echo "✓ Validated required environment variables"

# Create dozzle data directory if it doesn't exist
mkdir -p dozzle/data

# Generate Dozzle credentials
echo ""
echo "Generating Dozzle credentials..."
docker run --rm amir20/dozzle generate admin --password "$DOZZLE_PASSWORD" > dozzle/data/users.yml

if [ $? -eq 0 ]; then
    echo "✓ Dozzle credentials generated successfully"
else
    echo "ERROR: Failed to generate Dozzle credentials"
    exit 1
fi

echo ""
echo "=== Setup Complete! ==="
echo ""
echo "You can now start the services:"
echo "  - Development: docker compose up"
echo "  - Production:  ./start-prod.sh"
echo ""
echo "Access points:"
echo "  - Grafana:  http://localhost:3000 (user: admin)"
echo "  - Dozzle:   http://localhost:8080 (user: admin)"
echo ""
