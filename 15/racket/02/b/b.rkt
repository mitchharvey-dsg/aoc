#lang racket

(define (ribbon-amt l w h)
  (+ (* (apply + (take (sort (list l w h) <) 2)) 2) (* l w h)))

(call-with-input-file "input"
  (lambda(input)
    (apply + (map (lambda (s) (apply ribbon-amt (map string->number (string-split s "x")))) (sequence->list (in-lines input)))))
  #:mode 'text)