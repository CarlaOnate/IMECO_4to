;cmd+alt+l -> repl windo

(ns Tareas.Tarea9
  (:gen-class))

(defn -main
  "I don't do a whole lot ... yet."
  [& args]
  (println "Hello, World!"))

; (ultimo '(1 2 3 4))
(defn ultimo [lista] (last lista))

;(interseccion '(1 2 3) '(1 2))
(defn interseccion [lista1 lista2]
    (cond
    (nil? lista1) '()
    (= (first lista1) (first (filter (fn [x] (= x (first lista1))) lista2))) (cons (first lista1) (interseccion (next lista1) lista2))
    :else (interseccion (next lista1) lista2)))

; (pares '(1 2 (2 5 (6 (1)))))
(defn pares [lista]
  (cond
    (nil? lista) 0
    (list? (first lista)) (+ (pares (first lista)) (pares (next lista)))
    (= (mod (first lista) 2) 0) (+ 1 (pares (next lista)))
    :else (pares (next lista))))

;Matriz datos positivos sumatoria
; matriz -> ()()()
(defn matrizPos [matriz]
  (apply + (map (fn [x] (if (> x 0) x 0)) (flatten matriz))))


; Función que reciba a una función aritmética binaria y un valor, y genere una función que, al aplicarse sobre una lista, le aplique sobre cada dato la función aritmética con el valor, generando una lista de resultados.
(defn generadora [fnArit valor]
  (fn [x] (fnArit x valor)))
