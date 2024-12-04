#!/bin/bash
# Kyle Cox ~ CEG3120
# Bash script for CD/Project5

# Kill and remove the previous running container
docker stop angular-site
docker rm angular-site

# Pull the image from my DockerHub repository
docker pull kclondon22/cox-ceg3120:latest

# Start a new container with the freshly pulled image
docker run -d --name angular-site --restart always -p 80:5000 kclondon22/cox-ceg3120:latest

# Test that the script is successful (printing out docker containers)
docker ps -a
