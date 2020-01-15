(require "alexandria")
(require "rutils")
(require "series")
(defpackage :aoc2016
  (:use :cl :rutils.iter :rutils.bind :alexandria :series))
(in-package :aoc2016)
(defparameter *suppress-series-warnings* t)

(defmacro println (v)
  `(format t "~a~%" ,v))
