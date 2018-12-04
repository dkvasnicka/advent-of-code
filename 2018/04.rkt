#lang racket

(require (file "~/Library/Racket/7.0/pkgs/ftree/intervaltree/main.rkt")
         (file "~/Library/Racket/7.0/pkgs/ftree/ftree/main.rkt")
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

(define-values (_ guard-records __)
  (for/fold ([current-guard #f]
             [records (hasheq)]
             [current-interval-start #f])
    ([(timestamp evt) (in-dict data)])
    (match evt
      [(? number? guard-id) (values guard-id records current-interval-start)]
      ["falls asleep" (values current-guard records (->minutes timestamp))]
      ["wakes up" (values
                    current-guard
                    (hash-update records
                                 current-guard
                                 (curry it-insert current-interval-start (sub1 (->minutes timestamp)))
                                 (λ () (mk-itree)))
                    #f)])))

; Part 1
(define (sleep-duration it)
  (for/sum ([snooze (it-match it 0 60)])
    (- (interval-high snooze) (interval-low snooze) -1)))

(define-values (___ sleepyhead-id sleepyhead-records)
  (for/fold ([minutes-slept 0]
             [sleepyhead-id #f]
             [sleepyhead-records #f])
    ([(guard-id intervals) (in-hash guard-records)])
    (let ([sleep (sleep-duration intervals)])
      (if (> sleep minutes-slept)
          (values sleep guard-id intervals)
          (values minutes-slept sleepyhead-id sleepyhead-records)))))

(displayln
  (* sleepyhead-id
     (argmax (λ (i) (length (it-match sleepyhead-records i i)))
             (range 0 60))))
