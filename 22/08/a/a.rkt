#lang racket

(define MAP '())

(define (add-to-map l)
  (set! MAP (append MAP (list l))))

(define (line-to-nums s)
  (map string->number (map string (string->list s))))

(define (get-cell map i j)
  (list-ref (list-ref map i) j))

(define (get-row m i)
  (list-ref m i))

(define (get-col m j)
  (map (lambda (a) (list-ref a j)) m))

(define (is-visible m i j)
  (define tgt (get-cell m i j))
  (define row (get-row m i))
  (define lft-of-tgt (take row j))
  (define rgt-of-tgt (drop row (+ j 1)))
  (define col (get-col m j))
  (define top-of-tgt (take col i))
  (define btm-of-tgt (drop col (+ i 1)))
  (define all-list (list lft-of-tgt rgt-of-tgt top-of-tgt btm-of-tgt))
  (define tall-list (map (lambda (l) (filter (lambda (x) (>= x tgt)) l)) all-list))
  (for/or ([i tall-list]) (= (length i) 0)))

(call-with-input-file "input"
  (lambda(input)
    (for ([line (in-lines input)])
      (add-to-map (line-to-nums line))))
  #:mode 'text)

(define SUM 0)

(define h (length MAP))
(define w (length (list-ref MAP 0)))
(for ([i (in-range 1 (- h 1))])
  (for ([j (in-range 1 (- w 1))])
    (when (is-visible MAP i j)
      (set! SUM (+ SUM 1)))))
(set! SUM (+ SUM h h w w -4))

SUM