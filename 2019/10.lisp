(require "hh-redblack")
(defpackage #:aoc2019d10
  (:use :cl :iterate :alexandria :serapeum :parachute :hh-redblack)
  (:shadowing-import-from :iterate collecting until finish collect summing sum in)
  (:shadowing-import-from :parachute of-type featurep true))
(in-package #:aoc2019d10)

(defstruct pt x y)

(defun read-asteroids (s size)
  (iter (for idx from 0 below (expt size 2))
        (when (eq (read-char s) #\#)
          (collect (mvlet ((y x (floor idx size)))
                     (make-pt :x x :y y))))))

(defun in-radians (s a)
  (atan (- (pt-x a) (pt-x s))
        (- (pt-y a) (pt-y s))))

(defun angle (s a)
  (let ((degrees (round-to (* (/ 180 pi) (in-radians s a)) 0.00001)))
    (if (minusp degrees)
        (+ degrees 360)
        degrees)))

(defun dist (s a)
  (sqrt (+ (expt (- (pt-x s) (pt-x a)) 2)
           (expt (- (pt-y s) (pt-y a)) 2))))

(defun add-asteroid (polar accum)
  (destructuring-bind (a d) polar
    (mvlet ((val present? (rb-get accum a)))
      (if present?
          (heap-insert val d)
          (let ((new-heap (make-heap :test #'<)))
            (heap-insert new-heap d)
            (rb-put accum a new-heap)))
      accum)))

(defun count-visible-asteroids (station asteroids)
  (iter (for a in asteroids)
        (unless (equalp a station)
          (accumulate (list (angle station a)
                            (dist station a)) :by #'add-asteroid
                      :initial-value (make-red-black-tree) :into angles))
        (finally (return (rb-size angles)))))

(defun main ()
  (princ
    ; TODO: find maximizing; let & return a, count of angles, angles
    (let ((asteroids (read-asteroids *standard-input* 27)))
      (iter (for a in asteroids)
            (maximize (count-visible-asteroids a asteroids))))))

(define-test "create a set of points"
  (is equalp
      (list (make-pt :x 0 :y 1))
      (with-input-from-string (s "..#.")
        (read-asteroids s 2))))

(define-test "compute angle in 0-360 deg scale"
  (is = 45 (angle (make-pt :x 0 :y 0)
                  (make-pt :x 1 :y 1)))
  (is = 135 (angle (make-pt :x 0 :y 0)
                   (make-pt :x 1 :y -1)))
  (is = 180 (angle (make-pt :x 0 :y 0)
                   (make-pt :x 0 :y -1)))
  (is = 225 (angle (make-pt :x 0 :y 0)
                   (make-pt :x -1 :y -1)))
  (is = 315 (angle (make-pt :x 0 :y 0)
                   (make-pt :x -1 :y 1))))

(test *package*)
