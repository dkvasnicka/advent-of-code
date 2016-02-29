#lang racket

(require json)

(define (sum-all obj)
  (for/sum ([e obj])
    (cond
      [(number? e) e]
      [(list? e) (sum-all e)]
      [(hash? e) (let ([vals (in-hash-values e)]) 
                   (if (sequence-ormap (curry equal? "red") vals) 
                     0 
                     (sum-all vals)))]
      [else 0])))

(sum-all (read-json))
