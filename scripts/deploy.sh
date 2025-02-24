#!/bin/bash

# Exit on error
set -e

# Create Kind cluster
echo "Creating Kind cluster..."
kind create cluster --name mysql-data-generator

# Install NGINX Ingress Controller
echo "Installing NGINX Ingress Controller..."
kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/main/deploy/static/provider/kind/deploy.yaml

# Wait for Ingress to be ready
echo "Waiting for Ingress to be ready..."
kubectl wait --namespace ingress-nginx \
  --for=condition=ready pod \
  --selector=app.kubernetes.io/component=controller \
  --timeout=120s

# Build Docker images
echo "Building Docker images..."

# Build Writer image
echo "Building Writer image..."
docker build -t udit7803/mysql-writer:v1 -f src/writer/Dockerfile .

# Build Reader image
echo "Building Reader image..."
docker build -t udit7803/mysql-reader:v1 -f src/reader/Dockerfile .

# Load images into Kind cluster
echo "Loading images into Kind cluster..."
kind load docker-image udit7803/mysql-writer:v1 --name mysql-data-generator
kind load docker-image udit7803/mysql-reader:v1 --name mysql-data-generator

# Deploy MySQL
echo "Deploying MySQL..."
kubectl apply -f manifests/mysql/

# Wait for MySQL to be ready
echo "Waiting for MySQL to be ready..."
kubectl wait --for=condition=ready pod -l app=mysql-master --timeout=120s
kubectl wait --for=condition=ready pod -l app=mysql-slave --timeout=120s

# Deploy Writer
echo "Deploying Writer..."
kubectl apply -f manifests/writer/

# Deploy Reader
echo "Deploying Reader..."
kubectl apply -f manifests/reader/

# Wait for Reader to be ready
echo "Waiting for Reader to be ready..."
kubectl wait --for=condition=ready pod -l app=mysql-reader --timeout=120s

# Deploy Prometheus and Grafana
echo "Deploying Prometheus and Grafana..."
kubectl apply -f manifests/monitoring/

# Wait for Prometheus and Grafana to be ready
echo "Waiting for Prometheus and Grafana to be ready..."
kubectl wait --for=condition=ready pod -l app=prometheus --timeout=120s
kubectl wait --for=condition=ready pod -l app=grafana --timeout=120s

# Print access instructions
echo "Deployment complete!"
echo "To access Grafana, run: kubectl port-forward svc/grafana 3000:3000"
echo "To access the Reader API, run: kubectl port-forward svc/mysql-reader 8080:80"
echo "Open Grafana at http://localhost:3000 and the Reader API at http://localhost:8080"
