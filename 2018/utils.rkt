#lang racket

(provide sequence-argmax
         sequence-argmax/maxval)

(define (sequence-argmax/maxval proc seq)
  (for/fold ([current-max -inf.0] [current-winner (void)])
            ([e seq])
    (let ([maybe-new-max (proc e)])
      (if (> maybe-new-max current-max)
          (values maybe-new-max e)
          (values current-max current-winner)))))

(define (sequence-argmax proc seq)
  (let-values ([(_ winner) (sequence-argmax/maxval proc seq)])
    winner))
