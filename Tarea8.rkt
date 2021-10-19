#lang racket
;Parte I - filtra-negativo?
; (filtro negative? '(-1 2 3 -5))

(define filtro
  (lambda (pred lista)
    (cond
      ((null? lista) '())
      ((pred (car lista)) (cons (car lista) (filtro pred (cdr lista))))
      (else (filtro pred (cdr lista))))))


;Parte II - Quicksort - no sirve si se tienen elementos iguales
;pivot is (car lista)
; (quick-sort '(10 80 30 90 40 50 70))
(define quick-sort
  (lambda (lista)
    (cond
      ((null? lista) '()) ; en caso que filter con pivote regrese lista vacía. 
      ((null? (cdr lista)) (list (car lista)))
      (else (append (quick-sort (filtro (lambda (x) (< x (car lista))) (cdr lista))) (list (car lista)) (quick-sort (filtro (lambda (x) (> x (car lista))) (cdr lista))))))))
; llamas quicksort con lo que sea menor al pivote, agregar pivote en medio, llamar quicksort con lista mayor del pivote - solito se acomoda todo jiji

;Parte III
;baratos
(define prductos '((lapiz . 2) (borrador . 1) (grapadora . 50) (cinta . 10)))
(define baratos
  (lambda (lista)
        (map (lambda (prod) (if (< (cdr prod) 10) prod '())) lista))))
       

;Parte - V
;grafo - '((A ((B 2) (D 10))) (B ((C 9) (E 5))) (C ((A 12) (D 6))) (D ((E 7))) (E ((C 3))))
; (nodos '((A ((B 2) (D 10))) (B ((C 9) (E 5))) (C ((A 12) (D 6))) (D ((E 7))) (E ((C 3)))))
; 1
(define nodos
  (lambda (grafo)
    (map car grafo)))


; 3
; (suma-pesos '((A ((B 2) (D 10))) (B ((C 9) (E 5))) (C ((A 12) (D 6))) (D ((E 7))) (E ((C 3)))))
(define suma-pesos
  (lambda (grafo)
    (apply + (map (lambda (x) (apply + x)) (map (lambda (x) (map cadr x)) (map cadr grafo)))))) 


