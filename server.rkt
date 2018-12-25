#lang web-server/insta

(require web-server/http)
(require "model.rkt")

;; ===== Variables =====
(define title-hash (new-map 150 hash-default))
(bulk-insert! (load-entries "data/title-hash.txt") title-hash)

(define title-keys (get-keys title-hash))

(define author-hash (new-map 150 hash-default))
(bulk-insert! (load-entries "data/author-hash.txt") author-hash)

(define author-keys (get-keys author-hash))

(define isbn-hash (new-map 150 hash-default))
(bulk-insert! (load-entries "data/isbn-hash.txt") isbn-hash)

(define isbn-keys (get-keys isbn-hash))

(define owner-hash (new-map 50 hash-default))
(bulk-insert! (load-entries "data/owner-hash.txt") owner-hash)

(define owner-keys (get-keys owner-hash))

;; ===== Functions =====
;; refresh : void -> void
;;A function to refresh the hash tables
(define (refresh)
  (set! title-hash (new-map 150 hash-default))
  (bulk-insert! (load-entries "data/title-hash.txt") title-hash)
  (set! title-keys (get-keys title-hash))
  (set! author-hash (new-map 150 hash-default))
  (bulk-insert! (load-entries "data/author-hash.txt") author-hash)
  (set! author-keys (get-keys author-hash))
  (set! isbn-hash (new-map 150 hash-default))
  (bulk-insert! (load-entries "data/isbn-hash.txt") isbn-hash)
  (set! isbn-keys (get-keys isbn-hash))
  (set! owner-hash (new-map 50 hash-default))
  (bulk-insert! (load-entries "data/owner-hash.txt") owner-hash)
  (set! owner-keys (get-keys owner-hash)))

;; can-search? : bindings -> boolean
;; A function used to determine if there is an active search request
(define (can-search? bindings)
  (and (exists-binding? 'search-by bindings)
       (exists-binding? 'search-request bindings)))

;; parse-search : bindings -> (listof string)
;; A function used to get the information relevant to the search from
;; the bindings in the following form (list search-by search-request)
(define (parse-search bindings)
  (list
   (extract-binding/single 'search-by bindings)
   (extract-binding/single 'search-request bindings)))

;; search : (listof string) -> (listof entry)
(define (search item)
  (match item
    [(list search-by search-request)
     (match* search-by (string->key search-request)
       

;; ===== Rendering =====
(define (start request)
  (if (can-search? (request-bindings request))
      (error "Under construction: Working on rendering page.")
  (response/xexpr
   '(html
     (head (title "Racket Library"))
     (body
      (h1 "Under construction")
      (h2 "Search")
      (form
       (input ((type "radio") (name "search-by") (value "title"))) "Title"
       (input ((type "radio") (name "search-by") (value "author"))) "Author"
       (input ((type "radio") (name "search-by") (value "isbn"))) "ISBN"
       (input ((type "radio") (name "search-by") (value "owner"))) "Owner"
       (br)
       (input ((type "text") (name "search-request")))
       (input ((type "submit") (value "Submit")))))))))

;;(define item (extract-binding/single 'item (request-bindings request)))