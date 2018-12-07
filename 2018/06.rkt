#lang racket

(require math/statistics
         threading)

(struct pt (x y) #:transparent)

(define-values (data min-x min-y max-x max-y)
  (for/fold ([data '()]
             [min-x +inf.0] [min-y +inf.0] [max-x -inf.0] [max-y -inf.0])
            ([l (in-lines)])
    (match-let ([(list x y)
                 (map (compose string->number string-trim) (string-split l ","))])
      (values
        (cons (pt x y) data)
        (min min-x x) (min min-y y) (max max-x x) (max max-y y)))))

(define (manhattan-dist a b)
  (+ (abs (- (pt-x a) (pt-x b)))
     (abs (- (pt-y a) (pt-y b)))))

(define candidates
  (filter (λ (p) (and (> (pt-x p) min-x) (> (pt-y p) min-y)
                      (< (pt-x p) max-x) (< (pt-y p) max-y)))
          data))

(define (compute-area c)
  (let ([data-except-c (filter (λ~> (eq? c) not) data)])
    (list
      (for*/sum ([x (in-range (floor (/ (+ min-x (pt-x c)) 2))
                              (ceiling (/ (+ max-x (pt-x c)) 2)))]
                 [y (in-range (floor (/ (+ min-y (pt-y c)) 2))
                              (ceiling (/ (+ max-y (pt-y c)) 2)))])
                (let ([point (pt x y)])
                  (if (< (manhattan-dist c point)
                         (apply min (map (curry manhattan-dist point) data-except-c)))
                    1 0)))
      c)))

(argmax first (map compute-area candidates))
