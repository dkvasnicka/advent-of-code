#lang racket

(require openssl/md5
         rnrs/io/ports-6)

(define (produces-hash? i)
  (string-prefix? 
    (md5 (open-string-input-port
           (string-append "yzbqklnj" (number->string i)))) 
    "000000"))

(for/first ([i (in-naturals 1)] #:when (produces-hash? i)) i)
