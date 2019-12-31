(require "cl-containers")
(defpackage #:aoc2019d10
  (:use :cl :iterate :alexandria :serapeum :parachute :metabang.cl-containers)
  (:shadowing-import-from :iterate collecting until finish collect summing sum in)
  (:shadowing-import-from :serapeum filter)
  (:shadowing-import-from :parachute of-type children parent featurep true))
(in-package #:aoc2019d10)

(defstruct (sky-object (:conc-name sky-)) pt r α)

(defun read-asteroids (s size)
  (iter (for idx from 0 below (expt size 2))
        (when (eq (read-char s) #\#)
          (collect (multiple-value-call #'complex (floor idx size))))))

(defun angle (s a)
  (let ((α (round-to (* (/ 180 pi) (phase (- s a))) 0.00001)))
    (if (minusp α) (+ α 360) α)))

(defun dist (s a)
  (sqrt (+ (expt (- (realpart s) (realpart a)) 2)
           (expt (- (imagpart s) (imagpart a)) 2))))

(defun add-asteroid (polar accum)
  (if-let ((val (when-let ((i (item-at accum (sky-α polar)))) (element i))))
    (if (< (sky-r polar) (sky-r val))
        (insert-new-item accum polar)
        accum)
    (insert-new-item accum polar)))

(defun sky-map (station asteroids)
  (iter (for a in asteroids)
        (unless (equalp a station)
          (accumulate (make-sky-object :pt a :α (angle station a)
                                       :r (dist station a))
                      :by #'add-asteroid
                      :initial-value (make-instance 'red-black-tree
                                                    :sorter #'>
                                                    :key #'sky-α)))))

(defun encode-200th-vaporized (mp)
  (let* ((_200th (sky-pt (nth-element mp 198))))
    (+ (* 100 (imagpart _200th)) (realpart _200th))))

(defun main ()
  (mvlet* ((asteroids (read-asteroids *standard-input* 27))
           (best-map visible (iter (for a in asteroids)
                                   (finding (sky-map a asteroids)
                                            maximizing #'size into (bm siz))
                                   (finally (return (values bm siz))))))
          ; Part 1
          (format t "~a~%" visible)
          ; Part 2
          (princ (encode-200th-vaporized best-map))))

(define-test "create a set of points"
  (is equalp
      '(#C(1 0))
      (with-input-from-string (s "..#.")
        (read-asteroids s 2))))

(define-test "compute angle in 0-360 deg scale"
  (is = 225 (angle #C(0 0)
                   #C(1 1)))
  (is = 315 (angle #C(0 0)
                   #C(-1 1)))
  (is = 0 (angle #C(0 0)
                 #C(-1 0)))
  (is = 45 (angle #C(0 0)
                  #C(-1 -1)))
  (is = 135 (angle #C(0 0)
                   #C(1 -1))))

(test *package*)
