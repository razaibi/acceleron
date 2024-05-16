package models

import "github.com/dgrijalva/jwt-go"

type Claims struct {
	Username string   `json:"username"`
	Roles    []string `json:"roles"`
	jwt.StandardClaims
}
