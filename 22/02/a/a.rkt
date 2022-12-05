#lang racket
(define scores '())

(define (convert-num input)
  (case input
    [(A X) 0]
    [(B Y) 1]
    [(C Z) 2]
    [else (error "invalid input:" input)]))

(define (bonus-score op me)
  (cond [(= op me) 3] ; tie
        [(= op (modulo (- me 1) 3)) 6] ; win
        [else 0])) ; loss

(define (calc-score op me)
  (+ 1 (convert-num me) (apply bonus-score (map convert-num (list op me)))))

(call-with-input-file "input"
  (lambda(input-stream)
    (for ([line (in-lines input-stream)])
      (set! scores (append scores (list (apply calc-score (map string->symbol (string-split line " "))))))))
  #:mode 'text)

scores
(apply + scores)