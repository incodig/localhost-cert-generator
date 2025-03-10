# Use a lightweight and secure base image
FROM alpine:latest

# Install necessary packages for certificate generation and Makefile usage
RUN apk add --no-cache openssl make

# Set environment variables for the main directory where the Makefile and certificates are stored
ENV APP_DIR=/app
ENV CERTS_DIR=$APP_DIR/certs
ENV DAYS=365
ENV CA_NAME=localhost

# Create the working directory inside the image
RUN mkdir -p $CERTS_DIR

# Set the working directory
WORKDIR $APP_DIR

# Copy the Makefile and the script into the image
COPY Makefile /Makefile
COPY generate_cert.sh /usr/local/bin/generate_cert.sh

# Grant execution permissions to the script
RUN chmod +x /usr/local/bin/generate_cert.sh

# Run the script when the container starts
CMD ["/bin/sh", "-c", "/usr/local/bin/generate_cert.sh && make -C /app"]
