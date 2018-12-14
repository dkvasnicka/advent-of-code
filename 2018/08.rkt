#lang racket

(require (only-in srfi/43 vector-empty?)
         math/base)

(define (part1)
  (let ([children (read)])
    (if (eof-object? children)
        0
        (let ([metadata (read)])
          (+ (for/sum ([_ (in-range children)]) (part1))
             (for/sum ([_ (in-range metadata)]) (read)))))))

(define (part2)
  (let ([children (read)])
    (if (eof-object? children)
        0
        (let* ([metadata (read)]
               [children-vals (for/vector ([_ (in-range children)]) (part2))]
               [children-count (vector-length children-vals)]
               [idxs (for/list ([_ (in-range metadata)]) (read))])
          (if (vector-empty? children-vals)
              (sum idxs)
              (for/sum ([i idxs] #:when (and (>= i 1) (<= i children-count)))
                (vector-ref children-vals (sub1 i))))))))

(with-input-from-file "08.txt" part1)
(with-input-from-file "08.txt" part2)
