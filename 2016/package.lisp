(require "alexandria")
(require "iterate")
(require "rutils")
(require "series")
(require "losh")
(require "serapeum")
(defpackage :aoc2016
  (:use :cl :iterate :rutils.bind :serapeum :alexandria :series
   :LOSH.DEBUGGING :losh.iterate)
  (:shadowing-import-from :iterate iterate summing collecting collect
   in while sum until)
  (:shadowing-import-from :series scan)
  (:shadowing-import-from :serapeum @ comment bits)
  (:shadowing-import-from :rutils.bind with)
  (:shadowing-import-from :losh collect-hash))
(in-package :aoc2016)
(defparameter *suppress-series-warnings* t)
