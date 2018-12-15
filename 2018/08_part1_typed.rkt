#lang typed/racket/base

(require typed/racket/unsafe)
(unsafe-require/typed racket/base [read (-> Natural)])

; Slower than the untyped version, probably because of IO
; Discussed at https://www.reddit.com/r/Racket/comments/a64tys/why_is_this_typed_program_slower_than_its_untyped/

(time
  (let loop : Natural ()
   (let ([children (read)])
     (if (eof-object? children)
         0
         (let ([metadata (read)])
           (+ (for/sum : Natural ([_ (in-range children)]) (loop))
              (for/sum : Natural ([_ (in-range metadata)]) (read))))))))
