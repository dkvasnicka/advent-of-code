(ns day03.core
  (:require [clojure.core.typed :refer :all]))

(ann foo [Number -> Number])
(defn foo
  "I don't do a whole lot."
  [x]
  (+ x 3))
