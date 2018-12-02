#lang rackjure

(require list-utils
         data/collection)

(define data (map string->list (sequence->stream (in-lines))))

; Part 1
(define (process-id desired-freqs freq-vals counts)
  (if (null? desired-freqs)
      counts
      (process-id (cdr desired-freqs)
                  freq-vals
                  (if (member (car desired-freqs) freq-vals)
                      (hash-update counts (car desired-freqs) add1 0)
                      counts))))

(define id-candidate-counts
  (for/fold ([counts (hasheq)])
            ([box-id data])
    (let* ([freqs (frequencies box-id)]
           [freq-vals (hash-values freqs)])
      (process-id '(2 3) freq-vals counts))))

(displayln
  (* (id-candidate-counts 2) (id-candidate-counts 3)))

; Part 2
(define (similarity id-pair)
  (for/sum ([ch1 (first id-pair)]
            [ch2 (second id-pair)])
    (if (char=? ch1 ch2) 1 0)))

(define most-similar-pair
  (find-max (filter (λ (s) (not (eq? (first s) (second s))))
                    (cartesian-product data data))
            #:key similarity))

(displayln
  (list->string
    (for/list ([ch1 (first most-similar-pair)]
               [ch2 (second most-similar-pair)]
               #:when (char=? ch1 ch2))
      ch1)))
