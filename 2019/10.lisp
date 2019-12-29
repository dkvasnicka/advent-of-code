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
      (let ((degrees (round-to
                       (* (/ 180 pi) (atan (- (pt-x a) (pt-x s))
                                           (- (pt-y a) (pt-y s))))
                       0.00001)))
        (if (minusp degrees)
            (+ degrees 360)
            degrees))))

(defun count-visible-asteroids (station asteroids)
  (iter (for a in asteroids)
        (when-let (alpha (angle station a))
          ; TODO: RB-tree????
          (accumulate alpha :by (flip #'hs-ninsert)
                      :initial-value (make-hash-set) :into angles))
        (finally (return (hs-count angles)))))

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
