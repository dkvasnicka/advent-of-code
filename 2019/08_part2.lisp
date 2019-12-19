(require "array-operations")
(defpackage #:aoc2019d08p2
  (:use :cl :iterate :alexandria :serapeum :parachute)
  (:shadowing-import-from :iterate collecting until finish collect summing sum in)
  (:shadowing-import-from :parachute of-type featurep true))
(in-package #:aoc2019d08p2)

(defun read-layers (is w h)
  (cons (aops:generate (lambda () (digit-char-p (read-char is)))
                       (list h w))
        (let ((next-char (peek-char nil is nil)))
          (if (or (null next-char) (whitespacep next-char))
              '()
              (read-layers is w h)))))

(defun fold-pixels (&rest pixels)
  (ecase (or (find-if (partial #'> 2) pixels) 2)
    (1 #\FULL_BLOCK)
    (0 #\Space)))

(defun main ()
  (princ
    (apply (partial #'aops:each #'fold-pixels)
           (read-layers *standard-input* 25 6))))

(define-test "read layers into a list of 2D arrays"
  (is equalp
      (list #2A((1 1 2) (2 0 1)) #2A((0 0 2) (1 2 1)))
      (with-input-from-string (s "112201002121")
        (read-layers s 3 2))))

(test *package*)
