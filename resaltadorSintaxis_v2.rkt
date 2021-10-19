#lang racket

; Ejemplo automata '(((1 a 1) (1 b 2) (2 b 2))(2))




;INICIO PROYECTO

;lista estados finales
(define estadosFinales '(101 102 103 104 105 106 107 108 109 200 201 202 203 204 205 206 207))
(define estados* '(101 102 105 106 107 108 200 201))

(define arch (open-input-file "c:\\datos.txt")) ; arbir archivo

;lista transiciones
(define transiciones '((0 #\space 0)
                       (0 "number" 1)
                       (1 "number" 1)
                       (1 "letter-e" 101)
                       (1 #\e 101)
                       (1 "special" 101)
                       (1 #\space 101)
                       (1 #\. 2)
                       (2 "number" 2)
                       (2 "letter-e" 102)
                       (2 "special" 102)
                       (2 #\space 102)
                       (2 #\e 3)
                       (3 "number" 4)))

;INTENTO 1 - hacerlo caracteer por caracter

;Funciones que encuentra si el estado es final o no

(define estado*?
  (lambda (estado listaEstados)
    (cond
      ((null? estados*) #f)
      ((= estado (car estados*)) #t)
      (else (estado*? estado (cdr estados*))))))

(define find (lambda (el listToSearch)
     (cond
      ((null? listToSearch) #f)
      ((eq? el (car listToSearch)) #t)
      (else (find el (cdr listToSearch))))))
    

(define nextState (lambda (afd simbolo estado) ;funciona bien - a esta le vas pasando los simbolos
  (cond
    ((null? afd) -1)
    ((pair? (car afd)) (max (nextState (car afd) simbolo estado) (nextState (cdr afd) simbolo estado)))
    ((not (pair? (car afd))) (if (and (eq? (cadr afd) simbolo) (eq? (car afd) estado)) (caddr afd) -1))
    (else (nextState (cdr afd) simbolo estado)))))


(define letterToSymbol (lambda (el)
         (cond
           ((find el '(#\a #\b #\c #\d #\f #\g #\h #\i #\j #\k #\l #\m #\n #\o #\p #\q #\r #\s #\t #\u #\v #\w #\x #\y #\z #\A #\B #\C #\D #\F #\G #\H #\I #\J #\K #\L #\M #\N #\O #\P #\Q #\R #\S #\T #\U #\V #\W #\X #\Y #\Z)) "letter-e")
           ((find el '(#\1 #\2 #\3 #\4 #\5 #\6 #\7 #\8 #\9 #\0)) "number")
           (else el))))

;Estados finales siempre estan arriba de 100
(define findPattern (lambda (char estado el)  
         (cond
         ((< 100 estado) (list estado el))
         ((< estado 0) "no existe")
         (else (findPattern (read-char arch) (nextState transiciones (letterToSymbol char) estado) (append (list char) el)))))) ; esta sigue leyendo hasta encontrar algun estado final


; (testRead (findPattern (read-char arch) 0 '()))
(define testRead (lambda (finalState) ; aqui revisar si es estado* y llamar otra vez find pattern per con el mismo char.
                   (cond
                     ((pair? finalState) (if (estado*? (car finalState) estados*) (apply string (reverse (cdadr finalState))) (apply string (reverse (cadr finalState))))) ;regresa un string del valor que se le tiene que poner el HTMLtag
                     (eof-object? (read arch) "ya acabo el archivo")
                     (else (testRead (findPattern (read-char arch) 0 '()))))))


;(define writeHTML (lambda (list)  ;Aqui tiene que agregar el HTML tag y escribirlo en el archivo.
                  





;INTENTO 2 - Usar funciones tarea, leer por chars pero almacenar en listas y pasarselas a la funcion que lo lea

(define separateStringsFile (lambda (lista)
                    (cond
                     (eof-object? (read-char arch) "ya acabo el archivo")
                     ((not (eq? (read-char arch) #\space)) lista)
                     (else (pruebaArchivo (append (list lista (read-char arch))))))))

(define patterToChange (lambda (patternResult)
                         (cond
                           (patternResult ())
                                                           


(define (pattern afd simbolos estado)
  (cond
    ((> estado 100) estado)
    ((= estado -1) "no ta")
    (else (pattern afd (cdr simbolos) (followAFD afd (letterToSymbol (car simbolos)) estado)))))


;Esta función usa un simbolo y estado actual para saber el sig estado y regresarlo.
(define (followAFD afd simbolo estado) ;Regresa sig estado
  (cond
    ((null? afd) -1)
    ((pair? (car afd)) (max (followAFD (car afd) simbolo estado) (followAFD (cdr afd) simbolo estado)))
    ((not (pair? (car afd))) (if (and (eq? (cadr afd) simbolo) (eq? (car afd) estado)) (caddr afd) -1))
    (else (folloAFD (cdr afd) simbolo estado))))




