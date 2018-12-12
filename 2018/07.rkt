#lang rackjure

(require (prefix-in h: pfds/heap/pairing))

(current-curly-dict hasheq)
(define line-regex #px"^Step ([A-Z]) must be finished before step ([A-Z]) can begin.$")

  ; -->A--->B--
 ; /    \      \
; C      -->D----->E
 ; \           /
  ; ---->F-----

(define data
  (for/fold ([out (hasheq)]) ([l (in-lines)])
    (match-let ([(list child parent) (map (compose first string->list)
                                          (cdr (regexp-match line-regex l)))])
      (~> out
          (hash-update parent (curryr set-add child) seteq)
          (hash-update child identity seteq)))))

(define (find-next h exclude)
  (for/fold ([out (h:heap char<?)])
            ([(k v) h] #:when (and (not (member k exclude)) (set-empty? v)))
    (h:insert k out)))

(define (in-heap h)
  (if (h:empty? h)
      empty-stream
      (stream-cons (h:find-min/max h)
                   (in-heap (h:delete-min/max h)))))

(define A-time (sub1 (char->integer #\A)))
(define (time-needed letter)
  (- (char->integer letter) A-time -60))
(define idle-worker {'task #f 'remaining -inf.0})

(define (splitf-workers workers)
  (for/fold ([working '()] [idle '()] [done (seteq)]) ([w workers])
    (match-let ([(hash-table ('task k) ('remaining r)) w])
      (match r
        [-inf.0 (values working (cons w idle) done)]
        [1      (values working (cons idle-worker idle) (set-add done k))]
        [_      (values (cons (hash-update w 'remaining sub1) working) idle done)]))))

(define iterations 0)

(define (reduce input workers)
  (if (hash-empty? input)
      '()
      (let*-values ([(working idle done) (splitf-workers workers)]
                    [(updated-input)
                     (for/hash ([(k v) input] #:unless (set-member? done k))
                       (values k (set-subtract v done)))]
                    [(started new-idle)
                     (for/fold ([started '()] [new-idle idle])
                                          ([w idle] [ch (h:sorted-list (find-next updated-input
                                                                                  (map (λ~> (hash-ref 'task)) working)))])
                       (values
                         (cons {'task ch 'remaining (time-needed ch)} started)
                         (cdr new-idle)))])
        (displayln (str "working: " working))
        (displayln (str "idle: " idle))
        (displayln (str "done: " done))
        (displayln (str "started: " started))
        (displayln (str "new-idle: " new-idle))
        (displayln "---------------------------------------------------")
        (when (nand (empty? started) (empty? working)) (set! iterations (add1 iterations)))
        (append (sort (set->list done) char<?)
                (reduce updated-input (append started working new-idle))))))

(displayln
  (list->string (reduce data (for*/stream ([w (in-value idle-worker)] [_ (in-range 15)]) w))))

(displayln iterations)
