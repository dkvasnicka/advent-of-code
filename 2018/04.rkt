#lang racket

(require (file "~/Library/Racket/7.0/pkgs/ftree/intervaltree/main.rkt")
         (prefix-in c: data/collection)
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

(define-values (guard-records total-sleeps)
  (for/fold ([current-guard #f] [records (hasheq)] [total-sleeps (hasheq)] [current-interval-start #f]
             #:result (values records total-sleeps))
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
(define ((intervals-on-minute recs) point)
  (length (it-match recs point point)))

(displayln
  (match-let* ([(cons sleepyhead-id _) (c:find-max total-sleeps #:key cdr)]
               [sleepyhead-records (hash-ref guard-records sleepyhead-id)])
    (* sleepyhead-id
       (c:find-max (in-range 0 60)
                   #:key (intervals-on-minute sleepyhead-records)))))

; Part 2
(define-values (most-predictable-sleeper _ sleepiest-minute)
  (for/fold ([most-predictable-sleeper #f] [max-sleeps -inf.0] [sleepiest-minute #f])
            ([(guard-id records) guard-records])
    (match-let ([(list sleeps top-min)
                 (c:find-max #:key car (c:map (λ (m) (list ((intervals-on-minute records) m) m))
                                              (in-range 0 60)))])
      (if (> sleeps max-sleeps)
          (values guard-id sleeps top-min)
          (values most-predictable-sleeper max-sleeps sleepiest-minute)))))

(displayln (* most-predictable-sleeper sleepiest-minute))
