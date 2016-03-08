#lang racket

(require graph
         "hamiltonian.rkt")

(define (parse-row s)
  (let ([data (string-split s)])
    (values (set (first data) (string-trim (last data) #px"\\."))
            ((if (string=? (third data) "gain") + -) 
             (string->number (fourth data))))))

(define (load-edges)
  (for/fold ([h (hash)])
            ([edge (in-lines)])
    (let-values ([(k val-inc) (parse-row edge)])
      (hash-set h k (+ (hash-ref h k 0) val-inc)))))

(define (build-graph edge-hash)
  (weighted-graph/undirected
    (for/list ([e (in-hash-pairs edge-hash)])
      (cons (cdr e) (set->list (car e))))))

(hamiltonian (build-graph (load-edges)) 
             #:type 'cycle)
