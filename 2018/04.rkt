#lang racket

(require (file "~/Library/Racket/7.0/pkgs/ftree/intervaltree/main.rkt")
         (file "~/Library/Racket/7.0/pkgs/ftree/ftree/main.rkt")
         "utils.rkt"
         data/splay-tree
         mischief/for
         gregor)

(define log-pattern #px"\\[(.+)\\] (Guard #([0-9]+) begins shift|wakes up|falls asleep)")
(define timestamp-format "yyyy-MM-dd HH:mm")

(define/match (parse logentry)
  [((list datetime event #f))
   (values (parse-datetime datetime timestamp-format) event)]
  [((list datetime _ guard-id))
   (values (parse-datetime datetime timestamp-format) (string->number guard-id))])

(define data
  (for/dict! (make-splay-tree datetime-order) ([l (in-lines)])
    (let ([logentry (rest (regexp-match log-pattern l))])
      (parse logentry))))

(define-values (_ guard-records total-sleeps __)
  (for/fold ([current-guard #f]
             [records (hasheq)]
             [total-sleeps (hasheq)]
             [current-interval-start #f])
    ([(timestamp evt) (in-dict data)])
    (match evt
      [(? number? guard-id) (values guard-id records total-sleeps current-interval-start)]
      ["falls asleep" (values current-guard records total-sleeps (->minutes timestamp))]
      ["wakes up" (values
                    current-guard
                    (hash-update records
                                 current-guard
                                 (curry it-insert current-interval-start (sub1 (->minutes timestamp)))
                                 (λ () (mk-itree)))
                    (hash-update total-sleeps
                                 current-guard
                                 (curry + (- (->minutes timestamp) current-interval-start))
                                 0)
                    #f)])))

; Part 1
(displayln
  (match-let* ([(cons sleepyhead-id _)
                (sequence-argmax cdr (in-hash-pairs total-sleeps))]
               [sleepyhead-records (hash-ref guard-records sleepyhead-id)])
    (* sleepyhead-id
       (sequence-argmax (λ (i) (length (it-match sleepyhead-records i i)))
                        (in-range 0 60)))))
