#lang racket
(define SUM 0)

(define (get-priority ch)
  (define p (char->integer ch))
  (cond [(> p 96) (- p 96)]
    [else (- p 38)]))

(define (find-item-priority input)
  (define halflen (/ (string-length input) 2))
  (define head (take (string->list input) halflen))
  (define tail (drop (string->list input) halflen))
  (define overlap (set-intersect head tail))
  (get-priority (list-ref overlap 0)))

(call-with-input-file "input"
  (lambda(input-stream)
    (for ([line (in-lines input-stream)])
      (set! SUM (+ SUM (find-item-priority line)))))
  #:mode 'text)

SUM