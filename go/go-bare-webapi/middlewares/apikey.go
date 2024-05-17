package middlewares

import (
	"log"
	"net/http"
	"os"

	"github.com/joho/godotenv"
)

func init() {
	// Load .env file
	if err := godotenv.Load(); err != nil {
		log.Fatalf("Error loading .env file: %v", err)
	}
}

func APIKeyMiddleware(next http.Handler) http.Handler {
	return http.HandlerFunc(func(w http.ResponseWriter, r *http.Request) {
		apiKey := r.Header.Get("X-API-Key")
		expectedAPIKey := os.Getenv("X_API_KEY")
		if apiKey == "" || apiKey != expectedAPIKey {
			http.Error(w, "Invalid or missing API key", http.StatusUnauthorized)
			return
		}

		// Call the next handler, which can be another middleware in the chain, or the final handler.
		next.ServeHTTP(w, r)
	})
}
