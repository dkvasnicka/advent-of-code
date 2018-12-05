#lang racket

(provide sequence-argmax)

(define (sequence-argmax proc seq)
  (let-values ([(_ winner)
                (for/fold ([current-max -inf.0] [current-winner (void)])
                          ([e seq])
                  (let ([maybe-new-max (proc e)])
                    (if (> maybe-new-max current-max)
                        (values maybe-new-max e)
                        (values current-max current-winner))))])
    winner))
