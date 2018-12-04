#lang racket

(module algo typed/racket
  (require math/array)
  (provide solve-puzzles claim)

  (struct claim
    ([xl : Natural] [xr : Natural]
     [yt : Natural] [yb : Natural])
    #:transparent)

  (: array-update! ((Mutable-Array Integer) In-Indexes (Integer -> Integer) -> Void))
  (define (array-update! arr js updater)
    (let ([current (array-ref arr js)])
      (when (< current 2)
        (array-set! arr js (updater current)))))

  (: solve-puzzles ((Sequenceof claim) -> Void))
  (define (solve-puzzles data)
    (let ([fabric (array->mutable-array (make-array #[1000 1000] 0))])
      (for ([rect data])
        (for* ([x (in-range (claim-xl rect) (claim-xr rect))]
               [y (in-range (claim-yt rect) (claim-yb rect))])
          (array-update! fabric (vector y x) add1)))

      ; Part 1
      (displayln
        (array-count (λ ([x : Integer]) (> x 1)) fabric))

      ; Part 2
      (: non-overlapping? (claim -> Boolean))
      (define (non-overlapping? rect)
        (= (array-all-max
             (array-slice-ref fabric
                              (list
                                (:: (claim-yt rect) (claim-yb rect))
                                (:: (claim-xl rect) (claim-xr rect)))))
           1))

      (displayln
        (for/fold ([result 0])
                  ([rect data]
                   [i (in-naturals)] #:final (non-overlapping? rect))
          (add1 i))))))

(require 'algo)

(define spec-regex #px"([0-9]+),([0-9]+):\\s([0-9]+)x([0-9]+)")

(define data
  (for/stream ([l (in-lines)])
    (match-let ([(list _ xl yt width height)
                 (map string->number (regexp-match spec-regex l))])
      (claim xl (+ xl width) yt (+ yt height)))))

(solve-puzzles data)
