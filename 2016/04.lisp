(load "package.lisp")
(require "cl-ppcre")
(in-package :aoc2016)

(defun comp-chars (l r)
  (with (((l-ch l-cnt) l) ((r-ch r-cnt) r))
    (or (> l-cnt r-cnt)
        (and (= l-cnt r-cnt) (char< l-ch r-ch)))))

(defun most-common-chars (hist)
  (collect-elements
    (iter (for (ch cnt) in-hashtable hist)
          (accumulate (list ch cnt)
                      :by (flip #'insert-new-item)
                      :initial-value (make-instance 'sorted-list-container
                                                    :sorter #'comp-chars)))
    :transform #'car))

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
  ; 0.099 seconds of real time
  ; 0.098724 seconds of total run time (0.084180 user, 0.014544 system)
  ; [ Run times consist of 0.067 seconds GC time, and 0.032 seconds non-GC time. ]
  ; 100.00% CPU
  ; 112 lambdas converted
  ; 277,395,235 processor cycles
  ; 10,193,408 bytes consed
