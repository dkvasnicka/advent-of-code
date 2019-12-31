(require "cl-containers")
(defpackage #:aoc2019d10
  (:use :cl :iterate :alexandria :serapeum :parachute :metabang.cl-containers)
  (:shadowing-import-from :iterate collecting until finish collect summing sum in)
  (:shadowing-import-from :serapeum filter)
  (:shadowing-import-from :parachute of-type children parent featurep true))
(in-package #:aoc2019d10)

(defstruct pt x y)
(defstruct (pt-with-distance (:include pt)) r)
(defstruct line-of-sight α items)

(defun read-asteroids (s size)
  (iter (for idx from 0 below (expt size 2))
        (when (eq (read-char s) #\#)
          (collect (mvlet ((y x (floor idx size)))
                     (make-pt :x x :y y))))))

(defun in-radians (s a)
  (atan (- (pt-x s) (pt-x a))
        (- (pt-y s) (pt-y a))))

(defun angle (s a)
  (let ((α (round-to (* (/ 180 pi) (in-radians s a)) 0.00001)))
    (if (minusp α) (+ α 360) α)))

(defun dist (s a)
  (sqrt (+ (expt (- (pt-x s) (pt-x a)) 2)
           (expt (- (pt-y s) (pt-y a)) 2))))

(defun add-asteroid (polar accum)
  (destructuring-bind (φ ast) polar
    (let ((val (item-at accum φ)))
      (if val
          (heap-insert (line-of-sight-items (element val)) ast)
          (let ((new-heap (make-heap :key #'pt-with-distance-r :test #'<)))
            (heap-insert new-heap ast)
            (insert-new-item accum (make-line-of-sight :α φ :items new-heap))))
      accum)))

(defun sky-map (station asteroids)
  (iter (for a in asteroids)
        (unless (equalp a station)
          (accumulate (list (angle station a)
                            (let ((r (dist station a)))
                              (make-pt-with-distance :x (pt-x a) :y (pt-y a)
                                                     :r r)))
                      :by #'add-asteroid
                      :initial-value (make-instance 'red-black-tree
                                                    :sorter #'>
                                                    :key #'line-of-sight-α)))))

(defun encode-200th-vaporized (mp)
  (let* ((_200th (line-of-sight-items (nth-element mp 198)))
         (closest (heap-maximum _200th)))
    (+ (* 100 (pt-x closest)) (pt-y closest))))

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
      (list (make-pt :x 0 :y 1))
      (with-input-from-string (s "..#.")
        (read-asteroids s 2))))

(define-test "compute angle in 0-360 deg scale"
  (is = 225 (angle (make-pt :x 0 :y 0)
                   (make-pt :x 1 :y 1)))
  (is = 315 (angle (make-pt :x 0 :y 0)
                   (make-pt :x 1 :y -1)))
  (is = 0 (angle (make-pt :x 0 :y 0)
                 (make-pt :x 0 :y -1)))
  (is = 45 (angle (make-pt :x 0 :y 0)
                  (make-pt :x -1 :y -1)))
  (is = 135 (angle (make-pt :x 0 :y 0)
                   (make-pt :x -1 :y 1))))

(test *package*)
