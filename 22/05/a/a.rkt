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

(define (move-item src dst)
  (define item (take (list-ref STACKS src) 1))
  (define new-dst (append item (list-ref STACKS dst)))
  ;(println new-dst)
  (define new-src (drop (list-ref STACKS src) 1))
  ;(println new-src)
  (set! STACKS (append (take STACKS (- src 0)) (list new-src) (drop STACKS (+ src 1))))
  (set! STACKS (append (take STACKS (- dst 0)) (list new-dst) (drop STACKS (+ dst 1)))))

(define (move-items n src dst)
  ;(println (~a "BEFORE" STACKS))
  (for ([i n])
    (move-item (- src 1) (- dst 1))
    (println (~a i src dst)))
  ;(println (~a "AFTER" STACKS))
  )

(call-with-input-file "input"
  (lambda(input-stream)
    (for ([line (in-lines input-stream)])
      (apply move-items (filter-map string->number (string-split line " ")))))
  #:mode 'text)

STACKS