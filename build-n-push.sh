#!/bin/bash

# Build and push frontend image
docker build -t bchewy/frontend:latest -f frontend/Dockerfile .
docker push bchewy/frontend:latest

# Build and push backend image
docker build -t bchewy/backend:latest -f backend/Dockerfile .
docker push bchewy/backend:latest
