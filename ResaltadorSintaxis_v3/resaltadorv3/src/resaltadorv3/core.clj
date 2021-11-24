(ns resaltadorv3.core
  (:gen-class))

(def estados* '(101 102 106))
(def reservedWords '("println" "def" "if" "cond" "defn" "fn" "else" "true" "false" "nil" "cons" "first" "second" "rest" "next" "concat" "map" "apply" "filter" "reduce" "pmap" "let" "seq" "conj" "do" "and" "or"
"not" "not=" "quote" "empty?" "take" "range" "doall" "time" "future" "delay" "promise"))

(def resHaskell '("case" "class" "data" "default" "deriving" "do" "else" "if" "import" "in" "infix" "infixl" "infixr" "instance" "let" "module" "newtype" "of" "then" "type" "where" "_"))

; lista transiciones
(def transiciones '((0 \space 0) (0 \newline 201) (0 "number" 1) (1 "number" 1) (1 "letter-e" 101) (1 \e 101) (1 "special" 101) (1 "parenthesis" 101)
(1 \< 101) (1 \= 101) (1 \> 101) (1 \; 101) (1 \space 101) (1 \newline 101)
(1 \. 2) (2 "number" 2) (2 "letter-e" 102) (2 "special" 102) (2 "parenthesis" 102) (2 \space 102) (2 \newline 102) (2 \e 3)
(3 "number" 103)
(0 \" 4) (4 "letter-e" 4) (4 \e 4) (4 "number" 4) (4 \space 4) (4 "special" 4) (4 "parenthesis" 104) (4 \" 104)
(0 "letter-e" 5) (0 \e 5) (5 "letter-e" 5) (5 \e 5) (5 "number" 5) (5 "special" 5) (5 "parenthesis" 105) (5 \space 105) (5 \; 105) (5 \. 105) (5 \newline 105)
(0 \; 6) (6 \; 6) (6 "letter-e" 6) (6 \e 6) (6 "number" 6) (6 \" 6) (6 "special" 6) (6 "parenthesis" 6) (6 \< 6) (6 \= 6) (6 \> 6)
(6 \space 6) (6 \. 6) (6 \newline 106)
(0 \< 7) (0 \> 7) (7 \= 208) (7 "letter-e" 200) (7 \e 200) (7 "number" 200) (7 "special" 200) (7 "parenthesis" 200) (7 \space 200)
(7 \newline 200)
(0 "special" 200)(0 "parenthesis" 200) (0 \. 200) (0 \newline 0)))

(def haskell '(
   (0 \space 0) (0 "number" 1) (1 "number" 1) (1 "letter-e" 101) (1 \e 101) (1 \E 101) (1 "special" 101) (1 \space 101) (1 \newline 101) (1 "parenthesis" 101) (1 \{ 101) (1 \- 101) (1 \} 101)
   (1 \. 2) (2 "number" 2) (2 "letter-e" 102) (2 "special" 102) (2 \space 102) (2 "parenthesis" 102) (2 \newline 102)
   (2 \e 3) (2 \E 3) (3 \- 3) (3 "number" 4) (4 "number" 4) (4 \space 103) (4 \newline 103) (4 "letter-e" 103)
   (4 \e 103) (4 \E 103) (4 "special" 103) (4 \{ 103) (4 \} 103) (4 "parenthesis" 103)
   (0 \" 5) (5 "number" 5) (5 "letter-e" 5) (5 \e 5) (5 \E 5) (5 "special" 5) (5 \space 5) (5 \. 5)
   (5 \_ 5) (5 \' 5) (5 \- 5) (5 "parenthesis" 5) (5 \newline 5) (5 \" 104)
   (0 \' 6) (6 "number" 6) (6 "letter-e" 6) (6 \e 6) (6 \E 6) (6 "special" 6) (6 \space 6) (6 "parenthesis" 6) (6 \' 105)
   (0 "letter-e" 7) (0 \e 7) (0 \_ 7) (7 "letter-e" 7) (7 \e 7) (7 \E 7) (7 \_ 7) (7 "number" 7)
   (7 \space 106) (7 "special" 106) (7 \newline 106) (7 "parenthesis" 106) (7 \{ 106) (7 \} 106)
   (7 \. 106) (7 \- 106) (7 \" 106) (7 \' 106)
   (0 \- 8) (8 \space 200) (8 "special" 200) (8 \- 9) (9 "letter-e" 9) (9 \e 9) (9 \E 9) (9 \_ 9) (9 \- 9) (9 "number" 9) (9 \space 9) (9 "special" 9) (9 "parenthesis" 9)
   (9 \" 9) (9 \' 9) (9 \{ 9) (9 \} 9) (9 \. 9) (9 \newline 107)
   (0 \{ 10) (10 \- 11) (11 "letter-e" 11) (11 \e 11) (11 \_ 11) (11 "number" 11) (11 \space 11) (11 "special" 11) (11 "parenthesis" 11)
   (11 \' 11) (11 \" 11) (11 \. 11) (11 \newline 11) (11 \- 12) (12 \} 107)
   (0 \newline 201) (0 "parenthesis" 200) (0 "special" 200)
  ))

; transforma el caracter para que lo pueda leer el automata
(defn letterToSymbol [el] ;0(n)
  (cond
    (some #(= el %) '(\a \b \c \d \f \g \h \i \j \k \l \m \n \o \p \q \r \s \t \u \v \w \x \y \z \A \B \C \D \E \F \G \H \I \J \K \L \M \N \O \P \Q \R \S \T \U \V \W \X \Y \Z)) "letter-e"
    (some #(= el %) '(\1 \2 \3 \4 \5 \6 \7 \8 \9 \0)) "number"
    (some #(= el %) '(\{ \} \[ \] \( \))) "parenthesis"
    (some #(= el %) '(\+ \- \* \# \/ \\ \' \? \: \, \& \%)) "special"
    :else el))

; transforma el caracter para que lo pueda leer el automata
(defn letterToSymbol2 [el] ;0(n)
(cond
  (some #(= el %) '(\a \b \c \d \f \g \h \i \j \k \l \m \n \o \p \q \r \s \t \u \v \w \x \y \z \A \B \C \D \F \G \H \I \J \K \L \M \N \O \P \Q \R \S \T \U \V \W \X \Y \Z)) "letter-e"
  (some #(= el %) '(\1 \2 \3 \4 \5 \6 \7 \8 \9 \0)) "number"
  (some #(= el %) '(\[ \] \( \))) "parenthesis"
  (some #(= el %) '(\+ \* \/ \% \= \< \> \& \| \? \` \: \\ \$ \! \, \; \@ \#)) "special"
  :else el)) ; - . e E space newline { } " ' _

(defn estado*? [state]
       (if (some #(= (first state) %) estados*) true false))

(defn followAFD [afd simbolo estado]
  (cond
    (nil? afd) -1
    (seq? (first afd)) (max (followAFD (first afd) simbolo estado) (followAFD (next afd) simbolo estado))
    (not (seq? (first afd))) (if (and (= (nth afd 1) simbolo) (= (first afd) estado)) (nth afd 2) -1)
    :else (followAFD (next afd) simbolo estado)))

; TODO: DOES NOT FOLLOW AFD CORRECTLY
; recibe (0 simbolo 0)
(defn mapAFD [el simbolo estado] (if (and (= (second el) simbolo) (= (first el) estado)) (nth el 2) -1))

(defn returnNumerical [x] (if (not (nil? x)) x -1))

(defn followAFD2 [afd simbolo estado]
  (returnNumerical (some #(when (pos? %) %) (map (fn [x] (mapAFD x simbolo estado)) transiciones))))


;(defn reserved? [word]
;      (some (fn [x] (= (apply str (filter #(not= \space %) word)) x)) reservedWords))

(defn reserved? [word]
      (some (fn [x] (= (apply str (filter #(not= \space %) word)) x)) resHaskell))

(def htmlHead "<!DOCTYPEhtml><html><head><title>SuperMegaCoolResaltador</title><body style=\"white-space: pre\"><div><p>")

(def htmlEnd "</p></div></body></html>")


(defn htmlTag [listEl]
 (cond
   (= (first (first listEl)) 101) (str "<span style=\"color: red\">" (apply str (second listEl)) "</span>")
   (= (first (first listEl)) 102) (str "<span style=\"color: green\">" (apply str (second listEl)) "</span>")
   (= (first (first listEl)) 103) (str "<span style=\"color: orange\">" (apply str (second listEl)) "</span>")
   (= (first (first listEl)) 104) (str "<span style=\"color: blue\">" (apply str (second listEl)) "</span>")
   (= (first (first listEl)) 105) (str "<span style=\"color: blue\">" (apply str (second listEl)) "</span>")
   (= (first (first listEl)) 106) (if (reserved? (second listEl))
        (str "<span style=\"color:#bd42bd\">" (apply str (second listEl)) "</span>")
        (str "<span style=\"color:#5da28c\">" (apply str (second listEl)) "</span>"))
   (= (first (first listEl)) 107) (str "<span style=\"color:#1a9fe5\">" (apply str (second listEl)) "</span></p><p>")
   (= (first (first listEl)) 200) (str "<span style=\"color:#e1931e\">" (if (seq? (second listEl)) (apply str (second listEl)) (str (second listEl))) "</span>")
   (= (first (first listEl)) 201) "</p><p>"
   (and (= (first (first listEl)) -1) (= (second listEl) \space)) " "
   :else (str "<span style=\"color:black\">"(apply str (second listEl))"</span>")))


(defn pwriteHTML [fileName resList]
  (spit (str (subs fileName 0 (- (count fileName) 4)) ".html")
    (str htmlHead (apply str (map (fn [el] (htmlTag el)) resList)) htmlEnd)))


(defn pfindPattern2HTML [filename file state word res]
  (loop [fname filename f file s state w word r res] (when (not (nil? file))
    (cond
      (nil? f) (pwriteHTML fname (concat r (list (list (list s) w)) (list (list (list "end")))))
      (= s -1) (recur fname (next f) 0 (concat w (list (first f))) r)
      (> s 100) (if (some (fn [x] (= s x)) estados*)
        (recur fname (concat (list (first (reverse w))) f) 0 '() (concat r (list (list (list s) (reverse (next (reverse w)))))))
        (recur fname f 0 '() (concat r (list (list (list s) w)))))
   :else (recur fname (next f) (followAFD haskell (letterToSymbol2 (first f)) s) (concat w (list (first f))) r)))))


(defn mainSecuencial []
  (with-open [rdr (clojure.java.io/reader "src/resaltadorv3/test.txt")]
  (map #(pfindPattern2HTML % (seq (slurp %)) 0 '() '()) (doall (line-seq rdr)))))

(defn mainPartition []
  (with-open [rdr (clojure.java.io/reader "src/resaltadorv3/test.txt")]
  (pmap (fn [files] (map #(pfindPattern2HTML % (seq (slurp %)) 0 '() '()) files)) (partition-all 5 (doall (line-seq rdr))))))
