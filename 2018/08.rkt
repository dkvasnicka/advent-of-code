#lang racket

(let loop ()
  (let ([children (read)])
    (if (eof-object? children)
        0
        (let ([metadata (read)])
          (+ (for/sum ([_ (in-range children)]) (loop))
             (for/sum ([_ (in-range metadata)]) (read)))))))
