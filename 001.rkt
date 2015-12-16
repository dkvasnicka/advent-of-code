#lang racket

(require srfi/41)

(for/sum ([p (in-port read-char)]) (if (char=? p #\u028) 1 -1))

(stream-length
  (stream-take-while (λ (i) (> i -1)) 
                     (stream-scan + 0 
                                  (stream-map (λ (ch) (if (char=? ch #\u028) 1 -1)) 
                                              (port->stream)))))
