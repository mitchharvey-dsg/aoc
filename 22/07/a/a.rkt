#lang racket

(define PATH '())
(define SIZES (make-hash))

(define (append-path dir)
  (set! PATH (append PATH (list dir)))
  (println PATH))

(define (drop-path)
  (set! PATH (take PATH (- (length PATH) 1)))
  (println PATH))

(define (starts-with a b)
  (cond
    [(< (string-length a) (string-length b)) #f]
    [(string=? (substring a 0 (string-length b)) b) #t]
    [else #f]))

(call-with-input-file "input"
  (lambda(input)
    (for ([line (in-lines input)])
      ;(println line)
      (cond
        [(starts-with line "$ cd ..") (drop-path)]
        [(starts-with line "$ cd") (append-path (substring line 4))]
        [(string->number (list-ref (string-split line " ") 0))
         (for ([i (length PATH)])
           (define key (string-join (take PATH (- (length PATH) i)) "/"))
           (define value (string->number (list-ref (string-split line " ") 0)))
           (hash-set! SIZES key (+ value (hash-ref SIZES key 0))))])))
  #:mode 'text)

SIZES

(define under-limit (filter (lambda (n) (< n 100000)) (sequence->list (in-hash-values SIZES))))
under-limit

(apply + under-limit)