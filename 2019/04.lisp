(defpackage #:aoc2019d04
  (:use :cl :iterate :alexandria))
(in-package #:aoc2019d04)

(defun number->digits (n)
  (map 'list #'digit-char-p (write-to-string n)))

(defun password? (n)
  (iter (for x in (number->digits n))
        (for y previous x initially -1)
        (always (>= x y))
        (reducing (= x y) by #'or into res)
        (finally (return res))))

(defun has-two-items? (l)
  (= 2 (length l)))

(defun srsly-password? (n)
  (let ((digits (number->digits n)))
    (and (apply #'<= digits)
         (some #'has-two-items? (serapeum:runs digits)))))

(defun main ()
  (princ
    (iter (for pwd from 273025 to 767253)
          (counting (password? pwd) into p1)
          (counting (srsly-password? pwd) into p2)
          (finally (return (list p1 p2))))))
