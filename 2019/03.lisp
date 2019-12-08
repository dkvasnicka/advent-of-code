(require "str")
(require "cl-geometry")
(defpackage #:aoc2019d03
  (:use :cl :cl-geometry :serapeum))
(in-package #:aoc2019d03)

(defun parse-instruction (instr)
  (cons (intern (str:s-first instr))
        (parse-integer (str:s-rest instr))))

(defun read-wirespec ()
  (map 'list #'parse-instruction
       (str:split "," (read-line))))

(defvar *l1-wirespec* (read-wirespec))
(defvar *l2-wirespec* (read-wirespec))

(defalias pt (partial #'make-instance 'geometry:point))

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

(defun main ()
  ; (princ (next-end (make-instance 'geometry:point) (cons 'R 3)))
  (princ (reduce #'build-segment *l1-wirespec*
                 :initial-value (list (make-instance
                                        'geometry:line-segment))))
  )
