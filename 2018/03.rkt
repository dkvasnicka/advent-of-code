#lang racket

(module algo typed/racket
  (require math/array)
  (provide solve-puzzles)

  (: array-update! ((Mutable-Array Integer) In-Indexes (Integer -> Integer) -> Void))
  (define (array-update! arr js updater)
    (let ([current (array-ref arr js)])
      (when (< current 2)
        (array-set! arr js (updater current)))))

  (: solve-puzzles ((Sequenceof (Listof Integer)) -> Void))
  (define (solve-puzzles data)
    (let ([fabric (array->mutable-array (make-array #[1000 1000] 0))])
      (for ([rect data])
        (for* ([x (in-range (first rect) (+ (first rect) (third rect)))]
               [y (in-range (second rect) (+ (second rect) (fourth rect)))])
          (array-update! fabric (vector y x) add1)))

      ; Part 1
      (displayln
        (array-count (λ ([x : Integer]) (> x 1)) fabric))

      ; Part 2
      )))

(require 'algo)
(define data
  (for/stream ([l (in-lines)])
    (map string->number
         (rest
           (regexp-match #px"([0-9]+),([0-9]+):\\s([0-9]+)x([0-9]+)" l)))))

(solve-puzzles data)
