(require "hh-redblack")
(defpackage #:aoc2019d10
  (:use :cl :iterate :alexandria :serapeum :parachute :hh-redblack)
  (:shadowing-import-from :iterate collecting until finish collect summing sum in)
  (:shadowing-import-from :parachute of-type featurep true))
(in-package #:aoc2019d10)

(defstruct pt x y)
(defstruct polar-pt p r)

(defmethod rb< ((left number) (right number))
  (> left right))

(defun read-asteroids (s size)
  (iter (for idx from 0 below (expt size 2))
        (when (eq (read-char s) #\#)
          (collect (mvlet ((y x (floor idx size)))
                     (make-pt :x x :y y))))))

(defun in-radians (a s)
  (atan (- (pt-x a) (pt-x s))
        (- (pt-y a) (pt-y s))))

(defun angle (s a)
  (let ((α (round-to (* (/ 180 pi) (in-radians s a)) 0.00001)))
    (if (minusp α) (+ α 360) α)))

(defun dist (s a)
  (sqrt (+ (expt (- (pt-x s) (pt-x a)) 2)
           (expt (- (pt-y s) (pt-y a)) 2))))

(defun add-asteroid (polar accum)
  (destructuring-bind (φ ast) polar
    (mvlet ((val present? (rb-get accum φ)))
      (if present?
          (heap-insert val ast)
          (let ((new-heap (make-heap :key #'polar-pt-r :test #'<)))
            (heap-insert new-heap ast)
            (rb-put accum φ new-heap)))
      accum)))

(defun sky-map (station asteroids)
  (iter (for a in asteroids)
        (unless (equalp a station)
          (accumulate (list (angle station a)
                            (let ((r (dist station a)))
                              (make-polar-pt :p a :r r)))
                      :by #'add-asteroid
                      :initial-value (make-red-black-tree)))))

(defun encode-200th-vaporized (mp)
  (setq i 0)
  (setq result nil)
  (with-rb-keys-and-data (_ as) mp
    (incf i)
    (when (= i 199)
      (let ((closest (polar-pt-p (heap-maximum as))))
        (setf result (+ (* 100 (pt-x closest))
                        (pt-y closest))))))
  result)

(defun main ()
  (mvlet* ((asteroids (read-asteroids *standard-input* 27))
           (best-map visible (iter (for a in asteroids)
                                   (finding (sky-map a asteroids)
                                            maximizing #'rb-size into (bm siz))
                                   (finally (return (values bm siz))))))
          (format t "~a~%" visible)
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
