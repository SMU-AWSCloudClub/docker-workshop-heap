#!/bin/bash

# Variables
DOMAIN="books.bchwy.com"
NGINX_CONF="./nginx.conf"

# Create SSL directory if it doesn't exist
# sudo mkdir -p /etc/nginx/ssl
sudo mkdir ./certs

# Generate a self-signed SSL certificate
sudo openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
    -keyout ./certs/$DOMAIN.key \
    -out ./certs/$DOMAIN.crt \
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

        ssl_certificate /etc/nginx/ssl/$DOMAIN.crt;
        ssl_certificate_key /etc/nginx/ssl/$DOMAIN.key;

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
