(defpackage #:aoc2019d04
  (:use :cl :iterate))
(in-package #:aoc2019d04)

(defun password? (n)
  (iter (for x in (map 'list #'digit-char-p (write-to-string n)))
        (for y previous x initially -1)
        (always (>= x y))
        (reducing (= x y) by #'or into res)
        (finally (return res))))

(defun main ()
  (princ
    (iter (for pwd from 273025 to 767253)
          (counting (password? pwd)))))
