(require "taps")
(require "str")
(require "cl-geometry")
(defpackage #:aoc2019d03 (:use :cl :cl-geometry :iterate :alexandria))
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
  (let* ((current-end (end (last-elt segs)))
         (built (make-instance 'geometry:line-segment
                               :start current-end
                               :end (next-end current-end instruction))))
    (if (geometry:point-equal-p current-end *origin*)
        (serapeum:vect built)
        (serapeum:vector-conc-extend segs (vector built)))))

(defun read-wirespec (line-string)
  (series:collect-fn 'vector
                     (lambda () (vector (make-instance 'geometry:line-segment)))
                     #'build-segment
                     (series:map-fn 'list #'parse-instruction
                                    (taps:tap :words line-string))))

(defun manhattan-distance (p1 p2)
  (+ (abs (- (x p1) (x p2)))
     (abs (- (y p1) (y p2)))))

(defun xsection-pt (s1 s2)
  (geometry:line-segments-intersection-point s1 s2 :exclude-endpoints t))

(defun dist (p1 p2)
  (geometry:distance (x p1) (y p1) (x p2) (y p2)))

; Most naive solutions are going point by point. This one uses trivial 2D
; geometry to find the solution to both parts of the problem in one go.
(defun main ()
  (let ((wire1 (read-wirespec (read-line)))
        (wire2 (read-wirespec (read-line))))
    (princ
      (iter outer (for segment in-vector wire2)
            (sum (geometry:line-segment-length segment) into travelled1)
            (iter (for l1-segment in-vector wire1)
                  (sum (geometry:line-segment-length l1-segment) into travelled2)
                  (in outer
                      (when-let ((xsection (xsection-pt segment l1-segment)))
                                (minimizing (manhattan-distance *origin* xsection) into d)
                                (minimizing (- (+ travelled1 travelled2)
                                               (dist (end segment) xsection)
                                               (dist (end l1-segment) xsection))
                                            into min-travelled))
                      (finally (return-from outer (list d min-travelled)))))))))
