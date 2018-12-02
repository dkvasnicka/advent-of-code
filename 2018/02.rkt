#lang racket

(require list-utils)

(define data (sequence-map string->list (in-lines)))

; Part 1
(define (process-id desired-freqs freq-vals counts)
  (if (null? desired-freqs)
      counts
      (process-id
        (cdr desired-freqs)
        freq-vals
        (if (member (car desired-freqs) freq-vals)
            (hash-update counts (car desired-freqs) add1 0)
            counts))))

(define id-candidate-counts
  (for/fold
    ([counts (hasheq)])
    ([box-id data])
    (let* ([freqs (frequencies box-id)]
           [freq-vals (hash-values freqs)])
      (process-id '(2 3) freq-vals counts))))

(displayln
  (for/product ([v (in-hash-values id-candidate-counts)]) v))

; Part 2
