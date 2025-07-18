# 1. Build stage
FROM golang:1.21-alpine AS builder

WORKDIR /app

# Copy Go code and certs
COPY main.go .
COPY certs/ certs/

# Build the Go server
RUN go build -o https-server main.go

# 2. Runtime stage
FROM alpine:latest

WORKDIR /app

# Copy binary and certs from builder
COPY --from=builder /app/https-server .
COPY --from=builder /app/certs/ certs/

# Expose HTTPS port
EXPOSE 8443

# Run the HTTPS server
CMD ["./https-server"]
