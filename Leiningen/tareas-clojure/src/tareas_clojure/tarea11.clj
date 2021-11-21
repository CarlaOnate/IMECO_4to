(ns tareas-clojure.tarea11
  (:gen-class))

(defn main [] "mierda")

(defn primo [n d]
  (cond
      (= n 2) true
      (< n 2) false
      (= 0 (mod n d))false
      (< d (Math/sqrt n)) (primo n (+ d 1))
      :true true))

(defn primo? [n] (primo n 2))

(defn suma [] (apply + (filter primo? (range 5000001))))

(defn sumap [] (apply +
  (pmap (fn [el] (apply + (filter primo? el)))
  (partition-all 100 (range 5000001)))))

; (defn sumap [] (apply + (apply concat (pmap
;   (fn [el] (map #(if (primo? %) % 0) el))
;   (partition-all 100 (range 500))))))
