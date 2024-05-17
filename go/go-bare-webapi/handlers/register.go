package handlers

import (
	"database/sql"
	"encoding/json"
	"net/http"

	"github.com/mattn/go-sqlite3"
)

type UserCredentials struct {
	Username string `json:"username"`
	Password string `json:"password"`
}

func RegisterHandler(db *sql.DB) http.HandlerFunc {
	return func(w http.ResponseWriter, r *http.Request) {
		var creds UserCredentials
		if err := json.NewDecoder(r.Body).Decode(&creds); err != nil {
			http.Error(w, "Invalid request body", http.StatusBadRequest)
			return
		}

		// Prepare to insert a new user
		statement, err := db.Prepare("INSERT INTO users (username, password, roles) VALUES (?, ?, ?)")
		if err != nil {
			http.Error(w, "Failed to prepare the database statement", http.StatusInternalServerError)
			return
		}
		defer statement.Close()

		// Default role for simplicity
		defaultRoles, _ := json.Marshal([]string{"user"})
		_, err = statement.Exec(creds.Username, creds.Password, string(defaultRoles))
		if err != nil {
			if sqliteErr, ok := err.(sqlite3.Error); ok && sqliteErr.ExtendedCode == sqlite3.ErrConstraintUnique {
				http.Error(w, "Username already exists", http.StatusConflict)
				return
			}
			http.Error(w, "Failed to register the user", http.StatusInternalServerError)
			return
		}

		w.Write([]byte("User registered successfully"))
	}
}

func RegisterAdminHandler(db *sql.DB) http.HandlerFunc {
	return func(w http.ResponseWriter, r *http.Request) {
		var creds UserCredentials
		if err := json.NewDecoder(r.Body).Decode(&creds); err != nil {
			http.Error(w, "Invalid request body", http.StatusBadRequest)
			return
		}

		// Prepare to insert a new user
		statement, err := db.Prepare("INSERT INTO users (username, password, roles) VALUES (?, ?, ?)")
		if err != nil {
			http.Error(w, "Failed to prepare the database statement", http.StatusInternalServerError)
			return
		}
		defer statement.Close()

		// Default role for simplicity
		defaultRoles, _ := json.Marshal([]string{"admin"})
		_, err = statement.Exec(creds.Username, creds.Password, string(defaultRoles))
		if err != nil {
			if sqliteErr, ok := err.(sqlite3.Error); ok && sqliteErr.ExtendedCode == sqlite3.ErrConstraintUnique {
				http.Error(w, "Username already exists", http.StatusConflict)
				return
			}
			http.Error(w, "Failed to register the user", http.StatusInternalServerError)
			return
		}

		w.Write([]byte("User registered successfully"))
	}
}
