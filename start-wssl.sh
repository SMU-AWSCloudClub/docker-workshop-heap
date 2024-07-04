#!/bin/bash

# Set the public IP or domain
export PUBLIC_IP='books.bchwy.com' # TODO: replace with your domain
export NEXT_PUBLIC_BACKEND_URL="https://${PUBLIC_IP}/api"

# Run docker-compose with the environment variable
docker compose -f docker-compose.cloud-ssl.yaml up --build -d

# Wait for the services to start
sleep 10

# Check the status of the containers
docker compose -f docker-compose.cloud-ssl.yaml ps

# Obtain SSL certificate using Certbot
docker compose -f docker-compose.cloud-ssl.yaml run --rm certbot certonly --webroot --webroot-path=/var/www/certbot -d $PUBLIC_IP

# Reload Nginx to apply the new certificate
docker compose -f docker-compose.cloud-ssl.yaml exec nginx nginx -s reload

# Check the status of the containers again
docker compose -f docker-compose.cloud-ssl.yaml ps

# Check logs for any issues
# docker-compose -f docker-compose.cloud-ssl.yaml logs nginx
# docker-compose -f docker-compose.cloud-ssl.yaml logs backend
# docker-compose -f docker-compose.cloud-ssl.yaml logs frontend
# docker-compose -f docker-compose.cloud-ssl.yaml logs certbot

echo "SSL certificate obtained and Nginx reloaded."