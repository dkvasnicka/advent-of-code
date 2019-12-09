(require "taps")
(require "str")
(require "cl-geometry")
(defpackage #:aoc2019d03 (:use :cl :cl-geometry :iterate))
(in-package #:aoc2019d03)
(defparameter *suppress-series-warnings* t)

(defun parse-instruction (instr)
  (cons (intern (str:s-first instr))
        (parse-integer (str:s-rest instr))))

(serapeum:defalias pt (serapeum:partial #'make-instance 'geometry:point))

(defun next-end (current-end instruction)
  (ecase (car instruction)
    ('R (pt :x (+ (cdr instruction) (x current-end))
            :y (y current-end)))
    ('L (pt :x (- (x current-end) (cdr instruction))
            :y (y current-end)))
    ('U (pt :x (x current-end)
            :y (+ (cdr instruction) (y current-end))))
    ('D (pt :x (x current-end)
            :y (- (y current-end) (cdr instruction))))))

(defvar *origin* (make-instance 'geometry:point))

(defun build-segment (segs instruction)
  (let* ((current-end (end (car segs)))
         (built (make-instance 'geometry:line-segment
                               :start current-end
                               :end (next-end current-end instruction))))
    (if (geometry:point-equal-p current-end *origin*)
        (list built)
        (cons built segs))))

(defun read-wirespec (line-string)
  (series:collect-fn 'list
                     (lambda () (list (make-instance 'geometry:line-segment)))
                     #'build-segment
                     (series:map-fn 'list #'parse-instruction
                                    (taps:tap :words line-string))))

(defvar *wire1* (read-wirespec (read-line)))
(defvar *wire2* (read-wirespec (read-line)))

(defun manhattan-distance (p1 p2)
  (if (null p2)
      sb-ext:double-float-positive-infinity
      (+ (abs (- (x p1) (x p2)))
         (abs (- (y p1) (y p2))))))

(defun main ()
  (princ
    (iter outer (for segment in *wire2*)
          (iter (for l1-segment in *wire1*)
                (in outer (minimize (manhattan-distance
                                      *origin*
                                      (geometry:line-segments-intersection-point
                                        segment l1-segment :exclude-endpoints t))))))))
