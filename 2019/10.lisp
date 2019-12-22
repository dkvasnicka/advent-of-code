(require "fset")
(defpackage #:aoc2019d10
  (:use :cl :iterate :alexandria :serapeum :parachute)
  (:shadowing-import-from :iterate collecting until finish collect summing sum in)
  (:shadowing-import-from :parachute of-type featurep true))
(in-package #:aoc2019d10)

(defstruct pt x y)

(defun add-point (coords pts)
  (destructuring-bind (y x) coords
    (fset:with pts (make-pt :x x :y y))))

(defun read-asteroids (s size)
  (iter (for idx from 0 below (expt size 2))
        (when (equal (read-char s) #\#)
              (accumulate (multiple-value-list (floor idx size)) :by #'add-point
                          :initial-value (fset:empty-set)))))

(defun main ()
  (princ (read-asteroids *standard-input* 27)))

(define-test "create a set of points"
  (is equalp
      (fset:set (make-pt :x 0 :y 1))
      (with-input-from-string (s "..#.")
        (read-asteroids s 2))))

(test *package*)
