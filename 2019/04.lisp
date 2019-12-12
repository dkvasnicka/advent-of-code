(defpackage #:aoc2019d04
  (:use :cl :iterate :alexandria))
(in-package #:aoc2019d04)

(defun number->digits (n)
  (map 'list #'digit-char-p (write-to-string n)))

(defun password? (digits)
  (iter (for x in digits)
        (for y previous x initially -1)
        (always (>= x y))
        (reducing (= x y) by #'or into res)
        (finally (return res))))

(defun srsly-password? (digits)
  (and (apply #'<= digits)
       (some (serapeum:of-length 2) (serapeum:runs digits))))

(defun main ()
  (princ
    (iter (for pwd from 273025 to 767253)
          (let ((digits (number->digits pwd)))
            (counting (password? digits) into p1)
            (counting (srsly-password? digits) into p2))
          (finally (return (list p1 p2))))))
