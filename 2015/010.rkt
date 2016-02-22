#lang racket

(define (counting-drop-while fn? strm (cnt 0))
  (if (or (empty? strm) (not (fn? (first strm))))
    (values cnt strm)
    (counting-drop-while fn? (rest strm) (add1 cnt))))

(define (look-and-say strm)
  (if (empty? strm)
    '()
    (let*-values ([(head) (first strm)]
                  [(cnt tail) (counting-drop-while (curry = head) strm)])
      (cons cnt
            (cons head
                  (look-and-say tail))))))

(length
  (for/fold ([initval '(1 1 1 3 1 2 2 1 1 3)])
            ([i 50])
    (look-and-say initval)))
