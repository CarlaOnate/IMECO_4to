(ns tareas-clojure.tarea10
  (:gen-class))

;Se puede correr en repl asi: (tareas-clojure.tarea10/jiji)
; o cambiar de ns con: (in-ns 'tareas-clojure.tarea10)
;Tienes que guardar el archivo y hacer refresh del REPL para que aparezca tu nueva funcion

; I - 1
(defn listaRango [n]
  (take (* n 2) (range (* -1 n) n)))
; I - 2
(defn impares []
  (take 10000 (range 5263 (+ 5263 10000) 2)))
; I - 3
(defn repita [n]
  (take n (repeatedly rand)))
; I - 4
(defn randPos []
  (take 5000 (repeatedly (fn [] (rand-int 1000)))))
; I - 5
(defn tirarDado []
  (apply + (take 2 (repeatedly #(+ 1 (rand-int 6))))))

(defn tira [n]
  (take n (repeatedly tirarDado)))

;Para prueba del quicksort
(defn randomList [n] (take n (repeatedly (fn [] (rand-int 10000
  )))))

; II
(defn quick-sort [lista]
    (cond
      (empty? lista) '()
      (empty? (rest lista)) (list (first lista))
      :else (concat
        (quick-sort (filter (fn [x] (< x (first lista))) (rest lista)))
        (list (first lista))
        (quick-sort (filter (fn [x] (> x (first lista))) (rest lista))))))

;Pruebas qucksort
; 1,000,000 fue la lista que se tardó más de 5 segundos, antes de eso se tardaba 2 segundos.
