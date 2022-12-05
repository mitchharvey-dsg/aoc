#lang racket
(define SUM 0)

(define (fully-contained a b c d)
  (or (and (>= a c) (<= a d))
      (and (>= b c) (<= b d))
      (and (>= c a) (<= c b))
      (and (>= d a) (<= d b))))

(call-with-input-file "input"
  (lambda(input-stream)
    (for ([line (in-lines input-stream)])
      (define input (map string->number (string-split line #rx",|-")))
      (define is-contained (apply fully-contained input))
      (when is-contained
        (set! SUM (+ SUM 1)))
      (println (~a input is-contained SUM))))
  #:mode 'text)

SUM