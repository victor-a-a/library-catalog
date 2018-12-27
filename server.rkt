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
;; refresh? : void -> void
;; A function used to determine if the hash tables should be refreshed,
;; and acts accordingly
(define (refresh?)
  (match (seconds->date (current-seconds))
    [(date* 15 14 03 _ _ _ _ _ _ _ _ _) (refresh)]
    [_ (void 'end-here)]))

;; refresh : void -> void
;; A function to refresh the hash tables
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

;; search : (listof string) -> (optional (listof entry))
;; A function to search for a given item by a given field among
;; all the hashes
(define (search item)
  (match item
    [(list search-by search-request)
     (match search-by
       ["title"
        (if (symbol? (string->key search-request title-keys)) 'None
            (bulk-lookup
             (Some-value (string->key search-request title-keys))
             title-hash))]
       ["author"
        (if (symbol? (string->key search-request author-keys)) 'None
            (bulk-lookup
             (Some-value (string->key search-request author-keys))
             author-hash))]
       ["isbn"
        (if (symbol? (string->key search-request isbn-keys)) 'None
            (bulk-lookup
             (Some-value (string->key search-request isbn-keys))
             isbn-hash))]
       ["owner"
        (if (symbol? (string->key search-request owner-keys)) 'None
            (bulk-lookup
             (Some-value (string->key search-request owner-keys))
             owner-hash))])]))

;; entries->books : (listof entries) -> (listof books)
;; A function to turn a list of entries into a list of books
(define (entries->books entries)
  (foldr
   (lambda (entry books)
     (match entry
       [(Entry _ book) (append book books)]))
   '() entries))

;; results? request -> response
;; A function that determines if a search had matching results and
;; redirects the user to the according page.
(define (results? request)
  (match (search (parse-search (request-bindings request)))
          ['None (no-results request)]
          [_ (results request)]))
       
;; ===== Rendering =====
;; render-book : book -> xexpr
;; A function to render the html representation of a book struct
(define (render-book book)
  (match book
    [(Book title author isbn subject owner status location cover)
     `(div ((class "book"))
           (h3 ,title)
           (img ((src ,cover) (alt "Image not found.")))
           (p "By " ,author (br)
              ,subject (br)
              ,location " | " ,owner (br)
              ,isbn " | " ,status))]))

;; render-books : (listof book) -> xexper
;; A function to render the html representation of list of books
(define (render-books books)
  `(div ((class "books"))
        ,@(map render-book books)))

;; home-page : request -> response
(define (home-page request)
    (response/xexpr
     '(html
       (head
        (title "RKT-LIB")
        (link ((href
                "http://fonts.googleapis.com/css?family=Fjalla+One|Cantarell:400,400italic,700italic,700")
               (rel "stylesheet") (type "text/css")))
        (link ((rel "stylesheet") (href "/default.css") (type "text/css"))))
       (body
        (h1 "RKT-LIB")
        (div ((class "search-bar"))
             (h2 "Search")
             (form
              (label ((class "radio"))
                     (input ((type "radio") (name "search-by") (value "title")))
                     (span ((class "checkmark")))
                     "Title")
              (label ((class "radio"))
                     (input ((type "radio") (name "search-by") (value "author")))
                     (span ((class "checkmark")))
                     "Author")
              (label ((class "radio"))
                     (input ((type "radio") (name "search-by") (value "isbn")))
                     (span ((class "checkmark")))
                     "ISBN")
              (label ((class "radio"))
                     (input ((type "radio") (name "search-by") (value "owner")))
                     (span ((class "checkmark")))
                     "Owner")
              (br)
              (input ((type "text") (name "search-request")))))))))

;; no-results : requests -> response
(define (no-results request)
  (define (response-generator embed/url)
    (response/xexpr
     `(html
       (head
        (title "RKT-LIB")
        (link ((href
                "http://fonts.googleapis.com/css?family=Fjalla+One|Cantarell:400,400italic,700italic,700")
               (rel "stylesheet") (type "text/css")))
        (link ((rel "stylesheet") (href "/default.css") (type "text/css"))))
       (body
        (h1 "RKT-LIB")
        (h2 "No matching results found")
        (p (string-append "Your search request did not match any books.  "
                          "Please try again with the following suggestions in mind:"))
        (ul
         (li "Make sure all words are spelled correctly.")
         (li "Try different key words.")
         (li "Try more general key words."))
        (div ((class "return"))
             (a ((href ,(embed/url start)))
                "Return to search page..."))))))
  (send/suspend/dispatch response-generator))

;; results : request -> response
(define (results request)
  (define (response-generator embed/url)
    (response/xexpr
     `(html
       (head
        (title "RKT-LIB")
        (link ((href
                "http://fonts.googleapis.com/css?family=Fjalla+One|Cantarell:400,400italic,700italic,700")
               (rel "stylesheet") (type "text/css")))
        (link ((rel "stylesheet") (href "/default.css") (type "text/css"))))
       (body
        (h1 "RKT-LIB")
        (h2 "Results")
        ,(render-books
          (entries->books
           (search (parse-search (request-bindings request)))))
        (div ((class "return"))
             (a ((href ,(embed/url start)))
                "Return to search page..."))))))
    (send/suspend/dispatch response-generator))
        
;; start : request -> response
(define (start request)
  (begin
    (refresh?)
    (if (can-search? (request-bindings request))
        (results? request)
        (home-page request))))

(static-files-path "styles")