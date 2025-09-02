package main

import (
	"fmt"
	"net/http"
)

func main() {
	http.HandleFunc("/healthz", func(w http.ResponseWriter, r *http.Request) {
		fmt.Fprint(w, "ok")
	})
	http.HandleFunc("/", func(w http.ResponseWriter, r *http.Request) {
		fmt.Fprint(w, "Byzancia API v0.1")
	})

	// Escucha en 8080 (coincide con el Dockerfile)
	if err := http.ListenAndServe(":8080", nil); err != nil {
		panic(err)
	}
}
