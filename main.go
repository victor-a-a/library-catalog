package main

import (
  "log"
  "net/http"
  "victoraa/virtual-bookshelf/routes"
  "victoraa/virtual-bookshelf/templates"
)

func main() {
  routes.MakeRoutes()
  templates.MakeTemplates()
  log.Printf("Running Server")
  http.ListenAndServe(":8080", nil)
}