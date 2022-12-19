#lang racket
(define MAP (make-hash))

(define (unmark1 x y)
  (hash-remove! MAP (~a x ":" y)))

(define (mark1 x y)
  (hash-set! MAP (~a x ":" y) #t))

(define (mark cx cy r)
  (define farx (+ r 1))
  (for ([i (in-range farx)])
    (when (= (modulo i 1000) 0)
      (println i))
    (for ([j (in-range (- farx i))])
      (when (or (= (+ cy j) 2000000) (= (- cy j) 2000000))
        (mark1 (+ cx i) (+ cy j))
        (mark1 (+ cx i) (- cy j))
        (mark1 (- cx i) (+ cy j))
        (mark1 (- cx i) (- cy j))))))

(define (manhtn x1 y1 x2 y2)
  (+ (abs (- x2 x1)) (abs (- y2 y1))))

(define (width-at-dist width dist)
  (if (> dist width)
      0
      (- width dist)))

(define (dist a b)
  (abs (- a b)))

(define Y-TGT 2000000)

(call-with-input-file "input_clean"
  (lambda(input)
    (for ([line (in-lines input)])
      (define coords (map string->number (string-split line ",")))
      (define d (apply manhtn coords))
      (define dist-to-y (dist (cadr coords) Y-TGT))
      (define x-width (width-at-dist d dist-to-y))
      (println (~a coords ":" d "," dist-to-y "," x-width))
      (when (> x-width 0)
        (for ([i (in-range (+ x-width 1))])
          (mark1 (- (car coords) i) Y-TGT)
          (mark1 (+ (car coords) i) Y-TGT)))))
  #:mode 'text)

(call-with-input-file "input_clean"
  (lambda(input)
    (for ([line (in-lines input)])
      (define coords (map string->number (string-split line ",")))
      (unmark1 (list-ref coords 2) (list-ref coords 3))
      ))
  #:mode 'text)

;MAP

(length (hash-keys MAP))

;(length (filter (lambda (x) (string-suffix? x ":2000000")) (hash-keys MAP)))
;(length (filter (lambda (x) (string-prefix? x "2000000:")) (hash-keys MAP)))