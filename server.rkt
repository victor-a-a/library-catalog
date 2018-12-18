#lang web-server/insta

(require "model.rkt")

(define (start request)
  (response/xexpr
   '(html
     (head (title "Racket Library"))
     (body (h1 "Under construction")))))