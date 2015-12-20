#lang racket

(require srfi/41)

; Part 1
(for/sum ([p (in-port read-char)]) (if (char=? p #\u028) 1 -1))

; Part 2
(stream-length
  (stream-take-while (λ (i) (> i -1)) 
                     (stream-scan + 0 
                                  (stream-map (λ (ch) (if (char=? ch #\u028) 1 -1)) 
                                              (port->stream)))))
