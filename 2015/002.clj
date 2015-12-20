(defn parse-line [l]
  (mapv #(Integer/parseInt %)
        (clojure.string/split l #"x")))

(defn wrap-present [[l w h]]
  (let [s1 (* l w)
        s2 (* w h)
        s3 (* h l)]
    (+ (min s1 s2 s3)
       (reduce + (map (partial * 2) [s1 s2 s3])))))

(def xf (comp (map parse-line)
              (map wrap-present)))

(println
  (transduce xf + (line-seq (clojure.java.io/reader *in*))))
