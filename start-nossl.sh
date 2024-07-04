#!/bin/bash

# Set the public IP or domain
# Uncomment the following line if using non-SSL
export PUBLIC_IP=$(curl -s http://checkip.amazonaws.com)
export NEXT_PUBLIC_BACKEND_URL="http://${PUBLIC_IP}/api"

# Run docker-compose with the environment variable
docker compose -f docker-compose.yaml up --build
