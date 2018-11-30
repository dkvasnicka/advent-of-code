#lang racket

(define (char->number c)
  (if (char-numeric? c)
      (string->number (string c))
      c))

(define (same? x y)
  (if (= x y) x 0))

(define (process last-num nums sum head)
  (if (equal? '(#\newline) nums)
      (+ sum (same? last-num head))
      (process
        (car nums)
        (cdr nums)
        (+ sum (same? last-num (car nums)))
        head)))

(let* ([data (sequence->list (sequence-map char->number (in-port read-char)))]
       [head (car data)])
  (process head (cdr data) 0 head))
