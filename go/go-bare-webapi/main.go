package main

import (
	"fmt"
	"log"
	"net/http"

	core "go-bare-webapi/core"
	handlers "go-bare-webapi/handlers"
	"go-bare-webapi/middlewares"
)

func main() {
	db := core.InitializeDB()
	defer db.Close()

	http.HandleFunc("/register", handlers.RegisterHandler(db))
	http.Handle("/register-admin", middlewares.APIKeyMiddleware(
		handlers.RegisterAdminHandler(db),
	))
	http.HandleFunc("/token", handlers.CreateTokenHandler(db))                     // Updated to use DB
	http.HandleFunc("/secured", middlewares.Authenticate(handlers.SecuredHandler)) // No change needed

	fmt.Println("Starting Server!")
	log.Fatal(http.ListenAndServe(":8080", nil))

}
