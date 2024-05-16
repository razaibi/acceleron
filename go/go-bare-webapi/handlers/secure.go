package handlers

import (
	"fmt"
	"go-bare-webapi/common" // This should match the actual import path
	models "go-bare-webapi/models"
	"net/http"
)

func SecuredHandler(w http.ResponseWriter, r *http.Request) {
	claims, ok := r.Context().Value(common.UserClaimsKey).(*models.Claims)
	if !ok {
		http.Error(w, "Internal server error", http.StatusInternalServerError)
		return
	}

	// Check if the roles include an admin role as an example of role-based access control
	isAdmin := false
	for _, role := range claims.Roles {
		if role == "admin" {
			isAdmin = true
			break
		}
	}

	if isAdmin {
		msg := fmt.Sprintf("Welcome admin %s!", claims.Username)
		w.Write([]byte(msg))
	} else {
		http.Error(w, "Access denied. This resource requires admin privileges.", http.StatusForbidden)
	}
}
