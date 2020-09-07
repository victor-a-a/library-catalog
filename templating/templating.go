package templating

import (
  "html/template"
  "log"
)

var templateList = []string{
	"html/browse"
  "html/footer"
  "html/header"
  "html/mybooks"
  "html/navbar"
}

func GenerateTemplates() *template.Template{
	var Templates *template.Template
	var err error
	Templates, err = template.New("").ParseFiles(templateList...)
	if err != nil {
		log.Printf("Error parsing templates: %v", err)
	}
  return Templates
}
