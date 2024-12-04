#lang racket

(call-with-input-file "input"
  (lambda(input)
    (define nums (map (lambda (x)
           (case x
             [(#\() 1]
             [(#\)) -1]))
         (string->list (read-line input))))
    (for/fold ([curr 0]
               [spot null])
               ([i nums]
               [idx (in-naturals 1)])
               #:break (< curr 0)
      (values (+ curr i) idx)))
  #:mode 'text)