package middlewares

import (
	"context"
	"go-bare-webapi/common"
	"go-bare-webapi/models"
	"net/http"

	"github.com/dgrijalva/jwt-go"
)

// authenticateMiddleware checks for valid JWT and proceeds if valid
func Authenticate(next http.HandlerFunc) http.HandlerFunc {
	return func(w http.ResponseWriter, r *http.Request) {
		tknStr := r.Header.Get("Authorization")
		if len(tknStr) < 8 || tknStr[:7] != "Bearer " {
			http.Error(w, "Authorization token is not provided or malformed", http.StatusUnauthorized)
			return
		}

		tknStr = tknStr[7:] // Strip "Bearer " prefix to extract the actual token
		claims := &models.Claims{}

		tkn, err := jwt.ParseWithClaims(tknStr, claims, func(token *jwt.Token) (interface{}, error) {
			return common.JwtKey, nil
		})

		if err != nil {
			if err == jwt.ErrSignatureInvalid {
				http.Error(w, "Invalid token signature", http.StatusUnauthorized)
				return
			}
			http.Error(w, "Error parsing token", http.StatusBadRequest)
			return
		}

		if !tkn.Valid {
			http.Error(w, "Invalid token", http.StatusUnauthorized)
			return
		}

		ctx := context.WithValue(r.Context(), common.UserClaimsKey, claims)
		next.ServeHTTP(w, r.WithContext(ctx))
	}
}
