package core

import (
	"database/sql"
	"log"

	_ "github.com/mattn/go-sqlite3"
)

func InitializeDB() *sql.DB {
	db, err := sql.Open("sqlite3", "./users.db")
	if err != nil {
		log.Fatal(err)
	}
	statement, _ := db.Prepare("CREATE TABLE IF NOT EXISTS users (id INTEGER PRIMARY KEY, username TEXT NOT NULL UNIQUE, password TEXT NOT NULL, roles TEXT)")
	statement.Exec()
	return db
}
