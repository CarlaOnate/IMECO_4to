#lang racket
;Ejercicios clase 5Oct

(define (genera-n-ceros n)
  (if (= n 0) ; (= n 1) - mejor usar con 0
      '()     ; '(0)
      (cons 0 (genera-n-ceros (- n 1)))))

(define (generar-n-1 n)
  (if (= n 0)
      '()
      (cons n (generar-n-1 (- n 1)))))

(define (1-n n)
  (if (= n 0) '()
      (append (1-n (- n 1)) (list n))))  ; si pones '(n) te va a dar una lista de puras n, tiene que ser (list n)

;Ej - generar una lista con los numeros de la serie de fibonacci

(define (fib n)
  (if (< n 3)
      1
      (+ (fib (- n 1)) (fib (- n 2)))))

(define (fibList n)
  (if (= n 0)
      '()
      (cons (fib n) (fibList (- n 1)))))  ; va de mayor a menor

(define (fibList2 n)
  (if (= n 0)
      '()
      (append (fibList2 (- n 1)) (list (fib n)))))  ; va de menor a mayor


;Sig ejercicios con profe
(define (incrementa lista)
  (if (null? lista) ; caso base - cuando la lista este vacia
      '()
      (cons (+ (car lista) 1) (incrementa (cdr lista)))))

;Ordena lista
(define (ordena lista)
  (if (null? lista)
      '()
      (inserta (car lista) (ordena (cdr lista)))))

(define (inserta dato listaord)  ; este es - insertion sort - no es muy eficiente
  (cond
    (null? listaord) (list dato)
    ((< dato (car listaord)) (cons dato listaord)) ; si el dato es menor que el inicio entones le toca ahi y lo pones al inicio con un cons.
    (else (cons (car listaord) (inserta dato (cdr listaord))))))
