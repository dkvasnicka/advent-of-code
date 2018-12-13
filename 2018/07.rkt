#lang racket

(require struct-update
         threading)

(define line-regex #px"^Step ([A-Z]) must be finished before step ([A-Z]) can begin.$")

(define data
  (for/fold ([out (hasheq)]) ([l (in-lines)])
    (match-let ([(list child parent) (map (compose first string->list)
                                          (cdr (regexp-match line-regex l)))])
      (~> out
          (hash-update parent (curryr set-add child) seteq)
          (hash-update child identity seteq)))))

(define (find-next h exclude)
  (sort
    (for/list ([(k v) h] #:when (and (not (set-member? exclude k)) (set-empty? v))) k)
    char<?))

(define A-time (sub1 (char->integer #\A)))
(define (time-needed letter)
  (- (char->integer letter) A-time -60))

(struct worker (task remaining) #:transparent)
(define-struct-updaters worker)
(define idle-worker (worker #f -inf.0))

(define (segment-workers workers)
  (for/fold ([working '()] [idle '()] [done (seteq)]) ([w workers])
    (match-let ([(worker k r) w])
      (match r
        [-inf.0 (values working (cons w idle) done)]
        [1      (values working (cons idle-worker idle) (set-add done k))]
        [_      (values (cons (worker-remaining-update w sub1) working) idle done)]))))

(define (maybe-start-tasks idle updated-input working)
  (for/fold ([started '()] [new-idle idle])
            ([w idle] [ch (find-next updated-input (for/seteq ([w working]) (worker-task w)))])
    (values
      (cons (worker ch (time-needed ch)) started)
      (cdr new-idle))))

(define (prune-input input done)
  (for/hash ([(k v) input] #:unless (set-member? done k))
    (values k (set-subtract v done))))

(define (do-work input workers)
  (if (hash-empty? input)
      empty-stream
      (let*-values ([(working idle done) (segment-workers workers)]
                    [(updated-input) (prune-input input done)]
                    [(started new-idle) (maybe-start-tasks idle updated-input working)])
        (stream-cons
          (list (sort (set->list done) char<?)
                (if (nand (empty? started) (empty? working)) 1 0))
          (do-work updated-input (append started working new-idle))))))

(time
  (for/fold ([out '()] [iterations 0] #:result (values (list->string out) iterations))
            ([step (do-work data (sequence-map (const idle-worker) (in-range 15)))])
    (values (append out (first step)) (+ iterations (second step)))))
