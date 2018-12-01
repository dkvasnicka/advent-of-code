#lang racket

(for/sum ([n (in-lines)])
  (string->number n))
