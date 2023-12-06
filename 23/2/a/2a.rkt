#lang racket
(require parsack)

(define (die-valid n color)
  (cond
    [(and(equal? color "blue") (<= n 14)) #t]
    [(and(equal? color "green") (<= n 13)) #t]
    [(and(equal? color "red") (<= n 12)) #t]
    [else #f]))

(define (dice-valid dice)
  (die-valid (car dice) (cdr dice)))

(define (all xs)
  (cond
    [(empty? xs) #t]
    [(pair?  xs) (and (first xs) (all (rest xs)))]
    [else        (error 'all "expected a list, got: " xs)]))

(define $number
    (parser-compose (nums <- (many $digit))
                    (return (string->number (list->string nums)))))

(define $string
    (parser-compose (letters <- (many $letter))
                    (return (list->string letters))))

(define dice
  (parser-compose (n <- $number)
                  (many $space)
                  (color <- $string)
                  (return (die-valid n color))))

(define draw
  (parser-compose (d <- (sepBy dice (string ", ")))
                  (return (all d))))


(define game
  (parser-compose (string "Game")
                  (many $space)
                  (id <- $number)
                  (char #\:)
                  (many $space)
                  (draws <- (sepBy draw (string "; ")))
                  (return (list id (all draws)))))

(define (game-value gr)
  (cond
    [(cadr gr) (car gr)]
    [else 0]))

(with-input-from-file "input"
  (λ ()
    (for/sum ([l (in-lines)])
      (game-value (parse-result game l)))))