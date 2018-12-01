#lang racket

(require math/base
         (only-in data/collection foldl/steps cycle))

(define data (sequence->list (in-port)))

(displayln (sum data))

(let ([register (mutable-seteq)]
      [reductions (foldl/steps + 0 (cycle data))])
  (for/last ([isum reductions] #:final (set-member? register isum))
    (set-add! register isum)
    isum))
