#lang racket

(require racklog (only-in threading ~>))

(struct bag (color content) #:transparent)

(define *head-regex* #px"^([\\w\\s]+) bags contain ((\\d+) ([\\w\\s]+)|no other) bag(s{0,1})")
(define *other-regex* #px"^(\\d+) ([\\w\\s]+) bag(s{0,1})")

(define (parse-bag line)
  (match-let* ([(list head other ...) (string-split line ",")]
               [(pregexp *head-regex* (list _ color _ _ content _)) head])
    (bag color
         (flatten
           (cons (or content '())
                 (map (λ (bagspec) (third (regexp-match *other-regex* (string-trim bagspec))))
                      other))))))

(define %contains %empty-rel)

(for ([b (sequence-map parse-bag (in-lines))]
      #:unless (null? (bag-content b)))
  (for ([in (bag-content b)])
    (%assert! %contains ()
              [((bag-color b) in)])))

(define %eventually-contains
  (%rel (x y z)
        [(x z)
         (%contains x y)
         (%contains y z)]))

(let ([pt1 (%which (bags-with-gold-bags)
                   (%let (a-bag x)
                         (%set-of x (%eventually-contains x "shiny gold")
                                  bags-with-gold-bags)))])
  (displayln (~> pt1 first length sub1))
  pt1)
