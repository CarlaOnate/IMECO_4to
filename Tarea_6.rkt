#lang racket
;Ej IV
(define (dis x1 y1 x2 y2)
  (sqrt (+ (* (- x2 x1) (- x2 x1)) (* (- y2 y1) (- y2 y1)) ))
 )
; dis x1 y1 x2 y2 - A
; dis x3 y3 x1 y1 - B
; dis x2 y2 x3 y3 - C

(define (quesesto x1 y1 x2 y2 x3 y3)
  (if (and
   (> (+ (dis x1 y1 x2 y2) (dis x3 y3 x1 y1)) (dis x2 y2 x3 y3))
   (> (+ (dis x1 y1 x2 y2) (dis x2 y2 x3 y3)) (dis x3 y3 x1 y1))
   (> (+ (dis x2 y2 x3 y3) (dis x3 y3 x1 y1)) (dis x1 y1 x2 y2)))
      ;true
      (cond
        [(not (or (= (dis x1 y1 x2 y2) (dis x1 y1 x3 y3)) (= (dis x1 y1 x2 y2) (dis x2 y2 x3 y3)))) "escaleno"]
        [(and (= (dis x1 y1 x2 y2) (dis x1 y1 x3 y3)) (= (dis x1 y1 x2 y2) (dis x2 y2 x3 y3))) "equilatero"] 
        [else "isoceles"]
      )
      ;false - no triangle
      "No es un triangulo"
   )
)

;Ej II 
(define (dis2 p1 p2)
  (sqrt (+ (* (- (car p2) (car p1)) (- (car p2) (car p1))) (* (- (cadr p2) (cadr p1)) (- (cadr p2) (cadr p1))) ))
 )

; dis x1 y1 x2 y2 - A
; dis x3 y3 x1 y1 - B
; dis x2 y2 x3 y3 - C

(define (triangle p1 p2 p3)
  (if (and
   (> (+ (dis2 p1 p2) (dis2 p3 p1)) (dis2 p2 p3))
   (> (+ (dis2 p1 p2) (dis2 p2 p3)) (dis2 p3 p1))
   (> (+ (dis2 p2 p3) (dis2 p3 p1)) (dis2 p1 p2)))
      ;true
      (cond
        [(not (or (= (dis2 p1 p2) (dis2 p1 p3)) (= (dis2 p1 p2) (dis2 p2 p3)))) "escaleno"]
        [(and (= (dis2 p1 p2) (dis2 p1 p3)) (= (dis2 p1 p2) (dis2 p2 p3))) "equilatero"] 
        [else "isoceles"]
      )
      ;false - no triangle
      "No es un triangulo"
   )
)


;Ej 1 - III
(define (suma-cuadrados-pares lista)
  (if (null? lista)
      0
      (if (even? (car lista))
          (+ (* (car lista) (car lista)) (suma-cuadrados-pares (cdr lista)))
          (+ 0 (suma-cuadrados-pares (cdr lista)))
      )
  )
)


;Ej 2 - III
(define (miembro? el lista)
  (if (null? lista)
     #f
     (if (= el (car lista))
         #t
         (miembro? el (cdr lista))
     )
  )
)


;Ej 3 - III
(define (accesa-n num lista)
  (cond
    ((or (null? lista) (< num 0)) 0)
    ((= num 1) (car lista))
    (else (accesa-n (- num 1) (cdr lista)))
  )
)


;Ej 4 - III
(define (producto-punto a b)
  (+ (* (car a) (car b)) (* (cadr a) (cadr b)) (* (caddr a) (caddr b)))) 


;Ej 5 - III
(define (mas-larga a b)
  (cond
    ((= (length a) (length b)) a)
    ((> (length a) (length b)) a)
    (else b)))



;Automata
;Matriz transiciones
;Terminal es 1
;  - a  b
;1 - 1  2
;2 - 1  2

;Automata en lista - v1
(define aut1 (list (list (cons 'a 1) (cons 'b 2)) (list (cons 'a 1) (cons 'b 2))))

;Automata en lista - v2
(define q1 (list (cons 'a 1) (cons 'b 2)))
(define q2 (list (cons 'a 1) (cons 'b 2)))
(define aut2 (list q1 q2))





