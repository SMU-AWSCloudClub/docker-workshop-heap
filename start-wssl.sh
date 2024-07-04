#!/bin/bash

# Set the public IP or domain
export PUBLIC_IP='books.bchwy.com' # TODO: replace with your domain
export NEXT_PUBLIC_BACKEND_URL="https://${PUBLIC_IP}/api"

# Run docker-compose with the environment variable
docker compose -f docker-compose.cloud-ssl.yaml up --build -d

# Wait for the services to start
sleep 10

# Obtain SSL certificate using Certbot
docker compose run --rm certbot certonly --webroot --webroot-path=/var/www/certbot -d $PUBLIC_IP

# Reload Nginx to apply the new certificate
docker compose exec nginx nginx -s reload

echo "SSL certificate obtained and Nginx reloaded."