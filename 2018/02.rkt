#lang rackjure

(require list-utils)

(define data (stream-map string->list (sequence->stream (in-lines))))

; Part 1
(define (process-id desired-freqs freq-vals counts)
  (for/fold ([counts-hash counts]) ([f desired-freqs])
    (if (member f freq-vals)
        (hash-update counts-hash f add1 0)
        counts-hash)))

(define id-candidate-counts
  (for/fold ([counts (hasheq)])
            ([box-id data])
    (process-id '(2 3) (hash-values (frequencies box-id)) counts)))

(displayln
  (* (id-candidate-counts 2) (id-candidate-counts 3)))

; Part 2
(define (similarity id1 id2)
  (for/sum ([ch1 id1] [ch2 id2])
    (if (char=? ch1 ch2) 0 1)))

(match-define (list winner1 winner2)
  (for*/first ([id1 data] [id2 data]
              #:when (and (not (eq? id1 id2))
                          (= 1 (similarity id1 id2))))
    (list id1 id2)))

(displayln
  (list->string
    (for/list ([ch1 winner1] [ch2 winner2]
               #:when (char=? ch1 ch2))
      ch1)))
