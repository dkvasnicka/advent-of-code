#lang typed/racket/base

(require typed/racket/unsafe)
(unsafe-require/typed racket/base [read (-> Natural)])

(time
  (let loop : Natural ()
   (let ([children (read)])
     (if (eof-object? children)
         0
         (let ([metadata (read)])
           (+ (for/sum : Natural ([_ (in-range children)]) (loop))
              (for/sum : Natural ([_ (in-range metadata)]) (read))))))))
