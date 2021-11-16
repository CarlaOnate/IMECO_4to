
;Cosas globales
(def estados* '(101 102 105 209))
(def reservedWords '("println" "def" "if" "cond" "defn" "fn" "else" "true" "false" "nil" "cons" "first" "second" "rest" "next" "concat" "map" "apply" "filter" "reduce" "pmap" "let" "seq" "conj" "do" "and" "or"
"not" "not=" "quote" "empty?" "take" "range" "doall" "time" "future" "delay" "promise"))

; TODO ver como hacer esto en Clojure
(def arch (open-input-file "c:\\datos.txt")) ; arbir archivo
(def listFile (fileToList (read-char arch) '())) ; lista con todo el archivo
(close-input-port arch)
(def outFile (open-output-file "c:\\datos.html" #:exists 'replace))

lista transiciones
(def transiciones '((0 \space 0) (0 \newline 201) (0 "number" 1) (1 "number" 1) (1 "letter-e" 101) (1 \e 101) (1 "special" 101) (1 "parenthesis" 101)
                       (1 \< 101) (1 \= 101) (1 \> 101) (1 \; 101) (1 \space 101) (1 \newline 101)
                       (1 \. 2) (2 "number" 2) (2 "letter-e" 102) (2 "special" 102) (2 "parenthesis" 102) (2 \space 102) (2 \newline 102) (2 \e 3)
                       (3 "number" 103)
                       (0 \" 4) (4 "letter-e" 4) (4 \e 4) (4 "number" 4) (4 \space 4) (4 "special" 4) (4 "parenthesis" 104) (4 \" 104)
                       (0 "letter-e" 5) (0 \e 5) (5 "letter-e" 5) (5 \e 5) (5 "number" 5) (5 "special" 5) (5 "parenthesis" 105) (5 \space 105)
                       (5 \; 105) (5 \. 105) (5 \newline 105)
                       (0 \; 6) (6 \; 6) (6 "letter-e" 6) (6 \e 6) (6 "number" 6) (6 \" 6) (6 "special" 6) (6 "parenthesis" 6) (6 \< 6) (6 \= 6) (6 \> 6)
                       (6 \space 6) (6 \. 6) (6 \newline 106)
                       (0 \< 7) (0 \> 7) (7 \= 208) (7 "letter-e" 200) (7 \e 200) (7 "number" 200) (7 "special" 200) (7 "parenthesis" 200) (7 \space 200)
                       (7 \newline 200)
                       (0 "special" 200)
                       (0 "parenthesis" 200) (0 \. 200)))


  ; transforma el caracter para que lo pueda leer el automata
  (defn letterToSymbol [el] ;0(n)
          (cond
            (some #(= el %) '(\a \b \c \d \f \g \h \i \j \k \l \m \n \o \p \q \r \s \t \u \v \w \x \y \z \A \B \C \D \E \F \G \H \I \J \K \L \M \N \O \P \Q \R \S \T \U \V \W \X \Y \Z)) "letter-e"
            (some #(= el %) '(\1 \2 \3 \4 \5 \6 \7 \8 \9 \0)) "number"
            (some #(= el %) '(\{ \} \[ \] \( \))) "parenthesis"
            (some #(= el %) '(\+ \- \* \/ \ \\ \' \? \: \, \& \%)) "special"
            :else el))

  (defn estado*? [state] ; revisa si el estado es determinante ;O(n)
         (if (some #(= (first state) %) estados*) true false))

 (defn findPattern [file state word res] ;O(n) por ser complejidad mayor dentro de la función res => ((101), (#\c))
       (cond
         ;((null? file) res)
         (nil? file) (writeHTML (concat res (list (list (list state) word)) (list (list (list "end")))))
         (= state -1) (findPattern (next file) 0 (concat word (list (first file))) res)
         (> state 100) (if (some #(= state %) estados*) ;O(n) por memq
                            (findPattern (concat (list (first (reverse word))) file) 0 '() (concat res (list (list (list state) (reverse (next (reverse word))))))) ; O(1)
                            (findPattern file 0 '() (concat res (list (list (list state) word)))))
         :else (findPattern (next file) (followAFD transiciones (letterToSymbol (first file)) state) (concat word (list (first file))) res)))


 (defn followAFD [afd simbolo estado] ;O(n) - cicla una lista de n elementos
   (cond
     (nil? afd) -1
     (list? (first afd)) (max (followAFD (first afd) simbolo estado) (followAFD (next afd) simbolo estado))
     (not (list? (first afd))) (if (and (= (cadr afd) simbolo) (= (first afd) estado)) (caddr afd) -1) ; TODO caddr to clojure
     :else (followAFD (next afd) simbolo estado)))

 (defn reserved? [word]
                     (some #(= (list->string (filter (lambda (x) (not (= x \space))) word)) %) reservedWords))
