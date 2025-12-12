#!/bin/bash

# Build the project first
echo "Building project..."
./mvnw clean package -q

# Create reports directory
mkdir -p reports

# Run consumer performance test
echo "Starting consumer performance test..."
java -jar amazon-mq-client/target/amazon-mq-client.jar \
  -url tcp://localhost:61616 \
  -user admin \
  -password admin \
  -mode receiver \
  -type queue \
  -destination PERF.TEST

echo "Consumer test completed."
