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

(define-type Slice-Transformer (-> (Array Integer) (Array Integer)))

(: process-instructions (-> Slice-Transformer Slice-Transformer Slice-Transformer Integer))
(define (process-instructions turn-on turn-off toggle)
  (let ([ary : (Settable-Array Integer) 
        (array->mutable-array (make-array #(1000 1000) 0))])
    (for ([l (in-lines)])
      (let* ([prefix (regexp-match #rx"[a-z ]+" l)]
             [slice-spec (line-to-slice l)]
             [slice (array-slice-ref ary slice-spec)])
        (array-slice-set! ary slice-spec
                          (case (car (cast prefix (Listof String)))
                            [("turn on ") (turn-on slice)]
                            [("turn off ") (turn-off slice)]
                            [else (toggle slice)]))))
    (array-all-sum ary)))

(define (part1)
  (let ([one : (Array Integer) (array 1)]
        [zero : (Array Integer) (array 0)])
    (process-instructions (λ (_) one) 
                          (λ (_) zero) 
                          (λ (s) (array-map (λ ([v : Integer]) (if (= 0 v) 1 0)) s)))))

(define (part2)
  (process-instructions (λ (s) (array+ s (array 1))) 
                        (λ (s) (array-if (array= s (array 0)) s (array- s (array 1)))) 
                        (λ (s) (array+ s (array 2)))))
