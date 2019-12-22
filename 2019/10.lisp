(require "hash-set")
(defpackage #:aoc2019d10
  (:use :cl :iterate :alexandria :serapeum :parachute :hash-set)
  (:shadowing-import-from :iterate collecting until finish collect summing sum in)
  (:shadowing-import-from :parachute of-type featurep true))
(in-package #:aoc2019d10)

(defstruct pt x y)

(defun read-asteroids (s size)
  (iter (for idx from 0 below (expt size 2))
        (when (eq (read-char s) #\#)
              (collect (mvlet ((y x (floor idx size)))
                         (make-pt :x x :y y))))))

(defun angle (s a)
  (if (equalp s a)
      nil
      (atan (- (pt-y a) (pt-y s))
            (- (pt-x a) (pt-x s)))))

(defun count-visible-asteroids (station asteroids)
  (iter (for a in asteroids)
        (when-let (alpha (angle station a))
          (accumulate alpha :by (flip #'hs-ninsert)
                      :initial-value (make-hash-set) :into angles))
        (finally (return (hs-count angles)))))

(defun main ()
  (princ
    (let ((asteroids (read-asteroids *standard-input* 27)))
      (iter (for a in asteroids)
            (maximize (count-visible-asteroids a asteroids))))))

(define-test "create a set of points"
  (is equalp
      (list (make-pt :x 0 :y 1))
      (with-input-from-string (s "..#.")
        (read-asteroids s 2))))

(test *package*)
