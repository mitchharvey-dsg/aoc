#lang racket

(call-with-input-file "input"
  (lambda(input)
    (apply + (map (lambda (x)
           (case x
             [(#\() 1]
             [(#\)) -1]))
         (string->list (read-line input)))))
  #:mode 'text)