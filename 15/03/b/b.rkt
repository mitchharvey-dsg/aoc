#lang racket

(define X 0)
(define Y 0)
(define MAP (make-hash))

(define (addy n)
  (set! Y (+ Y n)))

(define (addx n)
  (set! X (+ X n)))

(define (inc x y)
  (define addr (~a X ":" Y))
  (hash-set! MAP addr (+ (hash-ref MAP addr 0) 1))
  ;(println (~a addr " " (hash-ref MAP addr)))
  )

(inc 0 0)
(inc 0 0)

(call-with-input-file "test_input"
  (lambda(input)
    (for ([ch (in-input-port-chars input)]
          [n (in-naturals 0)])
      (unless (member ch (list #\newline)) ;ignored ch
        ;(print (~a ch " "))
        (case ch
          [(#\^) (addy 1)]
          [(#\v) (addy -1)]
          [(#\<) (addx -1)]
          [(#\>) (addx 1)]
          [else (error "invalid input" ch)])
        (inc X Y))))
  #:mode 'text)

(length (filter (lambda (v) (> v 1)) (hash-values MAP)))

(length (hash-values MAP))