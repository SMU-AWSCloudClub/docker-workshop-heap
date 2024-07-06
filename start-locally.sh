#!/bin/bash

# Let our frontend know what backend url we have
export NEXT_PUBLIC_BACKEND_URL="http://localhost/api"

# Run docker-compose with the environment variable
docker compose -f docker-compose.yaml up --build

# Windows ENV: $env:NEXT_PUBLIC_BACKEND_URL = "http://localhost/api"

# An alternative to running this
#but you need to have .env! --> including your NEXT_PUBLIC_BACKEND_URL
docker compose --env-file .env -f docker-compose.yaml up --build
