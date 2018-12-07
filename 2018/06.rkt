#lang racket

(require threading
         mischief/for)

(struct pt (x y) #:transparent)

(define/for/fold ([data '()]
                  [min-x +inf.0] [min-y +inf.0] [max-x -inf.0] [max-y -inf.0])
                 ([l (in-lines)])
  (match-let ([(list x y)
               (map (compose string->number string-trim) (string-split l ","))])
    (values
      (cons (pt x y) data)
      (min min-x x) (min min-y y) (max max-x x) (max max-y y))))

(define (manhattan-dist a b)
  (+ (abs (- (pt-x a) (pt-x b)))
     (abs (- (pt-y a) (pt-y b)))))

; Part 1
(define candidates
  (filter (λ (p) (and (< min-x (pt-x p) max-x) (< min-y (pt-y p) max-y)))
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

(displayln
  (time (argmax first (map compute-area candidates))))

; Part 2
(displayln
  (time
    (for*/sum ([x (in-range min-x (add1 max-x))]
               [y (in-range min-y (add1 max-y))])
      (if (< (for/sum ([p data]) (manhattan-dist (pt x y) p)) 10000)
          1 0))))
