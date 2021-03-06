(defpackage #:aoc2019d04
  (:use :cl :iterate :alexandria :serapeum :rove)
  (:shadowing-import-from :iterate collecting summing sum in))
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
       (some (of-length 2) (runs digits))))

(defun main ()
  (princ
    (iter (for pwd from 273025 to 767253)
          (let ((digits (number->digits pwd)))
            (counting (password? digits) into p1)
            (counting (srsly-password? digits) into p2))
          (finally (return (list p1 p2))))))

(deftest passwords
  (testing "password?"
    (ok (password? '(1 2 2 2 3 4)))
    (ng (password? '(1 2 2 3 4 3))))

  (testing "srsly-password?"
    (ok (srsly-password? '(1 2 2 2 3 3 4)))
    (ng (srsly-password? '(1 2 2 2 3)))))

(run-suite *package*)
