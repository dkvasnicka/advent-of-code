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
  (for/fold ([accum 0]) ([ch1 id1] [ch2 id2] #:break (= accum 2))
    (if (char=? ch1 ch2) accum (add1 accum))))

(match-define (list winner1 winner2)
  (for*/first ([id1 data] [id2 data]
               #:unless (or (eq? id1 id2)
                            (> (similarity id1 id2) 1)))
    (list id1 id2)))

(displayln
  (list->string
    (for/list ([ch1 winner1] [ch2 winner2]
               #:when (char=? ch1 ch2))
      ch1)))
