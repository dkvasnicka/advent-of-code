#lang racket

(provide sequence-argmax
         sequence-argmax/maxval
         sequence-argmin
         sequence-argmin/minval)

(define (sequence-argextreme/extremeval comparator initval proc seq)
  (for/fold ([current-extreme initval] [current-winner (void)])
            ([e seq])
    (let ([maybe-new-extreme (proc e)])
      (if (comparator maybe-new-extreme current-extreme)
          (values maybe-new-extreme e)
          (values current-extreme current-winner)))))

(define (sequence-argmax/maxval proc seq)
  (sequence-argextreme/extremeval > -inf.0 proc seq))

(define (sequence-argmax proc seq)
  (let-values ([(_ winner) (sequence-argmax/maxval proc seq)])
    winner))

(define (sequence-argmin/minval proc seq)
  (sequence-argextreme/extremeval < +inf.0 proc seq))

(define (sequence-argmin proc seq)
  (let-values ([(_ winner) (sequence-argmin/minval proc seq)])
    winner))
