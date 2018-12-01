#lang racket

(require math/base
         data/collection)

(define data (for/list ([n (in-lines)]) (string->number n)))

(displayln (sum data))

(let ([register (mutable-seteq)]
      [reductions (foldl/steps + 0 (cycle data))])
  (for/last ([isum reductions] #:final (set-member? register isum))
    (set-add! register isum)
    isum))
