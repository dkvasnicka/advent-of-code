#lang racket

(define (trigger-reaction [output (list (read-char))])
  (let ([next (read-char)])
    (if (not (char-alphabetic? next))
        (length output)
        (trigger-reaction
          (if (and (not (empty? output))
                   (char-ci=? (first output) next)
                   (not (char=? (first output) next)))
            (rest output)
            (cons next output))))))

(trigger-reaction)
