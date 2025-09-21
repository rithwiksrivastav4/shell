#!/bin/bash

set -e  # Exit on any error

# -------------------------------
# Configuration (set these)
# -------------------------------
REPO_URL="https://github.com/rithwiksrivastav4/django-applications.git"
APP_DIR="django-applications/leature3"
IMAGE_NAME="basic-project"
DOCKER_USERNAME="${DOCKER_USERNAME:?Please set DOCKER_USERNAME env variable}"
DOCKER_PASSWORD="${DOCKER_PASSWORD:?Please set DOCKER_PASSWORD env variable}"

# -------------------------------
# Functions
# -------------------------------

code_clone(){
    if [ ! -d "django-applications" ]; then
        echo "Cloning the git repo..."
        git clone "$REPO_URL"
    else
        echo "Repo already exists, skipping clone."
    fi
    cd "$APP_DIR" || exit 1
}

install_requirements(){
    echo "Installing dependencies..."
    sudo apt-get update -y
    sudo apt-get install -y nginx git curl

    # Install Docker
    curl -fsSL https://get.docker.com -o install-docker.sh
    sh install-docker.sh
    rm install-docker.sh

    # Add current user to docker group (effective on next login)
    sudo usermod -aG docker $USER

    # Install Docker Compose plugin
    sudo apt-get install -y docker-compose-plugin
}

deploy(){
    echo "Building the Docker image..."
    sudo docker build -t "$IMAGE_NAME" .

    echo "Tagging the image for Docker Hub..."
    sudo docker tag "$IMAGE_NAME" "$DOCKER_USERNAME/$IMAGE_NAME:latest"

    echo "Logging in to Docker Hub..."
    echo "$DOCKER_PASSWORD" | sudo docker login -u "$DOCKER_USERNAME" --password-stdin

    echo "Pushing the image to Docker Hub..."
    sudo docker push "$DOCKER_USERNAME/$IMAGE_NAME:latest"

    echo "Starting containers with Docker Compose..."
    sudo docker compose up -d
}

# -------------------------------
# Main Script
# -------------------------------
echo "********** DEPLOYMENT STARTED *********"

code_clone
install_requirements

echo "NOTE: Docker group changes will take effect after logout/login."
echo "For now, using sudo for Docker commands."

deploy

echo "********** DEPLOYMENT DONE *********"
