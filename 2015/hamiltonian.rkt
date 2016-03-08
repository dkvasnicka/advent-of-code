#lang racket

(require graph)

(provide hamiltonian)

(define (shortest-from g vertices origin start)
  (let ([new-vset (set-remove vertices start)])
    (cond
      [(set-empty? new-vset) (if origin (edge-weight g start origin) 0)]
      [(= (set-count vertices) (set-count new-vset)) -inf.0]
      [else (sequence-fold max -inf.0
              (sequence-map (λ (v) (+ (edge-weight g start v)
                                      (shortest-from g new-vset origin v)))
                            (in-neighbors g start)))])))

(define (hamiltonian g #:type type)
  (let ([vertices (list->set (get-vertices g))])
    (sequence-fold max -inf.0 
                   (sequence-map (λ (v) 
                                    (shortest-from 
                                      g vertices 
                                      (match type ['cycle v] ['path #f]) v)) 
                                 (in-vertices g)))))

; Day 9: part 1 just uses 'min' and +inf.0 instead of 'max' and -inf.0
