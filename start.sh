#!/bin/bash

# Fetch the public IP ##! uncomment when going to deploy in Ec2 
# export PUBLIC_IP=$(curl -s http://checkip.amazonaws.com)
export PUBLIC_IP='localhost'

# Run docker-compose with the environment variable
docker-compose up -d --build