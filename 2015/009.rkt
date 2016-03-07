#lang racket

(require graph)

(provide find-path)

(define (lines-seq)
  (sequence-map (curry regexp-match* #rx"(?![to])[a-zA-Z0-9]+")
                (in-lines)))

(define (read-edges)
  (let ([g (weighted-graph/undirected '())])
    (for ([l (lines-seq)])
      (add-edge! g (first l) (second l) (string->number (third l))))
    g))

(define (shortest-from g vertices origin start)
  (let ([new-vset (set-remove vertices start)])
    (cond
      [(set-empty? new-vset) (edge-weight g start origin)]
      [(= (set-count vertices) (set-count new-vset)) -inf.0]
      [else (sequence-fold max -inf.0
              (sequence-map (λ (v) (+ (edge-weight g start v)
                                      (shortest-from g new-vset origin v)))
                            (in-neighbors g start)))])))

(define (find-path g)
  (let* ([vertices (list->set (get-vertices g))])
    (sequence-fold max -inf.0 
                   (sequence-map (λ (v) (shortest-from g vertices v v)) 
                                 (in-vertices g)))))

; (find-path (read-edges))

; part 1 just uses 'min' and +inf.0 instead of 'max' and -inf.0
