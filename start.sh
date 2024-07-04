#!/bin/bash

# Set the public IP or domain
# Uncomment the following line if using non-SSL
# export PUBLIC_IP=$(curl -s http://checkip.amazonaws.com)

# This is for SSL
export PUBLIC_IP='books.bchwy.com' # TODO: replace with your domain
export NEXT_PUBLIC_BACKEND_URL="https://${PUBLIC_IP}/api"

# Generate self-signed SSL certificate
DOMAIN="books.bchwy.com" # Change this to your group domain
SSL_DIR="/etc/nginx/ssl"
NGINX_CONF="/etc/nginx/nginx.conf"

# Create SSL directory if it doesn't exist
sudo mkdir -p $SSL_DIR

# Generate a self-signed SSL certificate
sudo openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
    -keyout $SSL_DIR/$DOMAIN.key \
    -out $SSL_DIR/$DOMAIN.crt \
    -subj "/C=US/ST=State/L=City/O=Organization/OU=Department/CN=$DOMAIN"

# Update Nginx configuration
sudo tee $NGINX_CONF >/dev/null <<EOL
events {
    worker_connections 1024;
}

http {
    server {
        listen 80;
        server_name $DOMAIN;

        # Redirect all HTTP requests to HTTPS
        return 301 https://\$host\$request_uri;
    }

    server {
        listen 443 ssl;
        server_name $DOMAIN;

        ssl_certificate $SSL_DIR/$DOMAIN.crt;
        ssl_certificate_key $SSL_DIR/$DOMAIN.key;

        ssl_protocols TLSv1.2 TLSv1.3;
        ssl_ciphers HIGH:!aNULL:!MD5;

        location / {
            proxy_pass http://frontend:3000;
            proxy_set_header Host \$host;
            proxy_set_header X-Real-IP \$remote_addr;
            proxy_set_header X-Forwarded-For \$proxy_add_x_forwarded_for;
            proxy_set_header X-Forwarded-Proto \$scheme;
        }

        location /api/ {
            proxy_pass http://backend:8080;
            proxy_set_header Host \$host;
            proxy_set_header X-Real-IP \$remote_addr;
            proxy_set_header X-Forwarded-For \$proxy_add_x_forwarded_for;
            proxy_set_header X-Forwarded-Proto \$scheme;
        }
    }
}
EOL

echo "SSL certificate generated and Nginx configuration updated."

# Run docker-compose with the environment variable
docker compose -f docker-compose.cloud.yaml up --build
