(defn fuel-needed [mass]
  (let [initial-fuel (- (quot mass 3) 2)]
    (if (<= initial-fuel 0)
      0
      (+ initial-fuel (fuel-needed initial-fuel)))))

(println
  (time
    (transduce (map fuel-needed) + (repeatedly 100 read))))

; 100 rows  - avg  2.35 ms
; 1000 rows - avg 10.42 ms
; 5000 rows - avg 27.70 ms
