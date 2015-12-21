(defn parse-line [l]
  (mapv #(Integer/parseInt %)
        (clojure.string/split l #"x")))

(defn double-and-sum [s]
  (reduce + (map (partial * 2) s)))

(defn wrap-present [[l w h]]
  (let [s1 (* l w)
        s2 (* w h)
        s3 (* h l)]
    [(+ (min s1 s2 s3)
        (double-and-sum [s1 s2 s3]))
     (+ (* l w h)
        (double-and-sum (take 2 (sort [l w h]))))]))

(def xf (comp (map parse-line)
              (map wrap-present)))

(println
  (transduce xf (partial map +) [0 0] 
             (line-seq (clojure.java.io/reader *in*))))
