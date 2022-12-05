#lang racket
(define SUM 0)

(define (get-priority ch)
  (define p (char->integer ch))
  (cond [(> p 96) (- p 96)]
    [else (- p 38)]))

(define (find-item-priority input)
  (define overlap (apply set-intersect input))
  (get-priority (list-ref overlap 0)))

(call-with-input-file "input"
  (lambda(input)
    (for ([line (in-lines input)])
    (define lines (map string->list (list line (read-line input) (read-line input))))
    (set! SUM (+ SUM (find-item-priority lines)))))
  #:mode 'text)

SUM