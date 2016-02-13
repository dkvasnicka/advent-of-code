#lang racket

(require (only-in lang/htdp-advanced string-numeric?)
         racket/unsafe/ops
         racket/fixnum)

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

(define (node-val adjlist n)
  (let ([nval (hash-ref adjlist n)])
    (if (number? nval)
      nval
      (apply (node-op nval) 
             (map (curry node-val adjlist) 
                  (node-opnds nval))))))

(node-val (build-adjacency-list) "a")
