package main

import (
	"fmt"
	"log"
	"net/http"
)

func handler(w http.ResponseWriter, r *http.Request) {
	fmt.Fprintln(w, "Hello from self-signed HTTPS server!")
}

func main() {
	http.HandleFunc("/", handler)

	fmt.Println("Starting HTTPS server on https://localhost:8443")
	err := http.ListenAndServeTLS(":8443", "certs/cert.pem", "certs/key.pem", nil)
	if err != nil {
		log.Fatal(err)
	}
}
