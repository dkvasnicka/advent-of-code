#lang racket

(require srfi/14 "utils.rkt")

(define data (sequence->stream (in-port read-char)))

(define (trigger-reaction input output)
  (let ([next (stream-first input)])
    (if (not (char-alphabetic? next))
        (length output)
        (trigger-reaction
          (stream-rest input)
          (if (and (not (empty? output))
                   (char-ci=? (first output) next)
                   (not (char=? (first output) next)))
            (rest output)
            (cons next output))))))

; Part 1
(displayln
  (trigger-reaction (stream-rest data) (list (stream-first data))))

; Part 2
(define (reaction-length-without ch)
  (let ([input (stream-filter (compose not (curry char-ci=? ch)) data)])
    (trigger-reaction (stream-rest input) (list (stream-first input)))))

(sequence-argmin/minval
  reaction-length-without
  (char-set->list (char-set-intersection char-set:lower-case char-set:ascii)))
