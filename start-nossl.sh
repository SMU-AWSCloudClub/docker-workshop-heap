#!/bin/bash

# Set the public IP or domain
# Uncomment the following line if using non-SSL
export PUBLIC_IP=$(curl -s http://checkip.amazonaws.com)
export NEXT_PUBLIC_BACKEND_URL="http://${PUBLIC_IP}/api"

# Update Nginx configuration
sudo tee $NGINX_CONF >/dev/null <<EOL
events {
    worker_connections 1024;
}

http {
    server {
        listen 80;
        server_name $DOMAIN;

        location / {
            proxy_pass http://frontend:3000;
            proxy_set_header Host \$host;
            proxy_set_header X-Real-IP \$remote_addr;
            proxy_set_header X-Forwarded-For \$proxy_add_x_forwarded_for;
            proxy_set_header X-Forwarded-Proto \$scheme;
        }

        location /api {
            proxy_pass http://backend:8080;
            proxy_set_header Host \$host;
            proxy_set_header X-Real-IP \$remote_addr;
            proxy_set_header X-Forwarded-For \$proxy_add_x_forwarded_for;
            proxy_set_header X-Forwarded-Proto \$scheme;
        }
    }
}
EOL

echo "Nginx configuration updated."

# Run docker-compose with the environment variable
docker compose -f docker-compose.cloud.yaml up --build
