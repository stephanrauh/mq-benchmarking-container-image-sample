#!/bin/bash

# Build the project first
echo "Building project..."
./mvnw clean package -q

# Create reports directory
mkdir -p reports

echo "Starting combined producer/consumer performance test (30 seconds, peak performance)..."
echo "Queue: PERF.TEST"
echo "Broker: tcp://localhost:61616"

# Start consumer in background
java -jar amazon-mq-client/target/amazon-mq-client.jar \
  -url tcp://localhost:61616 \
  -user admin \
  -password admin \
  -mode receiver \
  -type queue \
  -destination PERF.TEST &

CONSUMER_PID=$!

# Start producer in background
java -jar amazon-mq-client/target/amazon-mq-client.jar \
  -url tcp://localhost:61616 \
  -user admin \
  -password admin \
  -mode sender \
  -type queue \
  -destination PERF.TEST \
  -interval 0 &

PRODUCER_PID=$!

# Run for 30 seconds
echo "Running for 30 seconds..."
sleep 30

# Stop both processes
echo "Stopping test..."
kill $PRODUCER_PID 2>/dev/null
kill $CONSUMER_PID 2>/dev/null

# Wait a moment for processes to terminate
sleep 2

echo "Performance test completed (30 seconds)."
