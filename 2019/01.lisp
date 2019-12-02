(defpackage #:aoc2019d01
  (:use :cl :series))

(in-package #:aoc2019d01)

(defun fuel-needed (mass)
  (let ((initial-fuel (- (floor mass 3) 2)))
    (if (<= initial-fuel 0)
        0
        (+ initial-fuel (fuel-needed initial-fuel)))))

(defun main ()
  (collect-sum
    (map-fn 'number
            #'fuel-needed
            (scan-stream *standard-input* #'read))))

(princ (main))
