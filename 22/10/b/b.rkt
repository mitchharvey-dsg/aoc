#lang racket

(define X 1)
(define CLK 0)

(define SIGNALS (make-hash))

(define (dist a b)
  (abs (- a b)))

(define (draw-pixel)
  (when (= (modulo CLK 40) 0)
    (display "\n"))
  (if (> (dist (modulo CLK 40) X) 1)
      (display " ")
      (display "#")))

(define (process amt cycles)
  (when (string? amt)
    (set! amt (string->number amt)))
  (when (string? cycles)
    (set! cycles (string->number cycles)))
  (for ([i (- cycles 1)])
    (draw-pixel)
    (set! CLK (+ CLK 1))
    (hash-set! SIGNALS CLK X))
  (draw-pixel)
  (set! CLK (+ CLK 1))
  (set! X (+ X amt))
  (hash-set! SIGNALS CLK X))

(call-with-input-file "input"
  (lambda(input)
    (for ([line (in-lines input)]
          [clk (in-naturals 1)])
      (define tokens (string-split line " "))
      (define cmd (car tokens))
      (define args (when (cdr tokens) (cdr tokens)))
      (cond
        [(equal? cmd "noop") (process 0 1)]
        [(equal? cmd "addx") (process (car args) 2)]
        [else (error (~a "Unknown command: " cmd))])))
  #:mode 'text)