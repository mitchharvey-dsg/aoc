#lang racket


;;;

;    Day 18 seems ok: Count adjacent 3d blocks
;    Day 13 seems ok: Recursive parse and sort
;    Day 12 seems doable: traverse grid based on which neighbor is a valid move

;;;

(define (combine-ranges list-ranges)
  (for/fold ([total-range (car list-ranges)])
            ([cur-range list-ranges])
    (if (<= (car cur-range) (+ (cadr total-range) 1))
        (list (car total-range) (max (cadr total-range) (cadr cur-range)))
        total-range)))

(define (range-contains a b)
  (and (<= (car a) (car b)) (>= (cadr a) (cadr b))))

(define (manhtn x1 y1 x2 y2)
  (+ (abs (- x2 x1)) (abs (- y2 y1))))

(define (width-at-dist width dist)
  (if (> dist width)
      0
      (- width dist)))

(define (dist a b)
  (abs (- a b)))

(struct circle (x y radius) #:transparent)

(define CIRCLES
  (call-with-input-file "input_clean"
    (lambda(input)
      (for/list ([line (in-lines input)])
        (define coords (map string->number (string-split line ",")))
        (define radius (apply manhtn coords))
        (define X (car coords))
        (define Y (cadr coords))
        (circle X Y radius)))
    #:mode 'text))

(for ([y-tgt 4000000])

  (define circle-ranges
    (filter
     (lambda (c)
       (> (dist (car c) (cadr c)) 0))
     (map
      (lambda (c)
        (define dist-to-y (dist (circle-y c) y-tgt))
        (define x-width (width-at-dist (circle-radius c) dist-to-y))
        (list (- (circle-x c) x-width) (+ (circle-x c) x-width)))
      CIRCLES)))

  (define sorted-circle-ranges
    (sort
     circle-ranges
     (lambda (a b)
       (< (car a) (car b)))))

  (define max-range (combine-ranges sorted-circle-ranges))

  (when (= 0 (modulo (+ 1 y-tgt) 10000))
    (display "."))

  (when (= 0 (modulo (+ 1 y-tgt) 1000000))
    (display "\n"))

  (when (not (range-contains max-range '(0 4000000)))
    (display (~a "\n" y-tgt ", " (+ 1 (cadr max-range)) "\n"))
    (println (+ (* (+ 1 (cadr max-range)) 4000000) y-tgt))))