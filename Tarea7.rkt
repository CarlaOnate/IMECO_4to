#lang racket

; (filtra-negativos '(-1 2 3 4 -5 -6))
(define (filtra-negativos lista)
  (cond
    ((null? lista) '())
    ((< (car lista) 0) (filtra-negativos (cdr lista)))
    (else (cons (car lista) (filtra-negativos (cdr lista))))))

;(genera-pares '(1 2 3) '(a b c))
(define (genera-pares lista1 lista2)
  (if (null? (cdr lista1)) ;listas tienen un elemento restante.
      (list (cons (car lista1) (car lista2)))
      (append (list (cons (car lista1) (car lista2))) (genera-pares (cdr lista1) (cdr lista2)))))
      
;(invierte '(1 2 3 4 5))
(define (invierte lista)
  (if (null? lista)
      '()
      (append (invierte (cdr lista)) (list (car lista)))))

; (duplicar '(((a) b) c))
(define (duplicar lista)
  (cond
    ((null? lista) '())
    ((list? (car lista)) (cons (duplicar (car lista)) (duplicar (cdr lista))))
    (else (cons (car lista) (cons (car lista) (duplicar (cdr lista)))))))


;(parentesis '(1 2 3 4)) - saca resultado con 1 menos, si son 2 sale 1, si son 8 sale 7
;NO SIRVE EES
(define (parentesis lista)
  (cond
    ((null? lista) 2)
    ((list? (car lista)) (+ 0 (parentesis (cdr lista)) (parentesis (car lista))))
    (else (+ 0 (parentesis (cdr lista))))))


;(convierte-plana '((((a b c)))))
(define (convierte-plana lista)
  (cond
    ((null? lista) '())
    ((not (pair? (car lista))) (append (cons (car lista) (convierte-plana (cdr lista)))))
    (else (append (convierte-plana (car lista)) (convierte-plana (cdr lista))))))


; III
(define Alumnos '((A01750624 (Paulina Alva) (80 70 90) 85)
                  (A01748223 (Luis Morales) (90 90 75) 90)
                  (A01728854 (Maria Lopez) (100 100 95) 100)))

(define (suma lista)
  (if (null? lista)
      0
      (+ (car lista) (suma (cdr lista)))))

(define (calificacion lista)
  (if (null? lista)
      '()
      (+ (* 0.60(/ (suma (car lista)) 3)) (* 0.40 (suma (cdr lista))))))

(define (calificacion-final lista)
  (if (null? lista)
      '()
      (cons (list (car (car lista)) (car (cdr (car lista))) (calificacion (cdr (cdr (car lista)))) (calificacion-final (cdr lista))))))



;IV -Arbol binario
; (contar-arbol '(5 (3 () ()) (8 () (9 () ()))))
(define (contar-arbol arbol)
  (cond
    ((null? arbol) 0)
    ((list? (car arbol)) (+ (contar-arbol (car arbol)) (contar-arbol (cdr arbol))))
    (else (+ 1 (contar-arbol (cdr arbol))))))


;Busqueda arbol
; (insertar '(5 (3 () ()) (8 () (9 () ()))) 1)

(define (insertar arbol valor)
  (cond
    ((null? arbol) (list valor '() '()))
    ((< valor (car arbol)) (list (car arbol) (insertar (cadr arbol) valor) (caddr arbol)))
    (else (list (car arbol) (cadr arbol) (insertar (caddr arbol) valor)))))


;Altura arbol
; (altura '(5 (3 () ()) (8 () (9 () ()))))
;Cada nivel cuenta - compara y regresa mas alto
(define (max el1 el2)
  (if (< el1 el2) el2 el1))

(define (altura arbol)
  (if (null? arbol) 0
      (+ 1 (max (altura (cadr arbol)) (altura (caddr arbol))))))




;V - automata
;automata
; (automata '(((1 a 1) (1 b 2) (2 b 2))(2)) '(a a a b))
;Esta función le pasa a reconocer los datos del afd como los necestia y le da el estadoFinal aparte. 
(define (acepta? afd simbolos)
  (reconoce (car afd) simbolos 1 (caadr afd)))

; (reconoce '((1 a 1)(1 b 2)(2 b 2)) '(a a a b) 1 2)
;Esta función cicla los simbolos y va guardando el estado actual, cuando se acabe la lista de simbolos
;compara si el estado actual es igual al estado final para ver si es valido. 
(define (reconoce afd simbolos estado estadoFinal)
  (cond
    ((null? simbolos) (if (= estado estadoFinal) #t #f))
    (else (reconoce afd (cdr simbolos) (buscar-afd afd (car simbolos) estado) estadoFinal))))

; (buscar-afd '((1 a 1)(1 b 2)(2 b 2)) '(a) 1)
; (buscar-afd '((1 a 1)(1 b 2)(2 b 2)) 'a 1)
;Esta función usa un simbolo y estado actual para saber el sig estado y regresarlo.
(define (buscar-afd afd simbolo estado) ;Regresa sig estado
  (cond
    ((null? afd) 0)
    ((pair? (car afd)) (max (buscar-afd (car afd) simbolo estado) (buscar-afd (cdr afd) simbolo estado)))
    ((not (pair? (car afd))) (if (and (eq? (cadr afd) simbolo) (eq? (car afd) estado)) (caddr afd) 0))
    (else (buscar-afd (cdr afd) simbolo estado))))





