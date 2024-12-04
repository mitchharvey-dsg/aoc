#lang racket

(define (wrap-amt l w h)
  (+ (apply * (take (sort (list l w h) <) 2)) (* l w 2) (* w h 2) (* h l 2)))

(call-with-input-file "input"
  (lambda(input)
    (apply + (map (lambda (s) (apply wrap-amt (map string->number (string-split s "x")))) (sequence->list (in-lines input)))))
  #:mode 'text)