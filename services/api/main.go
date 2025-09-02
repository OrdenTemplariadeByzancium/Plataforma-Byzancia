package main

import (
	"encoding/json"
	"fmt"
	"log"
	"net/http"
	"strconv"
	"strings"
)

// User representa un usuario simple
type User struct {
	ID   int    `json:"id"`
	Name string `json:"name"`
}

var users = []User{
	{ID: 1, Name: "Alice"},
	{ID: 2, Name: "Bob"},
}

func main() {
	http.HandleFunc("/health", healthHandler)
	http.HandleFunc("/users", usersHandler)
	http.HandleFunc("/users/", userByIDHandler) // /users/1

	fmt.Println("🚀 API escuchando en puerto 8080")
	if err := http.ListenAndServe(":8080", nil); err != nil {
		log.Fatal(err)
	}
}

func healthHandler(w http.ResponseWriter, r *http.Request) {
	w.WriteHeader(http.StatusOK)
	w.Write([]byte(`{"status":"ok"}`))
}

func usersHandler(w http.ResponseWriter, r *http.Request) {
	if r.Method == http.MethodGet {
		w.Header().Set("Content-Type", "application/json")
		json.NewEncoder(w).Encode(users)
		return
	}
	w.WriteHeader(http.StatusMethodNotAllowed)
}

func userByIDHandler(w http.ResponseWriter, r *http.Request) {
	if r.Method == http.MethodGet {
		// Extraer ID desde la URL: /users/{id}
		parts := strings.Split(r.URL.Path, "/")
		if len(parts) < 3 {
			http.Error(w, "ID requerido", http.StatusBadRequest)
			return
		}
		id, err := strconv.Atoi(parts[2])
		if err != nil {
			http.Error(w, "ID inválido", http.StatusBadRequest)
			return
		}

		for _, u := range users {
			if u.ID == id {
				w.Header().Set("Content-Type", "application/json")
				json.NewEncoder(w).Encode(u)
				return
			}
		}
		http.Error(w, "Usuario no encontrado", http.StatusNotFound)
		return
	}
	w.WriteHeader(http.StatusMethodNotAllowed)
}
