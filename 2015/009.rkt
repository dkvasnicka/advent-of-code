#lang racket

(require graph)

(define (lines-seq)
  (sequence-map (curry regexp-match* #rx"(?![to])[a-zA-Z0-9]+")
                (in-lines)))

(define (read-edges)
  (let ([g (weighted-graph/undirected '())])
    (for ([l (lines-seq)])
      (let ([weight (string->number (third l))])
        (add-edge! g (first l) (second l) weight)
        (add-edge! g (second l) (first l) weight))) 
    g))

(define (shortest-from g vertices start)
  (let ([new-vset (set-remove vertices start)])
    (cond
      [(set-empty? new-vset) 0]
      [(= (set-count vertices) (set-count new-vset)) -inf.0]
      [else (sequence-fold max -inf.0
              (sequence-map (λ (v) (+ (edge-weight g start v)
                                      (shortest-from g new-vset v)))
                            (in-neighbors g start)))])))

(let* ([g (read-edges)]
       [vertices (list->set (get-vertices g))])
  (sequence-fold max -inf.0 
                 (sequence-map (curry shortest-from g vertices) 
                               (in-vertices g))))

; part 1 just uses 'min' and +inf.0 instead of 'max' and -inf.0
