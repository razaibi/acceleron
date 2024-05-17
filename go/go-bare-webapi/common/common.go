package common

type ContextKey int

const (
	UserClaimsKey ContextKey = iota // iota initializes 0, increments by 1 for each iota
)

var JwtKey = []byte("my_secret_key")
