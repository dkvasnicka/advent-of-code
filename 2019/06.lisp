(require "graph-utils")
(defpackage #:aoc2019d06
  (:use :cl :iterate :alexandria :serapeum :rove)
  (:shadowing-import-from :iterate collecting summing sum in))
(in-package #:aoc2019d06)

(defun add-node (nodes g)
  (destructuring-bind (a b) nodes
    (graph-utils:add-node g a)
    (graph-utils:add-node g b)
    (graph-utils:add-edge g a b))
  g)

(defun sum-orbits (g &optional (n "COM") (steps 0))
  (let ((neighbors (graph-utils:outbound-neighbors g n)))
    (if (null neighbors)
        steps
        (+ steps
           (iter (for nbr in neighbors)
                 (sum (sum-orbits g nbr (1+ steps))))))))

(defun main ()
  (princ
    (iter (for l in-stream *standard-input* :using #'read-line)
          (accumulate (split-sequence #\) l) by #'add-node
                      initial-value (graph-utils:make-graph :directed? t)
                      into g)
          (finally
            (return (sum-orbits g))))))
