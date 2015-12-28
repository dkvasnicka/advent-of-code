#lang racket

(define (translate-directions ch)
  (match ch
    [#\^ '(0 1)]
    [#\> '(1 0)]
    [#\v '(0 -1)]
    [#\< '(-1 0)]))

(define (aggregate)
  (for/fold ([s (set '(0 0))]
             [cur '(0 0)])
            ([dir (in-port read-char)])

    (let ([new-pos (map + cur (translate-directions dir))])
      (values
        (set-add s new-pos)
        new-pos))))

(let-values ([(houses _) (aggregate)])
  (set-count houses))
