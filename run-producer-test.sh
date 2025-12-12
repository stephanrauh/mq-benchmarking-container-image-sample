#!/bin/bash

# Build the project first
echo "Building project..."
./mvnw clean package -q

# Create reports directory
mkdir -p reports

# Run producer performance test
echo "Starting producer performance test (peak performance)..."
java -jar amazon-mq-client/target/amazon-mq-client.jar \
  -url tcp://localhost:61616 \
  -user admin \
  -password admin \
  -mode sender \
  -type queue \
  -destination PERF.TEST \
  -interval 0

echo "Producer test completed."
