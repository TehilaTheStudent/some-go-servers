mkdir certs && cd certs

# 1. Generate root key
openssl genrsa -out rootCA.key 2048

# 2. Generate root certificate
openssl req -x509 -new -nodes -key rootCA.key -sha256 -days 3650 -out rootCA.crt -subj "/C=US/ST=Test/L=Local/O=TestRootCA/CN=Test Root CA"

# 3. Generate intermediate key
openssl genrsa -out intermediateCA.key 2048

# 4. Create intermediate CSR
openssl req -new -key intermediateCA.key -out intermediateCA.csr -subj "/C=US/ST=Test/L=Local/O=TestIntermediateCA/CN=Test Intermediate CA"

# 5. Sign intermediate with root
openssl x509 -req -in intermediateCA.csr -CA rootCA.crt -CAkey rootCA.key -CAcreateserial -out intermediateCA.crt -days 3650 -sha256

# 6. Generate server key
openssl genrsa -out server.key 2048

# 7. Create server CSR
openssl req -new -key server.key -out server.csr -subj "/C=US/ST=Test/L=Local/O=TestServer/CN=localhost"

# 8. Sign server cert with intermediate CA
openssl x509 -req -in server.csr -CA intermediateCA.crt -CAkey intermediateCA.key -CAcreateserial -out server.crt -days 365 -sha256

# 9. Create a certificate chain (intermediate first, then root)
cat intermediateCA.crt rootCA.crt > chain.crt
        