#lang racket

(require (only-in data/collection reverse in map sequence->string)
         srfi/41)

(define (parse-input w)
  (for/list ([ch (reverse (in w))])
    (- (char->integer ch) 96)))

(define (conditional-add1 n)
  (+ n
     (if (or (= n 8) (= n 11) (= n 14)) 
       2 1)))

(define (increment pwd)
  (let ([inc (conditional-add1 (car pwd))])
    (if (< inc 27)
      (cons inc (cdr pwd))
      (cons 1 (increment (cdr pwd))))))

(define (secure? pwd)
  (let loop ([decs 0]
             [pairs (set)]
             [seq pwd])
    (cond 
      [(and (> decs 1) (> (set-count pairs) 1)) #t]
      [(null? (cdr seq)) #f]
      [else (loop
              (if (= 1 (- (car seq) (cadr seq))) (add1 decs) (if (> decs 1) decs 0))
              (if (= (car seq) (cadr seq)) (set-add pairs (car seq)) pairs)
              (cdr seq))])))

(define (back-to-string newpwd)
  (sequence->string
    (map (λ (i) (integer->char (+ i 96))) 
         (reverse newpwd))))

(define (candidate-stream pwd)
  (stream-rest 
    (stream-iterate increment 
                    (parse-input pwd))))

(for/first ([pwd (current-command-line-arguments)])
           (for/first ([newpwd (candidate-stream pwd)]
                       #:when (secure? newpwd))
                      (back-to-string newpwd)))
