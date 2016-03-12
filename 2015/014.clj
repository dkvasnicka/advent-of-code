
(defrecord Reindeer [speed flight-time rest-time])

(defn line->Reindeer [l]
  (apply ->Reindeer (map #(Integer/parseInt %) l)))

(defn compute-distance [data]
  (let [cycle-len (+ (:flight-time data) (:rest-time data))
        cycles (quot 2503 cycle-len)
        cycle-dist (* (:speed data) (:flight-time data))]
    (+ (* cycle-dist cycles)
       (min cycle-dist (* (:speed data) (rem 2503 cycle-len))))))

(def xf 
  (comp
    (map (partial re-seq #"[0-9]+"))
    (map line->Reindeer)
    (map compute-distance)))

(println
  (transduce xf max -1 (line-seq (clojure.java.io/reader *in*))))
