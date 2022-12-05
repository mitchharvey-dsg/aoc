#lang racket
(define sums '())
(define current-sum 0)

(call-with-input-file "input"
  (lambda(input-stream)
    (for ([line (in-lines input-stream)])
      (cond
        ((string=? "" line)
         (set! sums (append sums (list current-sum)))
         (set! current-sum 0)
         ;(println sums)
         )
        (else
         (set! current-sum (+ current-sum (string->number line)))))))
  #:mode 'text)

(apply + (take (sort sums >) 3))