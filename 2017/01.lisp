(defun same? (x y)
  (if (= x y) x 0))

(defun process (last-num nums sum head)
  (if (null nums)
      (+ sum (same? last-num head))
      (process (car nums)
               (cdr nums)
               (+ sum (same? last-num (car nums)))
               head)))

(defun main ()
  (princ
    (let* ((data (for:for ((c over *standard-input*)
                           (num = (digit-char-p c))
                           (chars when num collect num))))
           (head (car data)))
      (process head (cdr data) 0 head)))
  (quit))

; (series:collect
; (series:choose-if #'alphanumericp
; (series:scan-stream *standard-input*
; #'read-char)))
