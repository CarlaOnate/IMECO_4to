#lang racket


;(fileToList (read-char arch) '())
(define fileToList (lambda (char lista) ; te pone todo los caracteres del archivo en una lista
                    (cond
                     ((eof-object? (peek-char arch)) (append lista (list char)))
                     (else (fileToList (read-char arch) (append lista (list char)))))))

;Cosas globales
(define estadosFinales '(101 102 103 104 105 106 107 108 109 200 201 202 203 204 205 206 207))
(define estados* '(101 102 105 106 107 108 200 201))

(define arch (open-input-file "c:\\datos.txt")) ; arbir archivo
(define listFile (fileToList (read-char arch) '())) ; lista con todo el archivo
(close-input-port arch)
(define outFile (open-output-file "c:\\datosSalida.txt" #:exists 'replace))

;lista transiciones
(define transiciones '((0 #\space -1) (0 "number" 1) (1 "number" 1) (1 "letter-e" 101) (1 #\e 101) (1 "special" 101) (1 #\space 101)
                       (1 #\. 2) (2 "number" 2) (2 "letter-e" 102) (2 "special" 102) (2 #\space 102) (2 #\newline 102) (2 "eof" 102) (2 #\e 3) (3 "number" 103)
                       (0 #\" 4) (4 "letter-e" 4) (4 #\e 4) (4 "number" 4) (4 #\space 4) (4 "special" 4) (4 #\" 104)
                       (0 "letter-e" 5) (0 #\e 5) (5 "letter-e" 5) (5 #\e 5) (5 "number" 5) (5 "special" 5) (5 #\space 105) (5 "eof" 105) (5 #\newline 105)
                       (0 #\; 6) (6 "letter-e" 6) (6 #\e 6) (6 "number" 6) (6 "special" 6) (6 #\space 6) (6 #\newline 106)
                       (0 #\< 7) (0 #\> 7) (7 #\= 208) (7 "letter-e" 209) (7 #\e 209) (7 "number" 209) (7 "special" 209) (7 #\space 209) (7 "eof" 209) (7 #\newline 209)
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
           ((find el '(#\( #\) #\{ #\} #\[ #\] #\+ #\- #\* #\/ #\# #\\ #\' #\;)) "special")
           ((eof-object? el) "eof")
           (else el))))

;(findPattern listFile 0 '() '())
(define findPattern (lambda (fileInList state word resFile) ; state es una lista -> (state '(p a t r o n)) -> regresa '(101 (#\1 #\2 #\space))
                         (cond
                           ((null? fileInList) resFile)
                           ((and (pair? state) (> (car state) 100)) (findPattern (cdr fileInList) 0 '() (append resFile (list state))))
                           ((and (pair? state) (= (car state) -1)) (findPattern (cdr fileInList) 0 '() (append resFile (list state))))
                           ((detectSpecial (car fileInList)) (findPattern fileInList (pattern transiciones (append word (list (car fileInList))) 0 '()) '() resFile))
                           (else (findPattern (cdr fileInList) state (append word (list (car fileInList))) resFile)))))

(define detectSpecial (lambda (el)
                         (if
                           (or (eq? el #\() (eq? el #\)) (eq? el #\{) (eq? el #\}) (eq? el #\[) (eq? el #\]) (eq? el #\+) (eq? el #\-) (eq? el #\*) (eq? el #\/) (eq? el #\#) (eq? el #\\) (eq? el #\') (eq? el #\space)) #t #f))) 


; (pattern transiciones listFile 0 '())
; (pattern transiciones '(#\1 #\2 #\space) 0 '())
(define (pattern afd simbolos estado listRes) ; -> regresa '(101 (#\1 #\2 #\space))
  (cond
    ((> estado 100) (list estado (list->string listRes)))
    ((= estado -1) (list -1 (list->string listRes)))
    ((null? simbolos) (list -1 (list->string listRes)))
    (else (pattern afd (cdr simbolos) (followAFD afd (letterToSymbol (car simbolos)) estado) (append listRes (list (car simbolos))))))) 


;Esta función usa un simbolo y estado actual para saber el sig estado y regresarlo.
(define (followAFD afd simbolo estado) ;Regresa sig estado
  (cond
    ((null? afd) -1)
    ((pair? (car afd)) (max (followAFD (car afd) simbolo estado) (followAFD (cdr afd) simbolo estado)))
    ((not (pair? (car afd))) (if (and (eq? (cadr afd) simbolo) (eq? (car afd) estado)) (caddr afd) -1))
    (else (followAFD (cdr afd) simbolo estado))))





