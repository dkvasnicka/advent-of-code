(load "package.lisp")
(require "array-operations")
(in-package :aoc2016)

(defparameter *dimensions* '(1908 3))

(defun count-triangles (mx)
  (aops:reduce-index #'+ i
    (let ((x (aref mx i 0))
          (y (aref mx i 1))
          (z (aref mx i 2)))
      (if (and (> (+ x y) z)
               (> (+ x z) y)
               (> (+ z y) x))
        1 0))))

(defun main ()
  (let ((triangles (aops:generate #'read *dimensions*)))
    (pr (count-triangles triangles))
    (pr (count-triangles
          (aops:reshape
            (aops:permute '(1 0) triangles)
            *dimensions*)))))
