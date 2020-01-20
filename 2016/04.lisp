(load "package.lisp")
(require "cl-ppcre")
(in-package :aoc2016)

(defun most-common-chars (hist)
  (map 'list #'car
       (sort (hash-table-alist hist)
             (lambda (l r) (or (> (cdr l) (cdr r))
                               (and (= (cdr l) (cdr r))
                                    (char< (car l) (car r))))))))

(defun real-room? (sector-name checksum)
  (starts-with-subseq checksum (most-common-chars
                                 (iter (for ch in-string sector-name)
                                       (when (alphanumericp ch)
                                         (collect-frequencies ch))))))

(defun main ()
  (pr
    (time
      (iter (for l in-stream *standard-input* using #'read-line)
            (cl-ppcre:register-groups-bind (sector-name sector-id checksum)
              ("((?:[a-z]+\\-)+)(\\d+)\\[([a-z]+)\\]" l)
              (when (real-room? sector-name checksum)
                (sum (parse-integer sector-id))))))))

; Evaluation took:
  ; 0.011 seconds of real time
  ; 0.010700 seconds of total run time (0.010549 user, 0.000151 system)
  ; 100.00% CPU
  ; 12 lambdas converted
  ; 30,039,906 processor cycles
  ; 3,723,568 bytes consed
