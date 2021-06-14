package handlers

import (
	"log"
	"net/http"
	"victoraa/virtual-bookshelf/templates"
	"victoraa/virtual-bookshelf/data"
)

func HandleAddBook(w http.ResponseWriter, r *http.Request) {
	// TODO: ADD USER AUNTHENTIFICATION AND TITLE VALIDATION

	r.ParseForm()
	s := r.PostFormValue("Autofill")
	log.Printf(s)

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

func HandleAutofill(w http.ResponseWriter, r *http.Request) {
	r.ParseForm()
	isbn := r.PostFormValue("isbn")
	log.Printf("Autofilling ISBN %s", isbn)
	
	bookData, err := data.GetBookData(isbn)
	log.Println(bookData)

	t := templates.Templates.Lookup("addbook.html")
  	if t == nil {
   		log.Printf("Cannot find addbook.html template\n")
		return
  	}

	err = t.Execute(w, nil)
	if err != nil {
		log.Printf("Error delivering addbook.html with err: %v\n", err)
		return
	}

	return
}