#lang racket

(require relation/composition
         racket/generic)

; Being inspired by Rust I wanted to try out idiomatic struct-oriented programming approach
; in Racket using generic interfaces. After implementing Part 1 this solution
; obviously felt ridiculously chatty and would be a lot shorter if
; `position` was just a simple list. However when moving to Part 2 it was nice
; being able to refactor the program by just tweaking the `position` struct and
; methods and going by meaningful compiler errors wherever further changes were
; necessary, instead of relying on cryptic errors stemming from unexpectedly short lists etc.

(define-generics encodable (encode encodable))

(struct position (horizontal depth aim) #:transparent
  #:methods gen:appendable
  [(define (append p1 p2)
     (position (+ (position-horizontal p1) (position-horizontal p2))
               (+ (position-depth p1) (* (position-aim p1) (position-horizontal p2)))
               (+ (position-aim p1) (position-aim p2))))]
  #:methods gen:encodable
  [(define (encode p) (* (position-horizontal p) (position-depth p)))])

(struct command (dir step) #:transparent)

(define (commands-seq)
  (for/stream ([l (in-lines)])
    (match (string-split l)
      [(list dir step) (command dir (string->number step))])))

(encode
  (for/fold ([pos (position 0 0 0)]) ([cmd (commands-seq)])
    (append pos
            (match cmd
              [(command "forward" x) (position x 0 0)]
              [(command "down" x) (position 0 0 x)]
              [(command "up" x) (position 0 0 (- x))]))))
