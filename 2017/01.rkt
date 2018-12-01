#lang racket

(require data/ralist)

(define (char->number c)
  (if (char-numeric? c)
      (string->number (string c))
      c))

(define (same? x y)
  (if (= x y) x 0))

(define (process last-num nums sum head)
  (if (equal? (list #\newline) nums)
      (+ sum (same? last-num head))
      (process
        (car nums)
        (cdr nums)
        (+ sum (same? last-num (car nums)))
        head)))

(let* ([data (for/list ([n (sequence-map char->number (in-port read-char))]) n)]
       [head (car data)])
  (process head (cdr data) 0 head))
