package handlers

import (
	"database/sql"
	"encoding/json"
	common "go-bare-webapi/common"
	models "go-bare-webapi/models"
	"net/http"
	"time"

	"github.com/dgrijalva/jwt-go"
)

func CreateTokenHandler(db *sql.DB) http.HandlerFunc {
	return func(w http.ResponseWriter, r *http.Request) {
		var creds UserCredentials
		err := json.NewDecoder(r.Body).Decode(&creds)
		if err != nil {
			w.WriteHeader(http.StatusBadRequest)
			return
		}

		var dbPassword, dbRoles string
		err = db.QueryRow("SELECT password, roles FROM users WHERE username = ?", creds.Username).Scan(&dbPassword, &dbRoles)
		if err != nil {
			if err == sql.ErrNoRows {
				w.WriteHeader(http.StatusUnauthorized)
			} else {
				w.WriteHeader(http.StatusInternalServerError)
			}
			return
		}

		if dbPassword != creds.Password {
			w.WriteHeader(http.StatusUnauthorized)
			return
		}

		var roles []string
		json.Unmarshal([]byte(dbRoles), &roles)

		expirationTime := time.Now().Add(30 * time.Minute)
		claims := &models.Claims{
			Username: creds.Username,
			Roles:    roles,
			StandardClaims: jwt.StandardClaims{
				ExpiresAt: expirationTime.Unix(),
			},
		}

		token := jwt.NewWithClaims(jwt.SigningMethodHS256, claims)
		tokenString, err := token.SignedString(common.JwtKey)
		if err != nil {
			w.WriteHeader(http.StatusInternalServerError)
			return
		}

		w.Write([]byte(tokenString))
	}
}
