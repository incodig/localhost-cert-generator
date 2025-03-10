#!/bin/sh

# Set default values for environment variables if they are not already set.
if [ -z "$APP_DIR" ]; then
  APP_DIR="/app"
fi

if [ -d "$APP_DIR/certs" ]; then
  CERTS_DIR="$APP_DIR/certs"
fi

if [ -z "$DAYS" ]; then
  DAYS=365
fi

if [ -z "$CA_NAME" ]; then
  CA_NAME="localhost"
fi

# Create the directory to store certificates if it doesn't already exist.
if [ ! -d "$CERTS_DIR" ]; then
  mkdir -p "$CERTS_DIR"
fi

# Check if Makefile exists before copying it to the certificates directory.
if [ -f "/Makefile" ]; then
    cp "/Makefile" "$APP_DIR/Makefile"
    echo "Makefile copied successfully."
else
    echo "Warning: Makefile not found. It was not copied."
fi

# Begin generating SSL certificates for localhost using the specified CA.
echo "Generating SSL certificates for localhost with Certificate Authority '$CA_NAME'..."

# Generate the Certificate Authority (CA) certificate and private key.
openssl req -x509 -new -nodes -keyout "$CERTS_DIR/$CA_NAME-ca.key" -out "$CERTS_DIR/$CA_NAME-ca.crt" -days $DAYS -subj "/CN=$CA_NAME Root CA"

# Generate a new private key for localhost.
openssl genpkey -algorithm RSA -out "$CERTS_DIR/localhost.key"

# Generate a Certificate Signing Request (CSR) for localhost using the generated private key.
openssl req -new -key "$CERTS_DIR/localhost.key" -out "$CERTS_DIR/localhost.csr" -subj "/CN=localhost"

if [ ! -f "$CERTS_DIR/localhost.ext" ]; then
# Create a configuration file for extensions to be used in certificate signing request.
cat <<EOF > "$CERTS_DIR/localhost.ext"
authorityKeyIdentifier=keyid,issuer
basicConstraints=CA:FALSE
keyUsage = digitalSignature, keyEncipherment
extendedKeyUsage = serverAuth
subjectAltName = @alt_names

[alt_names]
DNS.1 = localhost
DNS.2 = www.localhost
IP.1 = 127.0.0.1
IP.2 = ::1
EOF
fi

# Sign the certificate with the CA and generate the final certificate.
openssl x509 -req -in "$CERTS_DIR/localhost.csr" -CA "$CERTS_DIR/$CA_NAME-ca.crt" -CAkey "$CERTS_DIR/$CA_NAME-ca.key" -CAcreateserial -out "$CERTS_DIR/localhost.crt" -days $DAYS -sha256 -extfile "$CERTS_DIR/localhost.ext"

# Notify the user that certificates have been generated successfully.
echo "SSL certificates generated successfully and saved in '$CERTS_DIR'!"
