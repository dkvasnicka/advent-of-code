(load "package.lisp")
(in-package :aoc2016)

(defun main ()
  (println
    (collect-length
      (choose
        (mapping (((x y z) (chunk 3 3 (scan-stream *standard-input*))))
                 (and (> (+ x y) z)
                      (> (+ x z) y)
                      (> (+ z y) x)))))))
