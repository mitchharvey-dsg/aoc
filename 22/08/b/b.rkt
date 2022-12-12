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

; How many elements until we see one the same height or larger
(define (get-short-num l n)
  (define num
    (for/first ([e l]
                [idx (in-naturals 1)]
                #:when (>= e n))
      idx))
  (if num num (length l)))

(define (get-scenic-score m i j)
  (define tgt (get-cell m i j))
  (define row (get-row m i))
  (define lft-of-tgt (take row j))
  (define rgt-of-tgt (drop row (+ j 1)))
  (define col (get-col m j))
  (define top-of-tgt (take col i))
  (define btm-of-tgt (drop col (+ i 1)))
  (define view-dist-list (map (lambda (l) (get-short-num l tgt)) (list (reverse lft-of-tgt) rgt-of-tgt (reverse top-of-tgt) btm-of-tgt)))
  (apply * view-dist-list))

(call-with-input-file "input"
  (lambda(input)
    (for ([line (in-lines input)])
      (add-to-map (line-to-nums line))))
  #:mode 'text)

; could be changed to be list of x,y pairs. map each pair to score, get highest.
(define BEST 0)
(define h (length MAP))
(define w (length (list-ref MAP 0)))
(for ([i (in-range 1 (- h 1))])
  (for ([j (in-range 1 (- w 1))])
    (define score (get-scenic-score MAP i j))
    (when (> score BEST)
      (set! BEST score))))

BEST