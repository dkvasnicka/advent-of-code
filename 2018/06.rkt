#lang rackjure
(current-curly-dict hasheq)

(require (prefix-in c/ data/collection)
         math/statistics)

(define-values (data min-x min-y max-x max-y)
  (for/fold ([data '()]
             [min-x +inf.0] [min-y +inf.0] [max-x -inf.0] [max-y -inf.0])
            ([l (in-lines)])
    (match-let ([(list x y)
                 (map (compose string->number string-trim) (string-split l ","))])
      (values
        (cons {'x x 'y y} data)
        (min min-x x) (min min-y y) (max max-x x) (max max-y y)))))

(define (manhattan-dist a b)
  (+ (abs (- ('x a) ('x b)))
     (abs (- ('y a) ('y b)))))

(define candidates
  (c/filter (λ (p) (and (> ('x p) min-x) (> ('y p) min-y)
                        (< ('x p) max-x) (< ('y p) max-y)))
            data))

(define (compute-area c)
  (list
    (for*/sum ([x (in-range (floor (mean (list min-x ('x c))))
                            (ceiling (mean (list max-x ('x c)))))]
               [y (in-range (floor (mean (list min-y ('y c))))
                            (ceiling (mean (list max-y ('y c)))))])
              (if (< (manhattan-dist c {'x x 'y y})
                     (c/find-min (c/map (curry manhattan-dist {'x x 'y y}) (c/filter (λ~> (eq? c) not) data))))
                1 0))
    c))

(c/find-max (c/map compute-area candidates) #:key first)
