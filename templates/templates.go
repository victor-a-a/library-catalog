package templates

import (
  "html/template"
  "log"
)

var Templates *template.Template

var templateList = []string{
	"html/addbook.html",
	"html/browse.html",
	"html/mybooks.html",
	"html/navbar.html",
	"html/header.html",
  	"html/footer.html",
}

func MakeTemplates() {
	var err error
	Templates, err = template.New("").ParseFiles(templateList...)
	if err != nil {
		log.Printf("Error parsing templates: %v", err)
	}
}
