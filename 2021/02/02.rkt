#lang racket

(require relation/composition
         racket/generic)

; This solution is ridiculously chatty and would be a lot shorter if
; `position` was just a simple list. However being inspired by Rust
; I wanted to try out idiomatic struct-oriented programming approach
; in Racket using generic interfaces.

(define-generics encodable (encode encodable))

(struct position (horizontal depth) #:transparent
  #:methods gen:addable
  [(define (add p1 p2)
     (position (+ (position-horizontal p1) (position-horizontal p2))
               (+ (position-depth p1) (position-depth p2))))]
  #:methods gen:encodable
  [(define (encode p) (* (position-horizontal p) (position-depth p)))])

(struct command (dir step) #:transparent)

(define (commands-seq)
  (for/stream ([l (in-lines)])
    (match (string-split l)
      [(list dir step) (command dir (string->number step))])))

(encode
  (for/fold ([pos (position 0 0)]) ([cmd (commands-seq)])
    (+ pos
       (match cmd
         [(command "forward" x) (position x 0)]
         [(command "down" x) (position 0 x)]
         [(command "up" x) (position 0 (- x))]))))
