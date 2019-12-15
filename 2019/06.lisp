(require "graph-utils")
(defpackage #:aoc2019d06
  (:use :cl :iterate :alexandria :serapeum :rove :graph-utils)
  (:shadowing-import-from :iterate collecting summing sum in)
  (:shadowing-import-from :graph-utils select))
(in-package #:aoc2019d06)

(defun add-nodes-and-edge (nodes g)
  (destructuring-bind (a b) nodes
    (add-node g a)
    (add-node g b)
    (add-edge g a b))
  g)

(defun sum-orbits (g &optional (n "COM") (steps 0))
  (let ((neighbors (outbound-neighbors g n)))
    (+ steps
       (if (null neighbors)
           0
           (iter (for nbr in neighbors)
                 (sum (sum-orbits g nbr (1+ steps))))))))

(defun main ()
  (princ
    (iter (for l in-stream *standard-input* :using #'read-line)
          (accumulate (split-sequence #\) l) by #'add-nodes-and-edge
                      initial-value (make-graph :directed? t)
                      into g)
          (finally
            (return (sum-orbits g))))))
