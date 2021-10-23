#lang racket


;(fileToList (read-char arch) '())
(define fileToList (lambda (char lista) ; te pone todo los caracteres del archivo en una lista
                    (cond
                     ((eof-object? (peek-char arch)) (append lista (list char)))
                     (else (fileToList (read-char arch) (append lista (list char)))))))

;Cosas globales
(define estadosFinales '(101 102 103 104 105 106 200))
(define estados* '(101 102 105 209))

(define arch (open-input-file "c:\\datos.txt")) ; arbir archivo
(define listFile (fileToList (read-char arch) '())) ; lista con todo el archivo
(close-input-port arch)
(define outFile (open-output-file "c:\\datosSalida.txt" #:exists 'replace))

;lista transiciones
(define transiciones '((0 #\space -1) (0 "number" 1) (1 "number" 1) (1 "letter-e" 101) (1 #\e 101) (1 "special" 101) (1 #\space 101) (1 "eof" 101) (1 #\newline 101)
                       (1 #\. 2) (2 "number" 2) (2 "letter-e" 102) (2 "special" 102) (2 #\space 102) (2 #\newline 102) (2 "eof" 102) (2 #\e 3) (3 "number" 103)
                       (0 #\" 4) (4 "letter-e" 4) (4 #\e 4) (4 "number" 4) (4 #\space 4) (4 "special" 4) (4 #\" 104)
                       (0 "letter-e" 5) (0 #\e 5) (5 "letter-e" 5) (5 #\e 5) (5 "number" 5) (5 "special" 5) (5 #\space 105) (5 "eof" 105) (5 #\newline 105)
                       (0 #\; 6) (6 "letter-e" 6) (6 #\e 6) (6 "number" 6) (6 "special" 6) (6 #\space 6) (6 #\newline 106)
                       (0 #\< 7) (0 #\> 7) (7 #\= 208) (7 "letter-e" 200) (7 #\e 200) (7 "number" 200) (7 "special" 200) (7 #\space 200) (7 "eof" 200) (7 #\newline 200)
                       (0 "special" 200)
                       ;(0 #\( 200) (0 #\) 200) ; no entra aqui porque son specials todos
                       ;(0 #\' 201)
                       ;(0 #\{ 202) (0 #\} 202)
                       ;(0 #\[ 203) (0 #\] 203)
                       ;(0 #\+ 204) (0 #\- 204) (0 #\/ 204) (0 #\* 204)
                       ;(0 #\% 205) (0 #\# 205)
                       ;(0 #\= 206)
                       ;(0 #\: 207)
))


;INTENTO 2 - Usar funciones tarea, leer por chars pero almacenar en listas y pasarselas a la funcion que lo lea

(define find (lambda (el listToSearch)
     (cond
      ((null? listToSearch) #f)
      ((eq? el (car listToSearch)) #t)
      (else (find el (cdr listToSearch))))))

(define letterToSymbol (lambda (el)
         (cond
           ((find el '(#\a #\b #\c #\d #\f #\g #\h #\i #\j #\k #\l #\m #\n #\o #\p #\q #\r #\s #\t #\u #\v #\w #\x #\y #\z #\A #\B #\C #\D #\F #\G #\H #\I #\J #\K #\L #\M #\N #\O #\P #\Q #\R #\S #\T #\U #\V #\W #\X #\Y #\Z)) "letter-e")
           ((find el '(#\1 #\2 #\3 #\4 #\5 #\6 #\7 #\8 #\9 #\0)) "number")
           ((find el '(#\( #\) #\{ #\} #\[ #\] #\+ #\- #\* #\/ #\# #\\ #\' #\; #\=)) "special")
           ((eof-object? el) "eof")
           (else el))))

(define estado*? (lambda (state)
                         (if (find (car state) estados*) #t #f)))


;Cuando pattern solo regresa estado
;(findPattern listFile 0 '() '())
(define findPattern (lambda (fileInList state word resFile)
                         (cond
                            ;((null? fileInList) resFile)
                           ((null? fileInList) (writeHTML (append resFile (list (list (list "end"))))))
                           ((and (pair? state) (> (car state) 100)) (if (estado*? state)
                                                                         (findPattern fileInList (pattern transiciones (list (car fileInList)) 0) (list (car fileInList)) (append resFile (list (list state word))))
                                                                         (findPattern (cdr fileInList) 0 '() (append resFile (list (list state word))))))
                           ((and (pair? state) (= (car state) -1)) (findPattern (cdr fileInList) 0 '() (append resFile (list (list state word)))))
                           ((detectSpecial (car fileInList)) (if (null? word) (findPattern fileInList (pattern transiciones (append word (list (car fileInList))) 0) (car fileInList) resFile) (findPattern fileInList (pattern transiciones (append word (list (car fileInList))) 0) word resFile)))
                           (else (findPattern (cdr fileInList) state (append word (list (car fileInList))) resFile)))))
                           


(define detectSpecial (lambda (el)
                         (if
                           (or (eq? el #\() (eq? el #\)) (eq? el #\{) (eq? el #\}) (eq? el #\[) (eq? el #\]) (eq? el #\+) (eq? el #\-) (eq? el #\*) (eq? el #\/)
                               (eq? el #\#) (eq? el #\\) (eq? el #\') (eq? el #\=) (eq? el #\space) (eq? el #\newline)) #t #f))) 


; (pattern transiciones listFile 0 '())
; (pattern transiciones '(#\1 #\2 #\space) 0 '())
(define (pattern afd simbolos estado) ; -> regresa '(101 (#\1 #\2 #\space))
  (cond
    ((> estado 100) (list estado))
    ((= estado -1) (list -1))
    ((null? simbolos) (list -1))
    (else (pattern afd (cdr simbolos) (followAFD afd (letterToSymbol (car simbolos)) estado))))) 


;Esta función usa un simbolo y estado actual para saber el sig estado y regresarlo.
(define (followAFD afd simbolo estado) ;Regresa sig estado
  (cond
    ((null? afd) -1)
    ((pair? (car afd)) (max (followAFD (car afd) simbolo estado) (followAFD (cdr afd) simbolo estado)))
    ((not (pair? (car afd))) (if (and (eq? (cadr afd) simbolo) (eq? (car afd) estado)) (caddr afd) -1))
    (else (followAFD (cdr afd) simbolo estado))))


(define writeHTML (lambda (resList)
                    (for-each (lambda (el) (if (eq? (caar el) "end") (close-output-port outFile) (write (htmlTag el) outFile))) resList))) 

;(findPattern listFile 0 '() '())
(define htmlTag (lambda (listEl) ;-> recibe '((101) (#\1 #\2 #\3))
                         (cond
                           ((eq? (caar listEl) 101) (string-append "<span class=\"int\">" (list->string (cadr listEl)) "<span/>"))
                           ((eq? (caar listEl) 102) (string-append "<span class=\"float\">" (list->string (cadr listEl)) "<span/>"))
                           ((eq? (caar listEl) 103) (string-append "<span class=\"exp\">" (list->string (cadr listEl)) "<span/>"))
                           ((eq? (caar listEl) 104) (string-append "<span class=\"string\">" (list->string (cadr listEl)) "<span/>"))
                           ((eq? (caar listEl) 105) (string-append "<span class=\"identifier\">" (list->string (cadr listEl)) "<span/>")) ; checar palabras reservadas aqui
                           ((eq? (caar listEl) 106) (string-append "<span class=\"comments\">" (list->string (cadr listEl)) "<span/>"))
                           ((eq? (caar listEl) 200) (string-append "<span class=\"special\">" (list->string (if (pair? (cadr listEl)) (cadr listEl) (list (cadr listEl)))) "<span/>"))
                           ((eq? (caar listEl) 209) (string-append "<span class=\"special2\">" (list->string (if (pair? (cadr listEl)) (cadr listEl) (list (cadr listEl)))) "<span/>"))
                           ((and (eq? (caar listEl) -1) (eq? (cadr listEl) #\newline)) "\n")
                           ((and (eq? (caar listEl) -1) (eq? (cadr listEl) #\space)) " ")
                           (else (list->string (cadr listEl))))))



