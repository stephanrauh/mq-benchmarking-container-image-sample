FROM amazonlinux:2023
USER root

# Install dependencies
WORKDIR /app/
COPY setup.sh .
RUN yum update -y && \
    ./setup.sh && \
    yum -y clean all

# Copy project files
WORKDIR /app/
COPY . .

# Build the Java project
RUN ./mvnw clean package -q

# Make scripts executable
RUN chmod +x run-*.sh entrypoint.sh

EXPOSE 80

ENTRYPOINT ["./entrypoint.sh"]