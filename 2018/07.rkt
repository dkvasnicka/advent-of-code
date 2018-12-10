#lang rackjure

(define line-regex #px"^Step ([A-Z]) must be finished before step ([A-Z]) can begin.$")

  ; -->A--->X--
 ; /    \      \
; C      -->D----->E
 ; \           /
  ; ---->F-----
; D -> Y -> F
; N -> E

(define data
  (for/fold ([out (hasheq)]) ([l (in-lines)])
    (match-let ([(list child parent) (map (compose first string->list)
                                          (cdr (regexp-match line-regex l)))])
      (~> out
          (hash-update parent (curryr set-add child) seteq)
          (hash-update child identity seteq)))))

(define (find-next h)
  (for/fold ([out #\a])
            ([(k v) h] #:when (set-empty? v))
    (if (char<? k out) k out)))

(list->string
  (let loop ([input data])
    (if (hash-empty? input)
        '()
        (let* ([next (find-next input)]
               [updated-input
                (for/hash ([(k v) input] #:unless (eq? k next))
                  (values k (set-remove v next)))])
          (cons next (loop updated-input))))))
