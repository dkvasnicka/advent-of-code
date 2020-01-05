(require "array-operations")
(require "losh")
(defpackage #:aoc2019d12
  (:use :cl :iterate :rutils.bind :losh.iterate)
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

(defun trajectories (pos vel)
  (let* ((new-vel (compute-velocities pos vel))
         (new-pos (apply-velocities pos new-vel)))
    (cons new-pos new-vel)))

(defun energy (a)
  (aops:each-index i (aops:sum-index j (abs (aref a i j)))))

(defun zeroed-axis? (ary axis)
  (aops:reduce-index #'rutils.misc:and2 i (zerop (aref ary i axis))))

(defun main ()
  (princ
    (time
      (iter (for s from 1)
            (for (p . v) first (trajectories *moons-positions* *moons-velocities*)
                 then (trajectories p v))
            (when (= s 1000)
              (for nrg = (let ((potentials (energy p))
                               (kinetics (energy v)))
                           (reduce #'+ (map 'list #'* potentials kinetics)))))
            ; https://www.reddit.com/r/adventofcode/comments/e9nqpq/day_12_part_2_2x_faster_solution/
            (finding-first s such-that (zeroed-axis? v 0) into x)
            (finding-first s such-that (zeroed-axis? v 1) into y)
            (finding-first s such-that (zeroed-axis? v 2) into z)
            (until (and x y z (>= s 1000)))
            (returning (cons nrg (* 2 (lcm x y z))))))))
