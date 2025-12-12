# Amazon MQ ActiveMQ: Container Image Guide

## Overview

This container repository provides you with flexibility to create your image for benchmarking both on desktop and also on Amazon ECR. You can use your built/created image as `container_repo_url` [here](https://github.com/aws-samples/mq-benchmarking-sample). 

This repository applies to only open wire protocol. If you need to use other protocols and clients, kindly refer to [Amazon MQ workshop](https://github.com/aws-samples/amazon-mq-workshop) 

## Prerequisites

* Install [Docker Desktop](https://www.docker.com/products/docker-desktop/).
* Java 25 with Maven wrapper (included in project)
* If you are pushing the image to ECR, make sure the assigned role/user has the necessary [permissions](https://docs.aws.amazon.com/AmazonECR/latest/userguide/image-push.html) 

## Local Performance Testing

### Quick Start

1. **Start local ActiveMQ**
   ```bash
   cd local-activemq
   ./start-activemq.sh
   ```

2. **Run performance tests**
   ```bash
   cd ..
   ./run-perf-test.sh        # Combined producer/consumer test (30 seconds)
   # OR
   ./run-producer-test.sh    # Producer only
   ./run-consumer-test.sh    # Consumer only
   ```

### Test Configuration
- **Broker**: tcp://localhost:61616
- **Queue**: PERF.TEST
- **Credentials**: admin/admin
- **Message interval**: 0ms (peak performance)
- **Duration**: 30 seconds (automatic stop)

### ActiveMQ Web Console
- **URL**: http://localhost:8161
- **Username**: admin
- **Password**: admin

## Container Performance Testing

### Automatic Performance Testing

1. **Build the container**
   ```bash
   docker build -t mq-benchmark .
   ```

2. **Run with default settings** (30 seconds, localhost:61616, admin/admin)
   ```bash
   docker run --rm --network host mq-benchmark
   ```

3. **Run with custom parameters**
   ```bash
   docker run --rm --network host \
     -e BROKER_URL="tcp://my-broker:61616" \
     -e BROKER_USER="myuser" \
     -e BROKER_PASSWORD="mypass" \
     -e TEST_DURATION="60" \
     mq-benchmark
   ```

### Environment Variables
- **`BROKER_URL`** - Default: `tcp://localhost:61616`
- **`BROKER_USER`** - Default: `admin`
- **`BROKER_PASSWORD`** - Default: `admin`
- **`TEST_DURATION`** - Default: `30` seconds

### Container Behavior
- Starts automatically when container runs
- Shows configuration (URL, user, duration)
- Runs performance test for specified duration
- Stops automatically when test completes
- Container exits when Java programs stop

### Manual Container Testing

For interactive testing or debugging:

```bash
# Run container with bash shell
docker run --rm -it --network host --entrypoint /bin/bash mq-benchmark

# Inside container, run tests manually:
./run-perf-test.sh        # Combined test
./run-producer-test.sh    # Producer only
./run-consumer-test.sh    # Consumer only
```

## Complete Workflow Example

```bash
# 1. Start local ActiveMQ
cd local-activemq
./start-activemq.sh

# 2. Build performance test container
cd ..
docker build -t mq-benchmark .

# 3. Run performance test (automatic)
docker run --rm --network host mq-benchmark

# 4. View results in ActiveMQ console
# Open http://localhost:8161 (admin/admin)
```

## Push to ECR

For deployment to Amazon ECR, refer to [ECS documentation](https://docs.aws.amazon.com/AmazonECS/latest/developerguide/create-container-image.html#create-container-image-push-ecr).

## Technical Details

- **Java Version**: 25 (Amazon Corretto)
- **Build Tool**: Maven with wrapper
- **ActiveMQ Version**: 5.18.7
- **Protocol**: OpenWire
- **Performance**: Peak throughput with 1-second logging intervals
