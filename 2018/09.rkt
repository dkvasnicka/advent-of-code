#lang racket

(require data/ralist
         (only-in racket [car lcar] [cdr lcdr]))

(define (actual-idx lst idx)
  (let ([lstlen (length lst)])
    (cond
      [(> idx lstlen) (- idx lstlen)]
      [(negative? idx) (+ lstlen idx)]
      [else idx])))

(define (insert-at lst pos value [curpos 0])
  (if (empty? lst)
      (list value)
      (if (= pos curpos)
          (cons value lst)
          (cons (car lst) (insert-at (cdr lst) pos value (add1 curpos))))))

(define (remove-at lst pos [curpos 0])
  (if (= curpos pos)
      (cdr lst)
      (cons (car lst) (remove-at (cdr lst) pos (add1 curpos)))))

(define (highest-score players last-marble)
  (for/fold ([circle (list 0)]
             [current-marble 0]
             [scores (hasheq)] #:result (apply max (hash-values scores)))
            ([marble (in-range 1 (add1 last-marble))]
             [player (in-cycle (in-range players))])
            (if (= 0 (modulo marble 23))
                (let ([to-remove (actual-idx circle (- current-marble 7))])
                  (values
                    (remove-at circle to-remove)
                    to-remove
                    (hash-update scores player (curry + marble (list-ref circle to-remove)) 0)))
                (let ([actual-new-marble (actual-idx circle (+ current-marble 2))])
                  (values
                    (insert-at circle actual-new-marble marble)
                    actual-new-marble
                    scores)))))

(highest-score 452 70784)

(module+ test
  (require rackunit)

  (check-equal? (remove-at (list 1 2 3) 1) (list 1 3))
  (let ([test-lst (list 1 2 3)])
    (check-equal? (remove-at test-lst (actual-idx test-lst -1)) (list 1 2)))

  (define test-data
    '((32     9  25)
      (8317   10 1618)
      (146373 13 7999)
      (2764   17 1104)
      (54718  21 6111)
      (37305  30 5807)))

  (for ([tcase test-data])
    (check-equal? (apply highest-score (lcdr tcase)) (lcar tcase))))
