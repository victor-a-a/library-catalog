#lang typed/racket

(require racket/list)

;; ===== Data Structures =====
(define-struct (a) Some
  ([value : a]) #:transparent)

(define-type (Optional a)
  (U 'None (Some a)))

(define-struct Book
  ([title : String]
   [author : String]
   [isbn : String]
   [subject : String]
   [owner : String]
   [status : String]
   [location : String]
   [cover : String]) #:transparent)

(define-struct Entry
  ([key : String]
   [books : (Listof Book)]) #:transparent)

(define-type Bucket
  (Listof Entry))

(define-struct HashMap
  ([hash : (String -> Integer)]
   [buckets : (Vectorof Bucket)]) #:transparent)

;; ===== Functions =====
;; substring?: A function that takes in a string and determines if it is a
;; substring of a second string.
(: substring? : String String -> Boolean)
(define (substring? sub-string string)
  (local
    {(: loop : String String Integer -> Boolean)
     (define (loop sb str counter)
       (cond
         [(= (+ counter (string-length sb) -1) (string-length str)) #f]
         [(string=?
           sb (substring str counter (+ counter (string-length sb)))) #t]
         [else (loop sb str (add1 counter))]))}
    (loop (string-downcase sub-string) (string-downcase string) 0)))

;; string->key: A function that takes in an user defined string and tries
;; to match it to some string in a list of keys.
(: string->key : String (Listof String) -> (Optional (Listof String)))
(define (string->key string keys)
  (local
    {(: loop : String (Listof String) (Listof String) -> (Listof String))
     (define (loop sb strs acc)
       (match strs
         ['() acc]
         [(cons head tail)
          (if (substring? sb head)
              (loop sb tail (cons head acc))
              (loop sb tail acc))]))}
    (if (null? (loop string keys '())) 'None (Some (loop string keys '())))))

;; new-map: A fuction that creates a new, empty hash map of the the given size.
(: new-map : Integer (String -> Integer) -> HashMap)
(define (new-map size hash-function)
  (HashMap hash-function
           (make-vector size (cast '() Bucket))))

;; lookup: A function used to find a specific entry in the hash map.
(: lookup : String HashMap -> (Optional Entry))
(define (lookup key map)
  (local
    {(: loop : Bucket -> (Optional Entry))
     (define (loop bucket)
       (match bucket
         ['() 'None]
         [(cons head tail)
          (if (string=? key (Entry-key head)) (Some head) (loop tail))]))}
    (match map
      [(HashMap hash buckets)
       (loop
        (vector-ref buckets (remainder (hash key) (vector-length buckets))))])))

;; insert!: A function used to insert a given entry in a given hash map.
(: insert! : Entry HashMap -> Void)
(define (insert! entry map)
  (match* (entry map)
      [((Entry key _) (HashMap hash buckets))
       (vector-set!
        buckets (remainder (hash key) (vector-length buckets))
        (cons
         entry
         (vector-ref buckets (remainder (hash key) (vector-length buckets)))))]))

;; bulk-lookup: A fuction that looks up a list of keys and returns a list of entries
(: bulk-lookup : (Listof String) HashMap -> (Listof Entry))
(define (bulk-lookup keys map)
  (foldr
   (lambda ([key : String][entries : (Listof Entry)])
     (match (lookup key map)
       ['None entries]
       [(Some entry) (cons entry entries)]))
   '() keys))

;; bulk-insert!: A function that inserts a list of entries in a given map
(: bulk-insert! : (Listof Entry) HashMap -> Void)
(define (bulk-insert! entries map)
  (match entries
    ['() (void 'end-here)]
    [(cons head tail)
     (begin
       (insert! head map)
       (bulk-insert! tail map))]))

;; get-keys: A function that gets all the keys of all the entries in a given map
(: get-keys : HashMap -> (Listof String))
(define (get-keys map)
  (local
    {(: loop : HashMap Integer (Listof String) -> (Listof String))
     (define (loop m counter accumulator)
       (if (<= (add1 counter) (vector-length (HashMap-buckets m)))
           (loop m (add1 counter)
                 (foldr
                  (lambda ([entry : Entry][acc : (Listof String)])
                    (match entry
                      [(Entry key _) (cons key acc)]))
                  accumulator
                  (vector-ref (HashMap-buckets m) counter)))
           accumulator))}
    (loop map 0 '())))

;; string->book: A function that takes in a formated string and returns a Book
(: string->book : String -> Book)
(define (string->book string)
  (match (string-split string "#d#d#d#d#d")
    [(list title author isbn subject owner status location cover)
     (Book title author isbn subject owner status location cover)]))

;; string->entry: A function that takes in a formated string and returns an Entry
(: string->entry : String -> Entry)
(define (string->entry string)
  (match (string-split string "#k#k#k#k#k")
    [(list key books-string)
     (Entry key
            (foldr
             (lambda ([book-string : String][book-list : (Listof Book)])
               (cons (string->book book-string) book-list))
             '() (string-split books-string "#b#b#b#b#b")))]))

;; load-entries: A function that generates a list of entries from a specified txt file
(: load-entries : String -> (Listof Entry))
(define (load-entries file-path)
  (if
   (string=? (port->string (open-input-file file-path)) "")
   '()
   (foldr
    (lambda ([entry-string : String][entry-list : (Listof Entry)])
      (cons (string->entry entry-string) entry-list))
    '() (string-split (port->string (open-input-file file-path)) "#e#e#e#e#e"))))

;; hash: A function to hash the key into an integer
(: hash-default : String -> Integer)
(define (hash-default key)
  (foldr
   (lambda ([char : Integer][acc : Integer])
     (exact-ceiling (/ (* char acc 67867967) 49979687)))
   1 (map char->integer (string->list key))))

;; ===== Exporting =====
(provide (all-defined-out))