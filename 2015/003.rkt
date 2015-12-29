#lang racket

(define (translate-directions ch)
  (match ch
    [#\^ '(0 1)]
    [#\> '(1 0)]
    [#\v '(0 -1)]
    [#\< '(-1 0)]))

; Part 1
(define (aggregate)
  (for/fold ([s (set '(0 0))]
             [cur '(0 0)])
            ([dir (in-port read-char)])

    (let ([new-pos (map + cur (translate-directions dir))])
      (values
        (set-add s new-pos)
        new-pos))))

; Part 2
(define (aggregate-alternated)
  (for/fold ([s (set '(0 0))]
             [cur (hasheq 'santa '(0 0) 'robo '(0 0))])
            ([dir (in-port read-char)]
             [player (in-cycle '(santa robo))])

    (let ([new-pos (map + (hash-ref cur player) (translate-directions dir))])
      (values
        (set-add s new-pos)
        (hash-set cur player new-pos)))))

(let-values ([(houses _) (aggregate-alternated)])
  (set-count houses))
