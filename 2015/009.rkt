#lang racket

(require graph
         "hamiltonian.rkt")

(define (lines-seq)
  (sequence-map (curry regexp-match* #rx"(?![to])[a-zA-Z0-9]+")
                (in-lines)))

(define (read-edges)
  (let ([g (weighted-graph/undirected '())])
    (for ([l (lines-seq)])
      (add-edge! g (first l) (second l) (string->number (third l))))
    g))

(hamiltonian (read-edges) #:type 'path)
