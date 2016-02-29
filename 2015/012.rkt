#lang racket

(require json)

(define (sum-all obj)
  (for/sum ([e obj])
    (cond
      [(number? e) e]
      [(list? e) (sum-all e)]
      [(hash? e) (sum-all (in-hash-values e))]
      [else 0])))

(sum-all (read-json))
