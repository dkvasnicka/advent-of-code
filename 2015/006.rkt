#lang typed/racket

(require math/array)

(: parse-command (-> String (Listof Integer)))
(define (parse-command l)
  (map (cast string->number (-> String Integer))
       (regexp-match* #rx"[0-9]+" l)))

(: line-to-slice (-> String (Listof Slice-Spec)))
(define (line-to-slice l)
  (let ([nums (parse-command l)])
    (list
      (:: (car nums) (add1 (caddr nums)))
      (:: (cadr nums) (add1 (cadddr nums))))))

(let ([ary : (Settable-Array Nonnegative-Integer) (array->mutable-array (make-array #(1000 1000) 0))]
      [one : (Array Nonnegative-Integer) (array 1)]
      [zero : (Array Nonnegative-Integer) (array 0)])
  (for ([l (in-lines)])
    (let ([prefix (regexp-match #rx"[a-z ]+" l)]
          [slice (line-to-slice l)])
      (case (car (cast prefix (Listof String)))
        [("turn on ") (array-slice-set! ary slice one)]
        [("turn off ") (array-slice-set! ary slice zero)]
        [else (array-slice-set! ary slice 
                (array-map (λ ([v : Nonnegative-Integer]) (if (= 0 v) 1 0))
                           (array-slice-ref ary slice)))])))
  (array-all-sum ary))
