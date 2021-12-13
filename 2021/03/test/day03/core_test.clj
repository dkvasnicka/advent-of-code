(ns day03.core-test
  (:require [clojure.core.typed :refer :all]
            [day03.core :as d03]
            [clojure.test :refer [deftest testing is]]))

(deftest test-input
  (testing "test input from project description"
    (is (check-ns 'day03.core))
    (is (= (d03/foo 3) 6))))
