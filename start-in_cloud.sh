#!/bin/bash

# Let our frontend know what backend url we have
# ? In this version, it is a bit special as we're trying to get the IP for our backend.
export PUBLIC_IP=$(curl -s http://checkip.amazonaws.com)
export NEXT_PUBLIC_BACKEND_URL="http://${PUBLIC_IP}/api"

# Run docker-compose with the environment variable
docker compose -f docker-compose.yaml up --build
