(defun main ()
  (princ
    (series:collect-sum
      (series:map-fn 'number
                     (lambda (mass)
                       (- (ffloor (/ mass 3)) 2))
                     (series:scan-stream *standard-input* #'read))))
  (quit))
