#!/bin/bash

# Default values
BROKER_URL=${BROKER_URL:-"tcp://localhost:61616"}
BROKER_USER=${BROKER_USER:-"admin"}
BROKER_PASSWORD=${BROKER_PASSWORD:-"admin"}
TEST_DURATION=${TEST_DURATION:-"30"}

echo "Starting MQ Performance Test"
echo "Broker URL: $BROKER_URL"
echo "User: $BROKER_USER"
echo "Duration: ${TEST_DURATION} seconds"
echo "================================"

# Start consumer in background
java -jar amazon-mq-client/target/amazon-mq-client.jar \
  -url "$BROKER_URL" \
  -user "$BROKER_USER" \
  -password "$BROKER_PASSWORD" \
  -mode receiver \
  -type queue \
  -destination PERF.TEST &

CONSUMER_PID=$!

# Start producer in background
java -jar amazon-mq-client/target/amazon-mq-client.jar \
  -url "$BROKER_URL" \
  -user "$BROKER_USER" \
  -password "$BROKER_PASSWORD" \
  -mode sender \
  -type queue \
  -destination PERF.TEST \
  -interval 0 &

PRODUCER_PID=$!

# Run for specified duration
echo "Running for ${TEST_DURATION} seconds..."
sleep "$TEST_DURATION"

# Stop both processes
echo "Stopping test..."
kill $PRODUCER_PID 2>/dev/null
kill $CONSUMER_PID 2>/dev/null

# Wait for processes to terminate
wait $PRODUCER_PID 2>/dev/null
wait $CONSUMER_PID 2>/dev/null

echo "Performance test completed."
