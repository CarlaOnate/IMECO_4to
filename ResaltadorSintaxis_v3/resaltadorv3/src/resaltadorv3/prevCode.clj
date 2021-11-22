; (defn findPattern [file state word res]
;  (cond
;    (nil? file) (concat res (list (list (list state) word)) (list (list (list "end"))))
;    (= state -1) (findPattern (next file) 0 (concat word (list (first file))) res)
;    (> state 100) (if (some (fn [x] (= state x)) estados*)
;       (findPattern (concat (list (first (reverse word))) file) 0 '() (concat res (list (list (list state) (reverse (next (reverse word)))))))
;       (findPattern file 0 '() (concat res (list (list (list state) word)))))
;    :else (findPattern (next file) (followAFD2 transiciones (letterToSymbol (first file)) state) (concat word (list (first file))) res)))

;WRITE html; INTENTO FALLIDO
;     (doseq [el resList]
;       (cond
;       (= (first (first el) "begin")) htmlHead
;       (= (first (first el) "end")) htmlEnd
;       :else (htmlTag el))))
    ; (doall (apply str (map (fn [el]
    ;     (cond
    ;       (= (first (first el) "begin")) htmlHead
    ;       (= (first (first el) "end")) htmlEnd
    ;       :else (htmlTag el)) resList)))))


    ; (defn writeHead []
    ;         (spit "datos.html" "<!DOCTYPEhtml>")
    ;         (spit "datos.html" "<html>")
    ;         (spit "datos.html" "<head><title>SuperMegaCoolResaltador</title>")
    ;         (spit "datos.html" "<body style=\"white-space: pre\">")
    ;         (spit "datos.html" "<div><p>"))
    ;
    ; (defn writeEnd []
    ;         (spit "datos.html" "</p></div>")
    ;         (spit "datos.html" "</body>")
    ;         (spit "datos.html" "</html>"))

    (defn findPattern2 [file state word res]
      (loop [f file s state w word r res] (when (not (nil? file))
        (cond
          (nil? f) (concat r (list (list (list s) w)) (list (list (list "end"))))
          (= s -1) (recur (next f) 0 (concat w (list (first f))) r)
          (> s 100) (if (some (fn [x] (= s x)) estados*)
            (recur (concat (list (first (reverse w))) f) 0 '() (concat r (list (list (list s) (reverse (next (reverse w)))))))
            (recur f 0 '() (concat r (list (list (list s) w)))))
       :else (recur (next f) (followAFD transiciones (letterToSymbol (first f)) s) (concat w (list (first f))) r)))))
