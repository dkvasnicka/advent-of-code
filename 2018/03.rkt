#lang racket

(require math/array)

(define data
  (stream-map
    (compose
      (curry map string->number)
      rest
      (curry regexp-match #px"([0-9]+),([0-9]+):\\s([0-9]+)x([0-9]+)"))
    (sequence->stream (in-lines))))

; Part 1
(define (array-update! arr js updater)
  (let ([current (array-ref arr js)])
    (when (< current 2)
      (array-set! arr js (updater current)))))

(let ([fabric (array->mutable-array (make-array #[1000 1000] 0))])
  (for ([rect data])
    (for* ([x (in-range (first rect) (+ (first rect) (third rect)))]
           [y (in-range (second rect) (+ (second rect) (fourth rect)))])
      (array-update! fabric (vector y x) add1)))

  (displayln
    (array-count (curry < 1) fabric)))
