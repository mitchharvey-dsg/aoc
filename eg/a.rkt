#lang racket

(call-with-input-file "input"
  (lambda(input)
    (for ([line (in-lines input)])
      (println line)))
  #:mode 'text)