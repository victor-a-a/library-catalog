package routes

import (
	"net/http"
	"victoraa/virtual-bookshelf/handlers"
)

func MakeRoutes() {
	http.HandleFunc("/user/addbook", handlers.HandleAddBook)
	http.HandleFunc("/user/addbook/autofill", handlers.HandleAutofill)
}