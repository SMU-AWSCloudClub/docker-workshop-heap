#!/bin/bash
export PUBLIC_IP=$(curl -s http://checkip.amazonaws.com)
# export PUBLIC_IP='localhost'

# Generate self signed keys first
chmod a+x generate_self-signed-ssl.sh
./generate_self-signed-ssl.sh

# Run docker-compose with the environment variable
docker compose -f docker-compose.cloud.yaml up -d --build

#! Powershell use:
#!$env:PUBLIC_IP = (Invoke-RestMethod http://checkip.amazonaws.com).Trim()
