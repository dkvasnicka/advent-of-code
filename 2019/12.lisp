(require "array-operations")
(defpackage #:aoc2019d12
  (:use :iterate :cl21 :cl21.lazy :rutils.bind)
  (:shadowing-import-from :iterate while until)
  (:shadowing-import-from :rutils.bind with))
(in-package #:aoc2019d12)

(defparameter *moons-positions* #2A(( -3  10  -1)
                                    (-12 -10  -5)
                                    ( -9   0  10)
                                    (  7  -5  -3)))

; Testing data
; (defparameter *moons-positions* #2A((-1    0   2)
                                    ; ( 2  -10  -7)
                                    ; ( 4   -8   8)
                                    ; ( 3    5  -1)))
; (defparameter *moons-positions* #2A((-8  -10   0)
                                    ; ( 5    5  10)
                                    ; ( 2   -7   3)
                                    ; ( 9   -8  -3)))


(defparameter *moons-velocities*
  (make-array '(4 3) :initial-element 0 :element-type 'integer))

(defun compute-velocities (pos vel)
  ; TODO: maybe rewrite using alexandria:map-combinations?
  (aops:generate
    (lambda (subs)
      (with (((moon coord) subs)
             (this (aref pos moon coord)))
            (iter (for x from 0 to 3)
                  (unless (= x moon)
                    (reducing (let ((other (aref pos x coord)))
                                (cond ((< this other) 1)
                                      ((> this other) -1)
                                      (t 0)))
                              by #'+ initial-value (aref vel moon coord))))))
    '(4 3) :subscripts))

(defun apply-velocities (pos vel)
  (aops:each #'+ pos vel))

(defun trajectories-seq (pos vel)
  (lazy-sequence
    (let* ((new-vel (compute-velocities pos vel))
           (new-pos (apply-velocities pos new-vel)))
      (cons (list new-pos new-vel)
            (trajectories-seq new-pos new-vel)))))

(defun energy (a)
  (aops:each-index i (aops:sum-index j (abs (aref a i j)))))

(defun main ()
  (princ
    (with ((trajectories (trajectories-seq *moons-positions* *moons-velocities*))
           ((pos1000 vel1000) (elt trajectories 999))
           (potentials (energy pos1000))
           (kinetics (energy vel1000)))
          (reduce #'+ (map #'* potentials kinetics)))))
