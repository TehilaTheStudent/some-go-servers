package main

import (
	"crypto/tls"
	"fmt"
	"io"
	"log"
	"net/http"
	"os"
	"strings"
)

func logRequest(r *http.Request) {
	log.Println("--- Incoming Request ---")
	log.Printf("RemoteAddr: %s", r.RemoteAddr)
	log.Printf("Method: %s", r.Method)
	log.Printf("URL: %s", r.URL.String())
	log.Println("Headers:")
	for k, v := range r.Header {
		log.Printf("  %s: %s", k, strings.Join(v, ", "))
	}
	if r.ContentLength > 0 {
		body, err := io.ReadAll(r.Body)
		if err != nil {
			log.Printf("Error reading body: %v", err)
		} else {
			log.Printf("Body: %s", string(body))
		}
		// Reconstruct body for further use
		r.Body = io.NopCloser(strings.NewReader(string(body)))
	}
}

func helloHandler(w http.ResponseWriter, r *http.Request) {
	logRequest(r)
	fmt.Fprintf(w, "Hello, HTTPS world!\n")
}

func main() {
	certFile := "certs/server.crt"
	keyFile := "certs/server.key"
	chainFile := "certs/chain.crt"

	mux := http.NewServeMux()
	mux.HandleFunc("/", helloHandler)

	server := &http.Server{
		Addr:    ":8080",
		Handler: mux,
		TLSConfig: &tls.Config{
			MinVersion: tls.VersionTLS12,
			// Optionally require client certs for mTLS testing
		},
	}

	// Concatenate server cert and chain for correct chain presentation
	bundleFile := "certs/server-bundle.crt"
	bundle, err := os.Create(bundleFile)
	if err != nil {
		log.Fatalf("Failed to create bundle: %v", err)
	}
	for _, f := range []string{certFile, chainFile} {
		in, err := os.Open(f)
		if err != nil {
			log.Fatalf("Failed to open %s: %v", f, err)
		}
		io.Copy(bundle, in)
		in.Close()
	}
	bundle.Close()

	log.Printf("Starting HTTPS server on https://0.0.0.0:8080 ...")
	if err := server.ListenAndServeTLS(bundleFile, keyFile); err != nil {
		log.Fatalf("Server failed: %v", err)
	}
}
