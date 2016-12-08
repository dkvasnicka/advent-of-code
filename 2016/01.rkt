#lang rackjure

(require srfi/13
         math/array)

(current-curly-dict hash)
(struct rule (adjustment result-dir) #:transparent)

(define traversal-rules
  {'up    {"L" (rule (array #[-1 0]) 'left) 
           "R" (rule (array #[1 0]) 'right)}
   'right {"L" (rule (array #[0 1]) 'up) 
           "R" (rule (array #[0 -1]) 'down)}
   'down  {"L" (rule (array #[1 0]) 'right) 
           "R" (rule (array #[-1 0]) 'left)}
   'left  {"L" (rule (array #[0 -1]) 'down) 
           "R" (rule (array #[0 1]) 'up)}})

(define (new-position pos adj mult)
  (array+ pos (array-scale adj mult)))

(define (walk-the-walk)
  (for/fold ([pos (array #[0 0])]
             [dir 'up])
            ([cmd (sequence-map symbol->string (in-port))])
    (let* ([c ((string-take cmd 1) (dir traversal-rules))]
           [newpos (new-position pos (rule-adjustment c) (string->number 
                                                           (string-drop cmd 1)))])
      (values newpos (rule-result-dir c)))))

(let-values ([(dest _) (walk-the-walk)])
  (array-all-sum (array-abs dest)))
