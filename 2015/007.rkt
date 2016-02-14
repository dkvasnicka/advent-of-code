#lang racket

(require (only-in lang/htdp-advanced string-numeric?)
         racket/unsafe/ops)

(struct node (op opnds) #:transparent)

(define (parse-node-exp s)
  (match (string-split (string-trim s))
    [(list (? string-numeric? v)) (string->number v)]
    [(list (? string? n)) (node identity (list n))]
    [(list _ n) (node unsafe-fxnot (list n))]
    [(list n "LSHIFT" (? string-numeric? v)) 
     (node (curryr unsafe-fxlshift (string->number v)) (list n))]
    [(list n "RSHIFT" (? string-numeric? v)) 
     (node (curryr unsafe-fxrshift (string->number v)) (list n))]
    [(list "1" "AND" m) (node (curry unsafe-fxand 1) (list m))]
    [(list n "AND" m) (node unsafe-fxand (list n m))]
    [(list n "OR" m) (node unsafe-fxior (list n m))]))

(define (build-adjacency-list)
  (for/hash ([line (in-lines)])
    (let ([vk (string-split line #px"->")])
     (values
       (string-trim (cadr vk))
       (parse-node-exp (car vk))))))

(define adjlist 
  (make-hash
    (hash->list
      (build-adjacency-list))))

(define (compute-node-val nval)
  (apply (node-op nval) 
         (map node-val 
              (node-opnds nval))))

(define (node-val n)
  (let ([nval (hash-ref adjlist n)])
    (if (number? nval)
      nval
      (let ([new-nv (compute-node-val nval)])
        (hash-set! adjlist n new-nv)
        new-nv))))

(hash-set! adjlist "b" 956) ; Part 2 - overriding the b wire
(node-val "a")
