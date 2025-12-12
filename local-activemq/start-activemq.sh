#!/bin/bash

# Stop and remove existing container if it exists
docker stop activemq 2>/dev/null || true
docker rm activemq 2>/dev/null || true

# Build the image
docker build -t local-activemq .

# Run the container
docker run -d --name activemq -p 61616:61616 -p 8161:8161 local-activemq

# Show container status
echo "ActiveMQ container started:"
docker ps | grep activemq
echo "Web console: http://localhost:8161"
echo "Broker port: 61616"
