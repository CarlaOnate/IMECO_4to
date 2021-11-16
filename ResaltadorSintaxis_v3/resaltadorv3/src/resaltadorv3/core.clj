(ns resaltadorv3.core
  (:gen-class))

(def estados* '(101 102 105 209))
(def reservedWords '("println" "def" "if" "cond" "defn" "fn" "else" "true" "false" "nil" "cons" "first" "second" "rest" "next" "concat" "map" "apply" "filter" "reduce" "pmap" "let" "seq" "conj" "do" "and" "or"
"not" "not=" "quote" "empty?" "take" "range" "doall" "time" "future" "delay" "promise"))

(def listFile (seq (slurp "src/resaltadorv3/datos.txt")))

; lista transiciones
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

(defn estado*? [state]
       (if (some #(= (first state) %) estados*) true false))

(defn followAFD [afd simbolo estado]
  (cond
    (nil? afd) -1
    (seq? (first afd)) (max (followAFD (first afd) simbolo estado) (followAFD (next afd) simbolo estado))
    (not (seq? (first afd))) (if (and (= (nth afd 1) simbolo) (= (first afd) estado)) (nth afd 2) -1)
    :else (followAFD (next afd) simbolo estado)))


(defn reserved? [word]
                  (some (fn [x] (= (apply str (filter #(not= \space %) '(\d \e \f \n \space))) x)) reservedWords))


(defn writeHead [file]
                    (.write file "<!DOCTYPEhtml>")
                    (.write file "<html>")
                    (.write file "<head><title>SuperMegaCoolResaltador</title>")
                    (.write file "<body style=\"white-space: pre\">")
                    (.write file "<div><p>"))


(defn writeEnd [file]
                    (.write file "</p></div>")
                    (.write file "</body>")
                    (.write file "</html>"))


(defn htmlTag [listEl]
 (cond
   (= (first (first listEl)) 101) (str "<span style=\"color: red\">" (apply str (second listEl)) "</span>")
   (= (first (first listEl)) 102) (str "<span style=\"color: green\">" (apply str (second listEl)) "</span>")
   (= (first (first listEl)) 103) (str "<span style=\"color: orange\">" (apply str (second listEl)) "</span>")
   (= (first (first listEl)) 104) (str "<span style=\"color: blue\">" (apply str (second listEl)) "</span>")
   (= (first (first listEl)) 105) (if (reserved? (second listEl))
                                (str "<span style=\"color:#bd42bd\">" (apply str (second listEl)) "</span>")
                                (str "<span style=\"color:#5da28c\">" (apply str (second listEl)) "</span>"))
   (= (first (first listEl)) 106) (str "<span style=\"color:#1a9fe5\">" (apply str (second listEl)) "</span></p><p>")
   (= (first (first listEl)) 200) (str "<span style=\"color:#e1931e\">" (if (seq? (second listEl))
                                                                                (apply str (second listEl))
                                                                                (str (second listEl))) "</span>")
   (= (first (first listEl)) 209) (str "<span style=\"color:#e817a2\">" (apply str (if (seq? (second listEl))
                                                                                              (second listEl)
                                                                                              (list (second listEl)))) "</span>")
   (= (first (first listEl)) 201) "</p><p>"
   (and (= (first (first listEl)) -1) (= (second listEl) \space)) " "
   :else (str "<span style=\"color:black\">"(apply str (second listEl))"</span>")))


(defn writeHTML [resList]
  (with-open [w (clojure.java.io/writer "datos.html" :append true)]
    (map (fn [el]
        (cond
          (= (first (first el) "begin")) (writeHead w)
          (= (first (first el) "end")) (writeEnd w)
          :else (.write w (htmlTag el)))) resList)))

(defn findPattern [file state word res]
 (cond
   ;(empty? file) (writeHTML (concat res (list (list (list state) word)) (list (list (list "end"))))) ;TODO aqui hay algo raro
   (empty? file) res
   (= state -1) (findPattern (next file) 0 (concat word (list (first file))) res)
   (> state 100) (if (some (fn [x] (= state x)) estados*)
                  (findPattern (concat (list (first (reverse word))) file) 0 '() (concat res (list (list (list state) (reverse (next (reverse word)))))))
                  (findPattern file 0 '() (concat res (list (list (list state) word)))))
   :else (findPattern (next file) (followAFD transiciones (letterToSymbol (first file)) state) (concat word (list (first file))) res)))

(defn main []
    (findPattern listFile 0 '() '((("begin")))))
