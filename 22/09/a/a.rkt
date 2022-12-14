#lang racket

(define MAP (make-hash))

(define HEAD (vector 0 0))
(define TAIL (vector 0 0))

(define (vector-add a b)
  (for/vector ([i a]
               [j b])
    (+ i j)
    ))

(define (move-head h delta)
  (set! HEAD (vector-add h delta)))

(define (dist a b)
  (abs (- a b)))

(define (within-1 h t)
  (if (>= (dist h t) 1)
      (if (> h t)
          (- h 1)
          (+ h 1))
      h))

(define (drag-tail h t)
  (define hx (vector-ref h 0))
  (define hy (vector-ref h 1))
  (define tx (vector-ref t 0))
  (define ty (vector-ref t 1))
  (cond
    [(and (> (dist hx tx) 1) (= hy ty)) (vector (within-1 hx tx) ty)]
    [(and (> (dist hy ty) 1) (= hx tx)) (vector tx (within-1 hy ty))]
    [(or (> (dist hx tx) 1) (> (dist hy ty) 1)) (if (> (dist hx tx) (dist hy ty))
              (vector (within-1 hx tx) hy)
              (vector hx (within-1 hy ty)))]
    [else t]))

(define (draw-map h t)
  (define hx (vector-ref h 0))
  (define hy (vector-ref h 1))
  (define tx (vector-ref t 0))
  (define ty (vector-ref t 1))
  (for ([y (in-range -5 6)])
    (for ([x (in-range -5 6)])
      (if (equal? h (vector x y))
          (display "H")
          (if (equal? t (vector x y))
              (display "T")
              (display "."))))
    (display "\n"))
  (display "\n"))

(define (move-rope dir amt)
  (when (string? amt)
    (set! amt (string->number amt)))
  (for ([i amt])
    (move-head HEAD
               (case dir
                 [("U") (vector 0 1)]
                 [("D") (vector 0 -1)]
                 [("R") (vector 1 0)]
                 [("L") (vector -1 0)]
                 [else (error(~a "Unknown " dir))]))
    ;(println (~a dir " H: " HEAD " T: " TAIL))
    ;(draw-map HEAD TAIL)
    (set! TAIL (drag-tail HEAD TAIL))
    (hash-set! MAP TAIL #t)
    ;(println (~a dir " H: " HEAD " T: " TAIL))
    ;(draw-map HEAD TAIL)
    ))

(call-with-input-file "input"
  (lambda(input)
    (for ([line (in-lines input)])
      (apply move-rope (string-split line " "))))
  #:mode 'text)



;MAP

(length (hash-values MAP))