(defpackage #:aoc2019d01
  (:use :cl :series))

(in-package #:aoc2019d01)

(defun main ()
  (collect-sum
    (map-fn 'number
            (lambda (mass) (- (floor mass 3) 2))
            (scan-stream *standard-input* #'read))))

(princ (main))
