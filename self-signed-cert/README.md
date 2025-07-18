# Go HTTPS Server with Self-Signed Certificate Chain

## Overview
This project contains a Go HTTPS server that listens on port 8080, logs all HTTP request details, and uses a self-signed certificate chain (root CA, intermediate CA, server cert) for testing.

## Files
- `main.go`: Go server source code
- `Dockerfile`: Containerization instructions
- `generate-certs.sh`: Shell script to generate a root CA, intermediate CA, server certificate, and chain
- `README.md`: This documentation

## Usage

### 1. Generate Certificates
Run the shell script (requires OpenSSL):

```sh
sh generate-certs.sh
```

This will create:
- `rootCA.crt`, `rootCA.key`: Root CA
- `intermediateCA.crt`, `intermediateCA.key`: Intermediate CA
- `server.crt`, `server.key`: Server certificate and key
- `chain.crt`: Certificate chain (intermediate + root)
- `server-bundle.crt`: Used by the Go server (auto-generated on server start)

### 2. Build and Run Locally

```sh
go run main.go
```

Server will be available at: https://localhost:8080/

### 3. Build and Run with Docker

```sh
docker build -t go-https-server .
docker run -p 8080:8080 go-https-server
```

### 4. Testing
- Use curl or a browser to connect: `curl -k https://localhost:8080/`
- All request details are logged to stdout

---

**Note:** The certificates are for testing only and should not be used in production.
