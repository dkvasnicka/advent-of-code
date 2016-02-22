#lang typed/racket

(require racket/fixnum)

(: counting-drop-while (->* ((-> Integer Boolean) (Listof Integer)) (Integer) (Values Integer (Listof Integer))))
(define (counting-drop-while fn? strm (cnt 0))
  (if (or (empty? strm) (not (fn? (first strm))))
    (values cnt strm)
    (counting-drop-while fn? (rest strm) (add1 cnt))))

(: look-and-say (-> (Listof Integer) (Listof Integer)))
(define (look-and-say strm)
  (if (empty? strm)
    '()
    (let*-values ([(head) (first strm)]
                  [(cnt tail) (counting-drop-while (curry eq? head) strm)])
      (cons cnt
            (cons head
                  (look-and-say tail))))))

(length
  (for/fold ([initval : (Listof Integer) '(1 1 1 3 1 2 2 1 1 3)])
            ([i 50]) : (Listof Integer)
    (look-and-say initval)))
