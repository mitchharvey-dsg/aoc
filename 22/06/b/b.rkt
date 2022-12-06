#lang racket
(define SUM 0)

(call-with-input-file "input"
  (lambda(input)
    (define instr (read-line input))
    (for ([i (in-range 0 (string-length instr))])
      (define teststr (substring instr i (+ i 14)))
      (when (not (check-duplicates (string->list teststr)))
        (println teststr)
        (println (+ i 14))
        (exit))))
  #:mode 'text)