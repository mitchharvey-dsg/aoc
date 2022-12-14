#lang racket

(define MAP (make-hash))

(define ROPE (vector (vector 0 0) (vector 0 0) (vector 0 0) (vector 0 0) (vector 0 0) (vector 0 0) (vector 0 0) (vector 0 0) (vector 0 0) (vector 0 0)))

(define (move-rope r delta)
  (vector-set! r 0 (vector-add (vector-ref r 0) delta))
  (for ([tidx (in-range (- (vector-length r) 1))])
    (define head (vector-ref r tidx))
    (define tail (vector-ref r (+ tidx 1)))
    (vector-set! r (+ tidx 1) (drag-tail head tail)))
  r)

(define (vector-add a b)
  (for/vector ([i a]
               [j b])
    (+ i j)
    ))

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
    [(and (> (dist hx tx) 1) (= hy ty)) (vector (within-1 hx tx) (within-1 hy ty))]
    [(and (> (dist hy ty) 1) (= hx tx)) (vector (within-1 hx tx) (within-1 hy ty))]
    [(and (> (dist hx tx) 1) (> (dist hy ty) 1)) (vector (within-1 hx tx) (within-1 hy ty))]
    [(or (> (dist hx tx) 1) (> (dist hy ty) 1)) (if (> (dist hx tx) (dist hy ty))
                                                    (vector (within-1 hx tx) hy)
                                                    (vector hx (within-1 hy ty)))]
    [else t]))

(define (draw-map r)
  (for ([y (in-range -10 10)])
    (for ([x (in-range -20 20)])
      (define idx (vector-member (vector x y) r))
      (if idx
          (display idx)
          (display ".")))
    (display "\n"))
  (display "\n"))

(define (apply-moves dir amt)
  (when (string? amt)
    (set! amt (string->number amt)))
  (for ([i amt])
    (set! ROPE (move-rope ROPE
               (case dir
                 [("U") (vector 0 1)]
                 [("D") (vector 0 -1)]
                 [("R") (vector 1 0)]
                 [("L") (vector -1 0)]
                 [else (error(~a "Unknown " dir))])))
    ;(println ROPE)
    ;(draw-map ROPE)
    (hash-set! MAP (vector-ref ROPE 9) #t)
    ))

(call-with-input-file "input"
  (lambda(input)
    (for ([line (in-lines input)])
      (apply apply-moves (string-split line " "))))
  #:mode 'text)

;MAP

(length (hash-values MAP))