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


; Ej V

; Dividir a entre b para obtener un cociente q y un residuo r, de tal manera que: a=bq+r.
; Si r es diferente de cero, remplazar a por b y b por r, y volver a repetir los pasos 1 y 2.
; Si r es igual a cero, el MCD de a y b es b.

(define (ejV a b)
      ;(quotient a b)  q
      ;(remainder a b)  r
      (if (= (remainder a b) 0)
          ;then
          b
          ;else
          (ejV b (remainder a b))
       )
)



; Ej VI  - funciona
(define (separate x)
  (if (zero? x)
      ; then
      0
      ;else
      (+ (remainder x 10) (separate (quotient x 10)))  ; no entiendo como avanza en el numero usando quotient y remainder - toy confundida
   )
)

(define (sumarNum n)
 ; poner si es multiplo de 9 con un if
  (if (< n 10)
      ;then
      (if (= n 9) "multiplo de 9" "no es multiplo de 9")
      ;else
      (sumarNum (separate n))
  )
)







;Ej clase - vol cilindro
(define (volCil r h)
  (* pi (* r r) h)  
)


(define (mayor2 n1 n2) (if (> n1 n2) n1 n2))
; siendo mi solucion
(define (mayor3 n1 n2 n3)
  ;(if (>(mayor2 n1 n2) n3)
  ;    (mayor2 n1 n2)
  ;    n3
  ;)
  ;sol profe
  (mayor2 n1 (mayor2 n2 n3))
)












