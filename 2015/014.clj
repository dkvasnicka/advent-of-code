
(defn compute-distance [data]
  (let [cycle-len (+ (second data) (nth data 2))
        cycles (quot 2503 cycle-len)
        cycle-dist (* (first data) (second data))]
    (+ (* cycle-dist cycles)
       (min cycle-dist (* (first data) (* cycle-len (- (/ 2503 cycle-len) cycles)))))))

(def xf 
  (comp
    (map (partial re-seq #"[0-9]+"))
    (map (partial map #(Integer/parseInt %)))
    (map compute-distance)))

(println
  (transduce xf max -1 (line-seq (clojure.java.io/reader *in*))))
