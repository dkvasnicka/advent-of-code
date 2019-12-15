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

(defun sum-orbits (g &optional (n "COM") (prev -1) (steps 0))
  (let ((nbrs (remove prev (neighbors g n))))
    (+ steps
       (if (null nbrs)
           0
           (iter (for nbr in nbrs)
                 (sum (sum-orbits g nbr n (1+ steps))))))))

(defun read-graph ()
  (iter (for l in-stream *standard-input* :using #'read-line)
        (accumulate (split-sequence #\) l) by #'add-nodes-and-edge
                    initial-value (make-graph)
                    into g)
        (finally
          (return g))))

(defun path-to-santa (g)
  (- (length (find-shortest-path g "YOU" "SAN"))
     2))

(defun main ()
  (let ((g (read-graph)))
    ; Part 1
    (format t "~a~%" (sum-orbits g (lookup-node g "COM")))
    ; Part 2
    (princ (path-to-santa g))))
