(require "alexandria")
(require "iterate")
(require "rutils")
(require "series")
(require "losh")
(defpackage :aoc2016
  (:use :cl :iterate :rutils.bind :alexandria :series
   :LOSH.DEBUGGING :losh.iterate)
  (:shadowing-import-from :iterate iterate collect while until)
  (:shadowing-import-from :rutils.bind with)
  (:shadowing-import-from :losh collect-hash))
(in-package :aoc2016)
(defparameter *suppress-series-warnings* t)
