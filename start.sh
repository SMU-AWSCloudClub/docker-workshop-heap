#!/bin/bash

# ? uncomment if using non-ssl
# export PUBLIC_IP=$(curl -s http://checkip.amazonaws.com)

# ? this is for SSL
export PUBLIC_IP='books.bchwy.com' # TODO: replace with your domain
export NEXT_PUBLIC_BACKEND_URL="https://${PUBLIC_IP}/api"


# Generate self signed keys first
chmod a+x generate_self-signed-ssl.sh
./generate_self-signed-ssl.sh

# Run docker-compose with the environment variable
docker compose -f docker-compose.cloud.yaml up --build

#! Powershell use:
#!$env:PUBLIC_IP = (Invoke-RestMethod http://checkip.amazonaws.com).Trim()
