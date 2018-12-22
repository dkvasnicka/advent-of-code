#lang typed/racket

(require pfds/deque/real-time)

(: rotate-cw ((Deque Integer) Integer -> (Deque Integer)))
(define (rotate-cw dq cnt)
  (if (zero? cnt)
      dq
      (rotate-cw
        (match-let ([(cons last init) (last+init dq)])
          (enqueue-front last init))
        (sub1 cnt))))

(: rotate-ccw ((Deque Integer) Integer -> (Deque Integer)))
(define (rotate-ccw dq cnt)
  (if (zero? cnt)
      dq
      (rotate-ccw
        (match-let ([(cons head tail) (head+tail dq)])
          (enqueue head tail))
        (sub1 cnt))))

(: run-game (Integer Integer -> (Values (Deque Integer) (HashTable Integer Integer))))
(define (run-game players last-marble)
  (for/fold ([circle (deque 0)]
             [scores : (HashTable Integer Integer) (hasheq)])
            ([marble (in-range 1 (add1 last-marble))]
             [player (in-cycle (in-range players))])
            (if (= 0 (modulo marble 23))
                (match-let ([(cons h t) (head+tail (rotate-cw circle 7))])
                  (values
                    t
                    (hash-update scores player (λ ([x : Integer]) (+ marble h x)) (λ () 0))))
                (values
                  (enqueue-front marble (rotate-ccw circle 2))
                  scores))))

(: highest-score (Integer Integer -> Integer))
(define (highest-score players last-marble)
  (let-values ([(circle scores) (run-game players last-marble)])
    (apply max (hash-values scores))))

(highest-score 452 70784)
(highest-score 452 7078400)
