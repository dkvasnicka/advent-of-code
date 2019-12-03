(require "taps")
(require "str")
(require "random-access-lists")
(defpackage #:aoc2019d02
  (:use :cl :series :taps :alexandria :random-access-lists))
(in-package #:aoc2019d02)

(defparameter *suppress-series-warnings* t)

; Purely functional solution using transducers to load the data into a
; persistent RA list in one stream and then updating it
; using a properly tail-recursive function

(defvar *gravity-assist-program*
  (ra-reverse
    (collect-fn (type-of (ra-list)) #'ra-list (lambda (xs x) (ra-cons x xs))
                (map-fn 'integer #'parse-integer
                        (choose-if (compose #'not #'str:blank?)
                                   (tap :words *standard-input*
                                        :word-break-characters '(#\,)))))))

(defmacro offset-pointer-val (offset)
  `(ra-list-ref prg (ra-list-ref prg (+ idx ,offset))))

(defun exec-instruction (code idx prg)
  (ra-list-set prg
               (ra-list-ref prg (+ idx 3))
               (funcall (case code (1 #'+) (2 #'*))
                        (offset-pointer-val 1)
                        (offset-pointer-val 2))))

(defun instruction-cycle (idx prg)
  (let ((code (ra-list-ref prg idx)))
    (if (= 99 code)
        prg
        (instruction-cycle (+ idx 4)
                           (exec-instruction code idx prg)))))

(defun main ()
  (ra-car (instruction-cycle 0 *gravity-assist-program*)))

(princ (main))
