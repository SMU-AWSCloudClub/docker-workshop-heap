#!/bin/bash

# Set the public IP or domain
# Uncomment the following line if using non-SSL
export NEXT_PUBLIC_BACKEND_URL="http://localhost/api"

# Run docker-compose with the environment variable
docker compose -f docker-compose.yaml up --build

# Windows ENV: $env:NEXT_PUBLIC_BACKEND_URL = "http://localhost/api"
