#lang typed/racket

(require/typed rackjure/str
               [str (-> Any String)])
(require relation/composition)

(define-type Position (Tuple Number Number))
(struct command ([dir : String] [step : Number])
  #:type-name Command)

(define (commands-seq)
  (sequence-map
    (compose (match-lambda [(list dir step)
                            (command (str dir) (cast (string->number (str step)) Number))])
             string-split)
    (in-lines)))

(for/fold ([position : Position '(0 0)])
  ([command (commands-seq)])
  (map + position
       (match command
         [(Command "forward" x) (list x 0)])))
