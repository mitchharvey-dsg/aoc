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

(define (gen-my-move op wanted)
  (modulo (+ op wanted -1) 3))

(define (calc-score opmove wanted)
  (define mymove (gen-my-move opmove wanted))
  (println (~a opmove wanted mymove #:separator " "))
  (+ 1 mymove (bonus-score opmove mymove)))

(call-with-input-file "input"
  (lambda(input-stream)
    (for ([line (in-lines input-stream)])
      (set! scores (append scores (list (apply calc-score (map convert-num (map string->symbol (string-split line " ")))))))))
  #:mode 'text)

scores
(apply + scores)