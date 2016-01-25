#lang typed/racket

(require math/array)

(require/typed rnrs/io/ports-6 
               [open-file-input-port (-> String Input-Port)])

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

(let ([ary : (Settable-Array Boolean) (array->mutable-array (make-array #(1000 1000) #f))]
      [trues : (Array Boolean) (array #t)]
      [falses : (Array Boolean) (array #f)])
  (for ([l (in-lines (open-file-input-port "006.txt"))])
    (let ([prefix (regexp-match #rx"[a-z ]+" l)]
          [slice (line-to-slice l)])
      (case (car (cast prefix (Listof String)))
        [("turn on ") (array-slice-set! ary slice trues)]
        [("turn off ") (array-slice-set! ary slice falses)]
        [else (array-slice-set! ary slice (array-map not (array-slice-ref ary slice)))])))
  (array-count (inst identity Boolean) ary))
