(ns resaltadorv3.core
  (:gen-class))

(def estados* '(101 102 103 106 202))

(def reservedWords '("println" "def" "if" "cond" "defn" "fn" "else" "true" "false" "nil" "cons" "first" "second" "rest" "next" "concat" "map" "apply" "filter" "reduce" "pmap" "let" "seq" "conj" "do" "and" "or"
"not" "not=" "quote" "empty?" "take" "range" "doall" "time" "future" "delay" "promise"))


(def resHaskell '("case" "class" "data" "default" "deriving" "do" "else" "if" "import" "in" "infix" "infixl" "infixr" "instance" "let" "module" "newtype" "of" "then" "type" "where" "_"))


(def haskell '(
   (0 \space 0) (0 \. 200)
   (0 "number" 1) (1 "number" 1) (1 "letter-e" 101) (1 "special" 101) (1 \space 101) (1 \newline 101)
   (1 "parenthesis" 101) (1 \{ 101) (1 \- 101) (1 \} 101)

   (1 \. 2) (2 "number" 3) (3 "number" 3) (3 "letter-e" 102) (3 "special" 102) (3 \space 102) (3 "parenthesis" 102) (3 \newline 102)

   (1 \e 16) (1 \E 16) (16 \- 17) (17 "number" 18) (16 "number" 18) (18 "number" 18) (18 \space 103) (18 \newline 103) (18 "special" 103)
   (18 "parenthesis" 103) (18 \{ 103) (18 \} 103) (18 \- 103) (18 "letter-e" 103) (18 \_ 103)
   (3 \e 4) (3 \E 4) (4 \- 5) (5 "number" 6) (4 "number" 6) (6 "number" 6) (6 \space 103) (6 \newline 103) (6 "special" 103)
   (6 "parenthesis" 103) (6 \{ 103) (6 \} 103) (6 \- 103) (6 "letter-e" 103) (6 \_ 103)

   (0 \" 7) (7 "number" 7) (7 "letter-e" 7) (7 \e 7) (7 \E 7) (7 "special" 7) (7 \space 7) (7 \. 7)
   (7 \_ 7) (7 \' 7) (7 \- 7) (7 "parenthesis" 7) (7 \newline 7) (7 \" 104)
   (0 \' 8) (8 "number" 9) (8 "letter-e" 9) (8 \e 9) (8 \E 9) (8 "special" 9) (8 \space 9) (8 "parenthesis" 9) (9 \' 105)
   (0 "letter-e" 10) (0 \e 10) (0 \E 10) (0 \_ 10) (10 "letter-e" 10) (10 \e 10) (10 \E 10) (10 \_ 10) (10 "number" 10) (10 \' 10)
   (10 \space 106) (10 "special" 106) (10 \newline 106) (10 "parenthesis" 106) (10 \{ 106) (10 \} 106)
   (10 \. 106) (10 \- 106) (10 \" 106)
   (0 \- 11) (11 \space 200) (11 "special" 200) (11 \- 12) (12 "letter-e" 12) (12 \e 12) (12 \E 12) (12 \_ 12) (12 \- 12) (12 "number" 12) (12 \space 12) (12 "special" 12) (12 "parenthesis" 12)
   (12 \" 12) (12 \' 12) (12 \{ 12) (12 \} 12) (12 \. 12) (12 \newline 107)
   (0 \{ 13) (13 "letter-e" 202) (13 "number" 202) (13 "special" 202) (13 "parenthesis" 202) (13 \space 202) (13 \_ 202) (13 \newline 202)
  (13 \- 14) (14 "letter-e" 14) (14 \e 14) (14 \_ 14) (14 "number" 14) (14 \space 14) (14 "special" 14) (14 "parenthesis" 14)
   (14 \' 14) (14 \" 14) (14 \. 14) (14 \newline 14) (14 \- 15) (15 \} 107)
   (0 \newline 201) (0 "parenthesis" 200) (0 "special" 200) (0 \} 200)
  ))

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

(defn reserved? [word]
    (some (fn [x] (= (apply str (filter #(not= \space %) word)) x)) reservedWords))
      ;(some (fn [x] (= (apply str (filter #(not= \space %) word)) x)) resHaskell))

(def htmlHead "<!DOCTYPEhtml><html><head><title>SuperMegaCoolResaltador</title><body style=\"white-space: pre\"><div><p>")

(def htmlEnd "</p></div></body></html>")


(defn htmlTag [listEl]
 (cond
   (= (first (first listEl)) 101) (str "<span style=\"color: red\">" (apply str (second listEl)) "</span>")
   (= (first (first listEl)) 102) (str "<span style=\"color: green\">" (apply str (second listEl)) "</span>")
   (= (first (first listEl)) 103) (str "<span style=\"color: #e87e17\">" (apply str (second listEl)) "</span>")
   (= (first (first listEl)) 104) (str "<span style=\"color: blue\">" (apply str (second listEl)) "</span>")
   (= (first (first listEl)) 105) (str "<span style=\"color: blue\">" (apply str (second listEl)) "</span>")
   (= (first (first listEl)) 106) (if (reserved? (second listEl))
        (str "<span style=\"color:#bd42bd\">" (apply str (second listEl)) "</span>")
        (str "<span style=\"color:#5da28c\">" (apply str (second listEl)) "</span>"))
   (= (first (first listEl)) 107) (str "<span style=\"color:#1a9fe5\">" (apply str (second listEl)) "</span></p><p>")
   (or (= (first (first listEl)) 200) (= (first (first listEl)) 202)) (str "<span style=\"color:#e1931e\">" (if (seq? (second listEl)) (apply str (second listEl)) (str (second listEl))) "</span>")
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
      (= s -1) (recur fname f 0 '() (concat r (list (list (list s) w)))) ;(recur fname (next f) 0 (concat w (list (first f))) r)
      (> s 100) (if (some (fn [x] (= s x)) estados*)
        (recur fname (concat (list (first (reverse w))) f) 0 '() (concat r (list (list (list s) (reverse (next (reverse w)))))))
        (recur fname f 0 '() (concat r (list (list (list s) w)))))
   :else (recur fname (next f) (followAFD haskell (letterToSymbol2 (first f)) s) (concat w (list (first f))) r)))))


(defn mainSecuencial []
  (with-open [rdr (clojure.java.io/reader "src/resaltadorv3/test.txt")]
  (doall (map #(pfindPattern2HTML % (seq (slurp %)) 0 '() '()) (doall (line-seq rdr))))))

(defn mainPartition []
  (with-open [rdr (clojure.java.io/reader "src/resaltadorv3/test.txt")]
  (doall (pmap (fn [files] (doall (map #(pfindPattern2HTML % (seq (slurp %)) 0 '() '()) files))) (partition-all 20 (doall (line-seq rdr)))))))

  ; inputFiles/2.txt
  ; inputFiles/3.txt
  ; inputFiles/4.txt
  ; inputFiles/5.txt
  ; inputFiles/6.txt
  ; inputFiles/7.txt
  ; inputFiles/8.txt
  ; inputFiles/9.txt
  ; inputFiles/10.txt
  ; inputFiles/11.txt
  ; inputFiles/12.txt
  ; inputFiles/13.txt
  ; inputFiles/14.txt
  ; inputFiles/15.txt
  ; inputFiles/16.txt
  ; inputFiles/17.txt
  ; inputFiles/18.txt
  ; inputFiles/19.txt
  ; inputFiles/110.txt
  ; inputFiles/111.txt
  ; inputFiles/112.txt
  ; inputFiles/113.txt
  ; inputFiles/114.txt
  ; inputFiles/115.txt
  ; inputFiles/116.txt
  ; inputFiles/117.txt
  ; inputFiles/118.txt
  ; inputFiles/119.txt
  ; inputFiles/120.txt
