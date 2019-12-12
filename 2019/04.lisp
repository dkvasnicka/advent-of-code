(defpackage #:aoc2019d04
  (:use :cl :iterate :alexandria))
(in-package #:aoc2019d04)

(defun password? (n)
  (iter (for x in (map 'list #'digit-char-p (write-to-string n)))
        (for y previous x initially -1)
        (always (>= x y))
        (reducing (= x y) by #'or into res)
        (finally (return res))))

(defun has-two-items? (l)
  (= 2 (length l)))

(defun srsly-password? (n)
  (let ((digits (map 'list #'digit-char-p (write-to-string n))))
    (and (apply #'<= digits)
         (some #'has-two-items? (serapeum:runs digits)))))

(defun main ()
  (princ
    (iter (for pwd from 273025 to 767253)
          (counting (password? pwd) into p1)
          (counting (srsly-password? pwd) into p2)
          (finally (return (list p1 p2))))))
