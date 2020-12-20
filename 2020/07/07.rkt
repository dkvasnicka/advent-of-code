#lang racket

(require racklog
         (only-in threading ~>)
         (only-in rackjure str))

(struct bag (color content cnt)
  #:methods gen:equal+hash
  [(define (equal-proc b1 b2 recursive-equal?)
     (equal? (bag-color b1) (bag-color b2)))
   (define (hash-proc bag __)
     (equal-hash-code bag))
   (define (hash2-proc bag __)
     (equal-secondary-hash-code bag))]
  #:methods gen:custom-write
  [(define (write-proc b port mode)
     (write-string (str "#<" (bag-color b) ">") port))])

(define *head-regex* #px"^([\\w\\s]+) bags contain ((\\d+) ([\\w\\s]+)|no other) bag(s{0,1})")
(define *other-regex* #px"^(\\d+) ([\\w\\s]+) bag(s{0,1})")

(define (parse-bag line)
  (match-let* ([(list head other ...) (string-split line ",")]
               [(pregexp *head-regex* (list _ color _ cnt content _)) head])
    (bag color
         (flatten
           (cons (if content (bag content '() cnt) '())
                 (for/list ([bagspec other])
                   (bag
                     (third
                       (regexp-match *other-regex* (string-trim bagspec)))
                     '()
                     0))))
         0)))

(define %contains %empty-rel)

(for ([b (for/stream ([l (in-lines)] #:unless (string-prefix? l "shiny gold")) ; Part 2 needs this
           (parse-bag l))]
      #:unless (null? (bag-content b)))
  (for ([in (bag-content b)])
    (%assert! %contains ()
              [(b in)])))

(define %eventually-contains
  (%rel (x y z)
        [(x z) (%contains x z)]
        [(x z) (%contains x y)
               (%eventually-contains y z)]))

; Part 1
(displayln
  (~> (%which (bags-with-gold-bags)
              (%let (a-bag x)
                    (%set-of x (%eventually-contains x (bag "shiny gold" '() 0))
                             bags-with-gold-bags)))
      first
      length
      sub1))

; Part 2
; (displayln
  ; (~> (%which (bags-in-my-gold-bag)
              ; (%let (a-bag x)
                    ; (%set-of x (%eventually-contains "shiny gold" x)
                             ; bags-in-my-gold-bag)))
      ; first
      ; length
      ; sub1))
