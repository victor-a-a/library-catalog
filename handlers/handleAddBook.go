package handlers

import (
	"log"
	"net/http"
	"victoraa/virtual-bookshelf/templates"
)

func HandleAddBook(w http.ResponseWriter, r *http.Request) {
	// TODO: ADD USER AUNTHENTIFICATION AND TITLE VALIDATION

	t := templates.Templates.Lookup("addbook.html")
  	if t == nil {
   		log.Printf("Cannot find addbook.html template\n")
		return
  	}

	err := t.Execute(w, nil)
	if err != nil {
		log.Printf("Error delivering addbook.html with err: %v\n", err)
		return
	}
	return
}