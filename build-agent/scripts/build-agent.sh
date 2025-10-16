#!/bin/bash
set -e

# Permisos Docker
sudo usermod -aG docker azureuser

USER_VM="azureuser"
IMAGE_NAME="michael2209/fullstack-app:v1.0"
REPO_URL="https://github.com/michaelcriss-dev/fullstack-app.git"

# Permisos Docker
sudo usermod -aG docker azureuser

# Clonar o actualizar repositorio
git clone $REPO_URL


# Build Docker image
docker build -t "$IMAGE_NAME" .
echo "$DOCKER_PASS" | docker login -u "$DOCKER_USER" --password-stdin

# Push Docker Image
echo "Subiendo imagen a Docker Hub..."
docker push "$IMAGE_NAME"
echo "Script completado correctamente."