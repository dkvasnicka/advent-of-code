(require "taps")
(require "str")
(require "cl-geometry")
(defpackage #:aoc2019d03
  (:use :cl :cl-geometry :series))
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

(defun build-segment (segs instruction)
  (let ((current-end (end (car segs))))
    (cons (make-instance 'geometry:line-segment
                         :start current-end
                         :end (next-end current-end instruction))
          segs)))

(defun read-wirespec (line-string)
  (collect-fn 'list (lambda () (list (make-instance 'geometry:line-segment)))
              #'build-segment
              (map-fn 'list #'parse-instruction
                      (taps:tap :words line-string))))

(defvar *wire1* (read-wirespec (read-line)))
(defvar *wire2* (read-wirespec (read-line)))

(defun main ()
  (princ *wire1*)) ; TODO for:for
