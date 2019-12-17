(require "fset")
(defpackage #:aoc2019d08
  (:use :cl :iterate :alexandria :serapeum :parachute)
  (:shadowing-import-from :iterate collecting until finish collect summing sum in)
  (:shadowing-import-from :parachute of-type featurep true))
(in-package #:aoc2019d08)

(defun update-layer-histogram (layer-id px layers)
  (fset:with layers layer-id
             (let ((ly (or (fset:@ layers layer-id) (fset:empty-map))))
               (fset:with ly px (1+ (or (fset:@ ly px) 0))))))

(defun build-histograms (strm width height)
  (let ((layer-size (* width height)))
    (iter (for i :upfrom 0)
          (for px in-stream strm :using #'read-char)
          (accumulate px :by (partial #'update-layer-histogram (floor i layer-size))
                      :initial-value (fset:empty-map) :into hists)
          (finally (return hists)))))

(defun main ()
  (princ
    (build-histograms *standard-input* 25 6)))

(define-test histograms
  (is equalp
      (fset:map (0 (fset:map (#\0 1) (#\1 3) (#\2 2)))
                (1 (fset:map (#\1 2) (#\2 2) (#\0 2))))
      (with-input-from-string (s "112201002121")
        (build-histograms s 3 2))))

(test *package*)
