#lang racket

(define X 1)
(define BUF '(0 0))
(define CLK 1)

(define SIGNALS (make-hash))

(define (process amt cycles)
  (when (string? amt)
    (set! amt (string->number amt)))
  (when (string? cycles)
    (set! cycles (string->number cycles)))
  (for ([i (- cycles 1)])
    (set! CLK (+ CLK 1))
    (hash-set! SIGNALS CLK X))
  (set! CLK (+ CLK 1))
  (set! X (+ X amt))
  ;(set! BUF (append (cdr BUF) (list amt)))
  ;(println (~a X ": " BUF))
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
(+
(* (hash-ref SIGNALS 20) 20)
(* (hash-ref SIGNALS 60) 60)
(* (hash-ref SIGNALS 100) 100)
(* (hash-ref SIGNALS 140) 140)
(* (hash-ref SIGNALS 180) 180)
(* (hash-ref SIGNALS 220) 220)
)