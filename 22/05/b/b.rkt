#lang racket

;lazy

(define STACK0 '('V 'Q 'W 'M 'B 'N 'Z 'C))
(define STACK1 '('B 'C 'W 'R 'Z 'H))
(define STACK2 '('J 'R 'Q 'F))
(define STACK3 '('T 'M 'N 'F 'H 'W 'S 'Z))
(define STACK4 '('P 'Q 'N 'L 'W 'F 'G))
(define STACK5 '('W 'P 'L))
(define STACK6 '('J 'Q 'C 'G 'R 'D 'B 'V))
(define STACK7 '('W 'B 'N 'Q 'Z))
(define STACK8 '('J 'T 'G 'C 'F 'L 'H))
(define STACKS (list STACK0 STACK1 STACK2 STACK3 STACK4 STACK5 STACK6 STACK7 STACK8))

(define (move-item n src dst)
  ;(println STACKS)
  (define item (take (list-ref STACKS src) n))
  (define new-dst (append item (list-ref STACKS dst)))
  ;(println new-dst)
  (define new-src (drop (list-ref STACKS src) n))
  (println new-src)
  (set! STACKS (append (take STACKS (- src 0)) (list new-src) (drop STACKS (+ src 1))))
  (set! STACKS (append (take STACKS (- dst 0)) (list new-dst) (drop STACKS (+ dst 1)))))

(define (move-items n src dst)
  (move-item n (- src 1) (- dst 1)))

(call-with-input-file "input"
  (lambda(input-stream)
    (for ([line (in-lines input-stream)])
      (apply move-items (filter-map string->number (string-split line " ")))))
  #:mode 'text)

STACKS
(map (lambda(l) (list-ref l 0)) STACKS)