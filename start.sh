#!/bin/bash

# Fetch the public IP
export PUBLIC_IP=$(curl -s http://checkip.amazonaws.com)

# Run docker-compose with the environment variable
docker-compose up -d