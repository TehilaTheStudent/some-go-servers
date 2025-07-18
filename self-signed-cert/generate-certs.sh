#!/bin/sh
set -e

echo "Generating root CA..."
openssl genrsa -out rootCA.key 4096
openssl req -x509 -new -nodes -key rootCA.key -sha256 -days 3650 -out rootCA.crt -subj "/CN=Test Root CA"

echo "Generating intermediate CA..."
openssl genrsa -out intermediateCA.key 4096
openssl req -new -key intermediateCA.key -out intermediateCA.csr -subj "/CN=Test Intermediate CA"
openssl x509 -req -in intermediateCA.csr -CA rootCA.crt -CAkey rootCA.key -CAcreateserial -out intermediateCA.crt -days 1825 -sha256

echo "Generating server key/csr..."
openssl genrsa -out server.key 2048
openssl req -new -key server.key -out server.csr -subj "/CN=localhost"

echo "Signing server cert with intermediate CA..."
openssl x509 -req -in server.csr -CA intermediateCA.crt -CAkey intermediateCA.key -CAcreateserial -out server.crt -days 825 -sha256

# Create chain file (intermediate then root)
cat intermediateCA.crt rootCA.crt > chain.crt

echo "Certificate chain generated."
