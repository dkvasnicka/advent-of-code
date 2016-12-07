#lang rackjure

(require srfi/13
         math/array
         lens
         lens/data/hash)

(current-curly-dict hash)
(struct cmd (adjustment result-dir) #:transparent)

(define traversal-rules
  {'up    {"L" (cmd (array #[-1 0]) 'left) 
           "R" (cmd (array #[1 0]) 'right)}
   'right {"L" (cmd (array #[0 1]) 'up) 
           "R" (cmd (array #[0 -1]) 'down)}
   'down  {"L" (cmd (array #[1 0]) 'right) 
           "R" (cmd (array #[-1 0]) 'left)}
   'left  {"L" (cmd (array #[0 -1]) 'down) 
           "R" (cmd (array #[0 1]) 'up)}})

(define (walk-the-walk)
  (for/fold ([pos (array #[0 0])]
             [dir 'up])
            ([cmd (sequence-map symbol->string (in-port))])
    (let ([c (lens-view 
               (hash-ref-nested-lens dir (string-take cmd 1))
               traversal-rules)])
      (values
        (array+ pos
                (array-scale (cmd-adjustment c)
                             (string->number (string-drop cmd 1))))
        (cmd-result-dir c)))))

(let-values ([(dest _) (walk-the-walk)])
  (array-all-sum (array-abs dest)))
