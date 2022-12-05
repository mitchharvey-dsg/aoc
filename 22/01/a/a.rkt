#lang racket
(define input-stream (open-input-file "input" #:mode 'text))
(define greatest-sum 0)
(define current-sum 0)
(define number 0)

(for ([line (in-lines input-stream)])
    (if (string=? "" line)
        (and
          (when (> current-sum greatest-sum)
            (set! greatest-sum current-sum))
          (set! current-sum 0))
        (and
          (set! number (string->number line))
          (set! current-sum (+ current-sum number)))))

(println greatest-sum)