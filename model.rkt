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

;; ===== Exporting =====
;; EXPORT FUNCTIONS HERE