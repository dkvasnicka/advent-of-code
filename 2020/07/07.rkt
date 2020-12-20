#lang racket

; Learnings: Prolog-style programming was cool and succint for part 1 but given the
; differing requirements of the 2 parts of the problem I would have probably been
; better of choosing a graph-based representation

(require racklog
         (only-in rackjure str if-let ~>))

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
     (write-string (str "#<" (bag-cnt b) " " (bag-color b) ">") port))])

(define *head-regex* #px"^([\\w\\s]+) bags contain ((\\d+) ([\\w\\s]+)|no other) bag(s{0,1})")
(define *other-regex* #px"^(\\d+) ([\\w\\s]+) bag(s{0,1})")

(define (parse-bag line)
  (match-let* ([(list head other ...) (string-split line ",")]
               [(pregexp *head-regex* (list _ color _ cnt content _)) head])
    (bag color
         (flatten
           (cons (if content (bag content '() (string->number cnt)) '())
                 (for/list ([bagspec other])
                   (match-let* ([(pregexp *other-regex* (list _ other-cnt other-name _))
                                 (string-trim bagspec)])
                     (bag other-name '() (string->number other-cnt))))))
         0)))

(define %contains %empty-rel)
(define golden (box null))

(define (assert-bag! b)
  (for ([in (bag-content b)])
    (%assert! %contains ()
              [(b in)])))

(for ([b (for/stream ([l (in-lines)])
           (parse-bag l))]
      #:unless (null? (bag-content b)))
  (if (string=? (bag-color b) "shiny gold")
      (set-box! golden b) ; set shiny gold bag aside to prevent infinite loop in part 1
      (assert-bag! b)))

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
(assert-bag! (unbox golden)) ; add shiny gold bag to the relation to traverse its contents

(define (bags-inside b)
  (if-let [result (%which (inside)
                          (%let (a-bag x) (%bag-of x (%contains b x) inside)))]
          (~> result first cdr)
          '()))

(displayln
  (let loop ([contained (bags-inside (bag "shiny gold" '() 0))])
    (if (null? contained)
      0
      (for/sum ([in contained])
        (+ (bag-cnt in)
           (* (bag-cnt in) (loop (bags-inside in))))))))
